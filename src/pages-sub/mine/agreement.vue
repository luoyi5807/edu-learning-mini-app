<!-- src/pages-sub/mine/agreement.vue -->
<template>
  <view class="agreement-page" :class="themeClass">
    <!-- 固定顶部栏 -->
    <view class="nav-bar" :class="{ 'nav-bar-opaque': navBarOpaque }" :style="{ paddingTop: statusBarHeight + 'px' }">
      <view class="nav-bar-inner" :style="{ height: navContentHeight + 'px' }">
        <view class="nav-back" @tap="goBack">
          <text class="back-icon">←</text>
        </view>
        <text class="nav-title">{{ pageTitle }}</text>
      </view>
    </view>
    <view class="nav-placeholder" :style="{ height: (statusBarHeight + navContentHeight) + 'px' }"></view>

    <LoadingState v-if="state === 'loading'" text="加载协议内容…" />

    <block v-else-if="state === 'ready' && contentNodes">
      <view class="meta-card">
        <text class="meta-title">{{ detail.title || pageTitle }}</text>
        <text class="meta-time" v-if="detail.updateTime">更新于 {{ detail.updateTime }}</text>
      </view>
      <scroll-view class="content-scroll" scroll-y :show-scrollbar="false">
        <view class="content-card">
          <rich-text :nodes="contentNodes" />
        </view>
        <text class="foot-note">本协议最终解释权归平台所有</text>
      </scroll-view>
    </block>

    <view v-else class="error-wrap">
      <EmptyState :text="emptyText" />
      <view class="retry-btn" @tap="load"><text class="retry-text">重新加载</text></view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { onLoad, onPageScroll } from '@dcloudio/uni-app'
import LoadingState from '@/components/LoadingState.vue'
import EmptyState from '@/components/EmptyState.vue'
import { getAgreementDetailApi, AGREEMENT_DEFAULT_TITLE, type AgreementDetail } from '@/api/agreement'
import { useTheme } from '@/composables/useTheme'

const { themeClass } = useTheme()

/* ===== 顶部栏 ===== */
const statusBarHeight = ref<number>(0)
const navContentHeight = ref<number>(44)
const sysInfo = uni.getSystemInfoSync()
statusBarHeight.value = sysInfo.statusBarHeight || 0
// #ifdef MP-WEIXIN
const menuButton = uni.getMenuButtonBoundingClientRect()
if (menuButton) {
  navContentHeight.value = (menuButton.top - statusBarHeight.value) * 2 + menuButton.height
}
// #endif

const navBarOpaque = ref<boolean>(false)
onPageScroll((e) => { navBarOpaque.value = e.scrollTop > 40 })

/* ===== 数据 ===== */
const agreementType = ref<string>('user_agreement')
const detail = ref<AgreementDetail>({ agreementId: 0, agreementType: '', typeLabel: '', title: '', orderNum: 0, status: '', content: '' })
const state = ref<'loading' | 'ready' | 'error'>('loading')
const emptyText = ref<string>('协议内容暂未配置')

const pageTitle = computed<string>(
  () => detail.value.title || AGREEMENT_DEFAULT_TITLE[agreementType.value] || '协议详情'
)
const contentNodes = computed<string>(() => detail.value.content || '')

async function load() {
  state.value = 'loading'
  try {
    const d = await getAgreementDetailApi(agreementType.value)
    if (d) {
      detail.value = d
      state.value = 'ready'
    } else {
      emptyText.value = AGREEMENT_DEFAULT_TITLE[agreementType.value] + '内容暂未配置'
      state.value = 'error'
    }
  } catch (e) {
    emptyText.value = '加载失败，请稍后重试'
    state.value = 'error'
  }
}

function goBack() {
  const pages = getCurrentPages()
  if (pages.length > 1) uni.navigateBack()
  else uni.reLaunch({ url: '/pages/index/index' })
}

onLoad((query) => {
  const q = (query || {}) as Record<string, string>
  agreementType.value = q.type || 'user_agreement'
  if (q.title && !AGREEMENT_DEFAULT_TITLE[agreementType.value]) {
    detail.value = { ...detail.value, title: decodeURIComponent(q.title) }
  }
  load()
})
</script>

<style lang="scss" scoped>
.agreement-page {
  min-height: 100vh;
  box-sizing: border-box;
  display: flex;
  flex-direction: column;
  @include eduPageGradientStrong;
}

/* ===== 固定顶部栏 ===== */
.nav-bar {
  position: fixed;
  top: 0; left: 0; right: 0;
  z-index: 99;
  background: transparent;
  transition: background-color 0.3s ease, box-shadow 0.3s ease;
}
.nav-bar-opaque { background: var(--edu-surface); box-shadow: 0 2rpx 12rpx rgba(0, 0, 0, 0.06); }
.nav-bar-inner { display: flex; align-items: center; padding-left: 16rpx; }
.nav-back { width: 72rpx; height: 72rpx; display: flex; align-items: center; justify-content: center; }
.back-icon { font-size: 44rpx; color: $edu-text-primary; }
.nav-title { font-size: 40rpx; font-weight: 700; color: $edu-text-primary; margin-left: 8rpx; }

/* ===== 内容 ===== */
.meta-card { padding: 24rpx 40rpx 0; }
.meta-title { display: block; font-size: 40rpx; font-weight: 800; color: $edu-text-primary; }
.meta-time { display: block; font-size: 24rpx; color: $edu-text-hint; margin-top: 12rpx; }

.content-scroll { flex: 1; min-height: 0; padding: 0 32rpx; box-sizing: border-box; }
.content-card {
  margin-top: 24rpx;
  padding: 40rpx 32rpx;
  border-radius: 32rpx;
  background-color: $edu-surface;
  box-shadow: 0 8rpx 24rpx rgba(0, 0, 0, 0.04);
  font-size: 30rpx;
  line-height: 1.8;
  color: $edu-text-primary;
  word-break: break-all;
}
.foot-note { display: block; text-align: center; font-size: 24rpx; color: $edu-text-hint; padding: 32rpx 0 calc(32rpx + env(safe-area-inset-bottom)); }

.error-wrap { flex: 1; display: flex; flex-direction: column; align-items: center; justify-content: center; padding-bottom: 200rpx; }
.retry-btn { margin-top: 24rpx; height: 80rpx; padding: 0 56rpx; border-radius: 40rpx; display: flex; align-items: center; justify-content: center; @include eduBrandGradient; }
.retry-text { font-size: 28rpx; font-weight: 600; color: #FFFFFF; }
</style>
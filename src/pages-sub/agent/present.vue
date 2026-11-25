<template>
  <view class="present-page">
    <!-- 顶栏：汇报标题 + 页码 · 分享 · 关闭 -->
    <view class="present-nav" :style="{ paddingTop: statusBarHeight + 'px' }">
      <view class="present-nav-inner" :style="{ height: navContentHeight + 'px' }">
        <view class="present-title-wrap">
          <text class="present-title">{{ deck ? deck.deckTitle : '' }}</text>
          <text class="present-page-no">{{ current + 1 }} / {{ total }}</text>
        </view>
        <view class="present-tools">
          <view class="present-tool" @tap="onShare"><text class="present-tool-icon">⬆</text></view>
          <view class="present-tool" @tap="goBack"><text class="present-tool-icon">✕</text></view>
        </view>
      </view>
    </view>

    <!-- 幻灯片轮播 -->
    <view class="present-body">
      <swiper class="present-swiper" :current="current" :indicator-dots="false" @change="onChange">
        <swiper-item v-for="(s, i) in slides" :key="i">
          <view class="present-slide">
            <view class="present-slide-circle c1"></view>
            <view class="present-slide-circle c2"></view>
            <view class="present-slide-brand"><text class="present-slide-brand-star">✦</text><text class="present-slide-brand-name">阿星</text></view>
            <text class="present-slide-title">{{ s.title }}</text>
            <text class="present-slide-sub">{{ s.subtitle }}</text>
            <text class="present-slide-total">共 {{ total }} 页</text>
          </view>
        </swiper-item>
      </swiper>
    </view>

    <!-- 底部圆点 -->
    <view class="present-dots">
      <view class="present-dot" :class="{ 'present-dot-active': i === current }" v-for="(s, i) in slides" :key="'d' + i"></view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { onLoad } from '@dcloudio/uni-app'
import { useAgentDeck } from '@/composables/useAgentDeck'

const { deck } = useAgentDeck()
const slides = computed(() => (deck.value ? deck.value.slides : []))
const total = computed(() => slides.value.length)
const current = ref(0)

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

onLoad(() => { if (!deck.value) uni.navigateBack() })

function onChange(e: any) { current.value = e.detail.current }
function onShare() {
  const p = deck.value
  if (!p || !p.fileUrl) { uni.showToast({ title: '暂无可下载文件', icon: 'none' }); return }
  uni.showLoading({ title: '下载中…' })
  uni.downloadFile({
    url: p.fileUrl,
    success: (res: any) => {
      uni.hideLoading()
      if (res.statusCode !== 200) { uni.showToast({ title: '下载失败', icon: 'none' }); return }
      uni.openDocument({ filePath: res.tempFilePath, fileType: 'pptx', showMenu: true, fail: () => uni.showToast({ title: '该文件无法直接打开', icon: 'none' }) })
    },
    fail: () => { uni.hideLoading(); uni.showToast({ title: '下载失败', icon: 'none' }) }
  })
}
function goBack() { uni.navigateBack() }
</script>

<style lang="scss" scoped>
.present-page { display: flex; flex-direction: column; height: 100vh; background-color: #000000; }

/* 顶栏 */
.present-nav { padding-left: 32rpx; padding-right: 32rpx; }
.present-nav-inner { display: flex; align-items: center; justify-content: space-between; }
.present-title-wrap { display: flex; flex-direction: column; flex: 1; min-width: 0; }
.present-title { font-size: 34rpx; font-weight: 700; color: #FFFFFF; }
.present-page-no { font-size: 26rpx; color: rgba(255, 255, 255, 0.5); margin-top: 8rpx; }
.present-tools { display: flex; align-items: center; flex-shrink: 0; }
.present-tool { width: 76rpx; height: 76rpx; border-radius: 50%; background-color: rgba(255, 255, 255, 0.14); display: flex; align-items: center; justify-content: center; margin-left: 20rpx; }
.present-tool-icon { font-size: 34rpx; color: #FFFFFF; }

/* 幻灯片 */
.present-body { flex: 1; min-height: 0; display: flex; align-items: center; }
.present-swiper { width: 100%; height: 620rpx; }
.present-slide { position: relative; height: 100%; margin: 0 40rpx; border-radius: 16rpx; box-sizing: border-box; padding: 48rpx; overflow: hidden; @include eduBrandGradient; display: flex; flex-direction: column; }
.present-slide-circle { position: absolute; border-radius: 50%; background-color: rgba(255, 255, 255, 0.10); }
.present-slide-circle.c1 { width: 420rpx; height: 420rpx; top: -60rpx; right: -100rpx; }
.present-slide-circle.c2 { width: 300rpx; height: 300rpx; bottom: -80rpx; right: 40rpx; }
.present-slide-brand { display: flex; align-items: center; }
.present-slide-brand-star { font-size: 30rpx; color: #FFFFFF; margin-right: 10rpx; }
.present-slide-brand-name { font-size: 30rpx; color: rgba(255, 255, 255, 0.92); }
.present-slide-title { font-size: 64rpx; font-weight: 700; color: #FFFFFF; margin-top: 80rpx; line-height: 1.2; }
.present-slide-sub { font-size: 32rpx; color: rgba(255, 255, 255, 0.88); margin-top: 24rpx; }
.present-slide-total { font-size: 28rpx; color: rgba(255, 255, 255, 0.7); margin-top: auto; }

/* 圆点 */
.present-dots { display: flex; justify-content: center; align-items: center; padding-bottom: calc(40rpx + env(safe-area-inset-bottom)); }
.present-dot { width: 16rpx; height: 16rpx; border-radius: 8rpx; background-color: rgba(255, 255, 255, 0.35); margin: 0 8rpx; }
.present-dot-active { width: 44rpx; background-color: #FFFFFF; }
</style>
<template>
  <view class="follow-page">
    <!-- 固定顶部栏：返回 + 标题 -->
    <view class="nav-bar" :class="{ 'nav-bar-opaque': navBarOpaque }" :style="{ paddingTop: statusBarHeight + 'px' }">
      <view class="nav-bar-inner" :style="{ height: navContentHeight + 'px' }">
        <view class="nav-back" @tap="goBack">
          <text class="back-icon">←</text>
        </view>
        <text class="nav-title">{{ titleText }}</text>
      </view>
    </view>
    <view class="nav-placeholder" :style="{ height: (statusBarHeight + navContentHeight) + 'px' }"></view>

    <!-- Tab：关注 / 粉丝 -->
    <view class="filter-tabs">
      <view class="filter-pill" :class="{ 'filter-pill-active': tab === 'following' }" @tap="switchTab('following')">
        <text class="filter-pill-text">关注</text>
      </view>
      <view class="filter-pill" :class="{ 'filter-pill-active': tab === 'fans' }" @tap="switchTab('fans')">
        <text class="filter-pill-text">粉丝</text>
      </view>
    </view>

    <LoadingState v-if="state === 'loading'" text="正在加载…" />
    <ErrorState v-else-if="state === 'error'" text="加载失败" @retry="loadList" />
    <EmptyState v-else-if="list.length === 0" :text="tab === 'following' ? '还没有关注任何人' : '还没有粉丝'" />
    <view class="user-list" v-else>
      <view
          v-for="(u, idx) in list"
          :key="u.userId"
          class="user-item"
          :class="{ 'user-item-divider': idx < list.length - 1 }"
          @tap="goUser(u)"
      >
        <image v-if="u.avatar" class="user-avatar" :src="u.avatar" mode="aspectFill" />
        <view v-else class="user-avatar user-avatar-fallback">
          <text class="avatar-char">{{ charOf(u.nickName) }}</text>
        </view>
        <view class="user-info">
          <text class="user-name">{{ u.nickName }}</text>
          <text class="user-time" v-if="u.followTime">关注于 {{ u.followTime }}</text>
        </view>
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { onLoad, onShow, onPageScroll } from '@dcloudio/uni-app'
import LoadingState from '@/components/LoadingState.vue'
import ErrorState from '@/components/ErrorState.vue'
import EmptyState from '@/components/EmptyState.vue'
import { useAuthStore } from '@/store/auth'
import { getFollowingListApi, getFansListApi, type FollowUserDto } from '@/api/user'

const auth = useAuthStore()

/* ===== 顶部栏高度（含状态栏 + 胶囊区） ===== */
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

/* ===== 顶栏滚动变白 ===== */
const scrollTop = ref<number>(0)
const navBarOpaque = computed<boolean>(() => scrollTop.value > 40)
onPageScroll((e) => {
  scrollTop.value = e.scrollTop
})

/* ===== 入参：tab=following|fans，userId（查谁，缺省=自己） ===== */
const tab = ref<'following' | 'fans'>('following')
const targetUserId = ref<number>(0)
const isSelf = computed<boolean>(() => !targetUserId.value || String(targetUserId.value) === String(auth.state.user?.userId ?? ''))
const titleText = computed<string>(() => {
  const who = isSelf.value ? '' : 'TA的'
  return who + (tab.value === 'following' ? '关注' : '粉丝')
})

const list = ref<FollowUserDto[]>([])
const state = ref<'loading' | 'error' | 'ready'>('loading')

function charOf(name: string): string {
  return (name || 'U').charAt(0)
}

async function loadList() {
  state.value = 'loading'
  try {
    const uid = isSelf.value ? undefined : targetUserId.value
    list.value = tab.value === 'following'
        ? await getFollowingListApi(uid)
        : await getFansListApi(uid)
    state.value = 'ready'
  } catch (e) {
    state.value = 'error'
  }
}

function switchTab(t: 'following' | 'fans') {
  if (tab.value === t) return
  tab.value = t
  loadList()
}

function goUser(u: FollowUserDto) {
  uni.navigateTo({ url: `/pages-sub/mine/blog-home?userId=${u.userId}` })
}

function goBack() {
  const pages = getCurrentPages()
  if (pages.length > 1) {
    uni.navigateBack()
  } else {
    uni.reLaunch({ url: '/pages/index/index' })
  }
}

onLoad((query) => {
  if (query && query.tab === 'fans') tab.value = 'fans'
  if (query && query.userId) targetUserId.value = Number(query.userId)
})

onShow(() => {
  loadList()
})
</script>

<style lang="scss" scoped>
.follow-page {
  min-height: 100vh;
  box-sizing: border-box;
  padding: 0 32rpx 60rpx;
  @include eduPageGradientStrong;
}

/* ===== 固定顶部栏 ===== */
.nav-bar {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  z-index: 99;
  background: transparent;
  transition: background-color 0.3s ease, box-shadow 0.3s ease;
}
.nav-bar-opaque { background: #FFFFFF; box-shadow: 0 2rpx 12rpx rgba(0, 0, 0, 0.06); }
.nav-bar-inner { display: flex; align-items: center; padding-left: 16rpx; }
.nav-back { width: 72rpx; height: 72rpx; display: flex; align-items: center; justify-content: center; }
.back-icon { font-size: 44rpx; color: $edu-text-primary; }
.nav-title { font-size: 40rpx; font-weight: 700; color: $edu-text-primary; margin-left: 8rpx; }

/* ===== Tab ===== */
.filter-tabs { display: flex; align-items: center; margin-top: 24rpx; }
.filter-pill {
  display: flex;
  align-items: center;
  justify-content: center;
  height: 72rpx;
  padding: 0 44rpx;
  border-radius: 36rpx;
  margin-right: 20rpx;
  @include eduSurfaceWash;
  box-shadow: 0 4rpx 12rpx rgba(0, 0, 0, 0.03);
}
.filter-pill-active {
  background: $edu-primary;
  .filter-pill-text { color: #FFFFFF; font-weight: 600; }
}
.filter-pill-text { font-size: 28rpx; color: $edu-text-secondary; }

/* ===== 用户列表 ===== */
.user-list { margin-top: 24rpx; }
.user-item {
  position: relative;
  display: flex;
  align-items: center;
  padding: 24rpx 0;
}
.user-item-divider::after {
  content: '';
  position: absolute;
  left: 0;
  right: 0;
  bottom: 0;
  height: 2rpx;
  background: rgba(0, 0, 0, 0.05);
}
.user-avatar {
  width: 96rpx;
  height: 96rpx;
  border-radius: 50%;
  flex-shrink: 0;
  margin-right: 24rpx;
}
.user-avatar-fallback {
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: $edu-primary;
}
.avatar-char { font-size: 40rpx; font-weight: 700; color: #FFFFFF; }
.user-info { flex: 1; display: flex; flex-direction: column; justify-content: center; }
.user-name { font-size: 32rpx; font-weight: 600; color: $edu-text-primary; line-height: 1.4; }
.user-time { font-size: 26rpx; color: $edu-text-hint; margin-top: 10rpx; }
</style>
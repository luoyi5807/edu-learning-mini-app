<template>
  <view class="favorites-page">
    <!-- 固定顶部栏：返回 + 标题 -->
    <view class="nav-bar" :class="{ 'nav-bar-opaque': navBarOpaque }" :style="{ paddingTop: statusBarHeight + 'px' }">
      <view class="nav-bar-inner" :style="{ height: navContentHeight + 'px' }">
        <view class="nav-back" @tap="goBack">
          <text class="back-icon">←</text>
        </view>
        <text class="nav-title">我的收藏</text>
      </view>
    </view>

    <!-- 占位 -->
    <view class="nav-placeholder" :style="{ height: (statusBarHeight + navContentHeight) + 'px' }"></view>

    <!-- 筛选标签：全部 / 文章 / 视频 -->
    <view class="filter-tabs">
      <view
          v-for="tab in filterTabs"
          :key="tab.value"
          class="filter-pill"
          :class="{ 'filter-pill-active': activeFilter === tab.value }"
          @tap="activeFilter = tab.value"
      >
        <text class="filter-pill-text">{{ tab.label }}</text>
      </view>
    </view>

    <!-- 收藏列表 -->
    <view class="fav-list" v-if="filteredList.length > 0">
      <view
          v-for="(item, idx) in filteredList"
          :key="item.targetType + '-' + item.targetId"
          class="fav-item"
          :class="{ 'fav-item-divider': idx < filteredList.length - 1 }"
          @tap="handleItemTap(item)"
      >
        <image v-if="item.cover" class="fav-cover" :src="item.cover" mode="aspectFill" />
        <view v-else class="fav-cover fav-cover-placeholder"></view>
        <view class="fav-info">
          <text class="fav-title">{{ item.title }}</text>
          <text class="fav-time">{{ item.collectTime }}</text>
        </view>
      </view>
    </view>

    <!-- 空态 -->
    <EmptyState v-else text="还没有收藏内容" action-text="去逛逛社区" @action="goCommunity" />

    <!-- 加载更多 / 没有更多了 -->
    <view class="load-more" v-if="filteredList.length > 0 && hasMore" @tap="handleLoadMore">
      <text class="load-more-text">{{ loadingMore ? '加载中...' : '上拉加载更多' }}</text>
    </view>
    <view class="load-more load-more-end" v-else-if="filteredList.length > 0">
      <text class="load-more-text">没有更多了</text>
    </view>
  </view>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { onLoad, onPageScroll } from '@dcloudio/uni-app'
import EmptyState from '@/components/EmptyState.vue'

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

/* ===== 筛选 ===== */
interface FilterTab { label: string; value: number }
const filterTabs: FilterTab[] = [
  { label: '全部', value: 0 },
  { label: '文章', value: 1 },
  { label: '视频', value: 2 }
]
const activeFilter = ref<number>(0)

/* ===== Mock 收藏数据（字段对齐 UserTargetItemDto，接口接入零改动） ===== */
interface UserTargetItem {
  targetType: number   // 1 文章  2 视频课程
  targetId: number
  title: string
  cover: string
  collectTime: string
}

const favorites = ref<UserTargetItem[]>([
  { targetType: 1, targetId: 101, title: 'Kotlin 协程取消机制完全指南', cover: '', collectTime: '2026-09-10 10:00:00' },
  { targetType: 1, targetId: 102, title: 'Java 高并发编程', cover: '', collectTime: '2026-09-09 09:00:00' },
  { targetType: 1, targetId: 103, title: '后端接口设计中的 10 个常见错误', cover: '', collectTime: '2026-09-08 21:00:00' },
  { targetType: 2, targetId: 1, title: 'Machine Learning 从入门到实战', cover: '', collectTime: '2026-09-07 18:00:00' }
])

const filteredList = computed<UserTargetItem[]>(() => {
  if (activeFilter.value === 0) return favorites.value
  return favorites.value.filter((f) => f.targetType === activeFilter.value)
})

const hasMore = ref<boolean>(false)
const loadingMore = ref<boolean>(false)

/* ===== 交互 ===== */
function goBack() {
  const pages = getCurrentPages()
  if (pages.length > 1) {
    uni.navigateBack()
  } else {
    uni.reLaunch({ url: '/pages/index/index' })
  }
}

function goCommunity() {
  uni.switchTab ? uni.reLaunch({ url: '/pages/index/index' }) : uni.reLaunch({ url: '/pages/index/index' })
}

// 蓝本通用跳转规则：targetType==1 文章详情，否则课程详情
function handleItemTap(item: UserTargetItem) {
  if (item.targetType === 1) {
    uni.showToast({ title: `文章详情开发中：${item.title}`, icon: 'none' })
  } else {
    uni.showToast({ title: `课程详情开发中：${item.title}`, icon: 'none' })
  }
}

function handleLoadMore() {
  if (loadingMore.value) return
  uni.showToast({ title: '加载更多（接口待接入）', icon: 'none' })
}

onLoad(() => {
  // 接口接入：GET user/favorites?targetType=
})
</script>

<style lang="scss" scoped>
.favorites-page {
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

/* ===== 筛选标签 ===== */
.filter-tabs {
  display: flex;
  align-items: center;
  margin-top: 24rpx;
}
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
.filter-pill-text {
  font-size: 28rpx;
  color: $edu-text-secondary;
}

/* ===== 收藏列表 ===== */
.fav-list { margin-top: 24rpx; }
.fav-item {
  position: relative;
  display: flex;
  align-items: center;
  padding: 28rpx 0;
}
.fav-item-divider::after {
  content: '';
  position: absolute;
  left: 0;
  right: 0;
  bottom: 0;
  height: 2rpx;
  background: rgba(0, 0, 0, 0.05);
}
.fav-cover {
  width: 200rpx;
  height: 140rpx;
  border-radius: 16rpx;
  flex-shrink: 0;
  margin-right: 24rpx;
}
.fav-cover-placeholder {
  background: linear-gradient(135deg, #DCE8FF 0%, #5B8DEF 100%);
}
.fav-info {
  flex: 1;
  display: flex;
  flex-direction: column;
  justify-content: center;
}
.fav-title {
  font-size: 32rpx;
  font-weight: 600;
  color: $edu-text-primary;
  line-height: 1.4;
  margin-bottom: 16rpx;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
.fav-time {
  font-size: 26rpx;
  color: $edu-text-hint;
}

/* ===== 加载更多 ===== */
.load-more { padding: 40rpx 0; display: flex; justify-content: center; }
.load-more-text { font-size: 26rpx; color: $edu-primary; }
.load-more-end .load-more-text { color: $edu-text-hint; }
</style>
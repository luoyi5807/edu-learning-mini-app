<template>
  <view class="mine-list">
    <!-- 顶部栏：返回 + 标题 -->
    <view class="nav-bar" :class="{ 'nav-bar-opaque': navBarOpaque }" :style="{ paddingTop: statusBarHeight + 'px' }">
      <view class="nav-bar-inner" :style="{ height: navContentHeight + 'px' }">
        <view class="nav-back" @tap="goBack">
          <text class="back-icon">←</text>
        </view>
        <text class="nav-title">{{ title }}</text>
      </view>
    </view>

    <!-- 列表滚动区 -->
    <scroll-view class="list-scroll" scroll-y :show-scrollbar="false" @scroll="onScroll">
      <!-- 筛选标签 -->
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

      <!-- 列表 -->
      <view class="fav-list" v-if="filteredList.length > 0">
        <view
            v-for="(item, idx) in filteredList"
            :key="item.targetType + '-' + item.targetId"
            class="fav-item"
            :class="{ 'fav-item-divider': idx < filteredList.length - 1 }"
            @tap="handleItemTap(item)"
        >
          <view class="fav-cover-wrap">
            <image v-if="item.cover" class="fav-cover" :src="item.cover" mode="aspectFill" />
            <view v-else class="fav-cover fav-cover-placeholder"></view>
            <view class="progress-track" v-if="showProgress">
              <view class="progress-bar" :style="{ width: progressPct(item) + '%' }"></view>
            </view>
          </view>
          <view class="fav-info">
            <text class="fav-title">{{ item.title }}</text>
            <text class="fav-time">{{ timeLabel }} {{ item.collectTime }}</text>
          </view>
        </view>
      </view>

      <!-- 空态 -->
      <view class="empty" v-else>
        <text class="empty-text">暂无内容</text>
      </view>

      <!-- 没有更多了 -->
      <view class="load-more" v-if="filteredList.length > 0">
        <text class="load-more-text">没有更多了</text>
      </view>
    </scroll-view>
  </view>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import type { UserTargetItem } from '@/types/user'

interface Props {
  title: string
  items: UserTargetItem[]
  showProgress?: boolean
  timeLabel?: string
}
const props = withDefaults(defineProps<Props>(), {
  showProgress: false,
  timeLabel: '时间：'
})

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

/* ===== 滚动变白 ===== */
const navBarOpaque = ref<boolean>(false)
function onScroll(e: any) {
  navBarOpaque.value = e.detail.scrollTop > 40
}

/* ===== 筛选 ===== */
interface FilterTab { label: string; value: number }
const filterTabs: FilterTab[] = [
  { label: '全部', value: 0 },
  { label: '文章', value: 1 },
  { label: '视频', value: 2 }
]
const activeFilter = ref<number>(0)

const filteredList = computed<UserTargetItem[]>(() => {
  if (activeFilter.value === 0) return props.items
  return props.items.filter((f) => f.targetType === activeFilter.value)
})

function progressPct(item: UserTargetItem): number {
  if (!item.duration || !item.progressSeconds) return 0
  return Math.min(100, Math.round((item.progressSeconds / item.duration) * 100))
}

function goBack() {
  const pages = getCurrentPages()
  if (pages.length > 1) {
    uni.navigateBack()
  } else {
    uni.reLaunch({ url: '/pages/index/index' })
  }
}

// 通用跳转规则：targetType==1 文章详情，否则课程详情
function handleItemTap(item: UserTargetItem) {
  if (item.targetType === 1) {
    uni.showToast({ title: `文章详情开发中：${item.title}`, icon: 'none' })
  } else {
    uni.showToast({ title: `课程详情开发中：${item.title}`, icon: 'none' })
  }
}
</script>

<style lang="scss" scoped>
.mine-list {
  height: 100vh;
  display: flex;
  flex-direction: column;
  box-sizing: border-box;
  @include eduPageGradientStrong;
}

/* ===== 顶部栏 ===== */
.nav-bar {
  flex-shrink: 0;
  background: transparent;
  transition: background-color 0.3s ease, box-shadow 0.3s ease;
}
.nav-bar-opaque { background: #FFFFFF; box-shadow: 0 2rpx 12rpx rgba(0, 0, 0, 0.06); }
.nav-bar-inner { display: flex; align-items: center; padding-left: 16rpx; }
.nav-back { width: 72rpx; height: 72rpx; display: flex; align-items: center; justify-content: center; }
.back-icon { font-size: 44rpx; color: $edu-text-primary; }
.nav-title { font-size: 40rpx; font-weight: 700; color: $edu-text-primary; margin-left: 8rpx; }

/* ===== 滚动区 ===== */
.list-scroll {
  flex: 1;
  min-height: 0;
  padding: 0 32rpx;
  box-sizing: border-box;
}

/* ===== 筛选标签 ===== */
.filter-tabs { display: flex; align-items: center; margin-top: 24rpx; }
.filter-pill {
  display: flex; align-items: center; justify-content: center;
  height: 72rpx; padding: 0 44rpx; border-radius: 36rpx; margin-right: 20rpx;
  @include eduSurfaceWash;
  box-shadow: 0 4rpx 12rpx rgba(0, 0, 0, 0.03);
}
.filter-pill-active {
  background: $edu-primary;
  .filter-pill-text { color: #FFFFFF; font-weight: 600; }
}
.filter-pill-text { font-size: 28rpx; color: $edu-text-secondary; }

/* ===== 列表 ===== */
.fav-list { margin-top: 24rpx; }
.fav-item { position: relative; display: flex; align-items: center; padding: 28rpx 0; }
.fav-item-divider::after {
  content: ''; position: absolute; left: 0; right: 0; bottom: 0;
  height: 2rpx; background: rgba(0, 0, 0, 0.05);
}
.fav-cover-wrap { position: relative; width: 200rpx; height: 140rpx; flex-shrink: 0; margin-right: 24rpx; }
.fav-cover { width: 200rpx; height: 140rpx; border-radius: 16rpx; }
.fav-cover-placeholder { background: linear-gradient(135deg, #DCE8FF 0%, #5B8DEF 100%); }

/* 续播进度条 */
.progress-track {
  position: absolute; left: 0; right: 0; bottom: 0;
  height: 6rpx; background: rgba(0, 0, 0, 0.35);
  border-bottom-left-radius: 16rpx; border-bottom-right-radius: 16rpx;
  overflow: hidden;
}
.progress-bar { height: 100%; background: $edu-primary; }

.fav-info { flex: 1; display: flex; flex-direction: column; justify-content: center; }
.fav-title {
  font-size: 32rpx; font-weight: 600; color: $edu-text-primary; line-height: 1.4; margin-bottom: 16rpx;
  display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;
}
.fav-time { font-size: 26rpx; color: $edu-text-hint; }

/* ===== 空态 ===== */
.empty { padding: 160rpx 0; display: flex; justify-content: center; }
.empty-text { font-size: 28rpx; color: $edu-text-hint; }

/* ===== 加载更多 ===== */
.load-more { padding: 40rpx 0 60rpx; display: flex; justify-content: center; }
.load-more-text { font-size: 26rpx; color: $edu-text-hint; }
</style>
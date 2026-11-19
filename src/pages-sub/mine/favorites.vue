<template>
  <MineTargetList :class="themeClass" title="我的收藏" :items="list" time-label="收藏于：" />
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { onLoad } from '@dcloudio/uni-app'
import MineTargetList from '@/components/MineTargetList.vue'
import type { UserTargetItem } from '@/types/user'
import { getMyFavoritesApi } from '@/api/interaction'
import { useTheme } from '@/composables/useTheme'

const { themeClass } = useTheme()

const list = ref<UserTargetItem[]>([])

onLoad(async () => {
  try {
    list.value = await getMyFavoritesApi()
  } catch (e) {
    // 拉取失败保持空列表，组件展示空态
  }
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
.nav-bar-opaque { background: var(--edu-surface); box-shadow: 0 2rpx 12rpx rgba(0, 0, 0, 0.06); }
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
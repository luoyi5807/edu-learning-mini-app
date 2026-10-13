<template>
  <view class="stats-page">
    <!-- 固定顶部栏：返回 + 标题 -->
    <view class="nav-bar" :class="{ 'nav-bar-opaque': navBarOpaque }" :style="{ paddingTop: statusBarHeight + 'px' }">
      <view class="nav-bar-inner" :style="{ height: navContentHeight + 'px' }">
        <view class="nav-back" @tap="goBack">
          <text class="back-icon">←</text>
        </view>
        <text class="nav-title">学习数据</text>
      </view>
    </view>
    <view class="nav-placeholder" :style="{ height: (statusBarHeight + navContentHeight) + 'px' }"></view>

    <!-- 顶部两张卡 -->
    <view class="stat-row">
      <view class="stat-card">
        <text class="stat-card-label">今日学习</text>
        <view class="stat-num-line">
          <text class="stat-num stat-num-blue">{{ todayMinutes }}</text>
          <text class="stat-unit">分钟</text>
        </view>
      </view>
      <view class="stat-card">
        <text class="stat-card-label">连续学习</text>
        <view class="stat-num-line">
          <text class="stat-num stat-num-blue">{{ continueStudyDays }}</text>
          <text class="stat-unit">天</text>
        </view>
      </view>
    </view>

    <!-- 本周柱状图 -->
    <view class="chart-card">
      <text class="chart-title">本周学习时长</text>
      <view class="chart-bars">
        <view class="bar-col" v-for="d in weekData" :key="d.day">
          <view class="bar-area">
            <view class="bar" :style="{ height: barHeight(d.minutes) }"></view>
          </view>
          <text class="bar-label">{{ d.day }}</text>
        </view>
      </view>
    </view>

    <!-- 底部三张卡 -->
    <view class="stat-row">
      <view class="stat-card stat-card-sm">
        <text class="stat-num stat-num-dark">{{ finishedCourses }}</text>
        <text class="stat-card-sub">已完成课程</text>
      </view>
      <view class="stat-card stat-card-sm">
        <text class="stat-num stat-num-dark">{{ noteCount }}</text>
        <text class="stat-card-sub">笔记</text>
      </view>
      <view class="stat-card stat-card-sm">
        <text class="stat-num stat-num-dark">{{ todoCount }}</text>
        <text class="stat-card-sub">待办</text>
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { onLoad, onPageScroll } from '@dcloudio/uni-app'

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
const navBarOpaque = ref<boolean>(false)
onPageScroll((e) => {
  navBarOpaque.value = e.scrollTop > 40
})

/* ===== 数据（Mock，camelCase，接口零改动） ===== */
const todayMinutes = ref<number>(45)
const continueStudyDays = ref<number>(7)
const finishedCourses = ref<number>(3)
const noteCount = ref<number>(12)
const todoCount = ref<number>(5)

interface DayDuration { day: string; minutes: number }
const weekData = ref<DayDuration[]>([
  { day: '一', minutes: 30 },
  { day: '二', minutes: 55 },
  { day: '三', minutes: 20 },
  { day: '四', minutes: 75 },
  { day: '五', minutes: 65 },
  { day: '六', minutes: 90 },
  { day: '日', minutes: 45 }
])

const maxMinutes = computed<number>(() => Math.max(...weekData.value.map((d) => d.minutes), 1))
const MAX_BAR = 240 // rpx

function barHeight(minutes: number): string {
  if (minutes <= 0) return '8rpx'
  const h = Math.round((minutes / maxMinutes.value) * MAX_BAR)
  return Math.max(h, 16) + 'rpx'
}

function goBack() {
  const pages = getCurrentPages()
  if (pages.length > 1) uni.navigateBack()
  else uni.reLaunch({ url: '/pages/index/index' })
}

onLoad(() => {
  // 接口接入：学习统计（今日/连续/本周/完成数/笔记/待办）
})
</script>

<style lang="scss" scoped>
.stats-page {
  min-height: 100vh;
  box-sizing: border-box;
  padding: 0 32rpx 60rpx;
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
.nav-bar-opaque { background: #FFFFFF; box-shadow: 0 2rpx 12rpx rgba(0, 0, 0, 0.06); }
.nav-bar-inner { display: flex; align-items: center; padding-left: 16rpx; }
.nav-back { width: 72rpx; height: 72rpx; display: flex; align-items: center; justify-content: center; }
.back-icon { font-size: 44rpx; color: $edu-text-primary; }
.nav-title { font-size: 40rpx; font-weight: 700; color: $edu-text-primary; margin-left: 8rpx; }

/* ===== 卡片行 ===== */
.stat-row {
  display: flex;
  align-items: stretch;
  margin-top: 28rpx;
}
.stat-card {
  flex: 1;
  background-color: $edu-surface;
  border-radius: 24rpx;
  padding: 32rpx;
  box-shadow: 0 8rpx 24rpx rgba(0, 0, 0, 0.04);
}
.stat-card + .stat-card { margin-left: 24rpx; }
.stat-card-label { font-size: 28rpx; color: $edu-text-secondary; }
.stat-num-line { display: flex; align-items: baseline; margin-top: 16rpx; }
.stat-num { font-weight: 800; line-height: 1; }
.stat-num-blue { font-size: 68rpx; color: $edu-primary; }
.stat-num-dark { font-size: 56rpx; color: $edu-text-primary; display: block; text-align: center; }
.stat-unit { font-size: 28rpx; color: $edu-text-secondary; margin-left: 12rpx; }

/* 底部三卡居中 */
.stat-card-sm {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 36rpx 16rpx;
}
.stat-card-sub { font-size: 26rpx; color: $edu-text-secondary; margin-top: 16rpx; }

/* ===== 柱状图卡 ===== */
.chart-card {
  margin-top: 28rpx;
  background-color: $edu-surface;
  border-radius: 24rpx;
  padding: 32rpx;
  box-shadow: 0 8rpx 24rpx rgba(0, 0, 0, 0.04);
}
.chart-title { font-size: 32rpx; font-weight: 700; color: $edu-text-primary; }
.chart-bars {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  height: 300rpx;
  margin-top: 40rpx;
  padding-bottom: 8rpx;
}
.bar-col {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: flex-end;
  height: 100%;
}
.bar-area {
  height: 240rpx;
  display: flex;
  align-items: flex-end;
  justify-content: center;
}
.bar {
  width: 48rpx;
  border-radius: 10rpx 10rpx 4rpx 4rpx;
  background: linear-gradient(180deg, #6BA5FF 0%, #4E86F0 100%);
}
.bar-label { font-size: 26rpx; color: $edu-text-secondary; margin-top: 20rpx; }
</style>
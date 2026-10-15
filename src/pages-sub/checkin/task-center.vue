<template>
  <view class="task-page">
    <!-- 固定顶部栏：返回 + 标题 + 右侧「签到记录」 -->
    <view class="nav-bar" :class="{ 'nav-bar-opaque': navBarOpaque }" :style="{ paddingTop: statusBarHeight + 'px' }">
      <view
          class="nav-bar-inner"
          :style="{ height: navContentHeight + 'px', paddingRight: capsuleReserve + 'px' }"
      >
        <view class="nav-left">
          <view class="nav-back" @tap="goBack">
            <text class="back-icon">←</text>
          </view>
          <text class="nav-title">任务中心</text>
        </view>
        <view class="record-btn" @tap="goRecord">
          <text class="record-btn-text">签到记录</text>
        </view>
      </view>
    </view>
    <view class="nav-placeholder" :style="{ height: (statusBarHeight + navContentHeight) + 'px' }"></view>

    <!-- 积分卡（品牌渐变） -->
    <view class="points-card">
      <text class="points-label">我的积分</text>
      <text class="points-value">{{ points }}</text>
      <view class="points-foot">
        <text class="points-foot-text">连续签到 {{ continueSignDay }} 天</text>
        <text class="points-foot-text">累计签到 {{ totalSignDay }} 次</text>
      </view>
    </view>

    <!-- 签到按钮（青绿） -->
    <view
        class="checkin-btn"
        :class="{ 'checkin-btn-done': signedToday }"
        @tap="handleCheckin"
    >
      <text class="checkin-btn-text">{{ signedToday ? '今日已签到' : `签到 +${todayTask.reward} 积分` }}</text>
    </view>

    <!-- 免广告权益状态 -->
    <view class="info-card">
      <view class="status-dot" :class="{ 'status-dot-on': hasAdFree }"></view>
      <text class="status-text">{{ hasAdFree ? `免广告权益剩余 ${adFreeMinutes} 分钟` : '当前无免广告权益' }}</text>
    </view>

    <!-- 规则入口 -->
    <view class="info-card info-card-between" @tap="showRules">
      <text class="rules-title">积分获取与兑换规则</text>
      <text class="rules-link">查看 ›</text>
    </view>

    <!-- 兑换区 -->
    <text class="section-title">积分兑换免广告</text>
    <view class="exchange-card" v-for="p in exchangeProducts" :key="p.id">
      <view class="exchange-info">
        <text class="exchange-name">{{ p.name }}</text>
        <text class="exchange-cost">{{ p.costPoints }} 积分</text>
      </view>
      <view class="exchange-btn" :class="{ 'exchange-btn-disabled': points < p.costPoints }" @tap="handleExchange(p)">
        <text class="exchange-btn-text">兑换</text>
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { onLoad, onPageScroll } from '@dcloudio/uni-app'
import { AD_FREE_PRODUCTS } from '@/composables/pointsRule'

/* ===== 顶部栏高度（含状态栏 + 胶囊区） ===== */
const statusBarHeight = ref<number>(0)
const navContentHeight = ref<number>(44)
const capsuleReserve = ref<number>(100)

const sysInfo = uni.getSystemInfoSync()
statusBarHeight.value = sysInfo.statusBarHeight || 0
// #ifdef MP-WEIXIN
const menuButton = uni.getMenuButtonBoundingClientRect()
if (menuButton) {
  navContentHeight.value = (menuButton.top - statusBarHeight.value) * 2 + menuButton.height
  capsuleReserve.value = sysInfo.windowWidth - menuButton.left + 8
}
// #endif

/* ===== 顶栏滚动变白 ===== */
const navBarOpaque = ref<boolean>(false)
onPageScroll((e) => {
  navBarOpaque.value = e.scrollTop > 40
})

/* ===== 数据（Mock，字段对齐 sign-calendar / checkins DTO，接口零改动） ===== */
const points = ref<number>(286)
const continueSignDay = ref<number>(12)
const totalSignDay = ref<number>(12)
const signedToday = ref<boolean>(false)

// 今日签到任务：checkinType 1点击即签 2定位 3手势 4拍照
const todayTask = ref({ taskId: 1, taskName: '每日签到', checkinType: 1, reward: 18 })

// 免广告权益
const hasAdFree = ref<boolean>(false)
const adFreeMinutes = ref<number>(0)

// 兑换商品（与积分规则页同源）
interface ExchangeProduct { id: number; name: string; costPoints: number; minutes: number }
const exchangeProducts = ref<ExchangeProduct[]>(
  AD_FREE_PRODUCTS.map((p, idx) => ({ id: idx + 1, name: p.label, costPoints: p.points, minutes: p.minutes }))
)

/* ===== 交互 ===== */
function goBack() {
  const pages = getCurrentPages()
  if (pages.length > 1) uni.navigateBack()
  else uni.reLaunch({ url: '/pages/index/index' })
}

function goRecord() {
  uni.navigateTo({ url: '/pages-sub/checkin/record' })
}

// POST checkins（checkinType=1 点击即签；此处乐观更新，失败回滚）
function handleCheckin() {
  if (signedToday.value) {
    uni.showToast({ title: '今天已经签到啦', icon: 'none' })
    return
  }
  if (todayTask.value.checkinType !== 1) {
    uni.showToast({ title: '该签到方式开发中', icon: 'none' })
    return
  }
  const before = points.value
  points.value += todayTask.value.reward
  signedToday.value = true
  continueSignDay.value += 1
  totalSignDay.value += 1
  uni.showToast({ title: `签到成功 +${todayTask.value.reward} 积分`, icon: 'none' })
  // 接口失败时回滚：points.value = before ...
  void before
}

function showRules() {
  uni.navigateTo({ url: '/pages-sub/checkin/points-rules' })
}

function handleExchange(p: ExchangeProduct) {
  if (points.value < p.costPoints) {
    uni.showToast({ title: '积分不足', icon: 'none' })
    return
  }
  points.value -= p.costPoints
  hasAdFree.value = true
  adFreeMinutes.value += p.minutes
  uni.showToast({ title: `兑换成功，免广告 ${p.minutes} 分钟`, icon: 'none' })
}

onLoad(() => {
  // 接口接入：GET checkins/tasks/today、GET user/sign-calendar
})
</script>

<style lang="scss" scoped>
.task-page {
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
.nav-bar-inner { display: flex; align-items: center; justify-content: space-between; padding-left: 16rpx; }
.nav-left { display: flex; align-items: center; }
.nav-back { width: 72rpx; height: 72rpx; display: flex; align-items: center; justify-content: center; }
.back-icon { font-size: 44rpx; color: $edu-text-primary; }
.nav-title { font-size: 40rpx; font-weight: 700; color: $edu-text-primary; margin-left: 8rpx; }
.record-btn {
  height: 64rpx; padding: 0 28rpx; border-radius: 32rpx;
  display: flex; align-items: center; justify-content: center;
  background-color: $edu-primary-container;
}
.record-btn-text { font-size: 26rpx; color: $edu-primary; font-weight: 500; }

/* ===== 积分卡 ===== */
.points-card {
  margin-top: 24rpx;
  border-radius: 32rpx;
  padding: 44rpx 40rpx 36rpx;
  display: flex;
  flex-direction: column;
  align-items: center;
  @include eduBrandGradient;
  box-shadow: 0 16rpx 32rpx rgba(54, 119, 239, 0.25);
}
.points-label { font-size: 28rpx; color: rgba(255, 255, 255, 0.9); }
.points-value { font-size: 96rpx; font-weight: 800; color: #FFFFFF; line-height: 1.2; margin: 8rpx 0 24rpx; }
.points-foot { display: flex; align-items: center; justify-content: center; }
.points-foot-text { font-size: 26rpx; color: rgba(255, 255, 255, 0.9); margin: 0 24rpx; }

/* ===== 签到按钮 ===== */
.checkin-btn {
  margin-top: 32rpx;
  height: 108rpx;
  border-radius: 24rpx;
  display: flex; align-items: center; justify-content: center;
  background: linear-gradient(135deg, #00C2D4 0%, #00A2B6 100%);
  box-shadow: 0 12rpx 24rpx rgba(0, 176, 192, 0.22);
}
.checkin-btn-done { background: $edu-surface-variant; box-shadow: none; }
.checkin-btn-text { font-size: 34rpx; font-weight: 700; color: #FFFFFF; }
.checkin-btn-done .checkin-btn-text { color: $edu-text-hint; }

/* ===== 信息卡 ===== */
.info-card {
  margin-top: 28rpx;
  min-height: 108rpx;
  border-radius: 24rpx;
  padding: 0 32rpx;
  display: flex; align-items: center;
  background-color: $edu-surface-variant;
}
.info-card-between { justify-content: space-between; }
.status-dot { width: 16rpx; height: 16rpx; border-radius: 50%; background-color: $edu-text-hint; margin-right: 20rpx; flex-shrink: 0; }
.status-dot-on { background-color: $edu-accent-teal; }
.status-text { font-size: 30rpx; color: $edu-text-secondary; }
.rules-title { font-size: 32rpx; font-weight: 600; color: $edu-text-primary; }
.rules-link { font-size: 28rpx; color: $edu-primary; }

/* ===== 兑换区 ===== */
.section-title { display: block; font-size: 34rpx; font-weight: 700; color: $edu-text-primary; margin: 44rpx 0 24rpx; }
.exchange-card {
  border-radius: 24rpx;
  padding: 32rpx;
  display: flex; align-items: center; justify-content: space-between;
  background-color: $edu-surface-variant;
  margin-bottom: 24rpx;
}
.exchange-info { display: flex; flex-direction: column; }
.exchange-name { font-size: 32rpx; font-weight: 600; color: $edu-text-primary; margin-bottom: 12rpx; }
.exchange-cost { font-size: 26rpx; color: $edu-text-hint; }
.exchange-btn {
  height: 72rpx; padding: 0 48rpx; border-radius: 36rpx;
  display: flex; align-items: center; justify-content: center;
  background-color: $edu-primary;
}
.exchange-btn-disabled { background-color: $edu-outline; }
.exchange-btn-text { font-size: 28rpx; font-weight: 500; color: #FFFFFF; }
</style>
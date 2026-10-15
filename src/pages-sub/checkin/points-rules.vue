<template>
  <view class="rules-page">
    <!-- 固定顶部栏：返回 + 标题 -->
    <view class="nav-bar" :class="{ 'nav-bar-opaque': navBarOpaque }" :style="{ paddingTop: statusBarHeight + 'px' }">
      <view class="nav-bar-inner" :style="{ height: navContentHeight + 'px' }">
        <view class="nav-back" @tap="goBack">
          <text class="back-icon">←</text>
        </view>
        <text class="nav-title">积分获取规则</text>
      </view>
    </view>
    <view class="nav-placeholder" :style="{ height: (statusBarHeight + navContentHeight) + 'px' }"></view>

    <!-- 签到积分规则 -->
    <view class="rule-card">
      <text class="card-title">签到积分规则</text>
      <view class="rule-row">
        <text class="rule-label">每日签到</text>
        <text class="rule-value">每天可签到一次</text>
      </view>
      <view v-for="item in signRules" :key="item.day" class="rule-row">
        <text class="rule-label">连续 {{ item.day }} 天</text>
        <text class="rule-value">{{ item.points }} 积分{{ item.suffix }}</text>
      </view>
      <view class="rule-row">
        <text class="rule-label">断签重置</text>
        <text class="rule-value rule-value-wrap">中断一天后连续天数重新从 1 开始</text>
      </view>
    </view>

    <!-- 积分兑换规则 -->
    <view class="rule-card">
      <text class="card-title">积分兑换规则</text>
      <view v-for="p in products" :key="p.points" class="rule-row">
        <text class="rule-label">{{ p.points }} 积分</text>
        <text class="rule-value">{{ p.label }}</text>
      </view>
      <view class="rule-row">
        <text class="rule-label">有效期</text>
        <text class="rule-value rule-value-wrap">兑换后立即生效，按自然时间倒计时</text>
      </view>
    </view>

    <text class="foot-note">规则由后端配置下发，实际以签到结果为准</text>
  </view>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { onPageScroll } from '@dcloudio/uni-app'
import { CONTINUOUS_REWARDS, AD_FREE_PRODUCTS } from '@/composables/pointsRule'

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

/* ===== 规则表（与任务中心共用 pointsRule 模块） ===== */
interface SignRule { day: number; points: number; suffix: string }

const signRules = ref<SignRule[]>(
    CONTINUOUS_REWARDS.map((points, idx) => ({
      day: idx + 1,
      points,
      suffix: idx === CONTINUOUS_REWARDS.length - 1 ? '（之后循环）' : ''
    }))
)

const products = ref(AD_FREE_PRODUCTS)

function goBack() {
  const pages = getCurrentPages()
  if (pages.length > 1) uni.navigateBack()
  else uni.reLaunch({ url: '/pages/index/index' })
}
</script>

<style lang="scss" scoped>
.rules-page {
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

/* ===== 规则卡 ===== */
.rule-card {
  margin-top: 24rpx;
  padding: 40rpx 32rpx 20rpx;
  border-radius: 32rpx;
  background-color: $edu-surface;
  box-shadow: 0 8rpx 24rpx rgba(0, 0, 0, 0.04);
}
.card-title {
  display: block;
  font-size: 36rpx;
  font-weight: 700;
  color: $edu-text-primary;
  margin-bottom: 24rpx;
}
.rule-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  min-height: 96rpx;
  padding: 16rpx 0;
}
.rule-label { font-size: 30rpx; color: $edu-text-secondary; flex-shrink: 0; margin-right: 24rpx; }
.rule-value {
  font-size: 32rpx;
  font-weight: 600;
  color: $edu-text-primary;
  text-align: right;
}
.rule-value-wrap { font-size: 28rpx; font-weight: 400; line-height: 1.4; }

.foot-note {
  display: block;
  font-size: 24rpx;
  color: $edu-text-hint;
  text-align: center;
  margin-top: 36rpx;
}
</style>
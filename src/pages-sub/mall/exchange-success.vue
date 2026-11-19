<!-- src/pages-sub/mall/exchange-success.vue -->
<template>
  <view class="success-page" :class="themeClass">
    <view class="nav-bar" :style="{ paddingTop: statusBarHeight + 'px' }">
      <view class="nav-bar-inner" :style="{ height: navContentHeight + 'px' }">
        <view class="nav-back" @tap="backMall"><text class="back-icon">←</text></view>
        <text class="nav-title">兑换成功</text>
      </view>
    </view>
    <view class="nav-placeholder" :style="{ height: (statusBarHeight + navContentHeight) + 'px' }"></view>

    <view class="hero">
      <view class="hero-circle"><text class="hero-check">✓</text></view>
      <text class="hero-title">兑换成功</text>
      <text class="hero-sub">兑换码已生成，可在兑换记录中随时查看</text>
    </view>

    <!-- 兑换码卡片 -->
    <view class="code-card" v-if="info.redemptionCode">
      <text class="code-label">兑换码</text>
      <view class="code-row">
        <text class="code-value">{{ info.redemptionCode }}</text>
        <view class="code-copy" @tap="copyCode"><text class="code-copy-text">复制</text></view>
      </view>
    </view>

    <view class="goods-card">
      <view class="gc-info">
        <text class="gc-name">{{ info.productName }}</text>
        <view class="gc-tags"><text class="gc-done-tag">已兑换</text></view>
      </view>
      <view class="gc-right"><text class="gc-cost">-{{ info.pointsCost }}</text><text class="gc-unit">积分</text></view>
    </view>

    <view class="consume-card">
      <view class="cc-row"><text class="cc-label">本次消耗</text><text class="cc-value">{{ info.pointsCost }} 积分</text></view>
      <view class="cc-row" v-if="info.orderId"><text class="cc-label">订单号</text><text class="cc-value cc-value-plain">{{ info.orderId }}</text></view>
    </view>

    <view class="bottom-bar">
      <view class="bb-btn-ghost" @tap="backMall"><text class="bb-btn-ghost-text">返回商城</text></view>
      <view class="bb-btn-primary" @tap="goRecords"><text class="bb-btn-primary-text">查看兑换记录</text></view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { onLoad } from '@dcloudio/uni-app'
import { useTheme } from '@/composables/useTheme'

const { themeClass } = useTheme()

const statusBarHeight = ref<number>(0)
const navContentHeight = ref<number>(44)
const sysInfo = uni.getSystemInfoSync()
statusBarHeight.value = sysInfo.statusBarHeight || 0
// #ifdef MP-WEIXIN
const menuButton = uni.getMenuButtonBoundingClientRect()
if (menuButton) navContentHeight.value = (menuButton.top - statusBarHeight.value) * 2 + menuButton.height
// #endif

/** 由确认页兑换成功后透传（后端 exchange 响应顶层字段） */
const info = ref<{ orderId: number; redemptionCode: string; productName: string; pointsCost: number }>({
  orderId: 0, redemptionCode: '', productName: '', pointsCost: 0
})

function backMall() {
  const pages = getCurrentPages()
  if (pages.length > 1) uni.navigateBack()
  else uni.reLaunch({ url: '/pages-sub/mall/mall' })
}
function goRecords() { uni.redirectTo({ url: '/pages-sub/mall/exchange-records' }) }
function copyCode() {
  uni.setClipboardData({
    data: info.value.redemptionCode,
    success: () => uni.showToast({ title: '兑换码已复制', icon: 'success' })
  })
}

onLoad((q) => {
  info.value = {
    orderId: Number((q && q.orderId) || 0),
    redemptionCode: decodeURIComponent((q && q.code) || ''),
    productName: decodeURIComponent((q && q.name) || ''),
    pointsCost: Number((q && q.cost) || 0)
  }
})
</script>

<style lang="scss" scoped>
.success-page { min-height: 100vh; box-sizing: border-box; padding: 0 32rpx 200rpx; @include eduPageGradientStrong; }
.nav-bar { position: fixed; top: 0; left: 0; right: 0; z-index: 99; background: transparent; }
.nav-bar-inner { display: flex; align-items: center; padding-left: 16rpx; }
.nav-back { width: 72rpx; height: 72rpx; display: flex; align-items: center; justify-content: center; }
.back-icon { font-size: 44rpx; color: $edu-text-primary; }
.nav-title { font-size: 40rpx; font-weight: 700; color: $edu-text-primary; margin-left: 8rpx; }

.hero { display: flex; flex-direction: column; align-items: center; padding: 40rpx 0 24rpx; }
.hero-circle { width: 160rpx; height: 160rpx; border-radius: 50%; background-color: #DCF2F5; display: flex; align-items: center; justify-content: center; }
.hero-check { font-size: 80rpx; font-weight: 700; color: $edu-accent-teal; }
.hero-title { font-size: 44rpx; font-weight: 800; color: $edu-text-primary; margin-top: 32rpx; }
.hero-sub { font-size: 26rpx; color: $edu-text-secondary; margin-top: 16rpx; }

/* 兑换码 */
.code-card { border-radius: 24rpx; padding: 32rpx; background-color: $edu-surface; box-shadow: 0 8rpx 24rpx rgba(0, 0, 0, 0.04); margin-top: 24rpx; border: 2rpx dashed $edu-primary; }
.code-label { font-size: 24rpx; color: $edu-text-hint; }
.code-row { display: flex; align-items: center; justify-content: space-between; margin-top: 12rpx; }
.code-value { font-size: 40rpx; font-weight: 800; color: $edu-primary; letter-spacing: 4rpx; }
.code-copy { height: 56rpx; padding: 0 28rpx; border-radius: 28rpx; display: flex; align-items: center; background-color: $edu-primary-container; }
.code-copy-text { font-size: 26rpx; font-weight: 600; color: $edu-primary; }

.goods-card { display: flex; align-items: center; border-radius: 24rpx; padding: 32rpx; background-color: $edu-surface; box-shadow: 0 8rpx 24rpx rgba(0, 0, 0, 0.04); margin-top: 28rpx; }
.gc-info { flex: 1; min-width: 0; }
.gc-name { display: block; font-size: 32rpx; font-weight: 700; color: $edu-text-primary; }
.gc-tags { display: flex; align-items: center; margin-top: 12rpx; }
.gc-done-tag { font-size: 22rpx; color: #0E6E78; background-color: #DCF2F5; padding: 4rpx 14rpx; border-radius: 8rpx; }
.gc-right { display: flex; flex-direction: column; align-items: flex-end; flex-shrink: 0; }
.gc-cost { font-size: 34rpx; font-weight: 800; color: $edu-primary; }
.gc-unit { font-size: 22rpx; color: $edu-text-hint; margin-top: 6rpx; }

.consume-card { border-radius: 24rpx; padding: 8rpx 32rpx; background-color: $edu-surface; box-shadow: 0 8rpx 24rpx rgba(0, 0, 0, 0.04); margin-top: 28rpx; }
.cc-row { display: flex; align-items: center; justify-content: space-between; padding: 24rpx 0; }
.cc-label { font-size: 28rpx; color: $edu-text-secondary; }
.cc-value { font-size: 32rpx; font-weight: 800; color: $edu-primary; }
.cc-value-plain { font-size: 28rpx; font-weight: 500; color: $edu-text-secondary; }

.bottom-bar { position: fixed; left: 0; right: 0; bottom: 0; z-index: 50; display: flex; align-items: center; padding: 20rpx 32rpx calc(20rpx + env(safe-area-inset-bottom)); background-color: $edu-surface; box-shadow: 0 -2rpx 16rpx rgba(0, 0, 0, 0.06); }
.bb-btn-ghost { flex: 1; height: 88rpx; border-radius: 44rpx; display: flex; align-items: center; justify-content: center; border: 2rpx solid $edu-primary; margin-right: 24rpx; }
.bb-btn-ghost-text { font-size: 30rpx; font-weight: 600; color: $edu-primary; }
.bb-btn-primary { flex: 1.2; height: 88rpx; border-radius: 44rpx; display: flex; align-items: center; justify-content: center; @include eduBrandGradient; }
.bb-btn-primary-text { font-size: 30rpx; font-weight: 700; color: #FFFFFF; }
</style>
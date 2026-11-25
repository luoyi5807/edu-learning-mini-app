<template>
  <!-- App 端真实 uni-ad：包进 APP-PLUS，微信小程序编译时整块剔除，避免触发 DCloud 登录 -->
  <!-- #ifdef APP-PLUS -->
  <view class="ad-banner" v-if="adpid && !simulate">
    <ad :adpid="adpid" class="ad-real" />
  </view>
  <!-- #endif -->
  <!-- 模拟广告：无真实投放时渲染高仿真广告卡（演示/答辩用）；独立 v-if，与真实分支互斥 -->
  <view class="ad-banner ad-sim" v-if="simulate">
    <view class="sim-card">
      <view class="sim-media">
        <text class="sim-brand">{{ creative.brand }}</text>
        <text class="sim-slogan">{{ creative.slogan }}</text>
      </view>
      <view class="sim-bar">
        <view class="sim-cta"><text class="sim-cta-text">{{ creative.cta }}</text></view>
        <text class="sim-tag">广告</text>
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { AD_SIMULATE } from '@/config/env'

const props = defineProps<{ unitId?: string; scene?: string; adpid?: string }>()
const simulate = AD_SIMULATE

const CREATIVES = [
  { brand: '网易云课堂', slogan: '限时秒杀 · 好课 1 折起', cta: '立即抢购' },
  { brand: '得到 APP', slogan: '每天听本书，通勤也能涨知识', cta: '免费试听' },
  { brand: 'B 站课堂', slogan: '大学生都在学的编程课', cta: '了解详情' },
  { brand: '菜鸟教程', slogan: '零基础入门，边学边练', cta: '开始学习' },
]
const creative = computed(() => {
  const key = props.scene || ''
  let idx = 0
  for (let i = 0; i < key.length; i++) idx += key.charCodeAt(i)
  return CREATIVES[idx % CREATIVES.length]
})
</script>

<style lang="scss" scoped>
.ad-banner { margin: 24rpx 0; }
.ad-real { width: 100%; }
.sim-card { border-radius: 24rpx; overflow: hidden; background: $edu-surface; box-shadow: 0 8rpx 24rpx rgba(0, 0, 0, 0.06); }
.sim-media { height: 200rpx; display: flex; flex-direction: column; justify-content: center; padding: 0 32rpx; background: linear-gradient(135deg, #5B9BFF 0%, #3677EF 100%); }
.sim-brand { font-size: 34rpx; font-weight: 700; color: #FFFFFF; }
.sim-slogan { font-size: 26rpx; color: rgba(255, 255, 255, 0.9); margin-top: 12rpx; }
.sim-bar { display: flex; align-items: center; justify-content: space-between; padding: 20rpx 32rpx; }
.sim-cta { height: 56rpx; padding: 0 28rpx; border-radius: 28rpx; background-color: $edu-primary-container; display: flex; align-items: center; }
.sim-cta-text { font-size: 26rpx; color: $edu-primary; font-weight: 600; }
.sim-tag { font-size: 20rpx; color: $edu-text-hint; }
</style>
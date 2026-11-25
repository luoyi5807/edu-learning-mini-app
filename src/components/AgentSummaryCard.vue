<template>
  <view class="sum-card">
    <text class="sum-heading">{{ summary.heading }}</text>
    <text class="sum-intro">{{ summary.intro }}</text>
    <view class="sum-bullet" v-for="(b, i) in summary.bullets" :key="i">
      <text class="sum-dot">•</text>
      <text class="sum-bullet-text">{{ b.label }}：{{ b.text }}</text>
    </view>
    <text class="sum-source-title">来源</text>
    <view class="sum-source" v-for="(s, i) in summary.sources" :key="'s' + i">
      <text class="sum-source-icon">📄</text>
      <text class="sum-source-text">{{ s }}</text>
    </view>
    <text class="sum-footnote">{{ summary.footnote }}</text>
  </view>
</template>

<script setup lang="ts">
import type { AgentSummaryPayload } from '@/types/agent'
defineProps<{ summary: AgentSummaryPayload }>()
</script>

<style lang="scss" scoped>
.sum-card { padding: 36rpx 32rpx; border-radius: 28rpx; background-color: $edu-surface; box-shadow: 0 8rpx 24rpx rgba(0, 0, 0, 0.05); }
.sum-heading { display: block; font-size: 34rpx; font-weight: 700; color: $edu-text-primary; line-height: 1.4; }
.sum-intro { display: block; font-size: 30rpx; color: $edu-text-secondary; line-height: 1.7; margin-top: 20rpx; }
.sum-bullet { display: flex; margin-top: 20rpx; }
.sum-dot { font-size: 32rpx; color: $edu-primary; margin-right: 14rpx; line-height: 1.6; }
.sum-bullet-text { flex: 1; font-size: 30rpx; color: $edu-text-secondary; line-height: 1.7; }
.sum-source-title { display: block; font-size: 26rpx; color: $edu-text-hint; margin-top: 32rpx; margin-bottom: 16rpx; }
.sum-source { display: flex; align-items: center; padding: 22rpx 24rpx; border-radius: 18rpx; background-color: $edu-surface-variant; margin-bottom: 16rpx; }
.sum-source-icon { font-size: 28rpx; color: $edu-primary; margin-right: 16rpx; }
.sum-source-text { flex: 1; font-size: 28rpx; color: $edu-text-secondary; }
.sum-footnote { display: block; font-size: 26rpx; color: $edu-text-hint; margin-top: 24rpx; }
</style>
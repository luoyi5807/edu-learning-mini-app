<template>
  <view class="answer-card">
    <text class="ac-text">{{ data.answer }}</text>

    <view class="ac-bullets" v-if="data.bullets && data.bullets.length">
      <view class="ac-bullet" v-for="(b, i) in data.bullets" :key="i">
        <text class="ac-dot">•</text>
        <text class="ac-bullet-label">{{ b.label }}：</text>
        <text class="ac-bullet-text">{{ b.text }}</text>
      </view>
    </view>

    <block v-if="data.sources && data.sources.length">
      <text class="ac-src-label">来源</text>
      <view class="ac-src" v-for="(s, i) in data.sources" :key="i">
        <text class="ac-src-icon">📄</text>
        <view class="ac-src-body">
          <text class="ac-src-title">{{ s.title }}</text>
          <text class="ac-src-sub" v-if="s.sub">{{ s.sub }}</text>
        </view>
        <text class="ac-src-time" v-if="s.time">{{ s.time }}</text>
      </view>
    </block>

    <text class="ac-foot" v-if="data.footnote">{{ data.footnote }}</text>
  </view>
</template>

<script setup lang="ts">
import type { AgentAnswerPayload } from '@/types/agent'
defineProps<{ data: AgentAnswerPayload }>()
</script>

<style lang="scss" scoped>
.answer-card {
  max-width: 92%; padding: 28rpx; border-radius: 8rpx 28rpx 28rpx 28rpx;
  background-color: $edu-surface; box-shadow: 0 6rpx 18rpx rgba(0, 0, 0, 0.04);
}
.ac-text { display: block; font-size: 30rpx; color: $edu-text-primary; line-height: 1.7; }
.ac-bullets { margin-top: 20rpx; }
.ac-bullet { display: flex; align-items: baseline; margin-top: 12rpx; }
.ac-dot { font-size: 30rpx; color: $edu-primary; margin-right: 12rpx; }
.ac-bullet-label { font-size: 28rpx; color: $edu-text-secondary; }
.ac-bullet-text { flex: 1; font-size: 28rpx; color: $edu-text-secondary; line-height: 1.5; }
.ac-src-label { display: block; font-size: 24rpx; color: $edu-text-hint; margin: 24rpx 0 12rpx; }
.ac-src {
  display: flex; align-items: center; padding: 20rpx 24rpx; border-radius: 16rpx;
  background-color: $edu-surface-variant; margin-bottom: 12rpx;
}
.ac-src-icon { font-size: 30rpx; color: $edu-primary; margin-right: 16rpx; }
.ac-src-body { flex: 1; min-width: 0; }
.ac-src-title { display: block; font-size: 28rpx; color: $edu-text-primary; }
.ac-src-sub { display: block; font-size: 24rpx; color: $edu-text-hint; margin-top: 4rpx; }
.ac-src-time { font-size: 26rpx; color: $edu-text-hint; margin-left: 16rpx; }
.ac-foot { display: block; font-size: 24rpx; color: $edu-text-hint; margin-top: 16rpx; }
</style>
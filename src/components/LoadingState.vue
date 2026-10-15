<template>
  <view class="loading-state" :class="{ 'loading-state-inline': inline }">
    <view class="spinner"></view>
    <text class="loading-text">{{ text }}</text>
  </view>
</template>

<script setup lang="ts">
defineProps({
  text: { type: String, default: '加载中…' },
  /** inline=true 时不占满屏高，用于列表底部 */
  inline: { type: Boolean, default: false }
})
</script>

<style lang="scss" scoped>
.loading-state {
  height: 320rpx;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
}
.loading-state-inline { height: 120rpx; flex-direction: row; }
.spinner {
  width: 48rpx;
  height: 48rpx;
  border-radius: 50%;
  border: 4rpx solid $edu-primary-container;
  border-top-color: $edu-primary;
  animation: edu-spin 0.8s linear infinite;
}
.loading-state-inline .spinner { margin-right: 16rpx; }
.loading-text { font-size: 28rpx; color: $edu-text-hint; margin-top: 20rpx; }
.loading-state-inline .loading-text { margin-top: 0; }
@keyframes edu-spin {
  from { transform: rotate(0deg); }
  to { transform: rotate(360deg); }
}
</style>
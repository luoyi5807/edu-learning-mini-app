<template>
  <view class="error-state">
    <view class="error-icon-wrap">
      <text class="error-icon">!</text>
    </view>
    <text class="error-text">{{ text }}</text>
    <view class="retry-btn" hover-class="retry-btn-pressed" @tap="emit('retry')">
      <text class="retry-text">重新加载</text>
    </view>
  </view>
</template>

<script setup lang="ts">
const emit = defineEmits(['retry'])

defineProps({
  text: { type: String, default: '加载失败，请稍后重试' }
})
</script>

<style lang="scss" scoped>
.error-state {
  padding: 100rpx 0;
  display: flex;
  flex-direction: column;
  align-items: center;
}
.error-icon-wrap {
  width: 96rpx;
  height: 96rpx;
  border-radius: 50%;
  background-color: $edu-error-container;
  display: flex;
  align-items: center;
  justify-content: center;
}
.error-icon { font-size: 56rpx; font-weight: 700; color: $edu-error-text; }
.error-text { font-size: 28rpx; color: $edu-text-secondary; margin-top: 28rpx; text-align: center; }
.retry-btn {
  margin-top: 40rpx;
  padding: 0 56rpx;
  height: 80rpx;
  border-radius: 40rpx;
  border: 2rpx solid $edu-outline;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: background-color 0.15s;
}
.retry-btn-pressed { background-color: $edu-surface-variant; }
.retry-text { font-size: 30rpx; font-weight: 600; color: $edu-primary; }
</style>
<template>
  <view class="ai-fab" @tap="handleTap">
    <view class="ai-fab-avatar">
      <view class="ai-fab-ring"></view>
      <text class="ai-fab-emoji">✦</text>
    </view>
    <view class="ai-fab-label"><text class="ai-fab-label-text">AI阿星</text></view>
  </view>
</template>

<script setup lang="ts">
function handleTap() {
  uni.navigateTo({ url: '/pages-sub/agent/assistant' })
}
</script>

<style lang="scss" scoped>
.ai-fab {
  position: fixed;
  right: 28rpx;
  bottom: calc(150rpx + env(safe-area-inset-bottom));
  z-index: 90;
  display: flex;
  flex-direction: column;
  align-items: center;
}
.ai-fab-avatar {
  position: relative;
  width: 108rpx;
  height: 108rpx;
  border-radius: 50%;
  @include eduBrandGradient;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 10rpx 26rpx rgba(54, 119, 239, 0.42);
}
.ai-fab-ring {
  position: absolute;
  top: -8rpx; left: -8rpx; right: -8rpx; bottom: -8rpx;
  border-radius: 50%;
  border: 3rpx solid rgba(91, 155, 255, 0.55);
}
.ai-fab-emoji { font-size: 52rpx; color: #FFFFFF; }
.ai-fab-label {
  margin-top: 10rpx;
  padding: 4rpx 18rpx;
  border-radius: 22rpx;
  background-color: $edu-surface;
  box-shadow: 0 4rpx 12rpx rgba(0, 0, 0, 0.10);
}
.ai-fab-label-text { font-size: 22rpx; font-weight: 600; color: $edu-primary; }
</style>
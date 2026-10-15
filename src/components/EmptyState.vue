<template>
  <view class="empty-state">
    <text class="empty-text">{{ text }}</text>
    <view class="empty-action" v-if="actionText" hover-class="empty-action-pressed" @tap="emit('action')">
      <text class="empty-action-text">{{ actionText }}</text>
    </view>
  </view>
</template>

<script setup lang="ts">
const emit = defineEmits(['action'])

defineProps({
  text: { type: String, default: '暂无内容' },
  actionText: { type: String, default: '' }
})
</script>

<style lang="scss" scoped>
.empty-state {
  padding: 140rpx 0;
  display: flex;
  flex-direction: column;
  align-items: center;
}
.empty-text { font-size: 28rpx; color: $edu-text-hint; }
.empty-action {
  margin-top: 40rpx;
  padding: 0 48rpx;
  height: 76rpx;
  border-radius: 38rpx;
  @include eduSurfaceWash;
  border: 2rpx solid $edu-divider;
  display: flex;
  align-items: center;
  justify-content: center;
}
.empty-action-pressed { background-color: $edu-surface-variant; }
.empty-action-text { font-size: 28rpx; color: $edu-primary; }
</style>
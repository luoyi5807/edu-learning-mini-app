<template>
  <view class="course-sheet" v-if="visible">
    <view class="sheet-mask" @tap="emit('close')"></view>
    <view class="sheet-panel">
      <view class="sheet-handle"></view>
      <view class="sheet-head">
        <view class="sheet-head-text">
          <text class="sheet-title">选一门课程</text>
          <text class="sheet-sub">选好后只用于这条消息</text>
        </view>
        <view class="sheet-close" @tap="emit('close')"><text class="sheet-close-icon">✕</text></view>
      </view>
      <scroll-view class="course-scroll" scroll-y :show-scrollbar="false">
        <view class="course-item" v-for="c in courses" :key="c.courseId" @tap="emit('select', c)">
          <text class="course-title">{{ c.title }}</text>
          <text class="course-desc">{{ c.desc }}</text>
        </view>
      </scroll-view>
    </view>
  </view>
</template>

<script setup lang="ts">
import type { AgentCourse } from '@/types/agent'

defineProps<{
  visible: boolean
  courses: AgentCourse[]
}>()
const emit = defineEmits(['close', 'select'])
</script>

<style lang="scss" scoped>
.course-sheet { position: fixed; top: 0; left: 0; right: 0; bottom: 0; z-index: 320; }
.sheet-mask { position: absolute; top: 0; left: 0; right: 0; bottom: 0; background: rgba(0, 0, 0, 0.4); }
.sheet-panel {
  position: absolute; left: 0; right: 0; bottom: 0;
  background-color: $edu-surface; border-radius: 32rpx 32rpx 0 0;
  padding-bottom: env(safe-area-inset-bottom);
  display: flex; flex-direction: column;
  animation: sheet-up 0.24s ease;
}
@keyframes sheet-up { from { transform: translateY(100%); } to { transform: translateY(0); } }
.sheet-handle { width: 72rpx; height: 8rpx; border-radius: 4rpx; background: $edu-outline; margin: 16rpx auto 0; }
.sheet-head { display: flex; align-items: flex-start; padding: 20rpx 32rpx 8rpx; }
.sheet-head-text { display: flex; flex-direction: column; flex: 1; min-width: 0; }
.sheet-title { font-size: 38rpx; font-weight: 700; color: $edu-text-primary; }
.sheet-sub { font-size: 26rpx; color: $edu-text-hint; margin-top: 8rpx; }
.sheet-close { width: 64rpx; height: 64rpx; border-radius: 50%; background-color: $edu-surface-variant; display: flex; align-items: center; justify-content: center; flex-shrink: 0; }
.sheet-close-icon { font-size: 32rpx; color: $edu-text-secondary; }
.course-scroll { max-height: 56vh; padding: 8rpx 32rpx 24rpx; box-sizing: border-box; }
.course-item { padding: 24rpx 0; }
.course-title { display: block; font-size: 34rpx; font-weight: 600; color: $edu-text-primary; margin-bottom: 8rpx; }
.course-desc { display: block; font-size: 26rpx; color: $edu-text-hint; }
</style>
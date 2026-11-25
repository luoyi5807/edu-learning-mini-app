<template>
  <view class="agent-drawer" v-if="visible">
    <view class="drawer-mask" @tap="emit('close')"></view>
    <view class="drawer-panel">
      <!-- 头部：阿星 + 关闭 -->
      <view class="drawer-header" :style="{ paddingTop: (statusBarHeight + 12) + 'px' }">
        <view class="drawer-avatar"><text class="drawer-avatar-emoji">✦</text></view>
        <text class="drawer-name">阿星</text>
        <view class="drawer-close" @tap="emit('close')"><text class="drawer-close-icon">✕</text></view>
      </view>

      <!-- 新对话 -->
      <view class="new-chat" @tap="emit('new-chat')">
        <text class="new-chat-icon">✎</text>
        <text class="new-chat-text">新对话</text>
      </view>

      <!-- 历史列表 -->
      <scroll-view class="history-scroll" scroll-y :show-scrollbar="false">
        <text class="history-label">历史对话</text>
        <view
          v-for="s in sessions"
          :key="s.sessionId"
          class="history-item"
          :class="{ 'history-item-active': s.sessionId === currentId }"
          @tap="emit('select', s.sessionId)"
        >
          <text class="history-title" :class="{ 'history-title-active': s.sessionId === currentId }">{{ s.title }}</text>
          <text class="history-meta">{{ s.rounds }} 轮 · {{ s.timeText }}</text>
        </view>
      </scroll-view>

      <!-- 底部：记忆管理 -->
      <view class="drawer-footer" @tap="emit('open-memory')">
        <text class="footer-icon">🧠</text>
        <text class="footer-text">记忆管理</text>
        <text class="footer-arrow">›</text>
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
import type { AgentSession } from '@/types/agent'

withDefaults(defineProps<{
  visible: boolean
  sessions: AgentSession[]
  currentId: number
  statusBarHeight?: number
}>(), { statusBarHeight: 0 })
const emit = defineEmits(['close', 'new-chat', 'select', 'open-memory'])
</script>

<style lang="scss" scoped>
.agent-drawer { position: fixed; top: 0; left: 0; right: 0; bottom: 0; z-index: 300; }
.drawer-mask { position: absolute; top: 0; left: 0; right: 0; bottom: 0; background: rgba(0, 0, 0, 0.4); }
.drawer-panel {
  position: absolute; top: 0; left: 0; bottom: 0; width: 600rpx;
  background-color: $edu-surface;
  display: flex; flex-direction: column;
  box-shadow: 8rpx 0 30rpx rgba(0, 0, 0, 0.12);
  animation: drawer-slide 0.24s ease;
}
@keyframes drawer-slide { from { transform: translateX(-100%); } to { transform: translateX(0); } }

/* 头部 */
.drawer-header { display: flex; align-items: center; padding: 12px 32rpx 20rpx; }
.drawer-avatar {
  width: 72rpx; height: 72rpx; border-radius: 50%;
  @include eduBrandGradient;
  display: flex; align-items: center; justify-content: center; margin-right: 16rpx;
}
.drawer-avatar-emoji { font-size: 36rpx; color: #FFFFFF; }
.drawer-name { font-size: 40rpx; font-weight: 700; color: $edu-text-primary; }
.drawer-close {
  margin-left: auto; width: 64rpx; height: 64rpx; border-radius: 50%;
  background-color: $edu-surface-variant;
  display: flex; align-items: center; justify-content: center;
}
.drawer-close-icon { font-size: 34rpx; color: $edu-text-secondary; }

/* 新对话 */
.new-chat {
  margin: 8rpx 32rpx 8rpx; height: 96rpx; border-radius: 24rpx;
  background-color: rgba(54, 119, 239, 0.10);
  display: flex; align-items: center; justify-content: center;
}
.new-chat-icon { font-size: 32rpx; color: $edu-primary; margin-right: 12rpx; }
.new-chat-text { font-size: 32rpx; font-weight: 600; color: $edu-primary; }

/* 历史列表 */
.history-scroll { flex: 1; min-height: 0; padding: 0 32rpx; box-sizing: border-box; }
.history-label { display: block; font-size: 26rpx; color: $edu-text-hint; margin: 20rpx 0 8rpx; }
.history-item { padding: 22rpx 24rpx; border-radius: 20rpx; margin-bottom: 8rpx; }
.history-item-active { background-color: rgba(54, 119, 239, 0.10); }
.history-title {
  display: block; font-size: 32rpx; color: $edu-text-primary; line-height: 1.4; margin-bottom: 8rpx;
  overflow: hidden; text-overflow: ellipsis; white-space: nowrap;
}
.history-title-active { color: $edu-primary; font-weight: 600; }
.history-meta { display: block; font-size: 24rpx; color: $edu-text-hint; }

/* 底部记忆管理 */
.drawer-footer {
  display: flex; align-items: center;
  padding: 28rpx 32rpx calc(28rpx + env(safe-area-inset-bottom));
  border-top: 2rpx solid $edu-divider;
}
.footer-icon { font-size: 34rpx; margin-right: 16rpx; }
.footer-text { font-size: 32rpx; color: $edu-text-primary; }
.footer-arrow { margin-left: auto; font-size: 40rpx; color: $edu-text-hint; }
</style>
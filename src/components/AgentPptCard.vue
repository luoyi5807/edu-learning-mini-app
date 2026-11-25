<template>
  <view class="ppt-card">
    <text class="ppt-title">{{ ppt.deckTitle }}</text>
    <view class="ppt-meta">
      <view class="ppt-meta-left">
        <text class="ppt-meta-icon">🗂</text>
        <text class="ppt-meta-text">已生成 {{ ppt.slides.length }} 页幻灯片</text>
      </view>
      <text class="ppt-count">{{ current + 1 }} / {{ ppt.slides.length }}</text>
    </view>
    <swiper class="ppt-swiper" :indicator-dots="false" :circular="true" @change="onSwiperChange">
      <swiper-item v-for="(s, i) in ppt.slides" :key="i">
        <view class="ppt-slide">
          <view class="ppt-slide-circle"></view>
          <view class="ppt-slide-brand"><text class="ppt-slide-brand-star">✦</text><text class="ppt-slide-brand-name">阿星</text></view>
          <text class="ppt-slide-title">{{ s.title }}</text>
          <text class="ppt-slide-sub">{{ s.subtitle }}</text>
          <text class="ppt-slide-total">共 {{ ppt.slides.length }} 页</text>
        </view>
      </swiper-item>
    </swiper>
    <view class="ppt-dots">
      <view class="ppt-dot" :class="{ 'ppt-dot-active': i === current }" v-for="(s, i) in ppt.slides" :key="'d' + i"></view>
    </view>
    <view class="ppt-actions">
      <view class="ppt-present" @tap="emit('present', ppt)"><text class="ppt-present-icon">▶</text><text class="ppt-present-text">全屏演示</text></view>
      <view class="ppt-export" @tap="emit('export', ppt)"><text class="ppt-export-icon">⬆</text><text class="ppt-export-text">导出</text></view>
    </view>
    <text class="ppt-footnote">{{ ppt.footnote }}</text>
  </view>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import type { AgentPptPayload } from '@/types/agent'
const props = defineProps<{ ppt: AgentPptPayload }>()
const emit = defineEmits<{ (e: 'present', p: AgentPptPayload): void; (e: 'export', p: AgentPptPayload): void }>()
const current = ref(0)
function onSwiperChange(e: any) { current.value = e.detail.current }
</script>

<style lang="scss" scoped>
.ppt-card { padding: 36rpx 32rpx; border-radius: 28rpx; background-color: $edu-surface; box-shadow: 0 8rpx 24rpx rgba(0, 0, 0, 0.05); }
.ppt-title { display: block; font-size: 34rpx; font-weight: 700; color: $edu-text-primary; }
.ppt-meta { display: flex; align-items: center; justify-content: space-between; margin-top: 20rpx; }
.ppt-meta-left { display: flex; align-items: center; }
.ppt-meta-icon { font-size: 28rpx; color: $edu-primary; margin-right: 12rpx; }
.ppt-meta-text { font-size: 28rpx; color: $edu-text-secondary; }
.ppt-count { font-size: 28rpx; color: $edu-text-hint; }
.ppt-swiper { height: 360rpx; margin-top: 24rpx; border-radius: 24rpx; overflow: hidden; }
.ppt-slide { position: relative; height: 100%; padding: 40rpx; box-sizing: border-box; overflow: hidden; @include eduBrandGradient; display: flex; flex-direction: column; }
.ppt-slide-circle { position: absolute; width: 360rpx; height: 360rpx; border-radius: 50%; background-color: rgba(255, 255, 255, 0.10); top: -80rpx; right: -80rpx; }
.ppt-slide-brand { display: flex; align-items: center; }
.ppt-slide-brand-star { font-size: 26rpx; color: #FFFFFF; margin-right: 8rpx; }
.ppt-slide-brand-name { font-size: 26rpx; color: rgba(255, 255, 255, 0.9); }
.ppt-slide-title { font-size: 52rpx; font-weight: 700; color: #FFFFFF; margin-top: 40rpx; line-height: 1.2; }
.ppt-slide-sub { font-size: 28rpx; color: rgba(255, 255, 255, 0.85); margin-top: 16rpx; }
.ppt-slide-total { font-size: 24rpx; color: rgba(255, 255, 255, 0.7); margin-top: auto; }
.ppt-dots { display: flex; justify-content: center; margin-top: 24rpx; }
.ppt-dot { width: 16rpx; height: 8rpx; border-radius: 4rpx; background-color: rgba(54, 119, 239, 0.25); margin: 0 6rpx; }
.ppt-dot-active { width: 32rpx; background-color: $edu-primary; }
.ppt-actions { display: flex; margin-top: 28rpx; }
.ppt-present { flex: 1; height: 88rpx; border-radius: 20rpx; @include eduBrandGradient; display: flex; align-items: center; justify-content: center; margin-right: 20rpx; }
.ppt-present-icon { font-size: 28rpx; color: #FFFFFF; margin-right: 12rpx; }
.ppt-present-text { font-size: 30rpx; font-weight: 600; color: #FFFFFF; }
.ppt-export { width: 200rpx; height: 88rpx; border-radius: 20rpx; background-color: rgba(54, 119, 239, 0.12); display: flex; align-items: center; justify-content: center; }
.ppt-export-icon { font-size: 28rpx; color: $edu-primary; margin-right: 12rpx; }
.ppt-export-text { font-size: 30rpx; color: $edu-primary; }
.ppt-footnote { display: block; font-size: 26rpx; color: $edu-text-hint; margin-top: 24rpx; }
</style>
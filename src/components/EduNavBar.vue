<template>
  <view class="edu-nav-wrap">
    <view class="edu-nav" :class="{ 'edu-nav-opaque': opaque }" :style="{ paddingTop: statusBarHeight + 'px' }">
      <view class="edu-nav-inner" :style="{ height: navContentHeight + 'px' }">
        <view class="edu-nav-back" @tap="handleBack">
          <text class="edu-nav-back-icon">←</text>
        </view>
        <text class="edu-nav-title">{{ title }}</text>
        <view class="edu-nav-right">
          <slot name="right" />
        </view>
      </view>
    </view>
    <view class="edu-nav-holder" :style="{ height: (statusBarHeight + navContentHeight) + 'px' }"></view>
  </view>
</template>

<script setup lang="ts">
const props = defineProps({
  title: { type: String, default: '' },
  /** 顶栏是否已滚动变白（由页面 onPageScroll 传入） */
  opaque: { type: Boolean, default: false }
})

const statusBarHeight = ref<number>(0)
const navContentHeight = ref<number>(44)

const sysInfo = uni.getSystemInfoSync()
statusBarHeight.value = sysInfo.statusBarHeight || 0
// #ifdef MP-WEIXIN
const menuButton = uni.getMenuButtonBoundingClientRect()
if (menuButton) {
  navContentHeight.value = (menuButton.top - statusBarHeight.value) * 2 + menuButton.height
}
// #endif

function handleBack() {
  const pages = getCurrentPages()
  if (pages.length > 1) uni.navigateBack()
  else uni.reLaunch({ url: '/pages/index/index' })
}
</script>

<style lang="scss" scoped>
.edu-nav {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  z-index: 99;
  background: transparent;
  transition: background-color 0.3s ease, box-shadow 0.3s ease;
}
.edu-nav-opaque { background: #FFFFFF; box-shadow: 0 2rpx 12rpx rgba(0, 0, 0, 0.06); }
.edu-nav-inner { display: flex; align-items: center; padding-left: 16rpx; }
.edu-nav-back { width: 72rpx; height: 72rpx; display: flex; align-items: center; justify-content: center; }
.edu-nav-back-icon { font-size: 44rpx; color: $edu-text-primary; }
.edu-nav-title { font-size: 40rpx; font-weight: 700; color: $edu-text-primary; margin-left: 8rpx; }
.edu-nav-right { margin-left: auto; padding-right: 24rpx; display: flex; align-items: center; }
</style>
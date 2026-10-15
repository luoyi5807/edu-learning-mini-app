<script setup lang="ts">
import { onLoad } from '@dcloudio/uni-app'

const SPLASH_URL = '/pages-sub/splash/splash'

function goSplash() {
	uni.reLaunch({
		url: SPLASH_URL,
		fail: (err) => {
			console.error('[placeholder] reLaunch splash fail:', JSON.stringify(err))
			// 兜底：万一分包未就绪，延迟重试一次
			setTimeout(() => {
				uni.reLaunch({
					url: SPLASH_URL,
					fail: (e2) => console.error('[placeholder] retry fail:', JSON.stringify(e2))
				})
			}, 500)
		}
	})
}

onLoad(() => {
	// 蓝本启动流程：placeholder → splash → (有token ? main : login)
	goSplash()
})
</script>

<template>
  <view class="boot">
    <text class="boot-text">正在启动…</text>
  </view>
</template>

<style lang="scss" scoped>
page {
  background-color: $edu-bg;
}
.boot {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
}
.boot-text {
  font-size: 28rpx;
  color: $edu-text-hint;
}
</style>
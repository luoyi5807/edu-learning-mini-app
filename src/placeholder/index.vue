<script setup lang="ts">
import { onLoad } from '@dcloudio/uni-app'

onLoad(() => {
	// 蓝本启动流程：placeholder → splash → (有token ? main : login)
	setTimeout(() => {
		uni.reLaunch({ url: '/pages-sub/splash/splash' })
	}, 300)
})
</script>

<template>
  <view></view>
</template>

<style lang="scss" scoped>
page {
  background-color: $edu-bg;
}
</style>
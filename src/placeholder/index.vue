<script setup lang="ts">
import { onLoad } from '@dcloudio/uni-app'

onLoad(() => {
	setTimeout(() => {
		uni.reLaunch({ url: '/pages/index/index' })
	}, 300)
})
</script>

<template>
  <view></view>
</template>

<style lang="scss" scoped>
page {
  background-color: #F7F9FC;
}
</style>
<template>
	<view class="splash-page">
		<!-- 中部插图 -->
		<view class="illustration">
			<!-- 三张便利贴 -->
			<view class="notes-row">
				<view class="note note-yellow"></view>
				<view class="note note-blue"></view>
				<view class="note note-red"></view>
			</view>

			<!-- 主卡片 -->
			<view class="card">
				<view class="card-inner"></view>
			</view>
			<view class="card-line"></view>
		</view>

		<!-- 标题区 -->
		<view class="title-area">
			<text class="app-title">学习平台</text>
			<text class="app-slogan">提升技能、精进能力.</text>
		</view>

		<!-- 底部品牌栏 -->
		<view class="brand-bar">
			<image class="brand-logo" src="/static/logo.png" mode="aspectFit" />
			<text class="brand-name">学习平台</text>
		</view>
	</view>
</template>

<script setup lang="ts">
import { onLoad, onUnload } from '@dcloudio/uni-app'

let jumpTimer: number | null = null

onLoad(() => {
	jumpTimer = setTimeout(() => {
		uni.reLaunch({ url: '/pages-sub/auth/login' })
	}, 2000) as unknown as number
})

onUnload(() => {
	if (jumpTimer) clearTimeout(jumpTimer)
})
</script>

<style lang="scss" scoped>
/* ===== 配色（浅色模式） ===== */
$color-primary: #3677EF;
$color-primary-light: #DCE8FF;
$color-accent-yellow: #F0B000;
$color-accent-blue: #85ABF4;
$color-accent-red: #D04030;
$color-text-secondary: #666666;
$color-divider: #EEEEEE;

.splash-page {
	display: flex;
	flex-direction: column;
	align-items: center;
	min-height: 100vh;
	background: linear-gradient(180deg, #FFFFFF 0%, #FFFBF2 30%, #F8F0ED 60%, #FDF5F5 85%, #FFFFFF 100%);
	box-sizing: border-box;
	position: relative;
}

/* ===== 插图区 ===== */
.illustration {
	display: flex;
	flex-direction: column;
	align-items: center;
	margin-top: 380rpx;
}

.notes-row {
	display: flex;
	align-items: flex-end;
	justify-content: center;
	margin-bottom: 40rpx;
}

.note {
	border-radius: 12rpx;
}

.note-yellow {
	width: 80rpx;
	height: 72rpx;
	background-color: $color-accent-yellow;
	margin-right: 28rpx;
}

.note-blue {
	width: 76rpx;
	height: 96rpx;
	background-color: $color-accent-blue;
	margin-bottom: -12rpx;
}

.note-red {
	width: 80rpx;
	height: 72rpx;
	background-color: $color-accent-red;
	margin-left: 28rpx;
}

.card {
	width: 640rpx;
	height: 240rpx;
	background: linear-gradient(135deg, #E8ECF6 0%, $color-primary-light 100%);
	border-radius: 24rpx;
	display: flex;
	align-items: center;
	justify-content: center;
}

.card-inner {
	width: 300rpx;
	height: 160rpx;
	background: linear-gradient(135deg, #5B8DEF 0%, $color-primary 100%);
	border-radius: 16rpx;
}

.card-line {
	width: 640rpx;
	height: 12rpx;
	background-color: $color-divider;
	border-radius: 6rpx;
	margin-top: 24rpx;
}

/* ===== 标题区 ===== */
.title-area {
	display: flex;
	flex-direction: column;
	align-items: center;
	margin-top: 80rpx;
}

.app-title {
	font-size: 76rpx;
	font-weight: 700;
	color: $color-primary;
	letter-spacing: 4rpx;
	margin-bottom: 32rpx;
}

.app-slogan {
	font-size: 32rpx;
	color: $color-text-secondary;
}

/* ===== 底部品牌栏 ===== */
.brand-bar {
	position: absolute;
	bottom: 100rpx;
	left: 0;
	right: 0;
	display: flex;
	align-items: center;
	justify-content: center;
}

.brand-logo {
	width: 64rpx;
	height: 64rpx;
	border-radius: 14rpx;
	margin-right: 16rpx;
}

.brand-name {
	font-size: 32rpx;
	font-weight: 600;
	color: #1A1A1A;
}
</style>

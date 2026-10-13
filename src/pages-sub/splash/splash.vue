<template>
	<view class="splash-page">
		<!-- 中央柔光圆 680rpx（蓝本 2.4） -->
		<view class="glow-orb"></view>

		<!-- 中央插画 -->
		<view class="illustration">
			<!-- 三张便利贴：黄 60×44 / 蓝 52×68 / 红 60×52，圆角 6，opacity 0.85，间距 20 -->
			<view class="notes-row">
				<view class="note note-yellow"></view>
				<view class="note note-blue"></view>
				<view class="note note-red"></view>
			</view>

			<!-- 桌面屏幕卡 400×172，圆角 20，主色 10~20% 渐变底 -->
			<view class="card">
				<view class="card-screen"></view>
			</view>
			<!-- 桌腿 400×12 #DADCE0 -->
			<view class="card-line"></view>
		</view>

		<!-- 插画下 56rpx：品牌名 68 Bold 主色，下 24rpx：slogan 30 #666 -->
		<view class="title-area">
			<text class="app-title">学习平台</text>
			<text class="app-slogan">提升技能、精进能力.</text>
		</view>

		<!-- 底部品牌栏 bottom 96rpx -->
		<view class="brand-bar">
			<image class="brand-logo" src="/static/logo.png" mode="aspectFit" />
			<text class="brand-name">学习平台</text>
		</view>
	</view>
</template>

<script setup lang="ts">
import { onLoad, onUnload } from '@dcloudio/uni-app'

let jumpTimer: ReturnType<typeof setTimeout> | null = null

onLoad(() => {
	// 最短展示 700ms（与系统启动窗接力，无白帧）
	jumpTimer = setTimeout(() => {
		const token = uni.getStorageSync('accessToken')
		if (token) {
			uni.reLaunch({ url: '/pages/index/index' })
		} else {
			uni.reLaunch({ url: '/pages-sub/auth/login' })
		}
	}, 700)
})

onUnload(() => {
	if (jumpTimer) clearTimeout(jumpTimer)
})
</script>

<style lang="scss" scoped>
.splash-page {
	display: flex;
	flex-direction: column;
	align-items: center;
	min-height: 100vh;
	box-sizing: border-box;
	position: relative;
	overflow: hidden;
	@include eduPageGradientStrong;
}

/* 中央柔光圆 */
.glow-orb {
	@include eduGlowOrb(680rpx);
	top: 50%;
	left: 50%;
	transform: translate(-50%, -60%);
	z-index: 0;
}

/* 插画区 */
.illustration {
	position: relative;
	z-index: 2;
	display: flex;
	flex-direction: column;
	align-items: center;
	margin-top: 320rpx;
}

.notes-row {
	display: flex;
	align-items: flex-end;
	justify-content: center;
	margin-bottom: 44rpx;
}

.note {
	border-radius: 6rpx;
	opacity: 0.85;
}

.note-yellow {
	width: 60rpx;
	height: 44rpx;
	background-color: $edu-accent-yellow;
	margin-right: 20rpx;
}

.note-blue {
	width: 52rpx;
	height: 68rpx;
	background-color: $edu-brand-blue-light;
	margin-bottom: -12rpx;
}

.note-red {
	width: 60rpx;
	height: 52rpx;
	background-color: $edu-accent-coral;
	margin-left: 20rpx;
}

.card {
	width: 400rpx;
	height: 172rpx;
	border-radius: 20rpx;
	background: linear-gradient(135deg,
		rgba(54, 119, 239, 0.1) 0%,
		rgba(54, 119, 239, 0.2) 100%);
	display: flex;
	align-items: center;
	justify-content: center;
}

.card-screen {
	width: 192rpx;
	height: 112rpx;
	border-radius: 12rpx;
	@include eduBrandGradient;
}

.card-line {
	width: 400rpx;
	height: 12rpx;
	background-color: $edu-outline;
	border-radius: 6rpx;
	margin-top: 24rpx;
}

.title-area {
	position: relative;
	z-index: 2;
	display: flex;
	flex-direction: column;
	align-items: center;
	margin-top: 56rpx;
}

.app-title {
	font-size: 68rpx;
	font-weight: 700;
	color: $edu-primary;
	letter-spacing: 4rpx;
	line-height: 1;
	margin-bottom: 24rpx;
}

.app-slogan {
	font-size: 30rpx;
	color: $edu-text-secondary;
	line-height: 1;
}

.brand-bar {
	position: absolute;
	bottom: 96rpx;
	left: 0;
	right: 0;
	display: flex;
	align-items: center;
	justify-content: center;
	z-index: 2;
}

.brand-logo {
	width: 56rpx;
	height: 56rpx;
	border-radius: 16rpx;
	margin-right: 8rpx;
}

.brand-name {
	font-size: 28rpx;
	font-weight: 600;
	color: $edu-text-primary;
}
</style>

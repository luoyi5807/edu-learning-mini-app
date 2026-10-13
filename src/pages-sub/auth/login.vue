<template>
	<view class="login-page">
		<!-- 顶部柔光圆 600rpx, TopCenter, top 16rpx -->
		<view class="glow-orb"></view>

		<!-- 顶部 96rpx 留白 -->
		<view class="top-spacer"></view>

		<!-- 品牌区 -->
		<view class="brand-area">
			<image class="brand-logo" src="/static/logo.png" mode="aspectFit" />
			<text class="brand-title">登录</text>
			<text class="brand-subtitle">欢迎使用，请登录以继续</text>
		</view>

		<!-- 说明文字（左对齐） -->
		<text class="section-tip">使用账号登录</text>

		<!-- 表单区 -->
		<view class="form-area">
			<!-- 用户名（手机/邮箱/账号三合一） -->
			<view class="auth-field" :class="{ 'field-focused': userFocused, 'field-error': userError }">
				<view class="field-icon"><text class="icon-text">👤</text></view>
				<input
					class="field-input"
					v-model="username"
					placeholder="用户名"
					placeholder-class="field-placeholder"
					@focus="userFocused = true"
					@blur="handleUserBlur"
				/>
			</view>
			<text v-if="userError" class="error-text">{{ userErrorText }}</text>

			<!-- 密码 -->
			<view class="auth-field" :class="{ 'field-focused': pwdFocused, 'field-error': pwdError }">
				<view class="field-icon"><text class="icon-text">🔒</text></view>
				<input
					class="field-input"
					:password="!passwordVisible"
					v-model="password"
					placeholder="密码"
					placeholder-class="field-placeholder"
					@focus="pwdFocused = true"
					@blur="handlePwdBlur"
				/>
				<view class="eye-btn" @tap="togglePasswordVisibility">
					<text class="eye-icon">{{ passwordVisible ? '🙈' : '👁' }}</text>
				</view>
			</view>
			<text v-if="pwdError" class="error-text">{{ pwdErrorText }}</text>

			<!-- 记住我 / 忘记密码 -->
			<view class="options-row">
				<view class="checkbox-wrap" @tap="rememberMe = !rememberMe">
					<view class="checkbox" :class="{ 'checkbox-checked': rememberMe }">
						<text v-if="rememberMe" class="check-mark">✓</text>
					</view>
					<text class="option-text">记住我</text>
				</view>
				<text class="forgot-link" @tap="handleForgot">忘记密码</text>
			</view>

			<!-- 主按钮（loading 变「登录中...」并禁用） -->
			<view
				class="login-btn"
				:class="{ 'btn-disabled': !isFormValid || loading, 'btn-pressed': btnPressed }"
				@touchstart="btnPressed = true"
				@touchend="btnPressed = false"
				@touchcancel="btnPressed = false"
				@tap="handleLogin"
			>
				<text class="btn-text">{{ loading ? '登录中...' : '登录' }}</text>
			</view>
		</view>

		<!-- 底部注册 -->
		<view class="footer-link">
			<text class="footer-text">还没有账号？</text>
			<text class="register-link" @tap="goToRegister">立即注册</text>
		</view>
	</view>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'

const username = ref<string>('')
const password = ref<string>('')
const rememberMe = ref<boolean>(false)

const userFocused = ref<boolean>(false)
const pwdFocused = ref<boolean>(false)
const userError = ref<boolean>(false)
const userErrorText = ref<string>('')
const pwdError = ref<boolean>(false)
const pwdErrorText = ref<string>('')
const passwordVisible = ref<boolean>(false)
const btnPressed = ref<boolean>(false)
const loading = ref<boolean>(false)

function validateUsername(): boolean {
	if (!username.value) {
		userErrorText.value = '用户名不能为空'
		userError.value = true
		return false
	}
	userError.value = false
	return true
}

function validatePassword(): boolean {
	if (!password.value) {
		pwdErrorText.value = '密码不能为空'
		pwdError.value = true
		return false
	}
	if (password.value.length < 6) {
		pwdErrorText.value = '密码至少为 6 位字符'
		pwdError.value = true
		return false
	}
	pwdError.value = false
	return true
}

const isFormValid = computed<boolean>(() => {
	return !!username.value && password.value.length >= 6
})

function handleUserBlur() {
	userFocused.value = false
	if (username.value) validateUsername()
}

function handlePwdBlur() {
	pwdFocused.value = false
	if (password.value) validatePassword()
}

function togglePasswordVisibility() {
	passwordVisible.value = !passwordVisible.value
}

function handleLogin() {
	if (loading.value) return
	if (!isFormValid.value) {
		validateUsername()
		validatePassword()
		return
	}
	loading.value = true
	// TODO: 接入 POST /api/v1/auth/login 后替换此段
	setTimeout(() => {
		uni.setStorageSync('accessToken', 'mock-token-' + Date.now())
		loading.value = false
		uni.showToast({ title: '登录成功（mock）', icon: 'success', duration: 800 })
		setTimeout(() => {
			uni.reLaunch({ url: '/pages/index/index' })
		}, 800)
	}, 1200)
}

function handleForgot() {
	uni.showToast({ title: '功能开发中', icon: 'none' })
}

function goToRegister() {
	uni.navigateTo({ url: '/pages-sub/auth/register' })
}
</script>

<style lang="scss" scoped>
.login-page {
	position: relative;
	display: flex;
	flex-direction: column;
	align-items: center;
	min-height: 100vh;
	box-sizing: border-box;
	padding: 0 56rpx;
	overflow: hidden;
	@include eduPageGradientStrong;
}

/* 顶部柔光圆 */
.glow-orb {
	@include eduGlowOrb(600rpx);
	top: 16rpx;
	left: 50%;
	transform: translateX(-50%);
	z-index: 0;
}

.top-spacer {
	height: 96rpx;
	flex-shrink: 0;
}

.brand-area {
	position: relative;
	z-index: 1;
	display: flex;
	flex-direction: column;
	align-items: center;
	margin-bottom: 20rpx;
}

.brand-logo {
	width: 128rpx;
	height: 128rpx;
	border-radius: 24rpx;
	margin-bottom: 32rpx;
}

.brand-title {
	font-size: 52rpx;
	font-weight: 700;
	color: $edu-text-primary;
	margin-bottom: 16rpx;
}

.brand-subtitle {
	font-size: 28rpx;
	color: $edu-text-secondary;
}

.section-tip {
	position: relative;
	z-index: 1;
	display: block;
	align-self: flex-start;
	font-size: 30rpx;
	color: $edu-text-secondary;
	margin-top: 24rpx;
}

.form-area {
	position: relative;
	z-index: 1;
	width: 100%;
}

.auth-field {
	display: flex;
	align-items: center;
	width: 100%;
	height: 96rpx;
	border-radius: 48rpx;
	border: 2rpx solid $edu-divider;
	padding: 0 28rpx;
	box-sizing: border-box;
	margin-top: 28rpx;
	transition: border-color 0.2s;
	@include eduSurfaceWash;
}

.field-focused { border-color: $edu-primary; }
.field-error   { border-color: $edu-accent-coral; }

.field-icon {
	width: 44rpx;
	display: flex;
	align-items: center;
	justify-content: center;
	margin-right: 16rpx;
}

.icon-text { font-size: 32rpx; }

.field-input {
	flex: 1;
	height: 96rpx;
	line-height: 96rpx;
	font-size: 30rpx;
	color: $edu-text-primary;
	background: transparent;
	border: none;
}

.field-placeholder {
	color: $edu-text-hint;
	font-size: 30rpx;
}

.eye-btn {
	width: 64rpx;
	height: 96rpx;
	display: flex;
	align-items: center;
	justify-content: center;
}

.eye-icon { font-size: 32rpx; }

.error-text {
	display: block;
	font-size: 26rpx;
	color: $edu-error-text;
	margin-top: 12rpx;
	padding-left: 40rpx;
}

.options-row {
	display: flex;
	align-items: center;
	justify-content: space-between;
	margin-top: 20rpx;
	padding: 0 8rpx;
}

.checkbox-wrap {
	display: flex;
	align-items: center;
	min-height: 44rpx;
}

.checkbox {
	width: 36rpx;
	height: 36rpx;
	border: 2rpx solid $edu-text-hint;
	border-radius: 6rpx;
	display: flex;
	align-items: center;
	justify-content: center;
	margin-right: 12rpx;
}

.checkbox-checked {
	background-color: $edu-primary;
	border-color: $edu-primary;
}

.check-mark {
	font-size: 22rpx;
	color: #FFFFFF;
}

.option-text {
	font-size: 26rpx;
	color: $edu-text-secondary;
}

.forgot-link {
	font-size: 30rpx;
	color: $edu-primary;
}

.login-btn {
	width: 100%;
	height: 96rpx;
	display: flex;
	align-items: center;
	justify-content: center;
	border-radius: 48rpx;
	margin-top: 40rpx;
	transition: all 0.15s;
	@include eduBrandGradient;
	box-shadow: 0 8rpx 24rpx rgba(54, 119, 239, 0.3);
}

.btn-pressed {
	background: linear-gradient(135deg, #3677EF 0%, #2A5FD0 100%);
}

.btn-disabled {
	background: $edu-divider;
	box-shadow: none;

	.btn-text { color: $edu-text-hint; }
}

.btn-text {
	font-size: 32rpx;
	font-weight: 600;
	color: #FFFFFF;
}

.footer-link {
	position: relative;
	z-index: 1;
	display: flex;
	align-items: center;
	justify-content: center;
	margin-top: 36rpx;
	padding-bottom: 80rpx;
}

.footer-text {
	font-size: 28rpx;
	color: $edu-text-secondary;
}

.register-link {
	font-size: 28rpx;
	color: $edu-primary;
	font-weight: 600;
	margin-left: 8rpx;
}
</style>

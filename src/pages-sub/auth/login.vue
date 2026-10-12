<template>
	<view class="login-page">
		<!-- Logo -->
		<view class="logo-area">
			<image class="logo-img" src="/static/logo.png" mode="aspectFit" />
		</view>

		<!-- 标题区 -->
		<view class="header">
			<text class="header-title">登录</text>
			<text class="header-subtitle">欢迎使用，请登录以继续</text>
			<text class="header-section">使用账号登录</text>
		</view>

		<!-- 表单区 -->
		<view class="form-area">
			<!-- 手机号 -->
			<view class="input-box" :class="{ 'input-focused': phoneFocused, 'input-error': phoneError }">
				<view class="input-icon">
					<text class="icon-text">👤</text>
				</view>
				<input
					class="input-field"
					type="number"
					maxlength="11"
					v-model="phone"
					placeholder="手机号"
					placeholder-class="input-placeholder"
					@focus="phoneFocused = true"
					@blur="handlePhoneBlur"
				/>
			</view>
			<text v-if="phoneError" class="error-text">{{ phoneErrorText }}</text>

			<!-- 密码 -->
			<view class="input-box" :class="{ 'input-focused': pwdFocused, 'input-error': pwdError }">
				<view class="input-icon">
					<text class="icon-text">🔒</text>
				</view>
				<input
					class="input-field"
					:password="!passwordVisible"
					v-model="password"
					placeholder="密码"
					placeholder-class="input-placeholder"
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

			<!-- 登录按钮 -->
			<view
				class="login-btn"
				:class="{ 'btn-disabled': !isFormValid, 'btn-pressed': btnPressed }"
				@touchstart="btnPressed = true"
				@touchend="btnPressed = false"
				@touchcancel="btnPressed = false"
				@tap="handleLogin"
			>
				<text class="btn-text">登录</text>
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

const phone = ref<string>('')
const password = ref<string>('')
const rememberMe = ref<boolean>(false)

const phoneFocused = ref<boolean>(false)
const pwdFocused = ref<boolean>(false)
const phoneError = ref<boolean>(false)
const phoneErrorText = ref<string>('')
const pwdError = ref<boolean>(false)
const pwdErrorText = ref<string>('')
const passwordVisible = ref<boolean>(false)
const btnPressed = ref<boolean>(false)

const PHONE_REG = /^1[3-9]\d{9}$/

function validatePhone(): boolean {
	if (!phone.value) {
		phoneErrorText.value = '手机号不能为空'
		phoneError.value = true
		return false
	}
	if (!PHONE_REG.test(phone.value)) {
		phoneErrorText.value = '请输入正确的11位手机号'
		phoneError.value = true
		return false
	}
	phoneError.value = false
	return true
}

function validatePassword(): boolean {
	if (!password.value) {
		pwdErrorText.value = '密码不能为空'
		pwdError.value = true
		return false
	}
	if (password.value.length < 6) {
		pwdErrorText.value = '密码至少为6位字符'
		pwdError.value = true
		return false
	}
	pwdError.value = false
	return true
}

const isFormValid = computed<boolean>(() => {
	return PHONE_REG.test(phone.value) && password.value.length >= 6
})

function handlePhoneBlur() {
	phoneFocused.value = false
	if (phone.value) validatePhone()
}

function handlePwdBlur() {
	pwdFocused.value = false
	if (password.value) validatePassword()
}

function togglePasswordVisibility() {
	passwordVisible.value = !passwordVisible.value
}

function handleLogin() {
	if (!isFormValid.value) {
		validatePhone()
		validatePassword()
		return
	}
	uni.showToast({
		title: '表单校验通过，待接入登录接口',
		icon: 'none',
		duration: 2000
	})
}

function handleForgot() {
	uni.showToast({ title: '功能开发中', icon: 'none' })
}

function goToRegister() {
	uni.navigateTo({ url: '/pages-sub/auth/register' })
}
</script>

<style lang="scss" scoped>
$color-primary: #3677EF;
$color-primary-press: #2A5FD0;
$color-error: #D04030;
$color-bg: #F7F9FC;
$color-card: #FFFFFF;
$color-text-primary: #1A1A1A;
$color-text-secondary: #666666;
$color-text-placeholder: #999999;
$color-divider: #EEEEEE;

.login-page {
	display: flex;
	flex-direction: column;
	align-items: center;
	min-height: 100vh;
	background: linear-gradient(180deg, #FFFFFF 0%, $color-bg 100%);
	padding: 0 64rpx;
	box-sizing: border-box;
}

/* Logo */
.logo-area {
	padding-top: 120rpx;
	margin-bottom: 40rpx;
}

.logo-img {
	width: 140rpx;
	height: 140rpx;
	border-radius: 28rpx;
}

/* 标题 */
.header {
	display: flex;
	flex-direction: column;
	align-items: center;
	margin-bottom: 64rpx;
}

.header-title {
	font-size: 52rpx;
	font-weight: 700;
	color: $color-text-primary;
	margin-bottom: 20rpx;
}

.header-subtitle {
	font-size: 28rpx;
	color: $color-text-secondary;
	margin-bottom: 40rpx;
}

.header-section {
	font-size: 26rpx;
	color: $color-text-secondary;
}

/* 表单区 */
.form-area {
	width: 100%;
}

.input-box {
	display: flex;
	align-items: center;
	width: 100%;
	height: 100rpx;
	background-color: $color-card;
	border-radius: 50rpx;
	border: 2rpx solid $color-divider;
	padding: 0 32rpx;
	box-sizing: border-box;
	margin-top: 32rpx;
	transition: border-color 0.2s;
	box-shadow: 0 4rpx 12rpx rgba(0, 0, 0, 0.03);
}

.input-focused {
	border-color: $color-primary;
}

.input-error {
	border-color: $color-error;
}

.input-icon {
	width: 48rpx;
	display: flex;
	align-items: center;
	justify-content: center;
	margin-right: 20rpx;
}

.icon-text {
	font-size: 36rpx;
}

.input-field {
	flex: 1;
	height: 100rpx;
	line-height: 100rpx;
	font-size: 30rpx;
	color: $color-text-primary;
	background: transparent;
	border: none;
}

.input-placeholder {
	color: $color-text-placeholder;
	font-size: 30rpx;
}

.eye-btn {
	width: 64rpx;
	height: 100rpx;
	display: flex;
	align-items: center;
	justify-content: center;
}

.eye-icon {
	font-size: 36rpx;
}

/* 错误提示 */
.error-text {
	display: block;
	font-size: 24rpx;
	color: $color-error;
	margin-top: 12rpx;
	padding-left: 40rpx;
}

/* 记住我 / 忘记密码 */
.options-row {
	display: flex;
	align-items: center;
	justify-content: space-between;
	margin-top: 32rpx;
	margin-bottom: 48rpx;
	padding: 0 8rpx;
}

.checkbox-wrap {
	display: flex;
	align-items: center;
}

.checkbox {
	width: 36rpx;
	height: 36rpx;
	border: 2rpx solid $color-text-placeholder;
	border-radius: 6rpx;
	display: flex;
	align-items: center;
	justify-content: center;
	margin-right: 12rpx;
}

.checkbox-checked {
	background-color: $color-primary;
	border-color: $color-primary;
}

.check-mark {
	font-size: 24rpx;
	color: #FFFFFF;
}

.option-text {
	font-size: 26rpx;
	color: $color-text-secondary;
}

.forgot-link {
	font-size: 26rpx;
	color: $color-primary;
}

/* 登录按钮 */
.login-btn {
	width: 100%;
	height: 100rpx;
	display: flex;
	align-items: center;
	justify-content: center;
	background-color: $color-primary;
	border-radius: 50rpx;
	transition: background-color 0.15s;
	box-shadow: 0 8rpx 24rpx rgba(54, 119, 239, 0.3);
}

.btn-pressed {
	background-color: $color-primary-press;
}

.btn-disabled {
	background-color: $color-divider;
	box-shadow: none;

	.btn-text {
		color: $color-text-placeholder;
	}
}

.btn-text {
	font-size: 32rpx;
	font-weight: 500;
	color: #FFFFFF;
}

/* 底部注册 */
.footer-link {
	display: flex;
	align-items: center;
	justify-content: center;
	margin-top: 64rpx;
	padding-bottom: 80rpx;
}

.footer-text {
	font-size: 28rpx;
	color: $color-text-secondary;
}

.register-link {
	font-size: 28rpx;
	color: $color-primary;
	font-weight: 500;
	margin-left: 8rpx;
}
</style>

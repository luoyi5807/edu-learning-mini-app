<template>
  <view class="register-page">
    <!-- 顶部柔光圆 600rpx, TopCenter, top 16rpx -->
    <view class="glow-orb"></view>

    <!-- 顶部 96rpx 留白 -->
    <view class="top-spacer"></view>

    <!-- 品牌区 -->
    <view class="brand-area">
      <image class="brand-logo" src="/static/logo.png" mode="aspectFit" />
      <text class="brand-title">注册</text>
      <text class="brand-subtitle">创建账号，开始学习之旅</text>
    </view>

    <!-- 说明文字（左对齐） -->
    <text class="section-tip">使用手机号注册</text>

    <!-- 表单区 -->
    <view class="form-area">
      <!-- 手机号 -->
      <view class="auth-field" :class="{ 'field-focused': userFocused, 'field-error': userError }">
        <view class="field-icon"><text class="icon-text">📱</text></view>
        <input
            class="field-input"
            v-model="phone"
            type="number"
            maxlength="11"
            placeholder="手机号"
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
            placeholder="密码（至少 6 位）"
            placeholder-class="field-placeholder"
            @focus="pwdFocused = true"
            @blur="handlePwdBlur"
        />
        <view class="eye-btn" @tap="togglePasswordVisibility">
          <text class="eye-icon">{{ passwordVisible ? '🙈' : '👁' }}</text>
        </view>
      </view>
      <text v-if="pwdError" class="error-text">{{ pwdErrorText }}</text>

      <!-- 确认密码 -->
      <view class="auth-field" :class="{ 'field-focused': confirmFocused, 'field-error': confirmError }">
        <view class="field-icon"><text class="icon-text">🔑</text></view>
        <input
            class="field-input"
            :password="!confirmVisible"
            v-model="confirmPassword"
            placeholder="确认密码"
            placeholder-class="field-placeholder"
            @focus="confirmFocused = true"
            @blur="handleConfirmBlur"
        />
        <view class="eye-btn" @tap="toggleConfirmVisibility">
          <text class="eye-icon">{{ confirmVisible ? '🙈' : '👁' }}</text>
        </view>
      </view>
      <text v-if="confirmError" class="error-text">{{ confirmErrorText }}</text>

      <text v-if="registerError" class="error-text">{{ registerError }}</text>

      <!-- 主按钮（loading 变「注册中...」并禁用） -->
      <view
          class="register-btn"
          :class="{ 'btn-disabled': !isFormValid || loading, 'btn-pressed': btnPressed }"
          @touchstart="btnPressed = true"
          @touchend="btnPressed = false"
          @touchcancel="btnPressed = false"
          @tap="handleRegister"
      >
        <text class="btn-text">{{ loading ? '注册中...' : '注册' }}</text>
      </view>
    </view>

    <!-- 底部返回登录 -->
    <view class="footer-link">
      <text class="footer-text">已有账号？</text>
      <text class="login-link" @tap="goToLogin">返回登录</text>
    </view>
  </view>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { registerApi } from '@/api/auth'

const phone = ref<string>('')
const password = ref<string>('')
const confirmPassword = ref<string>('')

const userFocused = ref<boolean>(false)
const pwdFocused = ref<boolean>(false)
const confirmFocused = ref<boolean>(false)
const userError = ref<boolean>(false)
const userErrorText = ref<string>('')
const pwdError = ref<boolean>(false)
const pwdErrorText = ref<string>('')
const confirmError = ref<boolean>(false)
const confirmErrorText = ref<string>('')
const passwordVisible = ref<boolean>(false)
const confirmVisible = ref<boolean>(false)
const btnPressed = ref<boolean>(false)
const loading = ref<boolean>(false)

const registerError = ref<string>('')

function validatePhone(): boolean {
  if (!phone.value) {
    userErrorText.value = '手机号不能为空'
    userError.value = true
    return false
  }
  if (!/^1[3-9]\d{9}$/.test(phone.value)) {
    userErrorText.value = '请输入正确的手机号'
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

function validateConfirmPassword(): boolean {
  if (!confirmPassword.value) {
    confirmErrorText.value = '请再次输入密码'
    confirmError.value = true
    return false
  }
  if (confirmPassword.value !== password.value) {
    confirmErrorText.value = '两次输入的密码不一致'
    confirmError.value = true
    return false
  }
  confirmError.value = false
  return true
}

const isFormValid = computed<boolean>(() => {
  return /^1[3-9]\d{9}$/.test(phone.value) && password.value.length >= 6 && confirmPassword.value.length >= 6
})

function handleUserBlur() {
  userFocused.value = false
  if (phone.value) validatePhone()
}

function handlePwdBlur() {
  pwdFocused.value = false
  if (password.value) validatePassword()
}

function handleConfirmBlur() {
  confirmFocused.value = false
  if (confirmPassword.value) validateConfirmPassword()
}

function togglePasswordVisibility() {
  passwordVisible.value = !passwordVisible.value
}

function toggleConfirmVisibility() {
  confirmVisible.value = !confirmVisible.value
}

async function handleRegister() {
  if (loading.value) return
  registerError.value = ''
  if (!isFormValid.value) {
    validatePhone()
    validatePassword()
    validateConfirmPassword()
    return
  }
  if (!validateConfirmPassword()) return
  loading.value = true
  try {
    await registerApi({
      phone: phone.value,
      password: password.value,
      confirmPassword: confirmPassword.value
    })
    uni.showToast({ title: '注册成功，请登录', icon: 'success', duration: 800 })
    setTimeout(() => {
      uni.navigateBack()
    }, 800)
  } catch (e: any) {
    registerError.value = (e && e.msg) ? e.msg : '注册失败，请稍后重试或检查后端服务'
    loading.value = false
  }
}

function goToLogin() {
  uni.navigateBack()
}
</script>

<style lang="scss" scoped>
.register-page {
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

/* 验证码 */
.captcha-field { padding-right: 12rpx; }
.captcha-img {
  width: 200rpx;
  height: 72rpx;
  border-radius: 12rpx;
  margin-left: 16rpx;
  background-color: #F0F3F8;
  flex-shrink: 0;
}
.captcha-img-empty {
  display: flex;
  align-items: center;
  justify-content: center;
}
.captcha-empty-text { font-size: 22rpx; color: $edu-text-hint; }

.error-text {
  display: block;
  font-size: 26rpx;
  color: $edu-error-text;
  margin-top: 12rpx;
  padding-left: 40rpx;
}

.register-btn {
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

.login-link {
  font-size: 28rpx;
  color: $edu-primary;
  font-weight: 600;
  margin-left: 8rpx;
}
</style>
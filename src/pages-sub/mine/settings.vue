<template>
  <view class="settings-page">
    <!-- 固定顶部栏：返回 + 标题 -->
    <view class="nav-bar" :class="{ 'nav-bar-opaque': navBarOpaque }" :style="{ paddingTop: statusBarHeight + 'px' }">
      <view class="nav-bar-inner" :style="{ height: navContentHeight + 'px' }">
        <view class="nav-back" @tap="goBack">
          <text class="back-icon">←</text>
        </view>
        <text class="nav-title">设置</text>
      </view>
    </view>
    <view class="nav-placeholder" :style="{ height: (statusBarHeight + navContentHeight) + 'px' }"></view>

    <!-- 账号组 -->
    <view class="setting-card">
      <view class="setting-row" @tap="openPwdSheet">
        <text class="setting-icon">🔒</text>
        <text class="setting-label">修改密码</text>
        <text class="setting-arrow">→</text>
      </view>
      <view class="setting-row setting-row-divider" @tap="handleTheme">
        <text class="setting-icon">🔖</text>
        <text class="setting-label">主题模式</text>
        <text class="setting-value">{{ themeLabel }}</text>
        <text class="setting-arrow">→</text>
      </view>
    </view>

    <!-- 通用组 -->
    <view class="setting-card">
      <view class="setting-row" @tap="handleClearCache">
        <text class="setting-icon">🧹</text>
        <text class="setting-label">清除缓存</text>
        <text class="setting-arrow">→</text>
      </view>
      <view class="setting-row setting-row-divider" @tap="handleAgreement">
        <text class="setting-icon">📄</text>
        <text class="setting-label">用户协议</text>
        <text class="setting-arrow">→</text>
      </view>
      <view class="setting-row setting-row-divider" @tap="handlePrivacy">
        <text class="setting-icon">🛡</text>
        <text class="setting-label">隐私政策</text>
        <text class="setting-arrow">→</text>
      </view>
      <view class="setting-row setting-row-divider" @tap="handleAbout">
        <text class="setting-icon">💬</text>
        <text class="setting-label">关于我们</text>
        <text class="setting-value">v{{ appVersion }}</text>
        <text class="setting-arrow">→</text>
      </view>
    </view>

    <!-- 退出登录 -->
    <view class="logout-card" @tap="handleLogout">
      <text class="logout-text">退出登录</text>
    </view>

    <text class="foot-version">学习平台 {{ appVersion }}</text>

    <!-- 修改密码弹层 -->
    <view v-if="pwdVisible" class="sheet-mask" @tap="closePwdSheet">
      <view class="sheet-panel" @tap.stop>
        <text class="sheet-title">修改密码</text>

        <input
            class="sheet-input"
            :password="true"
            v-model="oldPwd"
            placeholder="当前密码"
            placeholder-class="sheet-placeholder"
        />
        <input
            class="sheet-input"
            :password="true"
            v-model="newPwd"
            placeholder="新密码（6-20 位）"
            placeholder-class="sheet-placeholder"
        />
        <input
            class="sheet-input"
            :password="true"
            v-model="confirmPwd"
            placeholder="确认新密码"
            placeholder-class="sheet-placeholder"
        />

        <text v-if="pwdError" class="sheet-error">{{ pwdError }}</text>

        <view class="sheet-actions">
          <view class="sheet-btn sheet-btn-cancel" @tap="closePwdSheet">
            <text class="sheet-btn-cancel-text">取消</text>
          </view>
          <view
              class="sheet-btn sheet-btn-confirm"
              :class="{ 'sheet-btn-disabled': pwdSaving }"
              @tap="handleChangePwd"
          >
            <text class="sheet-btn-confirm-text">{{ pwdSaving ? '提交中...' : '确认' }}</text>
          </view>
        </view>
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { onLoad, onPageScroll } from '@dcloudio/uni-app'
import { useAuthStore } from '@/store/auth'
import { updatePwdApi } from '@/api/user'

const auth = useAuthStore()
const appVersion = '1.0.0'

/* ===== 顶部栏高度（含状态栏 + 胶囊区） ===== */
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

/* ===== 顶栏滚动变白 ===== */
const navBarOpaque = ref<boolean>(false)
onPageScroll((e) => {
  navBarOpaque.value = e.scrollTop > 40
})

/* ===== 主题模式（偏好本地持久化，深色样式待全站适配） ===== */
interface ThemeOption { label: string; value: string }
const themeOptions: ThemeOption[] = [
  { label: '浅色', value: 'light' },
  { label: '深色', value: 'dark' },
  { label: '跟随系统', value: 'system' }
]
const themeMode = ref<string>('light')
const themeLabel = computed<string>(
    () => themeOptions.find((o) => o.value === themeMode.value)?.label || '浅色'
)

onLoad(() => {
  const saved = uni.getStorageSync('themeMode')
  if (saved) themeMode.value = saved
})

function handleTheme() {
  uni.showActionSheet({
    itemList: themeOptions.map((o) => o.label),
    success: (r) => {
      themeMode.value = themeOptions[r.tapIndex].value
      uni.setStorageSync('themeMode', themeMode.value)
      if (themeMode.value === 'dark') {
        uni.showToast({ title: '深色模式适配中，暂仅保存偏好', icon: 'none' })
      } else {
        uni.showToast({ title: '已切换主题', icon: 'none' })
      }
    }
  })
}

/* ===== 清除缓存（保留登录态） ===== */
function handleClearCache() {
  uni.showModal({
    title: '清除缓存',
    content: '将清除搜索历史等非登录数据，确定继续？',
    confirmColor: '#3677EF',
    success: (r) => {
      if (!r.confirm) return
      const keep = ['accessToken', 'themeMode']
      const info = uni.getStorageInfoSync()
      info.keys.forEach((k) => {
        if (keep.indexOf(k) < 0) uni.removeStorageSync(k)
      })
      uni.showToast({ title: '缓存已清除', icon: 'success' })
    }
  })
}

/* ===== 协议 / 关于 ===== */
function handleAgreement() {
  uni.showModal({
    title: '用户协议',
    content: '本协议约定账号使用、内容发布与违规处理等基本条款。完整协议文本待后端 app_config 下发后展示。',
    showCancel: false,
    confirmText: '知道了',
    confirmColor: '#3677EF'
  })
}

function handlePrivacy() {
  uni.showModal({
    title: '隐私政策',
    content: '我们仅收集为提供学习服务所必需的信息（账号、学习进度、签到定位）。完整政策文本待后端配置下发后展示。',
    showCancel: false,
    confirmText: '知道了',
    confirmColor: '#3677EF'
  })
}

function handleAbout() {
  uni.showModal({
    title: '关于我们',
    content: `学习平台 v${appVersion}\n一个帮你坚持学习、沉淀知识的移动学习应用。`,
    showCancel: false,
    confirmText: '知道了',
    confirmColor: '#3677EF'
  })
}

/* ===== 修改密码 ===== */
const pwdVisible = ref<boolean>(false)
const oldPwd = ref<string>('')
const newPwd = ref<string>('')
const confirmPwd = ref<string>('')
const pwdError = ref<string>('')
const pwdSaving = ref<boolean>(false)

function openPwdSheet() {
  oldPwd.value = ''
  newPwd.value = ''
  confirmPwd.value = ''
  pwdError.value = ''
  pwdVisible.value = true
}

function closePwdSheet() {
  if (pwdSaving.value) return
  pwdVisible.value = false
}

async function handleChangePwd() {
  if (pwdSaving.value) return
  pwdError.value = ''
  if (!oldPwd.value) {
    pwdError.value = '请输入当前密码'
    return
  }
  if (newPwd.value.length < 6 || newPwd.value.length > 20) {
    pwdError.value = '新密码需 6-20 位字符'
    return
  }
  if (newPwd.value === oldPwd.value) {
    pwdError.value = '新密码不能与当前密码相同'
    return
  }
  if (newPwd.value !== confirmPwd.value) {
    pwdError.value = '两次输入的新密码不一致'
    return
  }
  pwdSaving.value = true
  try {
    await updatePwdApi(oldPwd.value, newPwd.value)
    pwdVisible.value = false
    uni.showToast({ title: '密码已修改', icon: 'success' })
  } catch (e: any) {
    pwdError.value = (e && e.msg) ? e.msg : '修改失败，请稍后重试'
  } finally {
    pwdSaving.value = false
  }
}

/* ===== 退出登录 ===== */
function handleLogout() {
  uni.showModal({
    title: '提示',
    content: '确定要退出登录吗？',
    confirmColor: '#D04030',
    success: async (r) => {
      if (!r.confirm) return
      await auth.logout()
      uni.reLaunch({ url: '/pages-sub/auth/login' })
    }
  })
}

function goBack() {
  const pages = getCurrentPages()
  if (pages.length > 1) uni.navigateBack()
  else uni.reLaunch({ url: '/pages/index/index' })
}
</script>

<style lang="scss" scoped>
.settings-page {
  min-height: 100vh;
  box-sizing: border-box;
  padding: 0 32rpx 60rpx;
  @include eduPageGradientStrong;
}

/* ===== 固定顶部栏 ===== */
.nav-bar {
  position: fixed;
  top: 0; left: 0; right: 0;
  z-index: 99;
  background: transparent;
  transition: background-color 0.3s ease, box-shadow 0.3s ease;
}
.nav-bar-opaque { background: #FFFFFF; box-shadow: 0 2rpx 12rpx rgba(0, 0, 0, 0.06); }
.nav-bar-inner { display: flex; align-items: center; padding-left: 16rpx; }
.nav-back { width: 72rpx; height: 72rpx; display: flex; align-items: center; justify-content: center; }
.back-icon { font-size: 44rpx; color: $edu-text-primary; }
.nav-title { font-size: 40rpx; font-weight: 700; color: $edu-text-primary; margin-left: 8rpx; }

/* ===== 设置分组卡 ===== */
.setting-card {
  margin-top: 24rpx;
  padding: 0 32rpx;
  border-radius: 32rpx;
  background-color: $edu-surface;
  box-shadow: 0 8rpx 24rpx rgba(0, 0, 0, 0.04);
}
.setting-row {
  position: relative;
  display: flex;
  align-items: center;
  min-height: 112rpx;
}
.setting-row-divider::after {
  content: '';
  position: absolute;
  left: 72rpx;
  right: 0;
  bottom: 0;
  height: 2rpx;
  background: $edu-divider;
}
.setting-icon { width: 56rpx; font-size: 36rpx; margin-right: 16rpx; }
.setting-label { flex: 1; font-size: 32rpx; color: $edu-text-primary; }
.setting-value { font-size: 28rpx; color: $edu-text-hint; margin-right: 12rpx; }
.setting-arrow { font-size: 32rpx; color: $edu-text-hint; }

/* ===== 退出登录 ===== */
.logout-card {
  margin-top: 40rpx;
  height: 112rpx;
  border-radius: 32rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  @include eduWarmYellowGradient;
}
.logout-text { font-size: 34rpx; font-weight: 700; color: $edu-accent-coral; }

.foot-version {
  display: block;
  font-size: 24rpx;
  color: $edu-text-hint;
  text-align: center;
  margin-top: 40rpx;
}

/* ===== 修改密码弹层 ===== */
.sheet-mask {
  position: fixed;
  left: 0; top: 0; right: 0; bottom: 0;
  z-index: 200;
  background: rgba(0, 0, 0, 0.4);
  display: flex;
  align-items: flex-end;
}
.sheet-panel {
  width: 100%;
  box-sizing: border-box;
  padding: 40rpx 40rpx calc(40rpx + env(safe-area-inset-bottom));
  border-top-left-radius: 32rpx;
  border-top-right-radius: 32rpx;
  background-color: $edu-surface;
}
.sheet-title {
  display: block;
  font-size: 36rpx;
  font-weight: 700;
  color: $edu-text-primary;
  margin-bottom: 32rpx;
}
.sheet-input {
  width: 100%;
  height: 96rpx;
  box-sizing: border-box;
  padding: 0 28rpx;
  margin-bottom: 24rpx;
  border-radius: 24rpx;
  border: 2rpx solid $edu-outline;
  font-size: 30rpx;
  color: $edu-text-primary;
  background-color: rgba(255, 255, 255, 0.6);
}
.sheet-placeholder { font-size: 28rpx; color: $edu-text-hint; }
.sheet-error {
  display: block;
  font-size: 26rpx;
  color: $edu-error-text;
  margin-bottom: 20rpx;
}
.sheet-actions { display: flex; align-items: center; margin-top: 16rpx; }
.sheet-btn {
  flex: 1;
  height: 96rpx;
  border-radius: 48rpx;
  display: flex;
  align-items: center;
  justify-content: center;
}
.sheet-btn-cancel {
  margin-right: 24rpx;
  background-color: $edu-surface-variant;
}
.sheet-btn-cancel-text { font-size: 32rpx; color: $edu-text-secondary; }
.sheet-btn-confirm {
  @include eduBrandGradient;
  box-shadow: 0 8rpx 24rpx rgba(54, 119, 239, 0.3);
}
.sheet-btn-disabled { opacity: 0.6; box-shadow: none; }
.sheet-btn-confirm-text { font-size: 32rpx; font-weight: 600; color: #FFFFFF; }
</style>
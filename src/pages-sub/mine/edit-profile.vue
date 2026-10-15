<template>
  <view class="edit-profile-page">
    <!-- 顶部栏：返回 + 标题 -->
    <view class="nav-bar" :style="{ paddingTop: statusBarHeight + 'px' }">
      <view class="nav-bar-inner" :style="{ height: navContentHeight + 'px' }">
        <view class="nav-back" @tap="goBack">
          <text class="back-icon">←</text>
        </view>
        <text class="nav-title">编辑主页</text>
      </view>
    </view>

    <!-- 头像 -->
    <view class="avatar-block">
      <view class="avatar-wrap" @tap="chooseAvatar">
        <image v-if="form.avatarUrl" class="avatar" :src="form.avatarUrl" mode="aspectFill" />
        <view v-else class="avatar avatar-fallback">
          <text class="avatar-char">{{ avatarChar }}</text>
        </view>
        <view v-if="uploading" class="avatar-mask">
          <text class="avatar-mask-text">上传中…</text>
        </view>
      </view>
      <text class="avatar-tip">点击头像从相册选择</text>
    </view>

    <!-- 昵称 -->
    <view class="field-card" :class="{ 'field-card-error': nicknameError }">
      <text class="field-label">昵称</text>
      <input
          class="field-input"
          v-model="form.nickName"
          placeholder="请输入昵称"
          placeholder-class="field-placeholder"
          :maxlength="20"
          @blur="handleNicknameBlur"
      />
    </view>
    <text v-if="nicknameError" class="error-text">{{ nicknameErrorText }}</text>

    <!-- 个人简介 -->
    <view class="field-card">
      <text class="field-label">个人简介</text>
      <textarea
          class="field-textarea"
          v-model="form.bio"
          placeholder="介绍一下你自己吧"
          placeholder-class="field-placeholder"
          :maxlength="100"
          auto-height
      />
    </view>

    <!-- 性别 -->
    <text class="group-label">性别</text>
    <view class="gender-row">
      <view
          v-for="opt in genderOptions"
          :key="opt.value"
          class="gender-pill"
          :class="{ 'gender-pill-active': form.sex === opt.value }"
          @tap="form.sex = opt.value"
      >
        <text class="gender-pill-text">{{ opt.label }}</text>
      </view>
    </view>

    <text v-if="saveError" class="error-text error-text-block">{{ saveError }}</text>

    <view class="bottom-placeholder"></view>

    <!-- 吸底保存按钮 -->
    <view class="save-bar">
      <view
          class="save-btn"
          :class="{ 'save-btn-disabled': !isFormValid || saving, 'btn-pressed': btnPressed }"
          @touchstart="btnPressed = true"
          @touchend="btnPressed = false"
          @touchcancel="btnPressed = false"
          @tap="handleSave"
      >
        <text class="save-btn-text">{{ saving ? '保存中...' : '保存' }}</text>
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { ref, reactive, computed } from 'vue'
import { onLoad } from '@dcloudio/uni-app'
import { useAuthStore } from '@/store/auth'
import { getProfileApi, updateProfileApi, uploadAvatarApi, resolveFileUrl } from '@/api/user'

const auth = useAuthStore()

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

/* ===== 表单状态 ===== */
const avatarChar = ref<string>('U')
const uploading = ref<boolean>(false)
const saving = ref<boolean>(false)
const btnPressed = ref<boolean>(false)
const saveError = ref<string>('')

const form = reactive({
  nickName: '',
  bio: '',
  sex: '2',        // 0男 1女 2未知，与后端 sex 编码一致
  avatarUrl: '',   // 展示用完整地址
  avatarPath: ''   // 提交用相对地址
})

const genderOptions = [
  { label: '不公开', value: '2' },
  { label: '男', value: '0' },
  { label: '女', value: '1' }
]

/* ===== 昵称校验 ===== */
const nicknameError = ref<boolean>(false)
const nicknameErrorText = ref<string>('')

function validateNickname(): boolean {
  if (!form.nickName.trim()) {
    nicknameErrorText.value = '昵称不能为空'
    nicknameError.value = true
    return false
  }
  nicknameError.value = false
  return true
}

function handleNicknameBlur() {
  if (form.nickName) validateNickname()
}

const isFormValid = computed<boolean>(() => !!form.nickName.trim())

/* ===== 载入原资料 ===== */
function fillForm(u: any) {
  form.nickName = u?.nickName || u?.userName || ''
  form.bio = u?.remark || ''
  form.sex = u?.sex || '2'
  form.avatarPath = u?.avatar || ''
  form.avatarUrl = resolveFileUrl(u?.avatar)
  avatarChar.value = (form.nickName || 'U').charAt(0)
}

onLoad(async () => {
  fillForm(auth.state.user)
  try {
    const res: any = await getProfileApi()
    if (res && res.info) {
      auth.state.user = res.info
      fillForm(res.info)
    }
  } catch (e) {
    // 拉取失败时保留 store 缓存，不阻断编辑
  }
})

/* ===== 头像上传 ===== */
function chooseAvatar() {
  if (uploading.value) return
  uni.chooseImage({
    count: 1,
    sizeType: ['compressed'],
    sourceType: ['album'],
    success: async (res: any) => {
      const filePath = res.tempFilePaths[0]
      uploading.value = true
      try {
        const path = await uploadAvatarApi(filePath)
        form.avatarPath = path
        form.avatarUrl = resolveFileUrl(path)
        uni.showToast({ title: '头像已上传', icon: 'none' })
      } catch (err: any) {
        uni.showToast({ title: (err && err.msg) || '头像上传失败', icon: 'none' })
      } finally {
        uploading.value = false
      }
    }
  })
}

/* ===== 保存 ===== */
async function handleSave() {
  if (saving.value || !isFormValid.value) return
  saveError.value = ''
  if (!validateNickname()) return
  saving.value = true
  try {
    await updateProfileApi({
      nickName: form.nickName.trim(),
      sex: form.sex,
      remark: form.bio.trim(),
      avatar: form.avatarPath
    })
    await auth.fetchUserInfo()
    uni.$emit('profile:updated')
    uni.showToast({ title: '保存成功', icon: 'success', duration: 800 })
    setTimeout(goBack, 800)
  } catch (e: any) {
    saveError.value = (e && e.msg) ? e.msg : '保存失败，请检查后端服务'
  } finally {
    saving.value = false
  }
}

function goBack() {
  const pages = getCurrentPages()
  if (pages.length > 1) {
    uni.navigateBack()
  } else {
    uni.reLaunch({ url: '/pages/index/index' })
  }
}
</script>

<style lang="scss" scoped>
.edit-profile-page {
  min-height: 100vh;
  box-sizing: border-box;
  padding: 0 32rpx;
  @include eduPageGradientStrong;
}

/* ===== 顶部栏 ===== */
.nav-bar-inner { display: flex; align-items: center; padding-left: 16rpx; }
.nav-back { width: 72rpx; height: 72rpx; display: flex; align-items: center; justify-content: center; }
.back-icon { font-size: 44rpx; color: $edu-text-primary; }
.nav-title { font-size: 40rpx; font-weight: 700; color: $edu-text-primary; margin-left: 8rpx; }

/* ===== 头像 ===== */
.avatar-block {
  display: flex;
  flex-direction: column;
  align-items: center;
  margin-top: 48rpx;
}
.avatar-wrap { position: relative; }
.avatar { width: 220rpx; height: 220rpx; border-radius: 50%; }
.avatar-fallback {
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: $edu-primary;
}
.avatar-char { font-size: 96rpx; font-weight: 700; color: #FFFFFF; }
.avatar-mask {
  position: absolute;
  left: 0;
  top: 0;
  width: 220rpx;
  height: 220rpx;
  border-radius: 50%;
  background: rgba(0, 0, 0, 0.4);
  display: flex;
  align-items: center;
  justify-content: center;
}
.avatar-mask-text { font-size: 26rpx; color: #FFFFFF; }
.avatar-tip { font-size: 28rpx; color: $edu-text-hint; margin-top: 24rpx; }

/* ===== 浮动标签输入卡 ===== */
.field-card {
  position: relative;
  margin-top: 44rpx;
  padding: 40rpx 28rpx 24rpx;
  border-radius: 24rpx;
  border: 2rpx solid $edu-outline;
  background-color: rgba(255, 255, 255, 0.55);
  box-sizing: border-box;
}
.field-card-error { border-color: $edu-accent-coral; }
.field-label {
  position: absolute;
  top: -16rpx;
  left: 24rpx;
  padding: 0 12rpx;
  background-color: #FFFBF2;
  font-size: 26rpx;
  color: $edu-text-secondary;
}
.field-input {
  width: 100%;
  height: 56rpx;
  line-height: 56rpx;
  font-size: 34rpx;
  color: $edu-text-primary;
}
.field-textarea {
  width: 100%;
  min-height: 112rpx;
  font-size: 34rpx;
  line-height: 1.5;
  color: $edu-text-primary;
}
.field-placeholder { font-size: 30rpx; color: $edu-text-hint; }

/* ===== 性别 ===== */
.group-label {
  display: block;
  font-size: 34rpx;
  font-weight: 700;
  color: $edu-text-primary;
  margin-top: 56rpx;
}
.gender-row { display: flex; align-items: center; margin-top: 28rpx; }
.gender-pill {
  height: 84rpx;
  padding: 0 48rpx;
  border-radius: 42rpx;
  margin-right: 24rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  @include eduWarmYellowGradient;
}
.gender-pill-active {
  background: $edu-primary;
  .gender-pill-text { color: #FFFFFF; font-weight: 600; }
}
.gender-pill-text { font-size: 30rpx; color: $edu-text-secondary; }

/* ===== 错误提示 ===== */
.error-text {
  display: block;
  font-size: 26rpx;
  color: $edu-error-text;
  margin-top: 12rpx;
  padding-left: 12rpx;
}
.error-text-block { margin-top: 32rpx; }

/* ===== 吸底保存栏 ===== */
.bottom-placeholder { height: 220rpx; }
.save-bar {
  position: fixed;
  left: 0;
  right: 0;
  bottom: 0;
  z-index: 99;
  padding: 24rpx 56rpx calc(24rpx + env(safe-area-inset-bottom));
  background-color: rgba(255, 255, 255, 0.92);
  border-top: 2rpx solid $edu-divider;
}
.save-btn {
  width: 100%;
  height: 96rpx;
  border-radius: 48rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.15s;
  @include eduBrandGradient;
  box-shadow: 0 8rpx 24rpx rgba(54, 119, 239, 0.3);
}
.btn-pressed { background: linear-gradient(135deg, #3677EF 0%, #2A5FD0 100%); }
.save-btn-disabled {
  background: $edu-divider;
  box-shadow: none;
  .save-btn-text { color: $edu-text-hint; }
}
.save-btn-text { font-size: 32rpx; font-weight: 600; color: #FFFFFF; }
</style>
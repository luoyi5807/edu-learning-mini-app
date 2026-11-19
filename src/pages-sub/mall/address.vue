<!-- src/pages-sub/mall/address.vue -->
<template>
  <view class="address-page" :class="themeClass">
    <view class="nav-bar" :style="{ paddingTop: statusBarHeight + 'px' }">
      <view class="nav-bar-inner" :style="{ height: navContentHeight + 'px' }">
        <view class="nav-back" @tap="goBack"><text class="back-icon">←</text></view>
        <text class="nav-title">收货信息</text>
      </view>
    </view>
    <view class="nav-placeholder" :style="{ height: (statusBarHeight + navContentHeight) + 'px' }"></view>

    <view class="form-card">
      <view class="fc-head">
        <view class="fc-title-wrap"><text class="fc-pin">📍</text><text class="fc-title">收货信息</text></view>
        <text class="fc-hint">用于兑换奖品</text>
      </view>

      <view class="field">
        <text class="field-label">收货人</text>
        <input class="field-input" v-model="form.receiverName" placeholder="请输入收货人姓名" placeholder-class="field-ph" />
      </view>
      <view class="field">
        <text class="field-label">手机号</text>
        <input class="field-input" v-model="form.receiverPhone" type="number" :maxlength="11" placeholder="请输入手机号" placeholder-class="field-ph" />
      </view>
      <view class="field field-area">
        <text class="field-label">详细地址</text>
        <textarea class="field-textarea" v-model="form.detailAddress" placeholder="省市区、街道、门牌号等" placeholder-class="field-ph" :maxlength="200" auto-height />
      </view>
      <view class="field-switch">
        <text class="field-label">设为默认地址</text>
        <switch :checked="!!form.isDefault" color="#3677EF" @change="form.isDefault = $event.detail.value" />
      </view>
    </view>

    <text class="foot-note">收货信息保存在服务器，可随时修改；后端暂不做配送，地址仅作地址簿</text>

    <view class="bottom-bar">
      <view class="save-btn" @tap="save"><text class="save-btn-text">保存收货信息</text></view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { onLoad } from '@dcloudio/uni-app'
import { getAddressListApi, saveAddressApi, type MallAddress } from '@/api/mall'
import { useTheme } from '@/composables/useTheme'

const { themeClass } = useTheme()

const statusBarHeight = ref<number>(0)
const navContentHeight = ref<number>(44)
const sysInfo = uni.getSystemInfoSync()
statusBarHeight.value = sysInfo.statusBarHeight || 0
// #ifdef MP-WEIXIN
const menuButton = uni.getMenuButtonBoundingClientRect()
if (menuButton) navContentHeight.value = (menuButton.top - statusBarHeight.value) * 2 + menuButton.height
// #endif

const form = ref<MallAddress>({ receiverName: '', receiverPhone: '', detailAddress: '', isDefault: true })
const saving = ref<boolean>(false)

/** 编辑已有地址：取默认/第一条回填（addressId 决定 add 还是 edit） */
async function load() {
  try {
    const list = await getAddressListApi()
    const d = list.find((a) => a.isDefault) || list[0]
    if (d) form.value = { ...d }
  } catch (e) { /* 拉取失败按新增处理 */ }
}

function goBack() {
  const pages = getCurrentPages()
  if (pages.length > 1) uni.navigateBack()
  else uni.reLaunch({ url: '/pages-sub/mall/mall' })
}

async function save() {
  const f = form.value
  if (!f.receiverName.trim() || !f.receiverPhone.trim() || !f.detailAddress.trim()) {
    uni.showToast({ title: '请完善收货信息', icon: 'none' }); return
  }
  if (saving.value) return
  saving.value = true
  try {
    await saveAddressApi({
      ...f,
      receiverName: f.receiverName.trim(),
      receiverPhone: f.receiverPhone.trim(),
      detailAddress: f.detailAddress.trim()
    })
    uni.showToast({ title: '已保存', icon: 'success' })
    setTimeout(() => uni.navigateBack(), 500)
  } catch (e) { /* request.ts 已 toast 业务错误 */ }
  finally { saving.value = false }
}

onLoad(load)
</script>

<style lang="scss" scoped>
.address-page { min-height: 100vh; box-sizing: border-box; padding: 0 32rpx 200rpx; @include eduPageGradientStrong; }
.nav-bar { position: fixed; top: 0; left: 0; right: 0; z-index: 99; background: transparent; }
.nav-bar-inner { display: flex; align-items: center; padding-left: 16rpx; }
.nav-back { width: 72rpx; height: 72rpx; display: flex; align-items: center; justify-content: center; }
.back-icon { font-size: 44rpx; color: $edu-text-primary; }
.nav-title { font-size: 40rpx; font-weight: 700; color: $edu-text-primary; margin-left: 8rpx; }

.form-card { margin-top: 24rpx; border-radius: 24rpx; padding: 36rpx 32rpx; background-color: $edu-surface; box-shadow: 0 8rpx 24rpx rgba(0, 0, 0, 0.04); }
.fc-head { display: flex; align-items: center; justify-content: space-between; margin-bottom: 32rpx; }
.fc-title-wrap { display: flex; align-items: center; }
.fc-pin { font-size: 32rpx; margin-right: 12rpx; }
.fc-title { font-size: 34rpx; font-weight: 700; color: $edu-text-primary; }
.fc-hint { font-size: 24rpx; color: $edu-text-hint; }

.field { border: 2rpx solid $edu-outline; border-radius: 16rpx; padding: 20rpx 24rpx 12rpx; margin-bottom: 24rpx; }
.field-area { padding-bottom: 16rpx; }
.field-label { font-size: 24rpx; color: $edu-text-secondary; }
.field-input { font-size: 30rpx; color: $edu-text-primary; height: 56rpx; margin-top: 6rpx; }
.field-textarea { font-size: 30rpx; color: $edu-text-primary; width: 100%; min-height: 96rpx; margin-top: 6rpx; }
.field-ph { color: $edu-text-hint; }
.field-switch { display: flex; align-items: center; justify-content: space-between; margin-bottom: 24rpx; }

.foot-note { display: block; text-align: center; font-size: 24rpx; color: $edu-text-hint; margin-top: 40rpx; }

.bottom-bar { position: fixed; left: 0; right: 0; bottom: 0; z-index: 50; padding: 20rpx 32rpx calc(20rpx + env(safe-area-inset-bottom)); background-color: $edu-surface; box-shadow: 0 -2rpx 16rpx rgba(0, 0, 0, 0.06); }
.save-btn { height: 92rpx; border-radius: 46rpx; display: flex; align-items: center; justify-content: center; @include eduBrandGradient; }
.save-btn-text { font-size: 32rpx; font-weight: 700; color: #FFFFFF; }
</style>
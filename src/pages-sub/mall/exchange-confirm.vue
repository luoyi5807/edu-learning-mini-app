<!-- src/pages-sub/mall/exchange-confirm.vue -->
<template>
  <view class="confirm-page" :class="themeClass">
    <view class="nav-bar" :style="{ paddingTop: statusBarHeight + 'px' }">
      <view class="nav-bar-inner" :style="{ height: navContentHeight + 'px' }">
        <view class="nav-back" @tap="goBack"><text class="back-icon">←</text></view>
        <text class="nav-title">确认兑换</text>
      </view>
    </view>
    <view class="nav-placeholder" :style="{ height: (statusBarHeight + navContentHeight) + 'px' }"></view>

    <block v-if="product">
      <!-- 商品卡 -->
      <view class="goods-card">
        <view class="gc-top">
          <view class="gc-img">
            <image v-if="product.coverUrl" class="gc-cover" :src="product.coverUrl" mode="aspectFill" />
            <text v-else class="gc-emoji">🎁</text>
          </view>
          <view class="gc-info">
            <text class="gc-name">{{ product.productName }}</text>
            <view class="gc-tags">
              <text class="gc-cat" v-if="product.categoryName">{{ product.categoryName }}</text>
              <text class="gc-ref">已兑 {{ product.soldCount || 0 }} · 库存 {{ product.stock }}</text>
            </view>
          </view>
          <text class="gc-cost">{{ product.pointsPrice }} 积分</text>
        </view>
        <view class="gc-foot">
          <text class="gc-balance">当前可用积分 {{ balance }}</text>
          <text v-if="insufficient" class="gc-lack">积分不足，还差 {{ gap }} 分</text>
        </view>
      </view>

      <!-- 收货信息（默认地址，仅展示；后端明确兑换不携带地址、不做配送） -->
      <view class="addr-card">
        <view class="addr-head">
          <view class="addr-title-wrap"><text class="addr-pin">📍</text><text class="addr-title">收货信息</text></view>
          <text class="addr-edit" @tap="goAddress">{{ address ? '修改 ›' : '去填写 ›' }}</text>
        </view>
        <block v-if="address">
          <view class="addr-line"><text class="addr-name">{{ address.receiverName }}</text><text class="addr-phone">{{ maskPhone(address.receiverPhone) }}</text></view>
          <text class="addr-detail">{{ address.detailAddress }}</text>
        </block>
        <text v-else class="addr-detail">尚未填写收货地址（不影响兑换）</text>
      </view>

      <!-- 兑换须知 -->
      <view class="notice-card">
        <text class="notice-title">兑换须知</text>
        <view class="bullet" v-for="(b, i) in notices" :key="i">
          <text class="bullet-dot">•</text><text class="bullet-text">{{ b }}</text>
        </view>
      </view>

      <!-- 底部操作栏 -->
      <view class="bottom-bar">
        <view class="bb-left">
          <text class="bb-cost">{{ product.pointsPrice }} 积分</text>
          <text class="bb-balance">可用 {{ balance }} 积分</text>
        </view>
        <view class="bb-btn" :class="{ 'bb-btn-disabled': insufficient || soldOut || submitting }" @tap="confirm">
          <text class="bb-btn-text">{{ soldOut ? '已兑完' : (submitting ? '兑换中…' : '确认兑换') }}</text>
        </view>
      </view>
    </block>
    <EmptyState v-else-if="!loading" text="商品不存在或已下架" />
  </view>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { onLoad, onShow } from '@dcloudio/uni-app'
import EmptyState from '@/components/EmptyState.vue'
import { getPointsAccountApi } from '@/api/points'
import { getMallProductDetailApi, getDefaultAddressApi, exchangeProductApi, maskPhone, type MallProduct, type MallAddress } from '@/api/mall'
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

const productId = ref<number>(0)
const product = ref<MallProduct | null>(null)
const balance = ref<number>(0)
const address = ref<MallAddress | null>(null)
const loading = ref<boolean>(true)
const submitting = ref<boolean>(false)

const insufficient = computed<boolean>(() => (product.value ? balance.value < product.value.pointsPrice : false))
const gap = computed<number>(() => (product.value ? Math.max(0, product.value.pointsPrice - balance.value) : 0))
const soldOut = computed<boolean>(() => (product.value ? (product.value.stock ?? 0) < 1 : false))

const notices = [
  '兑换成功后积分立即扣除，不支持退回',
  '兑换码在兑换成功时当场生成，请妥善保存',
  '库存有限的实物奖品以兑换时实际库存为准',
  '收货地址仅作个人地址簿，发货安排以平台公告为准'
]

async function load() {
  loading.value = true
  try {
    product.value = await getMallProductDetailApi(productId.value).catch(() => null)
    address.value = await getDefaultAddressApi().catch(() => null)
    try { const acc = await getPointsAccountApi(); balance.value = acc.balance || 0 } catch (e) { /* ignore */ }
  } finally {
    loading.value = false
  }
}

function goBack() {
  const pages = getCurrentPages()
  if (pages.length > 1) uni.navigateBack()
  else uni.reLaunch({ url: '/pages-sub/mall/mall' })
}
function goAddress() { uni.navigateTo({ url: '/pages-sub/mall/address' }) }

async function confirm() {
  if (!product.value || submitting.value) return
  if (soldOut.value) { uni.showToast({ title: '该商品已兑完', icon: 'none' }); return }
  if (insufficient.value) { uni.showToast({ title: '积分不足', icon: 'none' }); return }
  submitting.value = true
  try {
    // 后端扣库存+扣积分+生成兑换码在同一事务，成功响应顶层带 redemptionCode/balance
    const r = await exchangeProductApi(product.value.productId)
    const q = 'orderId=' + (r.orderId || 0)
      + '&code=' + encodeURIComponent(r.redemptionCode || '')
      + '&name=' + encodeURIComponent(r.productName || (product.value ? product.value.productName : ''))
      + '&cost=' + (r.pointsCost != null ? r.pointsCost : (product.value ? product.value.pointsPrice : 0))
    uni.redirectTo({ url: '/pages-sub/mall/exchange-success?' + q })
  } catch (e: any) {
    // 库存不足/积分不足等业务错误 request.ts 已 toast，这里停留在本页刷新余额
    try { const acc = await getPointsAccountApi(); balance.value = acc.balance || 0 } catch (e2) { /* ignore */ }
    load()
  } finally {
    submitting.value = false
  }
}

onLoad((q) => { productId.value = Number((q && q.productId) || 0) })
onShow(load)
</script>

<style lang="scss" scoped>
.confirm-page { min-height: 100vh; box-sizing: border-box; padding: 0 32rpx 200rpx; @include eduPageGradientStrong; }

.nav-bar { position: fixed; top: 0; left: 0; right: 0; z-index: 99; background: transparent; }
.nav-bar-inner { display: flex; align-items: center; padding-left: 16rpx; }
.nav-back { width: 72rpx; height: 72rpx; display: flex; align-items: center; justify-content: center; }
.back-icon { font-size: 44rpx; color: $edu-text-primary; }
.nav-title { font-size: 40rpx; font-weight: 700; color: $edu-text-primary; margin-left: 8rpx; }

/* 商品卡 */
.goods-card { margin-top: 24rpx; border-radius: 24rpx; padding: 32rpx; background-color: $edu-surface; box-shadow: 0 8rpx 24rpx rgba(0, 0, 0, 0.04); }
.gc-top { display: flex; align-items: center; }
.gc-img { width: 112rpx; height: 112rpx; border-radius: 20rpx; display: flex; align-items: center; justify-content: center; flex-shrink: 0; overflow: hidden; background: linear-gradient(135deg, #E3ECFD 0%, #F6F9FF 100%); }
.gc-cover { width: 100%; height: 100%; }
.gc-emoji { font-size: 56rpx; }
.gc-info { flex: 1; min-width: 0; margin: 0 24rpx; }
.gc-name { display: block; font-size: 32rpx; font-weight: 700; color: $edu-text-primary; }
.gc-tags { display: flex; align-items: center; margin-top: 12rpx; }
.gc-cat { font-size: 22rpx; color: $edu-primary; background-color: $edu-primary-container; padding: 4rpx 14rpx; border-radius: 8rpx; }
.gc-ref { font-size: 22rpx; color: $edu-text-hint; margin-left: 16rpx; }
.gc-cost { font-size: 34rpx; font-weight: 800; color: $edu-primary; flex-shrink: 0; }
.gc-foot { display: flex; align-items: center; justify-content: space-between; margin-top: 28rpx; padding-top: 24rpx; border-top: 2rpx solid $edu-divider; }
.gc-balance { font-size: 26rpx; color: $edu-text-secondary; }
.gc-lack { font-size: 26rpx; color: $edu-accent-coral; font-weight: 600; }

/* 收货信息 */
.addr-card { margin-top: 28rpx; border-radius: 24rpx; padding: 32rpx; background-color: $edu-surface; box-shadow: 0 8rpx 24rpx rgba(0, 0, 0, 0.04); }
.addr-head { display: flex; align-items: center; justify-content: space-between; }
.addr-title-wrap { display: flex; align-items: center; }
.addr-pin { font-size: 30rpx; margin-right: 12rpx; }
.addr-title { font-size: 32rpx; font-weight: 700; color: $edu-text-primary; }
.addr-edit { font-size: 26rpx; color: $edu-primary; }
.addr-line { display: flex; align-items: center; margin-top: 24rpx; }
.addr-name { font-size: 30rpx; font-weight: 600; color: $edu-text-primary; }
.addr-phone { font-size: 28rpx; color: $edu-text-secondary; margin-left: 20rpx; }
.addr-detail { display: block; font-size: 26rpx; color: $edu-text-secondary; margin-top: 12rpx; line-height: 1.5; }

/* 须知 */
.notice-card { margin-top: 28rpx; border-radius: 24rpx; padding: 32rpx; background-color: $edu-surface; box-shadow: 0 8rpx 24rpx rgba(0, 0, 0, 0.04); }
.notice-title { display: block; font-size: 32rpx; font-weight: 700; color: $edu-text-primary; margin-bottom: 8rpx; }
.bullet { display: flex; align-items: flex-start; margin-top: 16rpx; }
.bullet-dot { font-size: 26rpx; color: $edu-primary; margin-right: 16rpx; line-height: 1.6; }
.bullet-text { flex: 1; font-size: 26rpx; color: $edu-text-secondary; line-height: 1.6; }

.demo-note { display: block; text-align: center; font-size: 24rpx; color: $edu-text-hint; margin-top: 40rpx; }

/* 底部栏 */
.bottom-bar { position: fixed; left: 0; right: 0; bottom: 0; z-index: 50; display: flex; align-items: center; justify-content: space-between; padding: 20rpx 32rpx calc(20rpx + env(safe-area-inset-bottom)); background-color: $edu-surface; box-shadow: 0 -2rpx 16rpx rgba(0, 0, 0, 0.06); }
.bb-left { display: flex; flex-direction: column; }
.bb-cost { font-size: 36rpx; font-weight: 800; color: $edu-primary; }
.bb-balance { font-size: 24rpx; color: $edu-text-hint; margin-top: 6rpx; }
.bb-btn { height: 88rpx; padding: 0 64rpx; border-radius: 44rpx; display: flex; align-items: center; justify-content: center; @include eduBrandGradient; }
.bb-btn-disabled { background: $edu-outline; }
.bb-btn-text { font-size: 32rpx; font-weight: 700; color: #FFFFFF; }
</style>
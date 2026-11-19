<!-- src/pages-sub/mall/exchange-records.vue -->
<template>
  <view class="records-page" :class="themeClass">
    <view class="nav-bar" :style="{ paddingTop: statusBarHeight + 'px' }">
      <view class="nav-bar-inner" :style="{ height: navContentHeight + 'px' }">
        <view class="nav-back" @tap="goBack"><text class="back-icon">←</text></view>
        <text class="nav-title">兑换记录</text>
      </view>
    </view>
    <view class="nav-placeholder" :style="{ height: (statusBarHeight + navContentHeight) + 'px' }"></view>

    <view class="sum-row">
      <text class="sum-count">共 {{ total }} 笔兑换</text>
      <text class="sum-consumed">累计消耗 <text class="sum-num">{{ consumed }}</text> 积分</text>
    </view>

    <LoadingState v-if="loading" inline text="加载兑换记录…" />
    <EmptyState v-else-if="records.length === 0" text="还没有兑换记录" />
    <view class="rec-list" v-else>
      <view class="rec-card" v-for="r in records" :key="r.orderId">
        <view class="rec-img">
          <image v-if="r.coverUrl" class="rec-cover" :src="r.coverUrl" mode="aspectFill" />
          <text v-else class="rec-emoji">🎁</text>
        </view>
        <view class="rec-body">
          <text class="rec-name">{{ r.productName }}</text>
          <text class="rec-time">{{ r.createTime }}</text>
          <text class="rec-code" v-if="r.redemptionCode">兑换码 {{ r.redemptionCode }}</text>
        </view>
        <view class="rec-right">
          <text class="rec-cost">-{{ r.pointsCost }}</text>
          <text class="rec-status st-done">已兑换</text>
        </view>
      </view>
    </view>

    <view class="load-more" v-if="!loading && records.length > 0 && hasMore" @tap="load(false)">
      <text class="load-more-text">{{ loadingMore ? '加载中...' : '点击加载更多' }}</text>
    </view>
    <text class="foot-note" v-else-if="records.length">兑换成功即扣减积分，兑换码长期有效</text>
  </view>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { onLoad } from '@dcloudio/uni-app'
import LoadingState from '@/components/LoadingState.vue'
import EmptyState from '@/components/EmptyState.vue'
import { getExchangeRecordsApi, totalConsumed, type ExchangeRecord } from '@/api/mall'
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

const records = ref<ExchangeRecord[]>([])
const total = ref<number>(0)
const pageNum = ref<number>(1)
const loading = ref<boolean>(false)
const loadingMore = ref<boolean>(false)
const PAGE_SIZE = 20
const hasMore = computed<boolean>(() => records.value.length < total.value)
const consumed = computed<number>(() => totalConsumed(records.value))

/** GET /api/v1/shop/order/list：服务端按兑换时间倒序分页，userId 从 Token 解析 */
async function load(reset: boolean) {
  if (reset) { if (loading.value) return; loading.value = true }
  else { if (loadingMore.value || !hasMore.value) return; loadingMore.value = true }
  const page = reset ? 1 : pageNum.value + 1
  try {
    const res = await getExchangeRecordsApi(page, PAGE_SIZE)
    records.value = reset ? res.list : records.value.concat(res.list)
    total.value = res.total
    pageNum.value = page
  } catch (e) {
    if (reset) { records.value = []; total.value = 0 }
    else uni.showToast({ title: '加载失败，请重试', icon: 'none' })
  } finally {
    loading.value = false
    loadingMore.value = false
  }
}

function goBack() {
  const pages = getCurrentPages()
  if (pages.length > 1) uni.navigateBack()
  else uni.reLaunch({ url: '/pages-sub/mall/mall' })
}

onLoad(() => { load(true) })
</script>

<style lang="scss" scoped>
.records-page { min-height: 100vh; box-sizing: border-box; padding: 0 32rpx 60rpx; @include eduPageGradientStrong; }
.nav-bar { position: fixed; top: 0; left: 0; right: 0; z-index: 99; background: transparent; }
.nav-bar-inner { display: flex; align-items: center; padding-left: 16rpx; }
.nav-back { width: 72rpx; height: 72rpx; display: flex; align-items: center; justify-content: center; }
.back-icon { font-size: 44rpx; color: $edu-text-primary; }
.nav-title { font-size: 40rpx; font-weight: 700; color: $edu-text-primary; margin-left: 8rpx; }

.sum-row { display: flex; align-items: center; justify-content: space-between; margin: 24rpx 0; }
.sum-count { font-size: 26rpx; color: $edu-text-secondary; }
.sum-consumed { font-size: 26rpx; color: $edu-text-secondary; }
.sum-num { font-size: 30rpx; font-weight: 800; color: $edu-primary; }

.rec-list { display: flex; flex-direction: column; }
.rec-card { display: flex; align-items: center; border-radius: 24rpx; padding: 28rpx; background-color: $edu-surface; box-shadow: 0 8rpx 24rpx rgba(0, 0, 0, 0.04); margin-bottom: 24rpx; }
.rec-img { width: 96rpx; height: 96rpx; border-radius: 20rpx; background-color: $edu-surface-variant; display: flex; align-items: center; justify-content: center; flex-shrink: 0; overflow: hidden; }
.rec-cover { width: 100%; height: 100%; }
.rec-emoji { font-size: 48rpx; }
.rec-body { flex: 1; min-width: 0; margin: 0 24rpx; }
.rec-name { display: block; font-size: 32rpx; font-weight: 700; color: $edu-text-primary; }
.rec-time { display: block; font-size: 24rpx; color: $edu-text-hint; margin-top: 8rpx; }
.rec-code { display: inline-block; font-size: 22rpx; color: $edu-primary; background-color: $edu-primary-container; padding: 4rpx 14rpx; border-radius: 8rpx; margin-top: 12rpx; }
.rec-right { display: flex; flex-direction: column; align-items: flex-end; flex-shrink: 0; }
.rec-cost { font-size: 34rpx; font-weight: 800; color: $edu-primary; }
.rec-status { font-size: 22rpx; padding: 4rpx 14rpx; border-radius: 8rpx; margin-top: 12rpx; }
.st-done { color: #0E6E78; background-color: #DCF2F5; }

.load-more { padding: 8rpx 0 24rpx; display: flex; justify-content: center; }
.load-more-text { font-size: 26rpx; color: $edu-primary; }

.foot-note { display: block; text-align: center; font-size: 24rpx; color: $edu-text-hint; margin-top: 32rpx; }
</style>
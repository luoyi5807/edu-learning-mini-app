<!-- src/pages-sub/mall/mall.vue -->
<template>
  <view class="mall-page" :class="themeClass">
    <!-- 自定义顶栏 -->
    <view class="nav-bar" :class="{ 'nav-bar-opaque': navBarOpaque }" :style="{ paddingTop: statusBarHeight + 'px' }">
      <view class="nav-bar-inner" :style="{ height: navContentHeight + 'px' }">
        <view class="nav-back" @tap="goBack"><text class="back-icon">←</text></view>
        <text class="nav-title">积分商城</text>
      </view>
    </view>
    <view class="nav-placeholder" :style="{ height: (statusBarHeight + navContentHeight) + 'px' }"></view>

    <!-- 积分余额卡 -->
    <view class="balance-card" @tap="goDetail">
      <view class="bc-left">
        <text class="bc-label">我的积分</text>
        <view class="bc-num-row">
          <text class="bc-num">{{ balance }}</text>
          <text class="bc-arrow">›</text>
        </view>
      </view>
      <view class="bc-right">
        <text class="bc-sub">今日内容已赚 {{ contentPoints }} 分</text>
        <view class="bc-records-btn" @tap.stop="goRecords">
          <text class="bc-records-text">兑换记录 ›</text>
        </view>
        <text class="bc-tip">兑换扣减即时生效</text>
      </view>
    </view>

    <!-- 搜索 -->
    <view class="search-box">
      <text class="search-icon">🔍</text>
      <input class="search-input" v-model="keyword" placeholder="搜索商品名称" placeholder-class="search-ph" confirm-type="search" />
    </view>

    <!-- 分类 chips（服务端 /shop/category/list） -->
    <scroll-view class="cat-scroll" scroll-x :show-scrollbar="false">
      <view class="cat-row">
        <view class="cat-chip" :class="{ 'cat-chip-active': activeCategoryId === 0 }" @tap="selectCategory(0)">
          <text class="cat-chip-text">全部</text>
        </view>
        <view v-for="c in categories" :key="c.categoryId" class="cat-chip"
              :class="{ 'cat-chip-active': activeCategoryId === c.categoryId }" @tap="selectCategory(c.categoryId)">
          <text class="cat-chip-text">{{ c.categoryName }}</text>
        </view>
      </view>
    </scroll-view>

    <!-- 积分区间 + 只兑得起 -->
    <view class="filter-row">
      <view class="price-chips">
        <view v-for="chip in priceChips" :key="chip.key" class="p-chip"
              :class="{ 'p-chip-active': price === chip.key }" @tap="price = chip.key">
          <text class="p-chip-text">{{ chip.label }}</text>
        </view>
      </view>
      <view class="afford-toggle" :class="{ 'afford-on': affordableOnly }" @tap="affordableOnly = !affordableOnly">
        <text class="afford-text">只兑得起</text>
      </view>
    </view>

    <!-- 商品网格 -->
    <view class="goods-grid" v-if="shown.length > 0">
      <view class="goods-card" v-for="p in shown" :key="p.productId" @tap="openExchange(p)">
        <view class="goods-img">
          <image v-if="p.coverUrl" class="goods-cover" :src="p.coverUrl" mode="aspectFill" />
          <text v-else class="goods-emoji">🎁</text>
          <view v-if="(p.stock ?? 0) <= 0" class="goods-badge badge-out"><text class="goods-badge-text">已兑完</text></view>
        </view>
        <text class="goods-name">{{ p.productName }}</text>
        <view class="goods-price-row">
          <text class="goods-cost">{{ p.pointsPrice }}</text>
          <text class="goods-ref">已兑 {{ p.soldCount || 0 }}</text>
        </view>
        <view class="goods-btn" :class="{ 'goods-btn-off': (p.stock ?? 0) <= 0 }">
          <text class="goods-btn-text">{{ (p.stock ?? 0) <= 0 ? '已兑完' : '去兑换' }}</text>
        </view>
      </view>
    </view>
    <view v-else class="empty-wrap">
      <text class="empty-emoji">🛒</text>
      <text class="empty-text">{{ loading ? '加载中…' : '没有找到符合条件的商品' }}</text>
    </view>
  </view>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { onShow, onPageScroll } from '@dcloudio/uni-app'
import { getMallCategoriesApi, getMallProductsApi, type MallCategory, type MallProduct } from '@/api/mall'
import { getPointsAccountApi, getTodayContentPoints } from '@/api/points'
import { useTheme } from '@/composables/useTheme'

const { themeClass } = useTheme()

/* ===== 顶栏高度 ===== */
const statusBarHeight = ref<number>(0)
const navContentHeight = ref<number>(44)
const sysInfo = uni.getSystemInfoSync()
statusBarHeight.value = sysInfo.statusBarHeight || 0
// #ifdef MP-WEIXIN
const menuButton = uni.getMenuButtonBoundingClientRect()
if (menuButton) navContentHeight.value = (menuButton.top - statusBarHeight.value) * 2 + menuButton.height
// #endif

/* ===== 顶栏滚动变白（与 settings.vue 一致，防止内容穿透重叠） ===== */
const navBarOpaque = ref<boolean>(false)
onPageScroll((e) => {
  navBarOpaque.value = e.scrollTop > 40
})

/** 积分区间筛选（客户端过滤，对齐商品列表页设计稿的三档 chips） */
type PriceFilter = 'all' | 'lt1000' | 'r1000_2000' | 'gt2000'

/* ===== 数据 ===== */
const balance = ref<number>(0)
const contentPoints = ref<number>(0)
const keyword = ref<string>('')
const price = ref<PriceFilter>('all')
const affordableOnly = ref<boolean>(false)
const categories = ref<MallCategory[]>([])
const activeCategoryId = ref<number>(0)
const products = ref<MallProduct[]>([])
const loading = ref<boolean>(false)

const priceChips: { key: PriceFilter; label: string }[] = [
  { key: 'all', label: '全部' },
  { key: 'lt1000', label: '1000 以下' },
  { key: 'r1000_2000', label: '1000-2000' },
  { key: 'gt2000', label: '2000 以上' }
]

/** 积分区间/关键词/可负担过滤：商品一次拉 100 条，客户端过滤（与后端分页无冲突） */
const shown = computed<MallProduct[]>(() => {
  const kw = keyword.value.trim()
  return products.value.filter((p) => {
    if (affordableOnly.value && balance.value < p.pointsPrice) return false
    if (price.value === 'lt1000' && !(p.pointsPrice < 1000)) return false
    if (price.value === 'r1000_2000' && !(p.pointsPrice >= 1000 && p.pointsPrice <= 2000)) return false
    if (price.value === 'gt2000' && !(p.pointsPrice > 2000)) return false
    if (kw && (p.productName || '').indexOf(kw) < 0 && (p.categoryName || '').indexOf(kw) < 0) return false
    return true
  })
})

async function loadCategories() {
  try { categories.value = await getMallCategoriesApi() } catch (e) { /* 静默 */ }
}

async function loadProducts() {
  loading.value = true
  try {
    const res = await getMallProductsApi({ categoryId: activeCategoryId.value || undefined })
    products.value = res.list
  } catch (e) {
    products.value = []
  } finally {
    loading.value = false
  }
}

async function load() {
  contentPoints.value = getTodayContentPoints()
  try { const acc = await getPointsAccountApi(); balance.value = acc.balance || 0 } catch (e) { /* ignore */ }
  loadProducts()
}

function selectCategory(id: number) {
  if (activeCategoryId.value === id) return
  activeCategoryId.value = id
  loadProducts()
}

/* ===== 交互 ===== */
function goBack() {
  const pages = getCurrentPages()
  if (pages.length > 1) uni.navigateBack()
  else uni.reLaunch({ url: '/pages/index/index' })
}
function goRecords() { uni.navigateTo({ url: '/pages-sub/mall/exchange-records' }) }
function goDetail() { uni.showToast({ title: '积分明细即将上线', icon: 'none' }) }
function openExchange(p: MallProduct) {
  if ((p.stock ?? 0) <= 0) { uni.showToast({ title: '该商品已兑完', icon: 'none' }); return }
  uni.navigateTo({ url: '/pages-sub/mall/exchange-confirm?productId=' + p.productId })
}

onMounted(loadCategories)
onShow(load)
</script>

<style lang="scss" scoped>
.mall-page { min-height: 100vh; box-sizing: border-box; padding: 0 32rpx 60rpx; @include eduPageGradientStrong; }

/* ===== 顶栏 ===== */
.nav-bar { position: fixed; top: 0; left: 0; right: 0; z-index: 99; background: transparent; transition: background-color 0.3s ease, box-shadow 0.3s ease; }
.nav-bar-opaque { background: var(--edu-surface); box-shadow: 0 2rpx 12rpx rgba(0, 0, 0, 0.06); }
.nav-bar-inner { display: flex; align-items: center; padding-left: 16rpx; }
.nav-back { width: 72rpx; height: 72rpx; display: flex; align-items: center; justify-content: center; }
.back-icon { font-size: 44rpx; color: $edu-text-primary; }
.nav-title { font-size: 40rpx; font-weight: 700; color: $edu-text-primary; margin-left: 8rpx; }

/* ===== 余额卡 ===== */
.balance-card { display: flex; align-items: center; margin-top: 24rpx; padding: 36rpx 40rpx; border-radius: 32rpx; @include eduBrandGradient; box-shadow: 0 12rpx 32rpx rgba(54, 119, 239, 0.3); }
.bc-left { flex: 1; }
.bc-label { display: block; font-size: 26rpx; color: rgba(255, 255, 255, 0.85); }
.bc-num-row { display: flex; align-items: center; margin-top: 12rpx; }
.bc-num { font-size: 64rpx; font-weight: 800; color: #FFFFFF; }
.bc-arrow { font-size: 40rpx; color: rgba(255, 255, 255, 0.85); margin-left: 12rpx; }
.bc-right { display: flex; flex-direction: column; align-items: flex-end; }
.bc-sub { font-size: 24rpx; color: rgba(255, 255, 255, 0.9); }
.bc-records-btn {
  margin-top: 12rpx;
  padding: 8rpx 20rpx;
  border-radius: 28rpx;
  background: rgba(255, 255, 255, 0.7);
  border: 2rpx solid $edu-primary;
}
.bc-records-text { font-size: 24rpx; color: $edu-primary; font-weight: 600; }
.bc-tip { font-size: 22rpx; color: rgba(255, 255, 255, 0.65); margin-top: 10rpx; }

/* ===== 搜索 ===== */
.search-box { display: flex; align-items: center; height: 80rpx; margin-top: 28rpx; padding: 0 28rpx; border-radius: 40rpx; background-color: $edu-surface; box-shadow: 0 4rpx 16rpx rgba(0, 0, 0, 0.04); }
.search-icon { font-size: 30rpx; margin-right: 16rpx; }
.search-input { flex: 1; font-size: 28rpx; color: $edu-text-primary; }
.search-ph { color: $edu-text-hint; }

/* ===== 分类 chips ===== */
.cat-scroll { margin-top: 24rpx; white-space: nowrap; }
.cat-row { display: inline-flex; align-items: center; }
.cat-chip { flex-shrink: 0; height: 64rpx; padding: 0 32rpx; border-radius: 32rpx; display: flex; align-items: center; margin-right: 20rpx; background-color: $edu-surface; }
.cat-chip-active { background-color: $edu-primary-container; }
.cat-chip-text { font-size: 28rpx; color: $edu-text-secondary; }
.cat-chip-active .cat-chip-text { color: $edu-primary; font-weight: 600; }

/* ===== 价格区间 + 只兑得起 ===== */
.filter-row { display: flex; align-items: center; flex-wrap: wrap; margin-top: 20rpx; }
.price-chips { display: flex; align-items: center; flex: 1; flex-wrap: wrap; row-gap: 12rpx; }
.p-chip { flex-shrink: 0; white-space: nowrap; height: 56rpx; padding: 0 24rpx; border-radius: 28rpx; display: flex; align-items: center; margin-right: 16rpx; border: 2rpx solid transparent; background-color: rgba(255, 255, 255, 0.7); }
.p-chip-active { border-color: $edu-primary; background-color: $edu-surface; }
.p-chip-text { font-size: 24rpx; color: $edu-text-secondary; }
.p-chip-active .p-chip-text { color: $edu-primary; font-weight: 600; }
.afford-toggle { height: 56rpx; padding: 0 24rpx; border-radius: 28rpx; display: flex; align-items: center; border: 2rpx solid $edu-outline; background-color: transparent; }
.afford-on { border-color: $edu-accent-coral; background-color: #FBE0DE; }
.afford-text { font-size: 24rpx; color: $edu-text-hint; }
.afford-on .afford-text { color: $edu-error-text; font-weight: 600; }

/* ===== 商品网格 ===== */
.goods-grid { display: flex; flex-wrap: wrap; justify-content: space-between; }
.goods-card { width: 320rpx; margin-bottom: 28rpx; border-radius: 24rpx; padding: 0 20rpx 24rpx; background-color: $edu-surface; box-shadow: 0 8rpx 24rpx rgba(0, 0, 0, 0.05); }
.goods-img { position: relative; height: 220rpx; border-radius: 18rpx; margin: 20rpx 0; display: flex; align-items: center; justify-content: center; background: linear-gradient(135deg, #E3ECFD 0%, #F6F9FF 100%); overflow: hidden; }
.goods-cover { width: 100%; height: 100%; }
.goods-emoji { font-size: 96rpx; }
.goods-badge { position: absolute; top: 16rpx; left: 16rpx; height: 40rpx; padding: 0 16rpx; border-radius: 20rpx; display: flex; align-items: center; background: #FFFFFF; font-size: 22rpx; font-weight: 600; }
.badge-out { color: $edu-text-hint; }
.goods-badge-text { font-size: 22rpx; font-weight: 600; }
.goods-name { display: block; font-size: 30rpx; font-weight: 600; color: $edu-text-primary; height: 84rpx; line-height: 42rpx; overflow: hidden; }
.goods-price-row { display: flex; align-items: baseline; margin-bottom: 20rpx }
.goods-cost { font-size: 32rpx; font-weight: 800; color: $edu-primary; }
.goods-cost::after { }
.goods-ref { font-size: 24rpx; color: $edu-text-hint; margin-left: 12rpx; }
.goods-btn { height: 72rpx; border-radius: 36rpx; display: flex; align-items: center; justify-content: center; background-color: $edu-primary-container; }
.goods-btn-text { font-size: 28rpx; font-weight: 600; color: $edu-primary; }
.goods-btn-off { background-color: $edu-surface-variant; }
.goods-btn-off .goods-btn-text { color: $edu-text-hint; }

/* ===== 空态 ===== */
.empty-wrap { display: flex; flex-direction: column; align-items: center; padding: 120rpx 0; }
.empty-emoji { font-size: 96rpx; }
.empty-text { font-size: 28rpx; color: $edu-text-hint; margin-top: 24rpx; }
</style>
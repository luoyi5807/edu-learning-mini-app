<template>
  <view class="category-page" :class="themeClass">
    <view class="nav-bar" :style="{ paddingTop: statusBarHeight + 'px' }">
      <view class="nav-bar-inner" :style="{ height: navContentHeight + 'px' }">
        <view class="nav-back" @tap="goBack"><text class="back-icon">←</text></view>
        <text class="nav-title">全部分类</text>
      </view>
    </view>
    <view class="nav-placeholder" :style="{ height: navTotalHeight + 'px' }"></view>

    <LoadingState v-if="loading" text="加载中…" />
    <ErrorState v-else-if="error" :message="error" @retry="load" />
    <EmptyState v-else-if="categories.length === 0" text="暂无分类" />
    <view v-else class="cat-grid">
      <view
          v-for="item in categories"
          :key="item.categoryId"
          class="cat-card"
          @tap="openCategory(item)"
      >
        <text class="cat-name">{{ item.categoryName }}</text>
        <text class="cat-enter">查看课程 ›</text>
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { onLoad } from '@dcloudio/uni-app'
import LoadingState from '@/components/LoadingState.vue'
import ErrorState from '@/components/ErrorState.vue'
import EmptyState from '@/components/EmptyState.vue'
import { getCourseCategoryListApi, type CategoryNode } from '@/api/category'
import { useTheme } from '@/composables/useTheme'

const { themeClass } = useTheme()

const statusBarHeight = ref<number>(0)
const navContentHeight = ref<number>(44)
const sysInfo = uni.getSystemInfoSync()
statusBarHeight.value = sysInfo.statusBarHeight || 0
// #ifdef MP-WEIXIN
const menuButton = uni.getMenuButtonBoundingClientRect()
if (menuButton) { navContentHeight.value = (menuButton.top - statusBarHeight.value) * 2 + menuButton.height }
// #endif
const navTotalHeight = computed<number>(() => statusBarHeight.value + navContentHeight.value)

const categories = ref<CategoryNode[]>([])
const loading = ref<boolean>(true)
const error = ref<string>('')

async function load() {
  loading.value = true
  error.value = ''
  try {
    categories.value = await getCourseCategoryListApi()
  } catch (e: any) {
    error.value = (e && (e.msg || e.message)) || '分类加载失败'
  } finally {
    loading.value = false
  }
}

function openCategory(item: CategoryNode) {
  uni.navigateTo({ url: `/pages-sub/search/search?type=2&categoryId=${item.categoryId}` })
}
function goBack() {
  const pages = getCurrentPages()
  if (pages.length > 1) uni.navigateBack()
  else uni.reLaunch({ url: '/pages/index/index' })
}

onLoad(load)
</script>

<style lang="scss" scoped>
.category-page { min-height: 100vh; box-sizing: border-box; padding: 0 32rpx 60rpx; @include eduPageGradientStrong; }
.nav-bar { position: fixed; top: 0; left: 0; right: 0; z-index: 99; background: var(--edu-surface); }
.nav-bar-inner { display: flex; align-items: center; padding-left: 8rpx; }
.nav-back { width: 72rpx; height: 72rpx; display: flex; align-items: center; justify-content: center; }
.back-icon { font-size: 44rpx; color: $edu-text-primary; }
.nav-title { font-size: 34rpx; font-weight: 700; color: $edu-text-primary; margin-left: 8rpx; }
.cat-grid { display: flex; flex-wrap: wrap; margin-top: 24rpx; }
.cat-card { width: calc(50% - 12rpx); box-sizing: border-box; margin-bottom: 24rpx; border-radius: 24rpx; padding: 36rpx 28rpx; display: flex; flex-direction: column; justify-content: center; @include eduSurfaceWash; }
.cat-card:nth-child(odd) { margin-right: 24rpx; }
.cat-name { font-size: 32rpx; font-weight: 700; color: $edu-text-primary; }
.cat-enter { font-size: 24rpx; color: $edu-primary; margin-top: 12rpx; }
</style>
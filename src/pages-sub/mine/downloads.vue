<template>
  <view class="downloads-page">
    <view class="nav-bar" :class="{ 'nav-bar-opaque': navBarOpaque }" :style="{ paddingTop: statusBarHeight + 'px' }">
      <view class="nav-bar-inner" :style="{ height: navContentHeight + 'px' }">
        <view class="nav-back" @tap="goBack"><text class="back-icon">←</text></view>
        <text class="nav-title">我的下载</text>
      </view>
    </view>
    <view class="nav-placeholder" :style="{ height: (statusBarHeight + navContentHeight) + 'px' }"></view>

    <view class="filter-tabs">
      <view
          v-for="tab in filterTabs"
          :key="tab.value"
          class="filter-pill"
          :class="{ 'filter-pill-active': activeFilter === tab.value }"
          @tap="handleFilter(tab.value)"
      >
        <text class="filter-pill-text">{{ tab.label }}</text>
      </view>
    </view>

    <LoadingState v-if="state === 'loading'" text="正在加载下载记录…" />
    <ErrorState v-else-if="state === 'error'" text="加载失败" @retry="loadList" />
    <EmptyState v-else-if="list.length === 0" text="还没有下载内容" />
    <view class="dl-list" v-else>
      <view
          v-for="item in list"
          :key="item.recordId"
          class="dl-item"
          @tap="handleTap(item)"
          @longpress="handleDelete(item)"
      >
        <view class="dl-cover-wrap">
          <view class="dl-cover" :class="item.resourceType === 1 ? 'dl-cover-doc' : 'dl-cover-video'">
            <text class="dl-cover-icon">{{ item.resourceType === 1 ? '📄' : '▶' }}</text>
          </view>
        </view>
        <view class="dl-info">
          <text class="dl-title">{{ item.title }}</text>
          <text class="dl-meta">{{ item.sizeText }} · {{ item.downloadTime }}</text>
          <text class="dl-hint" v-if="item.resourceType === 2 && item.progressSeconds">离线可播 · 已缓存进度</text>
        </view>
        <text class="dl-del" @tap.stop="handleDelete(item)">🗑</text>
      </view>
    </view>

    <text class="tip" v-if="list.length > 0">长按条目也可删除</text>
  </view>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { onLoad, onPageScroll } from '@dcloudio/uni-app'
import LoadingState from '@/components/LoadingState.vue'
import ErrorState from '@/components/ErrorState.vue'
import EmptyState from '@/components/EmptyState.vue'
import { getDownloadRecordsApi, removeDownloadRecordApi, type DownloadRecordDto } from '@/api/user'

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

const navBarOpaque = ref<boolean>(false)
onPageScroll((e) => { navBarOpaque.value = e.scrollTop > 40 })

interface FilterTab { label: string; value: number }
const filterTabs: FilterTab[] = [
  { label: '全部', value: 0 },
  { label: '视频', value: 2 },
  { label: '文章', value: 1 }
]
const activeFilter = ref<number>(0)

const list = ref<DownloadRecordDto[]>([])
const state = ref<'loading' | 'error' | 'ready'>('loading')

async function loadList() {
  state.value = 'loading'
  try {
    const res = await getDownloadRecordsApi(activeFilter.value || undefined)
    list.value = res || []
    state.value = 'ready'
  } catch (e) {
    state.value = 'error'
  }
}

function handleFilter(v: number) {
  activeFilter.value = v
  loadList()
}

function handleTap(item: DownloadRecordDto) {
  if (item.resourceType === 1) {
    uni.showToast({ title: `文章详情开发中：${item.title}`, icon: 'none' })
  } else {
    uni.showToast({ title: `离线播放开发中：${item.title}`, icon: 'none' })
  }
}

function handleDelete(item: DownloadRecordDto) {
  uni.showModal({
    title: '删除下载',
    content: `确定删除《${item.title}》的下载记录吗？`,
    confirmColor: '#D04030',
    success: async (r) => {
      if (!r.confirm) return
      await removeDownloadRecordApi(item.recordId)
      await loadList()
      uni.showToast({ title: '已删除', icon: 'none' })
    }
  })
}

function goBack() {
  const pages = getCurrentPages()
  if (pages.length > 1) uni.navigateBack()
  else uni.reLaunch({ url: '/pages/index/index' })
}

onLoad(() => { loadList() })
</script>

<style lang="scss" scoped>
.downloads-page {
  min-height: 100vh; box-sizing: border-box; padding: 0 32rpx 60rpx;
  @include eduPageGradientStrong;
}
.nav-bar {
  position: fixed; top: 0; left: 0; right: 0; z-index: 99; background: transparent;
  transition: background-color 0.3s ease, box-shadow 0.3s ease;
}
.nav-bar-opaque { background: #FFFFFF; box-shadow: 0 2rpx 12rpx rgba(0, 0, 0, 0.06); }
.nav-bar-inner { display: flex; align-items: center; padding-left: 16rpx; }
.nav-back { width: 72rpx; height: 72rpx; display: flex; align-items: center; justify-content: center; }
.back-icon { font-size: 44rpx; color: $edu-text-primary; }
.nav-title { font-size: 40rpx; font-weight: 700; color: $edu-text-primary; margin-left: 8rpx; }

.filter-tabs { display: flex; align-items: center; margin-top: 24rpx; }
.filter-pill {
  display: flex; align-items: center; justify-content: center;
  height: 72rpx; padding: 0 44rpx; border-radius: 36rpx; margin-right: 20rpx;
  @include eduSurfaceWash; box-shadow: 0 4rpx 12rpx rgba(0, 0, 0, 0.03);
}
.filter-pill-active { background: $edu-primary; .filter-pill-text { color: #FFFFFF; font-weight: 600; } }
.filter-pill-text { font-size: 28rpx; color: $edu-text-secondary; }

.dl-list { margin-top: 24rpx; }
.dl-item {
  position: relative; display: flex; align-items: center; padding: 24rpx;
  margin-bottom: 20rpx; border-radius: 24rpx; background-color: $edu-surface;
  box-shadow: 0 4rpx 16rpx rgba(0, 0, 0, 0.03);
}
.dl-cover-wrap { width: 120rpx; height: 120rpx; flex-shrink: 0; margin-right: 24rpx; }
.dl-cover {
  width: 120rpx; height: 120rpx; border-radius: 16rpx;
  display: flex; align-items: center; justify-content: center;
}
.dl-cover-video { background: linear-gradient(135deg, #DCF2F5 0%, #00B0C0 100%); }
.dl-cover-doc { background: linear-gradient(135deg, #DCE8FF 0%, #5B8DEF 100%); }
.dl-cover-icon { font-size: 44rpx; color: #FFFFFF; }
.dl-info { flex: 1; display: flex; flex-direction: column; }
.dl-title {
  font-size: 30rpx; font-weight: 600; color: $edu-text-primary; line-height: 1.4; margin-bottom: 12rpx;
  display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;
}
.dl-meta { font-size: 24rpx; color: $edu-text-hint; }
.dl-hint { font-size: 24rpx; color: $edu-accent-teal; margin-top: 8rpx; }
.dl-del { font-size: 36rpx; color: $edu-text-hint; padding: 16rpx 8rpx; }
.tip { display: block; text-align: center; font-size: 24rpx; color: $edu-text-hint; margin-top: 20rpx; }
</style>
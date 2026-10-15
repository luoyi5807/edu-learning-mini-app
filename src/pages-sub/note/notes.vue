<template>
  <view class="notes-page">
    <!-- 固定顶部栏：返回 + 标题 -->
    <view class="nav-bar" :class="{ 'nav-bar-opaque': navBarOpaque }" :style="{ paddingTop: statusBarHeight + 'px' }">
      <view class="nav-bar-inner" :style="{ height: navContentHeight + 'px' }">
        <view class="nav-back" @tap="goBack">
          <text class="back-icon">←</text>
        </view>
        <text class="nav-title">笔记本</text>
      </view>
    </view>
    <view class="nav-placeholder" :style="{ height: (statusBarHeight + navContentHeight) + 'px' }"></view>

    <!-- 搜索框 -->
    <view class="search-box">
      <input
          class="search-input"
          v-model="keyword"
          placeholder="搜索笔记"
          placeholder-class="search-ph"
          confirm-type="search"
      />
    </view>

    <!-- 筛选：全部 / 文章笔记 / 视频笔记 -->
    <view class="filter-tabs">
      <view
          v-for="tab in filterTabs"
          :key="tab.value"
          class="filter-pill"
          :class="{ 'filter-pill-active': activeFilter === tab.value }"
          @tap="activeFilter = tab.value"
      >
        <text class="filter-pill-text">{{ tab.label }}</text>
      </view>
    </view>

    <!-- 两列瀑布流 -->
    <view class="masonry" v-if="filteredNotes.length > 0">
      <view class="masonry-col">
        <view class="note-card" v-for="n in leftList" :key="n.noteId" @tap="openNote(n)">
          <text class="note-title">{{ n.title }}</text>
          <text class="note-summary">{{ n.summary }}</text>
          <view class="note-foot">
            <text class="note-tag">{{ n.sourceType === 1 ? '文章' : '视频' }}</text>
            <text class="note-time">{{ n.createTime }}</text>
          </view>
          <text class="note-progress" v-if="n.sourceType === 2 && n.videoTimestamp">进度 {{ n.videoTimestamp }}</text>
        </view>
      </view>
      <view class="masonry-col">
        <view class="note-card" v-for="n in rightList" :key="n.noteId" @tap="openNote(n)">
          <text class="note-title">{{ n.title }}</text>
          <text class="note-summary">{{ n.summary }}</text>
          <view class="note-foot">
            <text class="note-tag">{{ n.sourceType === 1 ? '文章' : '视频' }}</text>
            <text class="note-time">{{ n.createTime }}</text>
          </view>
          <text class="note-progress" v-if="n.sourceType === 2 && n.videoTimestamp">进度 {{ n.videoTimestamp }}</text>
        </view>
      </view>
    </view>

    <!-- 空态 -->
    <EmptyState v-else text="还没有笔记，去记录第一篇吧" />
  </view>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { onLoad, onShow, onPageScroll } from '@dcloudio/uni-app'
import EmptyState from '@/components/EmptyState.vue'
import { getNotesApi, type NoteDto } from '@/api/notes'

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

/* ===== 搜索 + 筛选 ===== */
const keyword = ref<string>('')
interface FilterTab { label: string; value: number }
const filterTabs: FilterTab[] = [
  { label: '全部', value: 0 },
  { label: '文章笔记', value: 1 },
  { label: '视频笔记', value: 2 }
]
const activeFilter = ref<number>(0)

/* ===== 笔记数据：GET notes（api/notes.ts，详情页记笔记后自动同步） ===== */
const notes = ref<NoteDto[]>([])

async function loadNotes() {
  notes.value = (await getNotesApi()) || []
}

const filteredNotes = computed<NoteDto[]>(() => {
  const kw = keyword.value.trim()
  return notes.value.filter((n) => {
    if (activeFilter.value !== 0 && n.sourceType !== activeFilter.value) return false
    if (kw && !(n.title.includes(kw) || (n.summary || '').includes(kw))) return false
    return true
  })
})

// 奇偶分列，还原两列错落瀑布流
const leftList = computed<NoteDto[]>(() => filteredNotes.value.filter((_, i) => i % 2 === 0))
const rightList = computed<NoteDto[]>(() => filteredNotes.value.filter((_, i) => i % 2 === 1))

/* ===== 交互 ===== */
function goBack() {
  const pages = getCurrentPages()
  if (pages.length > 1) uni.navigateBack()
  else uni.reLaunch({ url: '/pages/index/index' })
}

// 视频笔记 → 播放器对应进度；文章笔记 → 文章详情
function openNote(n: NoteDto) {
  if (n.sourceType === 2) {
    uni.showToast({ title: `跳播放器进度 ${n.videoTimestamp}（开发中）`, icon: 'none' })
  } else {
    uni.navigateTo({ url: `/pages-sub/article/detail?articleId=${n.sourceId}` })
  }
}

onLoad(() => {
})
onShow(() => { loadNotes() })
</script>

<style lang="scss" scoped>
.notes-page {
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

/* ===== 搜索框 ===== */
.search-box {
  margin-top: 24rpx;
  height: 96rpx;
  border-radius: 24rpx;
  border: 2rpx solid $edu-outline;
  background-color: $edu-surface;
  display: flex;
  align-items: center;
  padding: 0 28rpx;
}
.search-input { flex: 1; font-size: 30rpx; color: $edu-text-primary; }
.search-ph { color: $edu-text-hint; font-size: 30rpx; }

/* ===== 筛选胶囊 ===== */
.filter-tabs { display: flex; align-items: center; margin-top: 28rpx; }
.filter-pill {
  display: flex; align-items: center; justify-content: center;
  height: 72rpx; padding: 0 40rpx; border-radius: 36rpx; margin-right: 20rpx;
  @include eduSurfaceWash;
  box-shadow: 0 4rpx 12rpx rgba(0, 0, 0, 0.03);
}
.filter-pill-active {
  background: $edu-primary;
  .filter-pill-text { color: #FFFFFF; font-weight: 600; }
}
.filter-pill-text { font-size: 28rpx; color: $edu-text-secondary; }

/* ===== 两列瀑布流 ===== */
.masonry { display: flex; align-items: flex-start; margin-top: 28rpx; }
.masonry-col { flex: 1; display: flex; flex-direction: column; }
.masonry-col:first-child { margin-right: 20rpx; }
.note-card {
  background-color: $edu-surface;
  border-radius: 24rpx;
  padding: 28rpx;
  margin-bottom: 20rpx;
  box-shadow: 0 8rpx 24rpx rgba(0, 0, 0, 0.04);
}
.note-title {
  display: block;
  font-size: 32rpx;
  font-weight: 700;
  color: $edu-text-primary;
  line-height: 1.35;
  margin-bottom: 16rpx;
}
.note-summary {
  display: -webkit-box;
  -webkit-line-clamp: 3;
  -webkit-box-orient: vertical;
  overflow: hidden;
  white-space: pre-line;
  font-size: 26rpx;
  color: $edu-text-secondary;
  line-height: 1.5;
  margin-bottom: 20rpx;
}
.note-foot { display: flex; align-items: center; }
.note-tag { font-size: 26rpx; color: $edu-primary; font-weight: 500; margin-right: 16rpx; flex-shrink: 0; }
.note-time { font-size: 24rpx; color: $edu-text-hint; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
.note-progress { display: block; font-size: 24rpx; color: $edu-text-hint; margin-top: 12rpx; }

/* ===== 空态 ===== */
.empty { padding: 160rpx 0; display: flex; justify-content: center; }
.empty-text { font-size: 28rpx; color: $edu-text-hint; }
</style>

<template>
  <view class="courses-page">
    <!-- 固定顶部栏 -->
    <view class="nav-bar" :class="{ 'nav-bar-opaque': navBarOpaque }" :style="{ paddingTop: statusBarHeight + 'px' }">
      <view class="nav-bar-inner" :style="{ height: navContentHeight + 'px' }">
        <view class="nav-back" @tap="goBack"><text class="back-icon">←</text></view>
        <text class="nav-title">我的课程</text>
      </view>
    </view>
    <view class="nav-placeholder" :style="{ height: (statusBarHeight + navContentHeight) + 'px' }"></view>

    <!-- 搜索框 -->
    <view class="search-box">
      <input
          class="search-input"
          v-model="keyword"
          placeholder="搜索已加入的课程"
          placeholder-class="search-ph"
          confirm-type="search"
          @confirm="loadCourses"
      />
      <text class="search-btn" @tap="loadCourses">搜索</text>
    </view>

    <LoadingState v-if="state === 'loading'" text="正在加载课程…" />
    <ErrorState v-else-if="state === 'error'" text="课程加载失败" @retry="loadCourses" />
    <EmptyState v-else-if="list.length === 0" text="还没有加入课程" action-text="去首页看看" @action="goHome" />
    <view class="course-list" v-else>
      <view v-for="c in list" :key="c.courseId" class="course-card" @tap="handleTap(c)">
        <view class="cover-wrap">
          <image v-if="resolveFileUrl(c.coverUrl)" class="cover" :src="resolveFileUrl(c.coverUrl)" mode="aspectFill" />
          <view v-else class="cover cover-ph"></view>
        </view>
        <view class="info">
          <text class="title">{{ c.title }}</text>
          <text class="meta">{{ c.instructorName }} · 共 {{ c.totalLessons }} 节</text>
          <view class="progress-row">
            <view class="progress-track"><view class="progress-bar" :style="{ width: c.studyProgress + '%' }"></view></view>
            <text class="progress-pct">{{ c.studyProgress }}%</text>
          </view>
          <text class="last-time">最近学习：{{ c.lastStudyTime }}</text>
        </view>
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { onLoad, onPageScroll } from '@dcloudio/uni-app'
import LoadingState from '@/components/LoadingState.vue'
import ErrorState from '@/components/ErrorState.vue'
import EmptyState from '@/components/EmptyState.vue'
import { getMyCoursesApi, resolveFileUrl, type MyCourseDto } from '@/api/user'

/* ===== 顶部栏高度 ===== */
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

/* ===== 数据 ===== */
const keyword = ref<string>('')
const list = ref<MyCourseDto[]>([])
const state = ref<'loading' | 'error' | 'ready'>('loading')

async function loadCourses() {
  state.value = 'loading'
  try {
    const res = await getMyCoursesApi(keyword.value)
    list.value = res || []
    state.value = 'ready'
  } catch (e) {
    state.value = 'error'
  }
}

function handleTap(c: MyCourseDto) {
  uni.navigateTo({ url: `/pages-sub/course/detail?courseId=${c.courseId}` })
}

function goHome() { uni.reLaunch({ url: '/pages/index/index' }) }
function goBack() {
  const pages = getCurrentPages()
  if (pages.length > 1) uni.navigateBack()
  else uni.reLaunch({ url: '/pages/index/index' })
}

onLoad(() => { loadCourses() })
</script>

<style lang="scss" scoped>
.courses-page {
  min-height: 100vh;
  box-sizing: border-box;
  padding: 0 32rpx 60rpx;
  @include eduPageGradientStrong;
}
.nav-bar {
  position: fixed; top: 0; left: 0; right: 0; z-index: 99;
  background: transparent;
  transition: background-color 0.3s ease, box-shadow 0.3s ease;
}
.nav-bar-opaque { background: #FFFFFF; box-shadow: 0 2rpx 12rpx rgba(0, 0, 0, 0.06); }
.nav-bar-inner { display: flex; align-items: center; padding-left: 16rpx; }
.nav-back { width: 72rpx; height: 72rpx; display: flex; align-items: center; justify-content: center; }
.back-icon { font-size: 44rpx; color: $edu-text-primary; }
.nav-title { font-size: 40rpx; font-weight: 700; color: $edu-text-primary; margin-left: 8rpx; }

.search-box {
  margin-top: 24rpx; height: 96rpx; border-radius: 24rpx;
  border: 2rpx solid $edu-outline; background-color: $edu-surface;
  display: flex; align-items: center; padding: 0 20rpx 0 28rpx;
}
.search-input { flex: 1; font-size: 30rpx; color: $edu-text-primary; }
.search-ph { color: $edu-text-hint; font-size: 30rpx; }
.search-btn { font-size: 30rpx; color: $edu-primary; font-weight: 500; padding: 12rpx 16rpx; }

.course-list { margin-top: 24rpx; }
.course-card {
  display: flex; align-items: flex-start; padding: 28rpx; margin-bottom: 24rpx;
  border-radius: 28rpx; background-color: $edu-surface;
  box-shadow: 0 8rpx 24rpx rgba(0, 0, 0, 0.04);
}
.cover-wrap { width: 200rpx; height: 140rpx; flex-shrink: 0; margin-right: 24rpx; }
.cover { width: 200rpx; height: 140rpx; border-radius: 16rpx; }
.cover-ph { background: linear-gradient(135deg, #DCE8FF 0%, #5B8DEF 100%); }
.info { flex: 1; display: flex; flex-direction: column; }
.title {
  font-size: 32rpx; font-weight: 600; color: $edu-text-primary; line-height: 1.4; margin-bottom: 12rpx;
  display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;
}
.meta { font-size: 26rpx; color: $edu-text-secondary; margin-bottom: 16rpx; }
.progress-row { display: flex; align-items: center; margin-bottom: 12rpx; }
.progress-track { flex: 1; height: 10rpx; border-radius: 5rpx; background-color: $edu-surface-variant; overflow: hidden; margin-right: 16rpx; }
.progress-bar { height: 100%; background: $edu-primary; border-radius: 5rpx; }
.progress-pct { font-size: 24rpx; color: $edu-primary; font-weight: 600; }
.last-time { font-size: 24rpx; color: $edu-text-hint; }
</style>
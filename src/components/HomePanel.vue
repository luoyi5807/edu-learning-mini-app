<template>
  <view class="home-panel">
    <view class="top-bar">
      <view class="menu-btn" @tap="handleMenu">
        <text class="menu-icon">☰</text>
      </view>
      <view class="search-box" @tap="goSearch">
        <text class="search-placeholder-text">您想学习什么？</text>
        <text class="search-icon">🔍</text>
      </view>
      <view class="bell-btn" @tap="handleNotification">
        <text class="bell-icon">🔔</text>
        <view class="bell-dot" v-if="hasUnread"></view>
      </view>
    </view>

    <scroll-view class="category-tabs" scroll-x :show-scrollbar="false">
      <view class="tabs-inner">
        <view
            v-for="item in categories"
            :key="item.categoryId"
            class="tab-pill"
            :class="{ 'tab-pill-active': activeCategoryId === item.categoryId }"
            @tap="activeCategoryId = item.categoryId"
        >
          <text class="tab-pill-text">{{ item.categoryName }}</text>
        </view>
      </view>
    </scroll-view>

    <view class="section-header">
      <text class="section-title">课程分类</text>
      <text class="section-more" @tap="handleViewAll">查看全部</text>
    </view>

    <view class="carousel-wrap">
      <swiper
          class="course-swiper"
          :current="swiperIndex"
          :autoplay="swiperAutoplay && bannerCourses.length > 1"
          :interval="4000"
          :duration="500"
          :circular="bannerCourses.length > 1"
          next-margin="42rpx"
          @change="onSwiperChange"
          @touchstart="onSwiperTouchStart"
      >
        <swiper-item v-for="course in bannerCourses" :key="course.courseId">
          <view class="banner-card" @tap="handleCourseTap(course)">
            <image v-if="course.coverUrl" class="banner-cover" :src="course.coverUrl" mode="aspectFill" />
            <view v-else class="banner-cover banner-cover-placeholder"></view>
            <view class="banner-info">
              <text class="banner-title">{{ course.title }}</text>
              <text class="banner-sub">{{ course.instructorName }} · {{ formatCount(course.studentCount) }} 人在学</text>
            </view>
          </view>
        </swiper-item>
      </swiper>
      <view class="custom-indicator" v-if="bannerCourses.length > 1">
        <view
            v-for="(_, i) in bannerCourses"
            :key="i"
            :class="['indicator-dot', i === swiperIndex ? 'indicator-dot-active' : '']"
        ></view>
      </view>
    </view>

    <view class="section-header">
      <text class="section-title">热门课程</text>
    </view>
    <view class="hot-card-container">
      <view v-for="course in top2HotCourses" :key="course.courseId" class="hot-item" @tap="handleCourseTap(course)">
        <view class="hot-cover-wrap">
          <image v-if="course.coverUrl" class="hot-cover" :src="course.coverUrl" mode="aspectFill" />
          <view v-else class="hot-cover hot-cover-placeholder"></view>
          <view class="hot-play-badge"><text class="play-icon">▶</text></view>
        </view>
        <view class="hot-meta">
          <text class="hot-title">{{ course.title }}</text>
          <text class="hot-count">{{ course.studentCount > 0 ? formatCount(course.studentCount) + '人正在学' : '新上线' }}</text>
        </view>
      </view>
    </view>

    <block v-if="rankCourses.length > 0">
      <view class="section-header">
        <text class="section-title">本周课程热度排行</text>
      </view>
      <view class="rank-container">
        <view v-for="course in rankCourses" :key="course.courseId" class="rank-item" @tap="handleCourseTap(course)">
          <view class="rank-cover-wrap">
            <image v-if="course.coverUrl" class="rank-cover" :src="course.coverUrl" mode="aspectFill" />
            <view v-else class="rank-cover rank-cover-placeholder"></view>
          </view>
          <view class="rank-meta">
            <text class="rank-title">{{ course.title }}</text>
            <text class="rank-instructor">讲师：{{ course.instructorName }}</text>
          </view>
        </view>
      </view>
    </block>

    <view class="section-header">
      <text class="section-title">为你推荐</text>
    </view>
    <view class="recommend-empty">
      <text class="recommend-empty-text">推荐内容即将上线</text>
    </view>

    <view class="load-more" v-if="hasMore" @tap="handleLoadMore">
      <text class="load-more-text">{{ loadingMore ? '加载中...' : '上拉加载更多' }}</text>
    </view>
    <view class="load-more load-more-end" v-else>
      <text class="load-more-text">没有更多了</text>
    </view>
  </view>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import type { Course, CourseCategory } from '@/types/course'
import { useNotification } from '@/composables/useNotification'

const { hasUnread } = useNotification()

const categories = ref<CourseCategory[]>([
  { categoryId: 0, categoryName: '全部' },
  { categoryId: 1, categoryName: '艺术' },
  { categoryId: 2, categoryName: '商业' },
  { categoryId: 3, categoryName: 'IT 解决方案' }
])

const courses = ref<Course[]>([
  { courseId: 1, title: 'Machine Learning 从入门到实战', coverUrl: '', instructorName: '张老师', studentCount: 1200, categoryId: 3, categoryName: 'IT 解决方案', videoType: 2, isFree: 1 },
  { courseId: 2, title: 'Data Science 数据分析实战', coverUrl: '', instructorName: '李老师', studentCount: 960, categoryId: 3, categoryName: 'IT 解决方案', videoType: 2, isFree: 0 },
  { courseId: 3, title: 'UI 设计从零基础到精通', coverUrl: '', instructorName: '王老师', studentCount: 680, categoryId: 1, categoryName: '艺术', videoType: 2, isFree: 1 },
  { courseId: 4, title: '创业融资与商业计划书', coverUrl: '', instructorName: '陈老师', studentCount: 450, categoryId: 2, categoryName: '商业', videoType: 2, isFree: 0 },
  { courseId: 5, title: 'Python 编程基础入门', coverUrl: '', instructorName: '刘老师', studentCount: 1500, categoryId: 3, categoryName: 'IT 解决方案', videoType: 1, isFree: 1 },
  { courseId: 6, title: '品牌视觉与平面设计实务', coverUrl: '', instructorName: '赵老师', studentCount: 0, categoryId: 1, categoryName: '艺术', videoType: 2, isFree: 1 }
])

const activeCategoryId = ref<number>(0)
const swiperIndex = ref<number>(0)
const swiperAutoplay = ref<boolean>(true)
const hasMore = ref<boolean>(false)
const loadingMore = ref<boolean>(false)
let resumeTimer: ReturnType<typeof setTimeout> | null = null

const filteredCourses = computed<Course[]>(() => {
  if (activeCategoryId.value === 0) return courses.value
  return courses.value.filter((c) => c.categoryId === activeCategoryId.value)
})
const bannerCourses = computed<Course[]>(() => filteredCourses.value)
const sortedByHot = computed<Course[]>(() => [...filteredCourses.value].sort((a, b) => b.studentCount - a.studentCount))
const top2HotCourses = computed<Course[]>(() => sortedByHot.value.slice(0, 2))
const rankCourses = computed<Course[]>(() => sortedByHot.value.slice(2, 5))

function formatCount(n: number): string {
  if (n >= 10000) return (n / 10000).toFixed(1) + '万'
  return String(n)
}
function onSwiperChange(e: any) { swiperIndex.value = e.detail.current }
function onSwiperTouchStart() {
  if (bannerCourses.value.length <= 1) return
  swiperAutoplay.value = false
  if (resumeTimer) clearTimeout(resumeTimer)
  resumeTimer = setTimeout(() => { swiperAutoplay.value = true }, 8000)
}
function goSearch() { uni.navigateTo({ url: '/pages-sub/search/search?type=2' }) }
function handleMenu() { uni.showToast({ title: '侧边栏开发中', icon: 'none' }) }
function handleNotification() { uni.navigateTo({ url: '/pages-sub/notification/notification' }) }
function handleViewAll() { uni.showToast({ title: '全部分类开发中', icon: 'none' }) }
function handleCourseTap(course: Course) { uni.navigateTo({ url: `/pages-sub/course/detail?courseId=${course.courseId}` }) }
function handleLoadMore() { if (!loadingMore.value) uni.showToast({ title: '加载更多（接口待接入）', icon: 'none' }) }
</script>

<style lang="scss" scoped>
.home-panel {
  padding: 0 32rpx calc(100rpx + env(safe-area-inset-bottom));
  @include eduPageGradientWeak;
}
.top-bar { display: flex; align-items: center; padding: 16rpx 0; }
.menu-btn { width: 88rpx; height: 88rpx; display: flex; align-items: center; justify-content: center; flex-shrink: 0; }
.menu-icon { font-size: 40rpx; color: $edu-text-primary; }
.search-box { flex: 1; display: flex; align-items: center; height: 80rpx; border-radius: 40rpx; margin: 0 8rpx; padding: 0 24rpx; @include eduSurfaceWash; }
.search-placeholder-text { flex: 1; font-size: 28rpx; color: $edu-text-hint; }
.search-icon { font-size: 40rpx; color: $edu-primary; }
.bell-btn { position: relative; width: 88rpx; height: 88rpx; display: flex; align-items: center; justify-content: center; flex-shrink: 0; }
.bell-icon { font-size: 38rpx; }
.bell-dot { position: absolute; top: 20rpx; right: 22rpx; width: 16rpx; height: 16rpx; border-radius: 50%; background-color: $edu-accent-coral; }
.category-tabs { margin-top: 8rpx; white-space: nowrap; }
.tabs-inner { display: inline-flex; align-items: center; }
.tab-pill { flex-shrink: 0; display: flex; align-items: center; justify-content: center; height: 72rpx; padding: 0 40rpx; border-radius: 36rpx; margin-right: 16rpx; @include eduSurfaceWash; }
.tab-pill-active { @include eduSurfaceWashSelected; .tab-pill-text { color: $edu-primary; font-weight: 600; } }
.tab-pill-text { font-size: 28rpx; color: $edu-text-primary; }
.section-header { display: flex; align-items: center; justify-content: space-between; margin-top: 44rpx; margin-bottom: 24rpx; }
.section-title { font-size: 36rpx; font-weight: 700; color: $edu-text-primary; }
.section-more { font-size: 28rpx; color: $edu-primary; }
.carousel-wrap { position: relative; }
.course-swiper { height: 336rpx; }
.banner-card { position: relative; width: 100%; height: 336rpx; border-radius: 32rpx; overflow: hidden; margin-right: 20rpx; }
.banner-cover { width: 100%; height: 100%; }
.banner-cover-placeholder { background: linear-gradient(135deg, #DCE8FF 0%, #3677EF 100%); }
.banner-info { position: absolute; left: 0; right: 0; bottom: 0; padding: 28rpx 28rpx 16rpx 16rpx; background: rgba(0, 0, 0, 0.72); }
.banner-title { display: block; font-size: 30rpx; font-weight: 700; color: #FFFFFF; line-height: 1.2; margin-bottom: 4rpx; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
.banner-sub { display: block; font-size: 24rpx; color: rgba(255, 255, 255, 0.82); line-height: 1.2; }
.custom-indicator { position: absolute; left: 0; right: 42rpx; bottom: 92rpx; display: flex; align-items: center; justify-content: center; z-index: 5; pointer-events: none; }
.indicator-dot { width: 12rpx; height: 12rpx; border-radius: 50%; background: rgba(255, 255, 255, 0.45); margin: 0 6rpx; transition: all 0.2s; }
.indicator-dot-active { width: 32rpx; height: 8rpx; border-radius: 4rpx; background: #FFFFFF; }
.hot-card-container { border-radius: 28rpx; overflow: hidden; @include eduSurfaceWash; }
.hot-item { display: flex; align-items: center; padding: 20rpx 16rpx; }
.hot-cover-wrap { position: relative; width: 220rpx; height: 132rpx; flex-shrink: 0; margin-right: 24rpx; }
.hot-cover { width: 220rpx; height: 132rpx; border-radius: 16rpx; }
.hot-cover-placeholder { background: linear-gradient(135deg, #DCE8FF 0%, #5B8DEF 100%); }
.hot-play-badge { position: absolute; top: 8rpx; right: 8rpx; width: 32rpx; height: 32rpx; display: flex; align-items: center; justify-content: center; }
.play-icon { font-size: 22rpx; color: #FFFFFF; text-shadow: 0 2rpx 4rpx rgba(0, 0, 0, 0.4); }
.hot-meta { flex: 1; display: flex; flex-direction: column; justify-content: center; }
.hot-title { font-size: 30rpx; font-weight: 600; color: $edu-text-primary; margin-bottom: 8rpx; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
.hot-count { font-size: 26rpx; color: $edu-text-secondary; }
.rank-container { border-radius: 28rpx; overflow: hidden; @include eduSurfaceWash; }
.rank-item { position: relative; display: flex; align-items: flex-start; padding: 32rpx 20rpx; }
.rank-item:not(:last-child)::after { content: ''; position: absolute; left: 32rpx; right: 0; bottom: 0; height: 2rpx; background: $edu-divider; }
.rank-cover-wrap { width: 240rpx; height: 144rpx; flex-shrink: 0; margin-right: 24rpx; }
.rank-cover { width: 240rpx; height: 144rpx; border-radius: 20rpx; }
.rank-cover-placeholder { background: linear-gradient(135deg, #DCE8FF 0%, #5B8DEF 100%); }
.rank-meta { flex: 1; display: flex; flex-direction: column; padding-top: 4rpx; }
.rank-title { font-size: 30rpx; font-weight: 600; color: $edu-text-primary; line-height: 1.4; margin-bottom: 12rpx; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; }
.rank-instructor { font-size: 26rpx; color: $edu-text-secondary; }
.recommend-empty { padding: 60rpx 0; display: flex; justify-content: center; }
.recommend-empty-text { font-size: 26rpx; color: $edu-text-hint; }
.load-more { padding: 32rpx 0 24rpx; display: flex; justify-content: center; }
.load-more-text { font-size: 26rpx; color: $edu-primary; }
.load-more-end .load-more-text { color: $edu-text-hint; }
</style>
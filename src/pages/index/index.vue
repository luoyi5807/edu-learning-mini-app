<template>
  <view class="home-page">
    <!-- 顶部搜索栏 -->
    <view class="top-bar">
      <view class="menu-btn" @tap="handleMenu">
        <text class="menu-icon">☰</text>
      </view>
      <view class="search-box">
        <input
            class="search-input"
            v-model="keyword"
            placeholder="您想学习什么？"
            placeholder-class="search-placeholder"
            confirm-type="search"
            @confirm="handleSearch"
        />
        <text class="search-icon" @tap="handleSearch">🔍</text>
      </view>
      <view class="bell-btn" @tap="handleNotification">
        <text class="bell-icon">🔔</text>
      </view>
    </view>

    <!-- 分类标签 -->
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

    <!-- 课程分类轮播 -->
    <view class="section-header">
      <text class="section-title">课程分类</text>
      <text class="section-more" @tap="handleViewAll">查看全部</text>
    </view>
    <swiper
        class="course-swiper"
        :indicator-dots="true"
        :circular="true"
        indicator-color="rgba(255,255,255,0.5)"
        indicator-active-color="#FFFFFF"
        next-margin="80rpx"
    >
      <swiper-item v-for="course in bannerCourses" :key="course.courseId">
        <view class="banner-card" @tap="handleCourseTap(course)">
          <image v-if="course.coverUrl" class="banner-cover" :src="course.coverUrl" mode="aspectFill" />
          <view v-else class="banner-cover banner-cover-placeholder"></view>
          <view class="banner-info">
            <text class="banner-title">{{ course.title }}</text>
            <text class="banner-sub">{{ course.instructorName }} · {{ course.studentCount }} 人在学</text>
          </view>
        </view>
      </swiper-item>
    </swiper>

    <!-- 热门课程 -->
    <view class="section-header">
      <text class="section-title">热门课程</text>
    </view>
    <view class="course-list">
      <view v-for="course in hotCourses" :key="course.courseId" class="course-item" @tap="handleCourseTap(course)">
        <image v-if="course.coverUrl" class="course-thumb" :src="course.coverUrl" mode="aspectFill" />
        <view v-else class="course-thumb course-thumb-placeholder"></view>
        <view class="course-meta">
          <text class="course-title">{{ course.title }}</text>
          <text class="course-count">{{ course.studentCount }}人正在学</text>
        </view>
      </view>
    </view>

    <!-- 底部导航栏 -->
    <view class="tab-bar">
      <view
          v-for="tab in tabs"
          :key="tab.key"
          class="tab-item"
          @tap="handleTabChange(tab)"
      >
        <view
            class="tab-icon-wrap"
            :style="activeTab === tab.key ? { backgroundColor: tab.activeBg } : {}"
        >
          <text class="tab-icon" :style="activeTab === tab.key ? { color: tab.activeColor } : {}">{{ tab.icon }}</text>
        </view>
        <text class="tab-label" :style="activeTab === tab.key ? { color: tab.activeColor } : {}">{{ tab.label }}</text>
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import type { Course, CourseCategory } from '@/types/course'

const keyword = ref<string>('')
const activeTab = ref<string>('home')

/* ===== Mock 数据（字段对齐 course 表，待接入接口后替换） ===== */
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
  { courseId: 5, title: 'Python 编程基础入门', coverUrl: '', instructorName: '刘老师', studentCount: 1500, categoryId: 3, categoryName: 'IT 解决方案', videoType: 1, isFree: 1 }
])

const activeCategoryId = ref<number>(0)

const filteredCourses = computed<Course[]>(() => {
  if (activeCategoryId.value === 0) return courses.value
  return courses.value.filter((c) => c.categoryId === activeCategoryId.value)
})

const bannerCourses = computed<Course[]>(() => filteredCourses.value)

const hotCourses = computed<Course[]>(() =>
    [...filteredCourses.value].sort((a, b) => b.studentCount - a.studentCount)
)

/* ===== 底部导航（配色遵循方案四 Tab 选中态） ===== */
interface TabItem {
  key: string
  label: string
  icon: string
  activeColor: string
  activeBg: string
}

const tabs: TabItem[] = [
  { key: 'home', label: '首页', icon: '⌂', activeColor: '#282840', activeBg: '#E3E8FB' },
  { key: 'video', label: '视频', icon: '▶', activeColor: '#0E6E78', activeBg: '#D9F0F3' },
  { key: 'community', label: '社区', icon: '💬', activeColor: '#A8453C', activeBg: '#FBE4E0' },
  { key: 'profile', label: '个人主页', icon: '👤', activeColor: '#96650C', activeBg: '#FBEFD2' }
]

/* ===== 交互 ===== */
function handleSearch() {
  if (!keyword.value.trim()) {
    uni.showToast({ title: '请输入搜索内容', icon: 'none' })
    return
  }
  uni.showToast({ title: '搜索功能开发中', icon: 'none' })
}

function handleMenu() {
  uni.showToast({ title: '侧边栏开发中', icon: 'none' })
}

function handleNotification() {
  uni.showToast({ title: '消息通知开发中', icon: 'none' })
}

function handleViewAll() {
  uni.showToast({ title: '全部分类开发中', icon: 'none' })
}

function handleCourseTap(course: Course) {
  uni.showToast({ title: `课程详情开发中：${course.title}`, icon: 'none' })
}

function handleTabChange(tab: TabItem) {
  if (tab.key === 'home') return
  uni.showToast({ title: `${tab.label}模块开发中`, icon: 'none' })
}
</script>

<style lang="scss" scoped>
/* ===== 配色变量（浅色模式） ===== */
$color-primary: #3677EF;
$color-bg: #F7F9FC;
$color-card: #FFFFFF;
$color-text-primary: #1A1A1A;
$color-text-secondary: #666666;
$color-text-placeholder: #999999;
$color-divider: #EEEEEE;

.home-page {
  min-height: 100vh;
  background: linear-gradient(180deg, #FFFFFF 0%, #FFFBF2 25%, #F8F0ED 55%, #FDF5F5 80%, #F7F9FC 100%);
  padding: 0 32rpx calc(160rpx + env(safe-area-inset-bottom));
  box-sizing: border-box;
}

/* ===== 顶部搜索栏 ===== */
.top-bar {
  display: flex;
  align-items: center;
  padding-top: 32rpx;
}

.menu-btn {
  width: 64rpx;
  height: 64rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.menu-icon {
  font-size: 40rpx;
  color: $color-text-primary;
}

.search-box {
  flex: 1;
  display: flex;
  align-items: center;
  height: 80rpx;
  background-color: $color-card;
  border-radius: 40rpx;
  margin: 0 16rpx;
  padding: 0 28rpx;
  box-shadow: 0 4rpx 16rpx rgba(0, 0, 0, 0.04);
}

.search-input {
  flex: 1;
  font-size: 28rpx;
  color: $color-text-primary;
  background: transparent;
  border: none;
}

.search-placeholder {
  color: $color-text-placeholder;
  font-size: 28rpx;
}

.search-icon {
  font-size: 32rpx;
  color: $color-primary;
  margin-left: 8rpx;
}

.bell-btn {
  width: 64rpx;
  height: 64rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.bell-icon {
  font-size: 38rpx;
}

/* ===== 分类标签 ===== */
.category-tabs {
  margin-top: 28rpx;
  white-space: nowrap;
}

.tabs-inner {
  display: flex;
  align-items: center;
}

.tab-pill {
  flex-shrink: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  height: 72rpx;
  padding: 0 44rpx;
  background-color: $color-card;
  border: 2rpx solid $color-divider;
  border-radius: 36rpx;
  margin-right: 20rpx;
}

.tab-pill-active {
  border-color: $color-primary;

  .tab-pill-text {
    color: $color-primary;
    font-weight: 600;
  }
}

.tab-pill-text {
  font-size: 28rpx;
  color: $color-text-primary;
}

/* ===== 区块标题 ===== */
.section-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-top: 44rpx;
  margin-bottom: 24rpx;
}

.section-title {
  font-size: 36rpx;
  font-weight: 700;
  color: $color-text-primary;
}

.section-more {
  font-size: 28rpx;
  color: $color-primary;
}

/* ===== 课程轮播 ===== */
.course-swiper {
  height: 480rpx;
}

.banner-card {
  position: relative;
  width: calc(100vw - 64rpx - 80rpx);
  height: 440rpx;
  border-radius: 24rpx;
  overflow: hidden;
  margin-right: 24rpx;
}

.banner-cover {
  width: 100%;
  height: 100%;
}

.banner-cover-placeholder {
  background: linear-gradient(135deg, #DCE8FF 0%, #3677EF 100%);
}

.banner-info {
  position: absolute;
  left: 0;
  right: 0;
  bottom: 0;
  padding: 24rpx 28rpx;
  background: rgba(0, 0, 0, 0.55);
}

.banner-title {
  display: block;
  font-size: 32rpx;
  font-weight: 600;
  color: #FFFFFF;
  margin-bottom: 8rpx;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.banner-sub {
  display: block;
  font-size: 24rpx;
  color: rgba(255, 255, 255, 0.85);
}

/* ===== 热门课程列表 ===== */
.course-list {
  padding-bottom: 40rpx;
}

.course-item {
  display: flex;
  align-items: center;
  padding: 24rpx;
  background-color: rgba(255, 255, 255, 0.6);
  border-radius: 24rpx;
  margin-bottom: 20rpx;
}

.course-thumb {
  width: 200rpx;
  height: 140rpx;
  border-radius: 16rpx;
  flex-shrink: 0;
}

.course-thumb-placeholder {
  background: linear-gradient(135deg, #DCE8FF 0%, #5B8DEF 100%);
}

.course-meta {
  flex: 1;
  display: flex;
  flex-direction: column;
  justify-content: center;
  padding-left: 24rpx;
}

.course-title {
  font-size: 30rpx;
  font-weight: 600;
  color: $color-text-primary;
  margin-bottom: 12rpx;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.course-count {
  font-size: 26rpx;
  color: $color-text-secondary;
}

/* ===== 底部导航栏 ===== */
.tab-bar {
  position: fixed;
  left: 0;
  right: 0;
  bottom: 0;
  display: flex;
  align-items: center;
  justify-content: space-around;
  height: calc(110rpx + env(safe-area-inset-bottom));
  padding-bottom: env(safe-area-inset-bottom);
  background-color: $color-card;
  border-top: 2rpx solid $color-divider;
  z-index: 100;
}

.tab-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
}

.tab-icon-wrap {
  width: 88rpx;
  height: 56rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 28rpx;
  margin-bottom: 4rpx;
}

.tab-icon {
  font-size: 36rpx;
  color: $color-text-placeholder;
}

.tab-label {
  font-size: 22rpx;
  color: $color-text-placeholder;
}
</style>
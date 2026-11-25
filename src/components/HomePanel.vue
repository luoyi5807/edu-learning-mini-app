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
            @tap="selectCategory(item.categoryId)"
        >
          <text class="tab-pill-text">{{ item.categoryName }}</text>
        </view>
      </view>
    </scroll-view>

    <!-- 精选轮播：优先 Banner（真实轮播图），无 Banner 回退课程热度前 5 -->
    <view class="carousel-wrap" v-if="carouselItems.length > 0">
      <swiper
          class="course-swiper"
          :current="swiperIndex"
          :autoplay="swiperAutoplay && carouselItems.length > 1"
          :interval="4000"
          :duration="500"
          :circular="carouselItems.length > 1"
          next-margin="42rpx"
          @change="onSwiperChange"
          @touchstart="onSwiperTouchStart"
      >
        <swiper-item v-for="item in carouselItems" :key="item.key">
          <view class="banner-card" @tap="handleCourseTap(item.courseId)">
            <image v-if="coverSrc(item)" class="banner-cover" :src="coverSrc(item)" mode="aspectFill" @error="onCoverError(item.key)" />
            <view v-else class="banner-cover banner-cover-placeholder"></view>
            <view class="banner-info">
              <text class="banner-title">{{ item.title }}</text>
              <text class="banner-sub" v-if="item.sub">{{ item.sub }}</text>
            </view>
          </view>
        </swiper-item>
      </swiper>
      <view class="custom-indicator" v-if="carouselItems.length > 1">
        <view
            v-for="(_, i) in carouselItems"
            :key="i"
            :class="['indicator-dot', i === swiperIndex ? 'indicator-dot-active' : '']"
        ></view>
      </view>
    </view>

    <!-- 广告位：真实流量主 Banner 或演示占位（AdBanner 内部判断） -->
    <AdBanner :adpid="AD_PID_BANNER" :unit-id="AD_BANNER_HOME" scene="首页" />

    <!-- 排序标签：高分 / 热门 / 最新 -->
    <view class="sort-tabs">
      <text
          v-for="s in sorts"
          :key="s.key"
          class="sort-tab"
          :class="{ 'sort-tab-active': activeSort === s.key }"
          @tap="selectSort(s.key)"
      >{{ s.label }}</text>
    </view>

    <view v-if="loading" class="state-block"><text class="state-text">加载中…</text></view>
    <view v-else-if="error" class="state-block" @tap="retry"><text class="state-text state-text-error">{{ error }}，点击重试</text></view>
    <view v-else-if="courses.length === 0" class="state-block"><text class="state-text">该分类下暂无课程</text></view>

    <!-- 课程两列网格 -->
    <view class="course-grid" v-else>
      <view v-for="c in courses" :key="c.courseId" class="grid-card" @tap="handleCourseTap(c.courseId)">
        <view class="grid-cover-wrap">
          <image v-if="c.coverUrl" class="grid-cover" :src="c.coverUrl" mode="aspectFill" />
          <view v-else class="grid-cover grid-cover-placeholder"></view>
          <view class="grid-play-badge"><text class="play-icon">▶</text></view>
        </view>
        <view class="grid-body">
          <text class="grid-title">{{ c.title }}</text>
          <text class="grid-sub">{{ (c.averageScore || 0).toFixed(1) }}分 · {{ formatCount(c.viewCount || 0) }}人观看</text>
        </view>
      </view>
    </view>

    <view class="load-more" v-if="!loading && courses.length > 0 && hasMore" @tap="handleLoadMore">
      <text class="load-more-text">{{ loadingMore ? '加载中...' : '点击加载更多' }}</text>
    </view>
    <view class="load-more load-more-end" v-else-if="!loading && courses.length > 0">
      <text class="load-more-text">没有更多了</text>
    </view>
  </view>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import type { Course, CourseCategory } from '@/types/course'
import { getCourseListApi } from '@/api/course'
import { getBannerListApi, type Banner } from '@/api/banner'
import { getCourseCategoryListApi } from '@/api/category'
import { useNotification } from '@/composables/useNotification'
import AdBanner from '@/components/AdBanner.vue'
import { AD_BANNER_HOME } from '@/config/env'

const { hasUnread } = useNotification()

/** 轮播卡视图模型：优先用 Banner（真实轮播图），无 Banner 时回退课程热度榜前 5 */
interface CarouselItem { key: string; coverUrl: string; fallback: string; title: string; sub: string; courseId: number }

const categories = ref<CourseCategory[]>([{ categoryId: 0, categoryName: '全部' }])
const activeCategoryId = ref<number>(0)
const banners = ref<Banner[]>([])
const courses = ref<Course[]>([])

const sorts: { key: 'avgScore' | 'likeCount' | 'createTime'; label: string }[] = [
  { key: 'avgScore', label: '高分' },
  { key: 'likeCount', label: '热门' },
  { key: 'createTime', label: '最新' }
]
const activeSort = ref<'avgScore' | 'likeCount' | 'createTime'>('avgScore')

const loading = ref<boolean>(false)
const loadingMore = ref<boolean>(false)
const error = ref<string>('')
const total = ref<number>(0)
const pageNum = ref<number>(1)
const PAGE_SIZE = 20
const hasMore = computed<boolean>(() => courses.value.length < total.value)

const swiperIndex = ref<number>(0)
const swiperAutoplay = ref<boolean>(true)
let resumeTimer: ReturnType<typeof setTimeout> | null = null
/** 记录加载失败的轮播图 key，失败后改用课程封面兜底 */
const failedCovers = ref<Record<string, boolean>>({})

const carouselItems = computed<CarouselItem[]>(() => {
  if (banners.value.length > 0) {
    return banners.value.map((b) => ({
      key: 'banner-' + b.bannerId,
      coverUrl: b.imageUrl,
      fallback: courseCoverOf(b.courseId),
      title: b.title,
      sub: b.courseName || '',
      courseId: b.courseId
    }))
  }
  return courses.value.slice(0, 5).map((c) => ({
    key: 'course-' + c.courseId,
    coverUrl: c.coverUrl,
    fallback: '',
    title: c.title,
    sub: '',
    courseId: c.courseId
  }))
})

/** 实际展示的封面：未失败用 banner 图；banner 图加载失败则用课程封面兜底 */
function coverSrc(item: CarouselItem): string {
  if (failedCovers.value[item.key]) return item.fallback || ''
  return item.coverUrl || item.fallback || ''
}
function onCoverError(key: string) {
  if (failedCovers.value[key]) return
  failedCovers.value = { ...failedCovers.value, [key]: true }
}

/** Banner 没配图时，用其关联课程（当前分类已加载的课程列表）的封面兜底 */
function courseCoverOf(courseId: number): string {
  const hit = courses.value.find((c) => c.courseId === courseId)
  return hit ? hit.coverUrl : ''
}

async function loadCategories() {
  try {
    const list = await getCourseCategoryListApi()
    categories.value = [{ categoryId: 0, categoryName: '全部' }, ...list.map((c) => ({ categoryId: c.categoryId, categoryName: c.categoryName }))]
  } catch (e) {
    // 分类失败不阻塞首页，静默保留「全部」
  }
}

async function loadBanners() {
  try {
    banners.value = await getBannerListApi(activeCategoryId.value || undefined)
  } catch (e) {
    banners.value = []
  }
}

async function loadCourses(reset: boolean) {
  if (reset) {
    if (loading.value) return
    loading.value = true
    error.value = ''
  } else {
    if (loadingMore.value || !hasMore.value) return
    loadingMore.value = true
  }
  const page = reset ? 1 : pageNum.value + 1
  try {
    const res = await getCourseListApi({
      pageNum: page,
      pageSize: PAGE_SIZE,
      sortBy: activeSort.value,
      categoryId: activeCategoryId.value || undefined
    })
    courses.value = reset ? res.list : courses.value.concat(res.list)
    total.value = res.total
    pageNum.value = page
  } catch (e: any) {
    if (reset) error.value = (e && (e.msg || e.message)) || '课程加载失败'
    else uni.showToast({ title: '加载失败，请重试', icon: 'none' })
  } finally {
    loading.value = false
    loadingMore.value = false
  }
}

function selectCategory(id: number) {
  if (activeCategoryId.value === id) return
  activeCategoryId.value = id
  loadBanners()
  loadCourses(true)
}
function selectSort(key: 'avgScore' | 'likeCount' | 'createTime') {
  if (activeSort.value === key) return
  activeSort.value = key
  loadCourses(true)
}
function handleLoadMore() { loadCourses(false) }
function retry() { loadBanners(); loadCourses(true) }

onMounted(() => { loadCategories(); loadBanners(); loadCourses(true) })

function formatCount(n: number): string {
  if (n >= 10000) return (n / 10000).toFixed(1) + '万'
  return String(n)
}
function onSwiperChange(e: any) { swiperIndex.value = e.detail.current }
function onSwiperTouchStart() {
  if (carouselItems.value.length <= 1) return
  swiperAutoplay.value = false
  if (resumeTimer) clearTimeout(resumeTimer)
  resumeTimer = setTimeout(() => { swiperAutoplay.value = true }, 8000)
}
function goSearch() { uni.navigateTo({ url: '/pages-sub/search/search?type=2' }) }
function handleMenu() { uni.navigateTo({ url: '/pages-sub/course/category-all' }) }
function handleNotification() { uni.navigateTo({ url: '/pages-sub/notification/notification' }) }
function handleCourseTap(courseId: number) { uni.navigateTo({ url: `/pages-sub/course/detail?courseId=${courseId}` }) }
</script>

<style lang="scss" scoped>
.home-panel {
  padding: 0 32rpx calc(100rpx + env(safe-area-inset-bottom));
  @include eduPageGradientHome;
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
.category-tabs { margin-top: 8rpx; margin-bottom: 8rpx; white-space: nowrap; }
.tabs-inner { display: inline-flex; align-items: center; }
.tab-pill { flex-shrink: 0; display: flex; align-items: center; justify-content: center; height: 72rpx; padding: 0 40rpx; border-radius: 36rpx; margin-right: 16rpx; @include eduSurfaceWash; }
.tab-pill-active { @include eduSurfaceWashSelected; .tab-pill-text { color: $edu-primary; font-weight: 600; } }
.tab-pill-text { font-size: 28rpx; color: $edu-text-primary; }
.carousel-wrap { position: relative; margin-top: 8rpx; }
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
.ad-slot { margin-top: 28rpx; height: 160rpx; border-radius: 24rpx; background: $edu-surface-variant; display: flex; align-items: center; justify-content: center; }
.ad-slot-text { font-size: 26rpx; color: $edu-text-hint; }
.sort-tabs { display: flex; align-items: center; margin-top: 36rpx; }
.sort-tab { font-size: 28rpx; color: $edu-text-hint; margin-right: 40rpx; }
.sort-tab-active { font-size: 30rpx; font-weight: 700; color: $edu-text-primary; }
.course-grid { display: flex; flex-wrap: wrap; justify-content: space-between; margin-top: 24rpx; }
.grid-card { width: calc(50% - 12rpx); margin-bottom: 28rpx; border-radius: 24rpx; overflow: hidden; background-color: #FFFFFF; }
.grid-cover-wrap { position: relative; width: 100%; height: 180rpx; }
.grid-cover { width: 100%; height: 180rpx; }
.grid-cover-placeholder { background: linear-gradient(135deg, #DCE8FF 0%, #5B8DEF 100%); }
.grid-play-badge { position: absolute; right: 12rpx; bottom: 12rpx; width: 36rpx; height: 36rpx; border-radius: 50%; background: rgba(0, 0, 0, 0.35); display: flex; align-items: center; justify-content: center; }
.grid-body { padding: 16rpx 20rpx 24rpx; }
.grid-title { display: block; font-size: 30rpx; font-weight: 600; color: $edu-text-primary; line-height: 1.35; margin-bottom: 10rpx; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; }
.grid-sub { display: block; font-size: 24rpx; color: $edu-text-secondary; }
.state-block { padding: 120rpx 0; display: flex; justify-content: center; align-items: center; }
.state-text { font-size: 28rpx; color: $edu-text-hint; }
.state-text-error { color: $edu-accent-coral; }
.load-more { padding: 24rpx 0 8rpx; display: flex; justify-content: center; }
.load-more-text { font-size: 26rpx; color: $edu-primary; }
.load-more-end .load-more-text { color: $edu-text-hint; }
</style>
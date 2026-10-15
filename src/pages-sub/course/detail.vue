<template>
  <view class="course-detail-page">
    <view class="nav-bar" :style="{ paddingTop: statusBarHeight + 'px' }">
      <view class="nav-bar-inner" :style="{ height: navContentHeight + 'px' }">
        <view class="nav-back" @tap="goBack"><text class="back-icon">←</text></view>
      </view>
    </view>

    <LoadingState v-if="state === 'loading'" text="正在加载课程…" />
    <ErrorState v-else-if="state === 'error'" text="课程加载失败" @retry="loadDetail" />
    <block v-else-if="course">
      <scroll-view class="detail-scroll" scroll-y>
        <view class="cover-wrap">
          <image v-if="resolveFileUrl(course.coverUrl)" class="cover" :src="resolveFileUrl(course.coverUrl)" mode="aspectFill" />
          <view v-else class="cover cover-ph"></view>
        </view>

        <view class="info-card">
          <text class="course-title">{{ course.title }}</text>
          <view class="interact-row">
            <view class="interact-item" @tap="handleLike">
              <text class="interact-icon" :class="{ 'interact-liked': course.isLiked }">{{ course.isLiked ? '♥' : '♡' }}</text>
              <text class="interact-num">{{ formatCount(course.likeCount || 0) }}</text>
            </view>
            <view class="interact-item" @tap="handleFavorite">
              <text class="interact-icon" :class="{ 'interact-faved': course.isFavorited }">{{ course.isFavorited ? '⚑' : '⚐' }}</text>
              <text class="interact-num">收藏</text>
            </view>
          </view>
          <view class="type-tag"><text class="type-tag-text">长视频</text></view>
          <view class="rating-line">
            <text class="rating-score">{{ (course.averageScore || 0).toFixed(1) }} 分</text>
            <text class="rating-dot">·</text>
            <text class="rating-text">{{ course.ratingCount || 0 }} 人评价</text>
            <text class="rating-dot">·</text>
            <text class="rating-text">{{ formatCount(course.studentCount || 0) }} 人看过</text>
          </view>
        </view>

        <view class="section">
          <text class="section-title">课程简介</text>
          <text class="section-desc">{{ course.description || '暂无简介' }}</text>
          <text class="section-subtitle">最近点赞</text>
          <view class="liker-row">
            <view class="liker-avatar" v-for="u in course.recentLikers" :key="u.userId">
              <text class="liker-char">{{ charOf(u.nickName) }}</text>
            </view>
            <text class="liker-more">等 {{ formatCount(course.likeCount || 0) }} 人赞过</text>
          </view>
        </view>

        <view class="tabs">
          <view class="tab-item" :class="{ 'tab-item-active': activeTab === 'catalog' }" @tap="activeTab = 'catalog'">
            <text class="tab-text">目录</text>
            <view class="tab-underline" v-if="activeTab === 'catalog'"></view>
          </view>
          <view class="tab-item" :class="{ 'tab-item-active': activeTab === 'rating' }" @tap="switchToRating">
            <text class="tab-text">评价</text>
            <view class="tab-underline" v-if="activeTab === 'rating'"></view>
          </view>
        </view>

        <view class="catalog" v-if="activeTab === 'catalog'">
          <view class="chapter" v-for="ch in course.chapters" :key="ch.chapterId">
            <view class="chapter-head">
              <text class="chapter-title">{{ ch.title }}</text>
              <text class="chapter-count">{{ (ch.lessons || []).length }} 节</text>
            </view>
            <view class="lesson" v-for="ls in ch.lessons" :key="ls.lessonId" @tap="playLesson(ls)">
              <text class="lesson-play-glyph">▶</text>
              <text class="lesson-title">{{ ls.title }}</text>
              <text class="lesson-free" v-if="ls.isFree === 1">试看</text>
              <text class="lesson-done" v-if="ls.isFinished">✓</text>
              <text class="lesson-duration">{{ formatDuration(ls.duration) }}</text>
            </view>
          </view>
        </view>

        <view class="rating-panel" v-else>
          <view class="rating-summary">
            <text class="rating-big">{{ (course.averageScore || 0).toFixed(1) }}</text>
            <view class="rating-stars"><text class="star-glyph">★</text><text class="rating-total">{{ course.ratingCount || 0 }} 人评价</text></view>
          </view>
          <EmptyState v-if="ratings.length === 0" text="还没有评价" />
          <view class="rating-item" v-for="r in ratings" :key="r.ratingId">
            <view class="rating-avatar"><text class="rating-avatar-char">{{ charOf(r.nickName) }}</text></view>
            <view class="rating-body">
              <text class="rating-name">{{ r.nickName }}</text>
              <text class="rating-score-line">{{ r.score.toFixed(1) }} 分</text>
            </view>
            <text class="rating-time">{{ r.createTime }}</text>
          </view>
        </view>

        <view class="bottom-space"></view>
      </scroll-view>

      <view class="action-bar">
        <view class="ab-btn ab-note" @tap="handleNote"><text class="ab-note-text">📝 笔记</text></view>
        <view class="ab-btn ab-join" :class="{ 'ab-joined': course.isJoined }" @tap="handleJoin">
          <text class="ab-join-text">{{ course.isJoined ? '已加入' : '加入学习' }}</text>
        </view>
        <view class="ab-btn ab-study" @tap="handleStudy"><text class="ab-study-text">开始学习</text></view>
      </view>
    </block>
  </view>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { onLoad } from '@dcloudio/uni-app'
import LoadingState from '@/components/LoadingState.vue'
import ErrorState from '@/components/ErrorState.vue'
import EmptyState from '@/components/EmptyState.vue'
import { getCourseDetailApi, getCourseRatingsApi, joinCourseApi, leaveCourseApi, formatDuration } from '@/api/course'
import { toggleLikeApi, toggleFavoriteApi } from '@/api/interaction'
import { resolveFileUrl } from '@/api/user'
import { addNoteApi } from '@/api/notes'
import type { CourseDetailDto, LessonDto, CourseRatingDto } from '@/types/course'

const statusBarHeight = ref<number>(0)
const navContentHeight = ref<number>(44)
const sysInfo = uni.getSystemInfoSync()
statusBarHeight.value = sysInfo.statusBarHeight || 0
// #ifdef MP-WEIXIN
const menuButton = uni.getMenuButtonBoundingClientRect()
if (menuButton) navContentHeight.value = (menuButton.top - statusBarHeight.value) * 2 + menuButton.height
// #endif

const courseId = ref<number>(0)
const course = ref<CourseDetailDto | null>(null)
const ratings = ref<CourseRatingDto[]>([])
const state = ref<'loading' | 'error' | 'ready'>('loading')
const activeTab = ref<'catalog' | 'rating'>('catalog')

function charOf(name: string): string { return (name || 'U').charAt(0) }
function formatCount(n: number): string { return n >= 10000 ? (n / 10000).toFixed(1) + '万' : String(n) }

async function loadDetail() {
  state.value = 'loading'
  try {
    course.value = await getCourseDetailApi(courseId.value)
    state.value = 'ready'
  } catch (e) {
    state.value = 'error'
  }
}

async function switchToRating() {
  activeTab.value = 'rating'
  if (ratings.value.length === 0) {
    try { ratings.value = await getCourseRatingsApi(courseId.value) } catch (e) { /* ignore */ }
  }
}

async function handleLike() {
  if (!course.value) return
  const before = course.value
  const liked = !before.isLiked
  course.value = { ...before, isLiked: liked, likeCount: (before.likeCount || 0) + (liked ? 1 : -1) }
  try { await toggleLikeApi(2, before.courseId, !!before.isLiked) }
  catch (e) { course.value = before; uni.showToast({ title: '操作失败', icon: 'none' }) }
}

async function handleFavorite() {
  if (!course.value) return
  const before = course.value
  const faved = !before.isFavorited
  course.value = { ...before, isFavorited: faved, favoriteCount: (before.favoriteCount || 0) + (faved ? 1 : -1) }
  try {
    await toggleFavoriteApi(2, before.courseId, !!before.isFavorited)
    uni.showToast({ title: faved ? '已收藏' : '已取消收藏', icon: 'none' })
  } catch (e) { course.value = before }
}

async function handleJoin() {
  if (!course.value) return
  const before = course.value
  const joined = !before.isJoined
  course.value = { ...before, isJoined: joined }
  try {
    if (joined) await joinCourseApi(before.courseId)
    else await leaveCourseApi(before.courseId)
    uni.showToast({ title: joined ? '已加入学习' : '已退出', icon: 'none' })
  } catch (e) { course.value = before; uni.showToast({ title: '操作失败', icon: 'none' }) }
}

function firstLesson(): LessonDto | null {
  if (!course.value) return null
  for (const ch of course.value.chapters) { if (ch.lessons && ch.lessons.length) return ch.lessons[0] }
  return null
}
function handleStudy() { const ls = firstLesson(); if (ls) playLesson(ls); else uni.showToast({ title: '暂无小节', icon: 'none' }) }
function playLesson(ls: LessonDto) {
  uni.navigateTo({ url: `/pages-sub/player/player?courseId=${courseId.value}&lessonId=${ls.lessonId}` })
}

function handleNote() {
  if (!course.value) return
  uni.showModal({
    title: '记笔记', editable: true, placeholderText: '记录本节要点…',
    success: async (m) => {
      if (!m.confirm) return
      const text = (m.content || '').trim()
      if (!text) { uni.showToast({ title: '请输入内容', icon: 'none' }); return }
      try {
        await addNoteApi({ sourceType: 2, sourceId: course.value!.courseId, sourceTitle: course.value!.title, title: '《' + course.value!.title + '》笔记', content: text })
        uni.showToast({ title: '已保存到笔记本', icon: 'success' })
      } catch (e) { uni.showToast({ title: '保存失败', icon: 'none' }) }
    }
  })
}

function goBack() {
  const pages = getCurrentPages()
  if (pages.length > 1) uni.navigateBack()
  else uni.reLaunch({ url: '/pages/index/index' })
}

onLoad((query) => {
  courseId.value = Number((query && query.courseId) || 0)
  loadDetail()
})
</script>

<style lang="scss" scoped>
.course-detail-page { position: relative; min-height: 100vh; background-color: $edu-bg; }
.nav-bar { position: fixed; top: 0; left: 0; right: 0; z-index: 99; background: transparent; }
.nav-bar-inner { display: flex; align-items: center; padding-left: 16rpx; }
.nav-back { width: 72rpx; height: 72rpx; display: flex; align-items: center; justify-content: center; background: rgba(0, 0, 0, 0.25); border-radius: 50%; margin-left: 16rpx; }
.back-icon { font-size: 44rpx; color: #FFFFFF; }

.detail-scroll { position: absolute; top: 0; left: 0; right: 0; bottom: 0; }
.cover-wrap { width: 100%; height: 440rpx; }
.cover { width: 100%; height: 440rpx; }
.cover-ph { background: linear-gradient(135deg, #DCE8FF 0%, #3677EF 100%); }

.info-card { margin: -40rpx 24rpx 0; padding: 32rpx; border-radius: 28rpx; background-color: $edu-surface; box-shadow: 0 8rpx 24rpx rgba(0, 0, 0, 0.05); position: relative; }
.course-title { display: block; font-size: 40rpx; font-weight: 800; color: $edu-text-primary; line-height: 1.35; }
.interact-row { display: flex; align-items: center; margin-top: 20rpx; }
.interact-item { display: flex; align-items: center; margin-right: 48rpx; }
.interact-icon { font-size: 36rpx; color: $edu-text-secondary; margin-right: 8rpx; }
.interact-liked { color: #FF4D6A; }
.interact-faved { color: $edu-accent-yellow; }
.interact-num { font-size: 28rpx; color: $edu-text-secondary; }
.type-tag { display: inline-block; margin-top: 20rpx; padding: 8rpx 20rpx; border-radius: 12rpx; background-color: rgba(0, 176, 192, 0.12); }
.type-tag-text { font-size: 24rpx; color: $edu-accent-teal; font-weight: 600; }
.rating-line { display: flex; align-items: center; margin-top: 20rpx; }
.rating-score, .rating-text { font-size: 28rpx; color: $edu-text-secondary; }
.rating-dot { font-size: 28rpx; color: $edu-text-hint; margin: 0 12rpx; }

.section { margin: 32rpx 24rpx 0; padding: 32rpx; border-radius: 28rpx; @include eduSurfaceWash; }
.section-title { display: block; font-size: 34rpx; font-weight: 700; color: $edu-text-primary; margin-bottom: 16rpx; }
.section-desc { display: block; font-size: 30rpx; color: $edu-text-secondary; line-height: 1.6; }
.section-subtitle { display: block; font-size: 32rpx; font-weight: 700; color: $edu-text-primary; margin-top: 28rpx; margin-bottom: 20rpx; }
.liker-row { display: flex; align-items: center; }
.liker-avatar { width: 64rpx; height: 64rpx; border-radius: 50%; background-color: $edu-primary-container; display: flex; align-items: center; justify-content: center; margin-right: -16rpx; border: 2rpx solid #FFFFFF; }
.liker-char { font-size: 28rpx; font-weight: 700; color: #0C2C6B; }
.liker-more { font-size: 28rpx; color: $edu-text-secondary; margin-left: 32rpx; }

.tabs { display: flex; align-items: center; margin: 32rpx 24rpx 0; padding: 0 8rpx; border-bottom: 2rpx solid $edu-divider; }
.tab-item { position: relative; flex: 1; display: flex; flex-direction: column; align-items: center; padding-bottom: 20rpx; }
.tab-text { font-size: 30rpx; color: $edu-text-secondary; }
.tab-item-active .tab-text { font-size: 32rpx; font-weight: 700; color: $edu-primary; }
.tab-underline { position: absolute; bottom: 0; width: 56rpx; height: 6rpx; border-radius: 3rpx; background: $edu-primary; }

.catalog { margin: 8rpx 24rpx 0; }
.chapter { padding-top: 24rpx; }
.chapter-head { display: flex; align-items: center; justify-content: space-between; margin-bottom: 8rpx; }
.chapter-title { font-size: 32rpx; font-weight: 700; color: $edu-text-primary; }
.chapter-count { font-size: 26rpx; color: $edu-text-hint; }
.lesson { display: flex; align-items: center; padding: 28rpx 8rpx; border-bottom: 2rpx solid $edu-divider; }
.lesson-play-glyph { font-size: 24rpx; color: $edu-primary; margin-right: 20rpx; }
.lesson-title { flex: 1; font-size: 30rpx; color: $edu-text-primary; }
.lesson-free { font-size: 22rpx; color: $edu-accent-teal; background-color: rgba(0, 176, 192, 0.12); padding: 4rpx 12rpx; border-radius: 8rpx; margin-right: 16rpx; }
.lesson-done { font-size: 28rpx; color: $edu-primary; margin-right: 16rpx; }
.lesson-duration { font-size: 26rpx; color: $edu-text-hint; }

.rating-panel { margin: 24rpx 24rpx 0; }
.rating-summary { display: flex; align-items: center; padding: 32rpx; border-radius: 28rpx; @include eduSurfaceWash; margin-bottom: 16rpx; }
.rating-big { font-size: 72rpx; font-weight: 800; color: $edu-accent-yellow; margin-right: 32rpx; }
.rating-stars { display: flex; flex-direction: column; }
.star-glyph { font-size: 32rpx; color: $edu-accent-yellow; }
.rating-total { font-size: 26rpx; color: $edu-text-secondary; margin-top: 8rpx; }
.rating-item { display: flex; align-items: center; padding: 24rpx 8rpx; border-bottom: 2rpx solid $edu-divider; }
.rating-avatar { width: 64rpx; height: 64rpx; border-radius: 50%; background-color: $edu-primary-container; display: flex; align-items: center; justify-content: center; flex-shrink: 0; }
.rating-avatar-char { font-size: 28rpx; font-weight: 700; color: #0C2C6B; }
.rating-body { flex: 1; margin: 0 20rpx; }
.rating-name { display: block; font-size: 28rpx; font-weight: 600; color: $edu-text-secondary; }
.rating-score-line { display: block; font-size: 26rpx; color: $edu-accent-yellow; margin-top: 6rpx; }
.rating-time { font-size: 24rpx; color: $edu-text-hint; }

.bottom-space { height: calc(180rpx + env(safe-area-inset-bottom)); }

.action-bar {
  position: fixed; left: 0; right: 0; bottom: 0; z-index: 100;
  display: flex; align-items: center;
  background-color: $edu-surface; border-top: 2rpx solid $edu-divider;
  padding: 16rpx 24rpx calc(16rpx + env(safe-area-inset-bottom));
}
.ab-btn { display: flex; align-items: center; justify-content: center; height: 88rpx; border-radius: 44rpx; }
.ab-note { width: 160rpx; margin-right: 20rpx; background-color: $edu-surface-variant; }
.ab-note-text { font-size: 28rpx; color: $edu-text-secondary; }
.ab-join { flex: 1; margin-right: 20rpx; border: 2rpx solid $edu-primary; background-color: transparent; }
.ab-join-text { font-size: 30rpx; font-weight: 600; color: $edu-primary; }
.ab-joined { background-color: $edu-surface-variant; border-color: $edu-outline; .ab-join-text { color: $edu-text-secondary; } }
.ab-study { flex: 1; @include eduBrandGradient; }
.ab-study-text { font-size: 30rpx; font-weight: 600; color: #FFFFFF; }
</style>
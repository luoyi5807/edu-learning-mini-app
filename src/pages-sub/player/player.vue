<template>
  <view class="player-page">
    <video
        v-if="playUrl"
        id="course-video"
        class="player-video"
        :src="playUrl"
        :autoplay="true"
        :show-fullscreen-btn="true"
        :enable-play-gesture="true"
        :playback-rate="playbackRate"
        initial-time="0"
        @timeupdate="onTimeUpdate"
        @ended="onEnded"
    />
    <view v-else class="player-video player-video-ph">
      <LoadingState v-if="state === 'loading'" text="获取播放凭证…" />
      <ErrorState v-else-if="state === 'error'" text="播放失败" @retry="loadPlayInfo" />
      <view v-else class="player-empty"><text class="player-empty-text">视频源待接入</text></view>
    </view>

    <!-- 顶部栏 -->
    <view class="player-top" :style="{ paddingTop: statusBarHeight + 'px' }">
      <view class="player-top-inner" :style="{ height: navContentHeight + 'px' }">
        <view class="pt-back" @tap="goBack"><text class="pt-back-icon">←</text></view>
        <view class="pt-info">
          <text class="pt-title">{{ course ? course.title : '' }}</text>
          <text class="pt-lesson" v-if="currentLesson">{{ currentLesson.title }}</text>
        </view>
        <view class="pt-speed" @tap="cycleSpeed"><text class="pt-speed-text">{{ speedLabel }}</text></view>
      </view>
    </view>

    <!-- 右侧：目录开关 -->
    <view class="catalog-btn" @tap="toggleCatalog"><text class="catalog-btn-text">目录</text></view>

    <!-- 小节目录抽屉 -->
    <view class="catalog-mask" v-if="showCatalog" @tap="showCatalog = false"></view>
    <scroll-view class="catalog-drawer" scroll-y v-if="showCatalog && course">
      <text class="drawer-title">课程目录</text>
      <view class="drawer-chapter" v-for="ch in course.chapters" :key="ch.chapterId">
        <text class="drawer-chapter-title">{{ ch.title }}</text>
        <view
            class="drawer-lesson"
            :class="{ 'drawer-lesson-active': currentLessonId === ls.lessonId }"
            v-for="ls in ch.lessons"
            :key="ls.lessonId"
            @tap="switchLesson(ls)"
        >
          <text class="drawer-lesson-title">{{ ls.title }}</text>
          <text class="drawer-lesson-duration">{{ formatDuration(ls.duration) }}</text>
        </view>
      </view>
    </scroll-view>
  </view>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { onLoad } from '@dcloudio/uni-app'
import LoadingState from '@/components/LoadingState.vue'
import ErrorState from '@/components/ErrorState.vue'
import { getCourseDetailApi, getPlayInfoApi, formatDuration } from '@/api/course'
import type { CourseDetailDto, LessonDto } from '@/types/course'

const statusBarHeight = ref<number>(0)
const navContentHeight = ref<number>(44)
const sysInfo = uni.getSystemInfoSync()
statusBarHeight.value = sysInfo.statusBarHeight || 0
// #ifdef MP-WEIXIN
const menuButton = uni.getMenuButtonBoundingClientRect()
if (menuButton) navContentHeight.value = (menuButton.top - statusBarHeight.value) * 2 + menuButton.height
// #endif

const courseId = ref<number>(0)
const currentLessonId = ref<number>(0)
const course = ref<CourseDetailDto | null>(null)
const playUrl = ref<string>('')
const state = ref<'loading' | 'error' | 'ready'>('loading')
const showCatalog = ref<boolean>(false)

const speeds = [1, 1.25, 1.5, 2, 0.75]
const speedIndex = ref<number>(0)
const playbackRate = computed<number>(() => speeds[speedIndex.value])
const speedLabel = computed<string>(() => playbackRate.value + 'x')

const allLessons = computed<LessonDto[]>(() => {
  if (!course.value) return []
  return course.value.chapters.reduce<LessonDto[]>((acc, ch) => acc.concat(ch.lessons || []), [])
})
const currentLesson = computed<LessonDto | null>(() => allLessons.value.find((l) => l.lessonId === currentLessonId.value) || null)

async function loadCourse() {
  state.value = 'loading'
  try {
    course.value = await getCourseDetailApi(courseId.value)
    if (!currentLessonId.value && allLessons.value.length) currentLessonId.value = allLessons.value[0].lessonId
    await loadPlayInfo()
  } catch (e) {
    state.value = 'error'
  }
}

async function loadPlayInfo() {
  state.value = 'loading'
  try {
    const info = await getPlayInfoApi(courseId.value, currentLessonId.value || undefined)
    playUrl.value = (info && info.playUrl) || ''
    state.value = playUrl.value ? 'ready' : 'error'
    if (!playUrl.value) state.value = 'ready'   // mock：无源时展示占位而非报错
  } catch (e) {
    state.value = 'error'
  }
}

function switchLesson(ls: LessonDto) {
  currentLessonId.value = ls.lessonId
  showCatalog.value = false
  loadPlayInfo()
}

function onEnded() {
  const idx = allLessons.value.findIndex((l) => l.lessonId === currentLessonId.value)
  if (idx >= 0 && idx < allLessons.value.length - 1) {
    uni.showToast({ title: '即将播放下一节', icon: 'none' })
    switchLesson(allLessons.value[idx + 1])
  }
}

let lastReport = 0
function onTimeUpdate(e: any) {
  const now = Date.now()
  if (now - lastReport < 15000) return   // 心跳：约 15s 上报一次进度
  lastReport = now
  // POST courses/progress/sync { courseId, lessonId, progressSeconds:e.detail.currentTime }（后端待接入）
}

function cycleSpeed() {
  speedIndex.value = (speedIndex.value + 1) % speeds.length
  const ctx = uni.createVideoContext('course-video')
  if (ctx) ctx.playbackRate(playbackRate.value)
  uni.showToast({ title: '倍速 ' + speedLabel.value, icon: 'none' })
}

function toggleCatalog() { showCatalog.value = !showCatalog.value }
function goBack() {
  const pages = getCurrentPages()
  if (pages.length > 1) uni.navigateBack()
  else uni.reLaunch({ url: '/pages/index/index' })
}

onLoad((query) => {
  courseId.value = Number((query && query.courseId) || 0)
  currentLessonId.value = Number((query && query.lessonId) || 0)
  loadCourse()
})
</script>

<style lang="scss" scoped>
.player-page { position: relative; width: 100vw; height: 100vh; background-color: #000000; overflow: hidden; }
.player-video { width: 100%; height: 100%; }
.player-video-ph { display: flex; align-items: center; justify-content: center; background: radial-gradient(circle at 50% 45%, #1c2530 0%, #000000 75%); }
.player-empty-text { font-size: 30rpx; color: rgba(255, 255, 255, 0.7); }

.player-top { position: absolute; top: 0; left: 0; right: 0; z-index: 20; background: linear-gradient(180deg, rgba(0,0,0,0.5) 0%, rgba(0,0,0,0) 100%); }
.player-top-inner { display: flex; align-items: center; padding: 0 24rpx; }
.pt-back { width: 72rpx; height: 72rpx; display: flex; align-items: center; justify-content: center; }
.pt-back-icon { font-size: 44rpx; color: #FFFFFF; }
.pt-info { flex: 1; display: flex; flex-direction: column; margin-left: 8rpx; overflow: hidden; }
.pt-title { font-size: 30rpx; font-weight: 700; color: #FFFFFF; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
.pt-lesson { font-size: 24rpx; color: rgba(255, 255, 255, 0.8); margin-top: 4rpx; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
.pt-speed { padding: 8rpx 24rpx; border-radius: 28rpx; background: rgba(255, 255, 255, 0.18); }
.pt-speed-text { font-size: 26rpx; color: #FFFFFF; }

.catalog-btn { position: absolute; right: 24rpx; bottom: 200rpx; z-index: 20; padding: 16rpx 28rpx; border-radius: 32rpx; background: rgba(255, 255, 255, 0.18); }
.catalog-btn-text { font-size: 26rpx; color: #FFFFFF; }

.catalog-mask { position: absolute; top: 0; left: 0; right: 0; bottom: 0; z-index: 30; background: rgba(0, 0, 0, 0.4); }
.catalog-drawer {
  position: absolute; right: 0; top: 0; bottom: 0; width: 60%; max-width: 560rpx; z-index: 31;
  background: rgba(20, 24, 34, 0.96); padding: calc(80rpx + env(safe-area-inset-top)) 24rpx 40rpx; box-sizing: border-box;
}
.drawer-title { display: block; font-size: 32rpx; font-weight: 700; color: #FFFFFF; margin-bottom: 24rpx; }
.drawer-chapter { margin-bottom: 24rpx; }
.drawer-chapter-title { display: block; font-size: 28rpx; font-weight: 600; color: rgba(255, 255, 255, 0.7); margin-bottom: 12rpx; }
.drawer-lesson { display: flex; align-items: center; justify-content: space-between; padding: 20rpx 12rpx; border-radius: 12rpx; }
.drawer-lesson-active { background: rgba(54, 119, 239, 0.28); }
.drawer-lesson-title { flex: 1; font-size: 28rpx; color: #FFFFFF; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
.drawer-lesson-duration { font-size: 24rpx; color: rgba(255, 255, 255, 0.6); margin-left: 16rpx; }
</style>
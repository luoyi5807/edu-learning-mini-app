<template>
  <view class="player-page">
    <video
        v-if="playUrl"
        id="course-video"
        :key="currentLessonId"
        class="player-video"
        :src="playUrl"
        :autoplay="true"
        :show-fullscreen-btn="true"
        :enable-play-gesture="true"
        :playback-rate="playbackRate"
        :initial-time="initialTime"
        @timeupdate="onTimeUpdate"
        @ended="onEnded"
    />
    <view v-else class="player-video player-video-ph">
      <LoadingState v-if="state === 'loading'" text="正在加载课程…" />
      <ErrorState v-else-if="state === 'error'" text="加载失败" @retry="loadCourse" />
      <view v-else class="player-empty"><text class="player-empty-text">该课程暂无可播放视频</text></view>
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
    <!-- 右侧：阿星总结（视频总结，video_id = 当前小节） -->
    <view class="ai-summary-btn" @tap="askSummary"><text class="ai-summary-btn-text">✦ 总结</text></view>

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

    <!-- 视频总结弹层 -->
    <view class="sum-mask" v-if="summaryVisible" @tap="summaryVisible = false"></view>
    <scroll-view class="sum-sheet" scroll-y v-if="summaryVisible">
      <view class="sum-head">
        <text class="sum-title">阿星 · 视频总结</text>
        <text class="sum-close" @tap="summaryVisible = false">✕</text>
      </view>
      <text class="sum-meta" v-if="summaryMeta">{{ summaryMeta }}</text>
      <LoadingState v-if="summaryLoading" text="阿星正在总结这条视频…" />
      <text v-else class="sum-text">{{ summaryText }}</text>
    </scroll-view>
  </view>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { onLoad } from '@dcloudio/uni-app'
import LoadingState from '@/components/LoadingState.vue'
import ErrorState from '@/components/ErrorState.vue'
import { getCourseDetailApi, formatDuration } from '@/api/course'
import { reportStudyApi } from '@/api/study'
import { reportHistoryApi, getHistoryProgressApi } from '@/api/interaction'
import { videoSummaryApi, pollTask } from '@/api/agent'
import { safeParseJson } from '@/types/agent'
import { API_READY } from '@/config/apiStatus'
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
const initialTime = ref<number>(0)
let explicitLesson = false

/* ===== 阿星视频总结 ===== */
const summaryVisible = ref<boolean>(false)
const summaryLoading = ref<boolean>(false)
const summaryText = ref<string>('')
const summaryMeta = ref<string>('')

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
    await applyResume()
    applyPlayUrl()
  } catch (e) {
    state.value = 'error'
  }
}

/** 断点续播：查 /history/progress；外部进入（未指定小节）回到上次小节，位置匹配则从断点起播 */
async function applyResume() {
  if (!courseId.value) return
  try {
    const p = await getHistoryProgressApi('course', courseId.value)
    if (!p.found) return
    if (!explicitLesson && p.videoId && allLessons.value.some((l) => l.lessonId === p.videoId)) {
      currentLessonId.value = p.videoId
    }
    const sameLesson = !p.videoId || p.videoId === currentLessonId.value
    const dur = currentLesson.value?.duration || p.duration || 0
    if (sameLesson && p.position && p.position > 2 && (!dur || p.position < dur - 5)) {
      initialTime.value = Math.floor(p.position)
    }
  } catch (e) { /* 查断点失败不影响正常播放 */ }
}

/** 播放地址来自详情返回的视频直链（后端无独立播放凭证接口） */
function applyPlayUrl() {
  const ls = currentLesson.value
  playUrl.value = (ls && ls.playUrl) || ''
  state.value = 'ready'
}

function switchLesson(ls: LessonDto) {
  currentLessonId.value = ls.lessonId
  showCatalog.value = false
  initialTime.value = 0
  lastCurrentTime = 0
  lastReportTs = 0
  applyPlayUrl()
}

function onEnded() {
  const vid = currentLessonId.value
  if (vid) {
    reportStudyApi({ targetType: 'courseVideo', videoId: vid, seconds: 5, finished: 1 }).catch(() => {})
    reportHistoryApi({ targetType: 'course', targetId: courseId.value, videoId: vid, position: currentLesson.value?.duration || 0, duration: currentLesson.value?.duration }).catch(() => {})
  }
  const idx = allLessons.value.findIndex((l) => l.lessonId === currentLessonId.value)
  if (idx >= 0 && idx < allLessons.value.length - 1) {
    uni.showToast({ title: '即将播放下一节', icon: 'none' })
    switchLesson(allLessons.value[idx + 1])
  }
}

let lastReportTs = 0
let lastCurrentTime = 0

function onTimeUpdate(e: any) {
  const now = Date.now()
  if (now - lastReportTs < 15000) return   // 心跳：约 15s 上报一次
  lastReportTs = now
  const cur = Math.floor((e && e.detail && e.detail.currentTime) || 0)
  let delta = cur - lastCurrentTime
  lastCurrentTime = cur
  if (delta <= 0) delta = 1     // seek / 倍速抖动兜底，至少计 1 秒
  if (delta > 30) delta = 30    // 单次最多 30 秒，防拖动跳秒刷分
  const vid = currentLessonId.value
  if (!vid) return
  reportStudyApi({ targetType: 'courseVideo', videoId: vid, seconds: delta }).catch(() => {})
  reportHistoryApi({ targetType: 'course', targetId: courseId.value, videoId: vid, position: cur, duration: currentLesson.value?.duration }).catch(() => {})
}

function cycleSpeed() {
  speedIndex.value = (speedIndex.value + 1) % speeds.length
  const ctx = uni.createVideoContext('course-video')
  if (ctx) ctx.playbackRate(playbackRate.value)
  uni.showToast({ title: '倍速 ' + speedLabel.value, icon: 'none' })
}

function toggleCatalog() { showCatalog.value = !showCatalog.value }

/** 总结当前小节视频：POST /agent/video/summary → 轮询任务 → 展示 summary */
async function askSummary() {
  const vid = currentLessonId.value
  if (!vid) { uni.showToast({ title: '当前无可总结视频', icon: 'none' }); return }
  summaryVisible.value = true
  summaryMeta.value = currentLesson.value ? currentLesson.value.title : ''
  if (!API_READY.agent) { summaryLoading.value = false; summaryText.value = '（后端智能体未接入）'; return }
  summaryLoading.value = true
  summaryText.value = ''
  try {
    const taskId = await videoSummaryApi(vid)
    const task = await pollTask(taskId, { interval: 2000, timeout: 180000 })
    if (task.status === 'SUCCESS') {
      const out = safeParseJson(task.outputJson) || {}
      summaryText.value = out.summary || '（无总结内容）'
      summaryMeta.value = [out.videoTitle, out.durationMinutes ? out.durationMinutes + ' 分钟' : '', out.fallback ? '（基于元数据）' : ''].filter(Boolean).join(' · ')
    } else {
      summaryText.value = '总结失败：' + (task.errorMsg || '未知错误')
    }
  } catch (e: any) {
    summaryText.value = '总结失败：' + ((e && (e.msg || e.message)) || '服务暂不可用')
  } finally {
    summaryLoading.value = false
  }
}

function goBack() {
  const pages = getCurrentPages()
  if (pages.length > 1) uni.navigateBack()
  else uni.reLaunch({ url: '/pages/index/index' })
}

onLoad((query) => {
  courseId.value = Number((query && query.courseId) || 0)
  const lessonParam = Number((query && query.lessonId) || 0)
  explicitLesson = lessonParam > 0
  currentLessonId.value = lessonParam
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

.ai-summary-btn { position: absolute; right: 24rpx; bottom: 288rpx; z-index: 20; padding: 16rpx 28rpx; border-radius: 32rpx; background: rgba(54, 119, 239, 0.85); }
.ai-summary-btn-text { font-size: 26rpx; color: #FFFFFF; font-weight: 600; }

.sum-mask { position: absolute; top: 0; left: 0; right: 0; bottom: 0; z-index: 40; background: rgba(0, 0, 0, 0.5); }
.sum-sheet {
  position: absolute; left: 0; right: 0; bottom: 0; z-index: 41; max-height: 70vh;
  background-color: $edu-surface; border-radius: 32rpx 32rpx 0 0;
  padding: 32rpx 32rpx calc(40rpx + env(safe-area-inset-bottom)); box-sizing: border-box;
}
.sum-head { display: flex; align-items: center; justify-content: space-between; }
.sum-title { font-size: 34rpx; font-weight: 700; color: $edu-text-primary; }
.sum-close { font-size: 36rpx; color: $edu-text-hint; padding: 0 12rpx; }
.sum-meta { display: block; font-size: 24rpx; color: $edu-text-hint; margin-top: 12rpx; }
.sum-text { display: block; font-size: 30rpx; color: $edu-text-primary; line-height: 1.7; margin-top: 24rpx; white-space: pre-wrap; }
</style>
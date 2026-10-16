<template>
  <view class="video-panel">
    <LoadingState v-if="state === 'loading'" text="正在加载视频…" />
    <ErrorState v-else-if="state === 'error'" text="视频加载失败" @retry="loadVideos" />
    <EmptyState v-else-if="list.length === 0" text="暂无短视频" />
    <swiper
        v-else
        class="video-swiper"
        :vertical="true"
        :circular="false"
        :current="currentIndex"
        @change="onSwiperChange"
    >
      <swiper-item v-for="(item, idx) in list" :key="item.courseId">
        <view class="video-slide">
          <!-- 视频层：始终渲染，避免 v-if 挂载时序问题 -->
          <video
              :id="'video-' + item.courseId"
              class="video-media"
              :src="playUrlMap[item.courseId] || ''"
              :poster="item.coverUrl"
              :controls="false"
              :show-center-play-btn="false"
              :show-play-btn="false"
              :show-fullscreen-btn="false"
              :enable-progress-gesture="false"
              :loop="true"
              :autoplay="idx === currentIndex && !!playUrlMap[item.courseId]"
              object-fit="cover"
              @play="onPlay(item)"
              @pause="onPause(item)"
              @timeupdate="onTimeUpdate(item, $event)"
              @error="onVideoError(item, $event)"
          />

          <!-- 透明点击层：单击切换播放/暂停（不跳页） -->
          <view class="video-tap-layer" @tap="togglePlay(item)"></view>

          <!-- 顶部压黑，保证固定标题可读 -->
          <view class="video-top-scrim"></view>

          <!-- 底部压黑，保证文字可读 -->
          <view class="video-scrim"></view>

          <!-- 暂停态中央徽标 -->
          <view class="paused-badge" v-if="pausedMap[item.courseId]">
            <text class="paused-glyph">▶</text>
          </view>

          <!-- 右侧操作栏 -->
          <view class="action-bar">
            <view class="action-item" @tap.stop="handleLike(item)">
              <view class="action-icon-wrap">
                <text class="action-icon" :class="{ 'action-icon-liked': item.isLiked }">{{ item.isLiked ? '♥' : '♡' }}</text>
              </view>
              <text class="action-label">{{ formatCount(item.likeCount || 0) }}</text>
            </view>
            <view class="action-item" @tap.stop="openComments(item)">
              <view class="action-icon-wrap"><text class="action-icon">💬</text></view>
              <text class="action-label">{{ formatCount(item.commentCount || 0) }}</text>
            </view>
            <view class="action-item" @tap.stop="handleFavorite(item)">
              <view class="action-icon-wrap">
                <text class="action-icon" :class="{ 'action-icon-faved': item.isFavorited }">{{ item.isFavorited ? '★' : '⚑' }}</text>
              </view>
              <text class="action-label">{{ item.isFavorited ? '已收藏' : '收藏' }}</text>
            </view>
            <view class="action-item" @tap.stop="handleShare(item)">
              <view class="action-icon-wrap"><text class="action-icon">↗</text></view>
              <text class="action-label">分享</text>
            </view>
          </view>

          <!-- 左下信息 -->
          <view class="video-info">
            <view class="instructor-row">
              <view class="instructor-avatar" @tap.stop="goInstructor(item)">
                <text class="instructor-char">{{ charOf(item.instructorName) }}</text>
              </view>
              <text class="instructor-name" @tap.stop="goInstructor(item)">{{ item.instructorName }}</text>
            </view>
            <text class="video-title" @tap.stop="goDetail(item)">{{ item.title }}</text>
            <view class="video-meta">
              <text class="video-duration">时长 {{ formatDuration(item.duration || 0) }}</text>
              <text class="video-views">{{ formatCount(item.viewCount || 0) }} 次播放</text>
            </view>
          </view>

          <!-- 底部进度条 -->
          <view class="faux-progress">
            <view class="faux-progress-track">
              <view class="faux-progress-bar" :style="{ width: progressPct(item) + '%' }"></view>
            </view>
            <text class="faux-time faux-time-l">{{ formatDuration(currentTimeMap[item.courseId] || 0) }}</text>
            <text class="faux-time faux-time-r">{{ formatDuration(item.duration || 0) }}</text>
          </view>
        </view>
      </swiper-item>
    </swiper>

    <CommentsSheet :visible="commentVisible" :target-type="3" :target-id="commentTargetId" @close="commentVisible = false" />
  </view>
</template>

<script setup lang="ts">
import { ref, reactive, nextTick, getCurrentInstance, onMounted, onUnmounted } from 'vue'
import LoadingState from '@/components/LoadingState.vue'
import ErrorState from '@/components/ErrorState.vue'
import EmptyState from '@/components/EmptyState.vue'
import CommentsSheet from '@/components/CommentsSheet.vue'
import { getShortVideosApi, getPlayInfoApi, formatDuration } from '@/api/course'
import { toggleLikeApi, toggleFavoriteApi, reportShareApi, getInteractionStatusApi } from '@/api/interaction'
import type { Course } from '@/types/course'

const instance = getCurrentInstance()

const list = ref<Course[]>([])
const state = ref<'loading' | 'error' | 'ready'>('loading')
const currentIndex = ref<number>(0)
const commentVisible = ref<boolean>(false)
const commentTargetId = ref<number>(0)
let loadingMore = false

/* ===== 每个视频的播放状态 ===== */
const playUrlMap = reactive<Record<number, string>>({})
const pausedMap = reactive<Record<number, boolean>>({})
const currentTimeMap = reactive<Record<number, number>>({})

function charOf(name: string): string { return (name || 'U').charAt(0) }
function formatCount(n: number): string { return n >= 10000 ? (n / 10000).toFixed(1) + '万' : String(n) }
function indexOf(item: Course): number { return list.value.findIndex((x) => x.courseId === item.courseId) }
function progressPct(item: Course): number {
  const total = item.duration || 0
  if (total <= 0) return 0
  const cur = currentTimeMap[item.courseId] || 0
  return Math.max(0, Math.min(100, (cur / total) * 100))
}

/** 获取 video context（传组件实例，解决子组件内查找问题） */
function getCtx(courseId: number) {
  return uni.createVideoContext('video-' + courseId, instance)
}

/** 拉一次播放地址（缓存后不再请求）：真实数据用列表自带直链，mock 回退 play-info */
async function ensurePlayUrl(item: Course): Promise<string> {
  const cached = playUrlMap[item.courseId]
  if (cached !== undefined) return cached
  if (item.playUrl) {
    playUrlMap[item.courseId] = item.playUrl
    return item.playUrl
  }
  try {
    const info = await getPlayInfoApi(item.courseId)
    playUrlMap[item.courseId] = (info && info.playUrl) || ''
  } catch (e) {
    playUrlMap[item.courseId] = ''
  }
  return playUrlMap[item.courseId]
}

async function loadVideos() {
  state.value = 'loading'
  try {
    const res = await getShortVideosApi()
    list.value = res || []
    state.value = 'ready'
    backfillInteraction()
    await Promise.all(list.value.slice(0, 3).map(ensurePlayUrl))
  } catch (e) {
    state.value = 'error'
  }
}

/** 初始化点赞/收藏按钮态（targetType=3 短视频） */
async function backfillInteraction() {
  const ids = list.value.map((x) => x.courseId)
  const [liked, faved] = await Promise.all([
    getInteractionStatusApi(3, 1, ids),
    getInteractionStatusApi(3, 2, ids)
  ])
  const ls = new Set(liked), fs = new Set(faved)
  list.value = list.value.map((x) => ({ ...x, isLiked: ls.has(x.courseId), isFavorited: fs.has(x.courseId) }))
}

async function onSwiperChange(e: any) {
  const prev = currentIndex.value
  const next = e.detail.current
  if (prev !== next && list.value[prev]) {
    const oldCtx = getCtx(list.value[prev].courseId)
    if (oldCtx) oldCtx.pause()
  }
  currentIndex.value = next
  if (currentIndex.value >= list.value.length - 2) loadMore()
  await activateCurrent()
}

/** 滑动后手动播放当前（autoplay prop 对已挂载元素不重新触发） */
async function activateCurrent() {
  const cur = list.value[currentIndex.value]
  if (!cur) return
  await ensurePlayUrl(cur)
  if (!playUrlMap[cur.courseId]) return
  setTimeout(() => {
    const ctx = getCtx(cur.courseId)
    if (ctx) ctx.play()
  }, 100)
}

/** 单击视频区域：暂停 / 继续 */
function togglePlay(item: Course) {
  if (!playUrlMap[item.courseId]) return
  const ctx = getCtx(item.courseId)
  if (!ctx) return
  if (pausedMap[item.courseId]) ctx.play()
  else ctx.pause()
}

function onPlay(item: Course) { pausedMap[item.courseId] = false }
function onPause(item: Course) { pausedMap[item.courseId] = true }
function onTimeUpdate(item: Course, e: any) {
  currentTimeMap[item.courseId] = (e && e.detail && e.detail.currentTime) || 0
}
function onVideoError(item: Course, e: any) {
  // 文件缺失/网络问题时静默处理，不再弹 toast 打扰（首页会误弹）
  console.warn('[VideoPanel] 视频源加载失败:', item.courseId, e)
}

async function loadMore() {
  if (loadingMore) return
  loadingMore = true
  loadingMore = false
}

async function handleLike(item: Course) {
  const i = indexOf(item)
  if (i < 0) return
  const before = list.value[i]
  try {
    const r = await toggleLikeApi(3, before.courseId, !!before.isLiked)
    list.value[i] = { ...before, isLiked: r.isLiked, likeCount: r.likeCount ?? before.likeCount }
  } catch (e) {
    uni.showToast({ title: '操作失败', icon: 'none' })
  }
}

async function handleFavorite(item: Course) {
  const i = indexOf(item)
  if (i < 0) return
  const before = list.value[i]
  try {
    const r = await toggleFavoriteApi(3, before.courseId, !!before.isFavorited)
    list.value[i] = { ...before, isFavorited: r.isFavorited, favoriteCount: r.favoriteCount ?? before.favoriteCount }
  } catch (e) {
    uni.showToast({ title: '操作失败', icon: 'none' })
  }
}

function handleShare(item: Course) {
  reportShareApi(2, item.courseId, 4)
  uni.showToast({ title: '已复制链接', icon: 'none' })
}

function openComments(item: Course) { commentTargetId.value = item.courseId; commentVisible.value = true }
function goDetail(item: Course) { uni.navigateTo({ url: `/pages-sub/course/detail?courseId=${item.courseId}` }) }

function goInstructor(item: Course) {
  const uid = item.instructorId
  if (!uid) {
    uni.showToast({ title: '作者信息待完善', icon: 'none' })
    return
  }
  uni.navigateTo({ url: `/pages-sub/mine/blog-home?userId=${uid}` })
}

onMounted(() => { loadVideos() })
onUnmounted(() => {
  list.value.forEach((it) => {
    const c = getCtx(it.courseId)
    if (c) c.pause()
  })
})

/** 懒加载：首次切到「视频」Tab 才拉列表，避免启动即在首页触发加载/报错 */
let loaded = false
function maybeLoad() {
  if (loaded) return
  loaded = true
  loadVideos()
}
onMounted(() => { uni.$on('video:show', maybeLoad) })
onUnmounted(() => { uni.$off('video:show', maybeLoad) })
</script>

<style lang="scss" scoped>
.video-panel { position: absolute; top: 0; left: 0; right: 0; bottom: 0; background-color: #000000; }
.video-swiper { width: 100%; height: 100%; }
.video-slide { position: relative; width: 100%; height: 100%; background-color: #000000; overflow: hidden; }

.video-media { position: absolute; top: 0; left: 0; right: 0; bottom: 0; width: 100%; height: 100%; z-index: 0; }

.video-tap-layer { position: absolute; top: 0; left: 0; right: 0; bottom: 0; z-index: 1; background: transparent; }

.video-top-scrim { position: absolute; top: 0; left: 0; right: 0; height: 280rpx; background: linear-gradient(180deg, rgba(0,0,0,0.55) 0%, rgba(0,0,0,0) 100%); pointer-events: none; z-index: 2; }
.video-scrim { position: absolute; left: 0; right: 0; bottom: 0; height: 460rpx; background: linear-gradient(180deg, rgba(0,0,0,0) 0%, rgba(0,0,0,0.35) 55%, rgba(0,0,0,0.65) 100%); pointer-events: none; z-index: 2; }

.paused-badge { position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); width: 140rpx; height: 140rpx; border-radius: 50%; background: rgba(0, 0, 0, 0.35); display: flex; align-items: center; justify-content: center; z-index: 2; pointer-events: none; }
.paused-glyph { font-size: 64rpx; color: rgba(255, 255, 255, 0.9); text-shadow: 0 2rpx 12rpx rgba(0, 0, 0, 0.5); margin-left: 8rpx; line-height: 1; }

.action-bar { position: absolute; right: 24rpx; bottom: 240rpx; display: flex; flex-direction: column; align-items: center; z-index: 3; }
.action-item { display: flex; flex-direction: column; align-items: center; margin-bottom: 36rpx; }
.action-icon-wrap { width: 88rpx; height: 88rpx; border-radius: 50%; background: rgba(0, 0, 0, 0.55); display: flex; align-items: center; justify-content: center; }
.action-icon { font-size: 44rpx; color: #FFFFFF; }
.action-icon-liked { color: #FF4D6A; }
.action-icon-faved { color: #FFC107; }
.action-label { font-size: 24rpx; color: #FFFFFF; margin-top: 8rpx; }

.video-info { position: absolute; left: 32rpx; right: 160rpx; bottom: 200rpx; z-index: 3; }
.instructor-row { display: flex; align-items: center; margin-bottom: 20rpx; }
.instructor-avatar { width: 64rpx; height: 64rpx; border-radius: 50%; background: $edu-primary-container; display: flex; align-items: center; justify-content: center; margin-right: 16rpx; }
.instructor-char { font-size: 28rpx; font-weight: 700; color: #0C2C6B; }
.instructor-name { font-size: 30rpx; font-weight: 600; color: #FFFFFF; }
.video-title { display: block; font-size: 32rpx; font-weight: 700; color: #FFFFFF; line-height: 1.4; margin-bottom: 12rpx; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; }
.video-meta { display: flex; align-items: center; }
.video-duration { font-size: 26rpx; color: rgba(255, 255, 255, 0.8); margin-right: 24rpx; }
.video-views { font-size: 26rpx; color: rgba(255, 255, 255, 0.8); }

.faux-progress { position: absolute; left: 32rpx; right: 32rpx; bottom: 120rpx; display: flex; align-items: center; z-index: 3; }
.faux-progress-track { flex: 1; height: 4rpx; border-radius: 2rpx; background: rgba(255, 255, 255, 0.3); margin: 0 16rpx; position: relative; }
.faux-progress-bar { position: absolute; left: 0; top: 0; height: 4rpx; border-radius: 2rpx; background: #FFFFFF; }
.faux-time { font-size: 22rpx; color: rgba(255, 255, 255, 0.85); }
</style>
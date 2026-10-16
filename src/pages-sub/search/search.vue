<template>
  <view class="search-page">
    <view class="nav-bar" :style="{ paddingTop: statusBarHeight + 'px' }">
      <view class="nav-bar-inner" :style="{ height: navContentHeight + 'px' }">
        <view class="nav-back" @tap="goBack"><text class="back-icon">←</text></view>
        <text class="nav-title">搜索</text>
      </view>
      <view class="search-row">
        <view class="search-box">
          <input class="search-input" v-model="keyword" :focus="autoFocus" placeholder="您想学习什么？" placeholder-class="search-ph" confirm-type="search" @confirm="doSearch" />
        </view>
        <text class="search-go" @tap="doSearch">搜索</text>
      </view>
    </view>
    <view class="nav-placeholder" :style="{ height: navTotalHeight + 'px' }"></view>

    <!-- 双 Tab -->
    <view class="type-tabs">
      <view class="type-tab" :class="{ 'type-tab-active': type === 1 }" @tap="switchType(1)"><text class="type-tab-text">文章</text><view class="type-underline" v-if="type === 1"></view></view>
      <view class="type-tab" :class="{ 'type-tab-active': type === 2 }" @tap="switchType(2)"><text class="type-tab-text">视频课程</text><view class="type-underline" v-if="type === 2"></view></view>
    </view>

    <!-- 未搜索：历史 + 热词 -->
    <block v-if="!searched">
      <view class="section" v-if="history.length">
        <view class="section-head"><text class="section-title">搜索历史</text><text class="section-clear" @tap="clearHistory">清空</text></view>
        <view class="history-pills">
          <view class="history-pill" v-for="(h, i) in history" :key="i" @tap="tapKeyword(h)"><text class="history-pill-text">{{ h }}</text></view>
        </view>
      </view>
      <view class="section">
        <text class="section-title">热门搜索</text>
        <view class="hot-grid">
          <view class="hot-item" v-for="(w, i) in hotWords" :key="w" @tap="tapKeyword(w)">
            <text class="hot-rank" :class="{ 'hot-rank-top': i < 3 }">{{ i + 1 }}</text>
            <text class="hot-word">{{ w }}</text>
          </view>
        </view>
      </view>
    </block>

    <!-- 搜索结果 -->
    <block v-else>
      <LoadingState v-if="state === 'loading'" text="搜索中…" />
      <EmptyState v-else-if="resultCount === 0" text="没有找到相关内容" />
      <view class="result-list" v-else-if="type === 1">
        <view v-for="a in articles" :key="a.articleId" class="result-card" @tap="openArticle(a)">
          <text class="result-title">{{ a.title }}</text>
          <text class="result-sub">{{ a.authorName }} · {{ a.viewCount }} 阅读</text>
        </view>
      </view>
      <view class="result-list" v-else>
        <view v-for="c in courses" :key="c.courseId" class="result-card" @tap="openCourse(c)">
          <text class="result-title">{{ c.title }}</text>
          <text class="result-sub">{{ c.categoryName }} · {{ c.likeCount || 0 }} 点赞{{ c.averageScore ? ' · ' + c.averageScore.toFixed(1) + ' 分' : '' }}</text>
        </view>
      </view>
    </block>
  </view>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { onLoad } from '@dcloudio/uni-app'
import LoadingState from '@/components/LoadingState.vue'
import EmptyState from '@/components/EmptyState.vue'
import { getHotWordsApi, searchArticlesApi, getSearchHistory, addSearchHistory, clearSearchHistory as clearHistoryApi } from '@/api/search'
import { searchCoursesApi } from '@/api/course'
import type { ArticleDto } from '@/types/article'
import type { Course } from '@/types/course'

const statusBarHeight = ref<number>(0)
const navContentHeight = ref<number>(44)
const searchRowPx = ref<number>(56)
const sysInfo = uni.getSystemInfoSync()
statusBarHeight.value = sysInfo.statusBarHeight || 0
searchRowPx.value = Math.round(96 * sysInfo.windowWidth / 750)
// #ifdef MP-WEIXIN
const menuButton = uni.getMenuButtonBoundingClientRect()
if (menuButton) { navContentHeight.value = (menuButton.top - statusBarHeight.value) * 2 + menuButton.height }
// #endif
const navTotalHeight = computed<number>(() => statusBarHeight.value + navContentHeight.value + searchRowPx.value)

const autoFocus = ref<boolean>(true)
const keyword = ref<string>('')
const type = ref<number>(1)          // 1 文章  2 课程
const searched = ref<boolean>(false)
const state = ref<'loading' | 'ready'>('ready')

const history = ref<string[]>([])
const hotWords = ref<string[]>([])
const articles = ref<ArticleDto[]>([])
const courses = ref<Course[]>([])
const resultCount = computed<number>(() => (type.value === 1 ? articles.value.length : courses.value.length))

async function doSearch() {
  const kw = keyword.value.trim()
  if (!kw) { uni.showToast({ title: '请输入关键词', icon: 'none' }); return }
  addSearchHistory(kw)
  history.value = getSearchHistory()
  searched.value = true
  state.value = 'loading'
  try {
    if (type.value === 1) articles.value = await searchArticlesApi(kw)
    else courses.value = await searchCoursesApi(kw)
    state.value = 'ready'
  } catch (e) { state.value = 'ready' }
}

function switchType(t: number) {
  if (type.value === t) return
  type.value = t
  if (searched.value) doSearch()
}
function tapKeyword(w: string) { keyword.value = w; doSearch() }
function clearHistory() { clearHistoryApi(); history.value = [] }
function openArticle(a: ArticleDto) { uni.navigateTo({ url: `/pages-sub/article/detail?articleId=${a.articleId}` }) }
function openCourse(c: Course) { uni.showToast({ title: `课程详情开发中：${c.title}`, icon: 'none' }) }
function goBack() {
  const pages = getCurrentPages()
  if (pages.length > 1) uni.navigateBack()
  else uni.reLaunch({ url: '/pages/index/index' })
}

onLoad(async (query) => {
  if (query && query.type) type.value = Number(query.type) === 2 ? 2 : 1
  if (query && query.keyword) { keyword.value = query.keyword; doSearch() }
  history.value = getSearchHistory()
  hotWords.value = (await getHotWordsApi()) || []
})
</script>

<style lang="scss" scoped>
.search-page { min-height: 100vh; box-sizing: border-box; padding: 0 32rpx 60rpx; @include eduPageGradientStrong; }
.nav-bar { position: fixed; top: 0; left: 0; right: 0; z-index: 99; background: rgba(255, 255, 255, 0.92); }
.nav-bar-inner { display: flex; align-items: center; padding-left: 8rpx; padding-right: 8rpx; }
.nav-back { width: 64rpx; height: 72rpx; display: flex; align-items: center; justify-content: center; }
.back-icon { font-size: 44rpx; color: $edu-text-primary; }
.nav-title { font-size: 34rpx; font-weight: 700; color: $edu-text-primary; margin-left: 8rpx; }
.search-row { display: flex; align-items: center; padding: 0 32rpx 24rpx; }
.search-box { flex: 1; height: 72rpx; border-radius: 36rpx; background-color: $edu-primary-container; display: flex; align-items: center; padding: 0 28rpx; }
.search-input { flex: 1; font-size: 28rpx; color: $edu-text-primary; }
.search-ph { color: $edu-text-hint; font-size: 28rpx; }
.search-go { font-size: 30rpx; color: $edu-primary; font-weight: 600; padding: 0 16rpx; }

.type-tabs { display: flex; align-items: center; margin-top: 8rpx; border-bottom: 2rpx solid $edu-divider; }
.type-tab { position: relative; flex: 1; height: 88rpx; display: flex; align-items: center; justify-content: center; }
.type-tab-text { font-size: 30rpx; color: $edu-text-secondary; }
.type-tab-active .type-tab-text { font-size: 32rpx; font-weight: 700; color: $edu-primary; }
.type-underline { position: absolute; bottom: 0; left: 50%; transform: translateX(-50%); width: 96rpx; height: 6rpx; border-radius: 3rpx; background: $edu-primary; }

.section { margin-top: 40rpx; }
.section-head { display: flex; align-items: center; justify-content: space-between; }
.section-title { font-size: 32rpx; font-weight: 700; color: $edu-text-primary; }
.section-clear { font-size: 26rpx; color: $edu-text-hint; }
.history-pills { display: flex; flex-wrap: wrap; margin-top: 24rpx; }
.history-pill { padding: 14rpx 36rpx; border-radius: 32rpx; margin: 0 20rpx 20rpx 0; @include eduSurfaceWash; }
.history-pill-text { font-size: 28rpx; color: $edu-text-secondary; }

.hot-grid { display: flex; flex-wrap: wrap; margin-top: 24rpx; }
.hot-item { width: 33.33%; display: flex; align-items: center; margin-bottom: 28rpx; padding-right: 12rpx; box-sizing: border-box; }
.hot-rank { font-size: 30rpx; font-weight: 800; color: $edu-text-hint; margin-right: 12rpx; font-style: italic; }
.hot-rank-top { color: $edu-primary; }
.hot-word { font-size: 28rpx; color: $edu-text-primary; }

.result-list { margin-top: 24rpx; }
.result-card { padding: 28rpx 0; border-bottom: 2rpx solid $edu-divider; }
.result-title { display: block; font-size: 32rpx; font-weight: 600; color: $edu-text-primary; line-height: 1.4; }
.result-sub { display: block; font-size: 26rpx; color: $edu-text-hint; margin-top: 12rpx; }
</style>
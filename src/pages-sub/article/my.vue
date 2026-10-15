<template>
  <view class="my-articles-page">
    <view class="nav-bar" :class="{ 'nav-bar-opaque': navBarOpaque }" :style="{ paddingTop: statusBarHeight + 'px' }">
      <view class="nav-bar-inner" :style="{ height: navContentHeight + 'px' }">
        <view class="nav-back" @tap="goBack"><text class="back-icon">←</text></view>
        <text class="nav-title">我的发布</text>
      </view>
    </view>
    <view class="nav-placeholder" :style="{ height: (statusBarHeight + navContentHeight) + 'px' }"></view>

    <!-- 状态 Tab -->
    <scroll-view class="status-tabs" scroll-x :show-scrollbar="false">
      <view class="status-tabs-inner">
        <view
            v-for="tab in ARTICLE_STATUS_TABS"
            :key="String(tab.value)"
            class="status-pill"
            :class="{ 'status-pill-active': activeStatus === tab.value }"
            @tap="handleTab(tab.value)"
        >
          <text class="status-pill-text">{{ tab.label }}</text>
        </view>
      </view>
    </scroll-view>

    <LoadingState v-if="state === 'loading'" text="正在加载…" />
    <ErrorState v-else-if="state === 'error'" text="加载失败" @retry="loadList" />
    <EmptyState
        v-else-if="list.length === 0"
        text="还没有内容，去写一篇文章吧"
        action-text="去发布"
        @action="goPublish"
    />
    <view class="art-list" v-else>
      <view v-for="a in list" :key="a.articleId" class="art-card">
        <text class="art-title" @tap="handleView(a)">{{ a.title }}</text>
        <text class="art-summary" v-if="a.summary">{{ a.summary }}</text>

        <!-- 驳回原因 -->
        <view class="reject-box" v-if="a.status === 3 && a.rejectReason">
          <text class="reject-text">驳回原因：{{ a.rejectReason }}</text>
        </view>

        <view class="art-foot">
          <view class="art-meta">
            <text class="status-tag" :class="'st-' + a.status">{{ statusText(a.status) }}</text>
            <text class="meta-text">{{ formatCount(a.viewCount) }} 阅读 · {{ a.likeCount }} 赞</text>
          </view>
        </view>

        <!-- 操作按钮：按状态显示 -->
        <view class="art-actions">
          <template v-if="a.status === 0">
            <text class="act-btn" @tap="handleEdit(a)">编辑</text>
            <text class="act-btn act-primary" @tap="handleSubmit(a)">提交审核</text>
            <text class="act-btn act-danger" @tap="handleDelete(a)">删除</text>
          </template>
          <template v-else-if="a.status === 1">
            <text class="act-tip">审核中，请耐心等待</text>
            <text class="act-btn act-danger" @tap="handleDelete(a)">删除</text>
          </template>
          <template v-else-if="a.status === 2">
            <text class="act-btn" @tap="handleView(a)">查看</text>
            <text class="act-btn" @tap="handleWithdraw(a)">撤回</text>
            <text class="act-btn act-danger" @tap="handleDelete(a)">删除</text>
          </template>
          <template v-else-if="a.status === 3">
            <text class="act-btn act-primary" @tap="handleEdit(a)">修改重提</text>
            <text class="act-btn act-danger" @tap="handleDelete(a)">删除</text>
          </template>
          <template v-else>
            <text class="act-btn" @tap="handleView(a)">查看</text>
            <text class="act-btn act-danger" @tap="handleDelete(a)">删除</text>
          </template>
        </view>
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { onLoad, onShow, onPageScroll } from '@dcloudio/uni-app'
import LoadingState from '@/components/LoadingState.vue'
import ErrorState from '@/components/ErrorState.vue'
import EmptyState from '@/components/EmptyState.vue'
import {
  getMyArticlesApi,
  withdrawArticleApi,
  deleteArticleApi,
  submitArticleApi,
  ARTICLE_STATUS_TABS,
  ARTICLE_STATUS_TEXT,
  type MyArticleDto
} from '@/api/article'

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

const activeStatus = ref<number | ''>('')
const list = ref<MyArticleDto[]>([])
const state = ref<'loading' | 'error' | 'ready'>('loading')

function statusText(s: number): string {
  return ARTICLE_STATUS_TEXT[s] || '未知'
}
function formatCount(n: number): string {
  if (n >= 10000) return (n / 10000).toFixed(1) + '万'
  return String(n)
}

async function loadList() {
  state.value = 'loading'
  try {
    const res = await getMyArticlesApi(activeStatus.value === '' ? undefined : activeStatus.value)
    list.value = res || []
    state.value = 'ready'
  } catch (e) {
    state.value = 'error'
  }
}

function handleTab(v: number | '') {
  activeStatus.value = v
  loadList()
}

function handleView(a: MyArticleDto) {
  uni.navigateTo({ url: `/pages-sub/article/detail?articleId=${a.articleId}` })
}
function handleEdit(a: MyArticleDto) {
  uni.navigateTo({ url: `/pages-sub/article/publish?articleId=${a.articleId}` })
}
function goPublish() {
  uni.navigateTo({ url: '/pages-sub/article/publish' })
}

async function handleSubmit(a: MyArticleDto) {
  await submitArticleApi(a.articleId)
  await loadList()
  uni.showToast({ title: '已提交审核', icon: 'none' })
}
async function handleWithdraw(a: MyArticleDto) {
  uni.showModal({
    title: '撤回文章',
    content: `确定撤回《${a.title}》并改为草稿吗？`,
    confirmColor: '#3677EF',
    success: async (r) => {
      if (!r.confirm) return
      await withdrawArticleApi(a.articleId)
      await loadList()
      uni.showToast({ title: '已撤回为草稿', icon: 'none' })
    }
  })
}
function handleDelete(a: MyArticleDto) {
  uni.showModal({
    title: '删除文章',
    content: `确定删除《${a.title}》吗？此操作不可恢复。`,
    confirmColor: '#D04030',
    success: async (r) => {
      if (!r.confirm) return
      await deleteArticleApi(a.articleId)
      await loadList()
      uni.showToast({ title: '已删除', icon: 'none' })
    }
  })
}

function goBack() {
  const pages = getCurrentPages()
  if (pages.length > 1) uni.navigateBack()
  else uni.reLaunch({ url: '/pages/index/index' })
}

onLoad((query) => {
  // 支持 blog-home 带 ?status= 进入并定位到对应 Tab
  if (query && query.status !== undefined && query.status !== '') {
    const s = Number(query.status)
    if (!isNaN(s)) activeStatus.value = s
  }
})
onShow(() => { loadList() })
</script>

<style lang="scss" scoped>
.my-articles-page {
  min-height: 100vh; box-sizing: border-box; padding: 0 32rpx 60rpx;
  @include eduPageGradientStrong;
}
.nav-bar {
  position: fixed; top: 0; left: 0; right: 0; z-index: 99; background: transparent;
  transition: background-color 0.3s ease, box-shadow 0.3s ease;
}
.nav-bar-opaque { background: #FFFFFF; box-shadow: 0 2rpx 12rpx rgba(0, 0, 0, 0.06); }
.nav-bar-inner { display: flex; align-items: center; padding-left: 16rpx; }
.nav-back { width: 72rpx; height: 72rpx; display: flex; align-items: center; justify-content: center; }
.back-icon { font-size: 44rpx; color: $edu-text-primary; }
.nav-title { font-size: 40rpx; font-weight: 700; color: $edu-text-primary; margin-left: 8rpx; }

.status-tabs { white-space: nowrap; margin-top: 24rpx; }
.status-tabs-inner { display: inline-flex; align-items: center; }
.status-pill {
  display: inline-flex; align-items: center; justify-content: center;
  height: 72rpx; padding: 0 40rpx; border-radius: 36rpx; margin-right: 20rpx;
  @include eduSurfaceWash; box-shadow: 0 4rpx 12rpx rgba(0, 0, 0, 0.03);
}
.status-pill-active { background: $edu-primary; .status-pill-text { color: #FFFFFF; font-weight: 600; } }
.status-pill-text { font-size: 28rpx; color: $edu-text-secondary; }

.art-list { margin-top: 24rpx; }
.art-card {
  padding: 32rpx; margin-bottom: 24rpx; border-radius: 28rpx;
  background-color: $edu-surface; box-shadow: 0 8rpx 24rpx rgba(0, 0, 0, 0.04);
}
.art-title {
  display: block; font-size: 32rpx; font-weight: 700; color: $edu-text-primary; line-height: 1.4;
  display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;
}
.art-summary {
  display: block; font-size: 26rpx; color: $edu-text-secondary; line-height: 1.5; margin-top: 16rpx;
  display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;
}
.reject-box {
  margin-top: 16rpx; padding: 16rpx 20rpx; border-radius: 16rpx;
  background-color: $edu-error-container;
}
.reject-text { font-size: 24rpx; color: $edu-error-text; line-height: 1.4; }

.art-foot { margin-top: 20rpx; }
.art-meta { display: flex; align-items: center; }
.status-tag {
  font-size: 22rpx; padding: 4rpx 16rpx; border-radius: 8rpx; margin-right: 16rpx;
  background-color: $edu-surface-variant; color: $edu-text-secondary;
}
.st-0 { background-color: $edu-surface-variant; color: $edu-text-secondary; }
.st-1 { background-color: #FFF8E8; color: $edu-accent-yellow; }
.st-2 { background-color: #DCF2F5; color: $edu-accent-teal; }
.st-3 { background-color: $edu-error-container; color: $edu-accent-coral; }
.st-4 { background-color: $edu-surface-variant; color: $edu-text-hint; }
.meta-text { font-size: 24rpx; color: $edu-text-hint; }

.art-actions {
  display: flex; align-items: center; justify-content: flex-end;
  margin-top: 24rpx; padding-top: 20rpx; border-top: 2rpx solid $edu-divider;
}
.act-tip { font-size: 24rpx; color: $edu-text-hint; margin-right: auto; }
.act-btn {
  font-size: 26rpx; color: $edu-text-secondary; padding: 8rpx 28rpx;
  margin-left: 16rpx; border-radius: 32rpx; border: 2rpx solid $edu-outline;
}
.act-primary { color: $edu-primary; border-color: $edu-primary; }
.act-danger { color: $edu-accent-coral; border-color: $edu-accent-coral; }
</style>
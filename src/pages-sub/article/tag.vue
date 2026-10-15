<template>
  <view class="tag-page">
    <view class="nav-bar" :class="{ 'nav-bar-opaque': navBarOpaque }" :style="{ paddingTop: statusBarHeight + 'px' }">
      <view class="nav-bar-inner" :style="{ height: navContentHeight + 'px' }">
        <view class="nav-back" @tap="goBack"><text class="back-icon">←</text></view>
        <text class="nav-title">标签</text>
      </view>
    </view>
    <view class="nav-placeholder" :style="{ height: (statusBarHeight + navContentHeight) + 'px' }"></view>

    <view class="tag-hero">
      <text class="tag-hero-name">#{{ tagName }}</text>
      <text class="tag-hero-count">{{ list.length }} 篇文章</text>
    </view>

    <LoadingState v-if="state === 'loading'" text="正在加载…" />
    <ErrorState v-else-if="state === 'error'" text="加载失败" @retry="loadList" />
    <EmptyState v-else-if="list.length === 0" text="该标签下还没有文章" />
    <view class="article-list" v-else>
      <view v-for="(a, i) in list" :key="a.articleId" class="article-item" :class="{ 'article-divider': i < list.length - 1 }" @tap="handleOpen(a)">
        <view class="article-main">
          <text class="article-title">{{ a.title }}</text>
          <text class="article-summary" v-if="a.summary">{{ a.summary }}</text>
          <view class="article-meta">
            <text class="meta-count">{{ formatCount(a.viewCount) }} 阅读</text>
            <text class="meta-count">{{ a.commentCount }} 评论</text>
          </view>
        </view>
        <image v-if="a.coverUrl" class="article-cover" :src="a.coverUrl" mode="aspectFill" />
        <view v-else class="article-cover article-cover-ph"></view>
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
import { getArticlesByTagApi } from '@/api/article'
import type { ArticleDto } from '@/types/article'

const statusBarHeight = ref<number>(0)
const navContentHeight = ref<number>(44)
const sysInfo = uni.getSystemInfoSync()
statusBarHeight.value = sysInfo.statusBarHeight || 0
// #ifdef MP-WEIXIN
const menuButton = uni.getMenuButtonBoundingClientRect()
if (menuButton) { navContentHeight.value = (menuButton.top - statusBarHeight.value) * 2 + menuButton.height }
// #endif
const navBarOpaque = ref<boolean>(false)
onPageScroll((e) => { navBarOpaque.value = e.scrollTop > 40 })

const tagId = ref<number>(0)
const tagName = ref<string>('')
const list = ref<ArticleDto[]>([])
const state = ref<'loading' | 'error' | 'ready'>('loading')

function formatCount(n: number): string { return n >= 10000 ? (n / 10000).toFixed(1) + '万' : String(n) }

async function loadList() {
  state.value = 'loading'
  try { list.value = (await getArticlesByTagApi(tagId.value)) || []; state.value = 'ready' }
  catch (e) { state.value = 'error' }
}
function handleOpen(a: ArticleDto) { uni.navigateTo({ url: `/pages-sub/article/detail?articleId=${a.articleId}` }) }
function goBack() {
  const pages = getCurrentPages()
  if (pages.length > 1) uni.navigateBack()
  else uni.reLaunch({ url: '/pages/index/index' })
}

onLoad((query) => {
  tagId.value = Number((query && query.tagId) || 0)
  tagName.value = query && query.tagName ? decodeURIComponent(query.tagName) : '标签'
  loadList()
})
</script>

<style lang="scss" scoped>
.tag-page { min-height: 100vh; box-sizing: border-box; padding: 0 32rpx 60rpx; @include eduPageGradientStrong; }
.nav-bar { position: fixed; top: 0; left: 0; right: 0; z-index: 99; background: transparent; transition: background-color 0.3s ease, box-shadow 0.3s ease; }
.nav-bar-opaque { background: #FFFFFF; box-shadow: 0 2rpx 12rpx rgba(0, 0, 0, 0.06); }
.nav-bar-inner { display: flex; align-items: center; padding-left: 16rpx; }
.nav-back { width: 72rpx; height: 72rpx; display: flex; align-items: center; justify-content: center; }
.back-icon { font-size: 44rpx; color: $edu-text-primary; }
.nav-title { font-size: 40rpx; font-weight: 700; color: $edu-text-primary; margin-left: 8rpx; }

.tag-hero { margin-top: 24rpx; padding: 40rpx 32rpx; border-radius: 32rpx; @include eduSoftBlueGradient; }
.tag-hero-name { display: block; font-size: 48rpx; font-weight: 800; color: $edu-primary; }
.tag-hero-count { display: block; font-size: 26rpx; color: $edu-text-secondary; margin-top: 12rpx; }

.article-list { margin-top: 24rpx; }
.article-item { position: relative; display: flex; align-items: flex-start; padding: 32rpx 0; }
.article-divider::after { content: ''; position: absolute; left: 0; right: 0; bottom: 0; height: 2rpx; background: rgba(0, 0, 0, 0.05); }
.article-main { flex: 1; display: flex; flex-direction: column; padding-right: 24rpx; }
.article-title { font-size: 32rpx; font-weight: 700; color: $edu-text-primary; line-height: 1.4; margin-bottom: 12rpx; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; }
.article-summary { font-size: 28rpx; color: $edu-text-secondary; line-height: 1.5; margin-bottom: 16rpx; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; }
.article-meta { display: flex; align-items: center; }
.meta-count { font-size: 26rpx; color: $edu-text-hint; margin-right: 24rpx; }
.article-cover { width: 220rpx; height: 150rpx; border-radius: 16rpx; flex-shrink: 0; }
.article-cover-ph { background: linear-gradient(135deg, #DCE8FF 0%, #5B8DEF 100%); }
</style>
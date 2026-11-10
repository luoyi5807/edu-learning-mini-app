<template>
  <view class="community-panel">
    <!-- 搜索 + 发布（放大镜在搜索框内右侧，发布按钮独立在搜索框外） -->
    <view class="top-row">
      <view class="search-box" @tap="goSearch">
        <text class="search-placeholder-text">搜索文章</text>
        <text class="search-icon">🔍</text>
      </view>
      <view class="publish-btn" hover-class="publish-btn-pressed" @tap="goPublish">
        <text class="publish-icon">＋</text>
      </view>
    </view>

    <!-- 分类胶囊 -->
    <scroll-view class="category-tabs" scroll-x :show-scrollbar="false">
      <view class="tabs-inner">
        <view
            v-for="cat in categories"
            :key="cat.categoryId"
            class="tab-pill"
            :class="{ 'tab-pill-active': activeCategoryId === cat.categoryId }"
            @tap="handleCategory(cat.categoryId)"
        >
          <text class="tab-pill-text">{{ cat.categoryName }}</text>
        </view>
      </view>
    </scroll-view>

    <!-- 排序：最新 / 最热 / 精华 -->
    <view class="sort-tabs">
      <view
          v-for="s in sortTabs"
          :key="s.value"
          class="sort-item"
          :class="{ 'sort-item-active': activeSort === s.value }"
          @tap="handleSort(s.value)"
      >
        <text class="sort-text">{{ s.label }}</text>
        <view class="sort-underline" v-if="activeSort === s.value"></view>
      </view>
    </view>

    <!-- 广告位：微信流量主 Banner（AD_BANNER_COMMUNITY 为空时不渲染） -->
    <ad v-if="AD_BANNER_COMMUNITY" class="ad-slot" :unit-id="AD_BANNER_COMMUNITY"></ad>
    <view v-else class="ad-slot"><text class="ad-slot-text">广告位 · community_home_banner</text></view>

    <LoadingState v-if="state === 'loading'" text="正在加载文章…" />
    <ErrorState v-else-if="state === 'error'" text="文章加载失败" @retry="loadArticles" />
    <EmptyState v-else-if="list.length === 0" text="还没有文章，点右上角＋写第一篇吧" />
    <view class="article-list" v-else>
      <view
          v-for="a in list"
          :key="a.articleId"
          class="article-card"
          hover-class="article-card-pressed"
          @tap="handleOpen(a)"
      >
        <view class="article-title-row">
          <text class="essence-badge" v-if="a.essence === 1">精华</text>
          <text class="article-title">{{ a.title }}</text>
        </view>
        <text class="article-summary" v-if="a.summary">{{ a.summary }}</text>
        <view class="article-meta">
          <image
              v-if="a.authorAvatar"
              class="author-avatar author-avatar-img"
              :src="a.authorAvatar"
              mode="aspectFill"
          />
          <view v-else class="author-avatar"><text class="author-char">{{ charOf(a.authorName) }}</text></view>
          <text class="author-name">{{ a.authorName }}</text>
          <text class="meta-count">{{ a.viewCount }} 阅读</text>
          <text class="meta-count">{{ a.commentCount }} 评论</text>
        </view>
      </view>
    </view>

    <view class="load-more" v-if="list.length > 0 && hasMore" @tap="handleLoadMore">
      <text class="load-more-text">{{ loadingMore ? '加载中...' : '点击加载更多' }}</text>
    </view>
    <view class="load-more" v-else-if="list.length > 0">
      <text class="load-more-end-text">没有更多了</text>
    </view>
  </view>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import LoadingState from '@/components/LoadingState.vue'
import ErrorState from '@/components/ErrorState.vue'
import EmptyState from '@/components/EmptyState.vue'
import { getArticleListApi } from '@/api/article'
import { getArticleCategoryTreeApi, type CategoryNode } from '@/api/category'
import type { ArticleDto } from '@/types/article'
import { AD_BANNER_COMMUNITY } from '@/config/env'

const PAGE_SIZE = 20
const sortTabs = [
  { label: '最新', value: 1 },
  { label: '最热', value: 2 },
  { label: '精华', value: 3 }
]

const activeCategoryId = ref<number>(0)
const activeSort = ref<number>(1)
const categories = ref<CategoryNode[]>([{ categoryId: 0, categoryName: '全部' }])

const list = ref<ArticleDto[]>([])
const total = ref<number>(0)
const pageNum = ref<number>(1)
const state = ref<'loading' | 'error' | 'ready'>('loading')
const loadingMore = ref<boolean>(false)
const hasMore = computed<boolean>(() => list.value.length < total.value)

function charOf(name: string): string {
  return (name || 'U').charAt(0)
}

function queryParams(page: number) {
  return { categoryId: activeCategoryId.value, sort: activeSort.value, pageNum: page, pageSize: PAGE_SIZE }
}

async function loadArticles() {
  state.value = 'loading'
  pageNum.value = 1
  try {
    const res = await getArticleListApi(queryParams(1))
    list.value = res.list
    total.value = res.total
    state.value = 'ready'
  } catch (e) {
    state.value = 'error'
  }
}

async function handleLoadMore() {
  if (loadingMore.value || !hasMore.value) return
  loadingMore.value = true
  try {
    const next = pageNum.value + 1
    const res = await getArticleListApi(queryParams(next))
    list.value = list.value.concat(res.list)
    total.value = res.total
    pageNum.value = next
  } finally {
    loadingMore.value = false
  }
}

function handleCategory(id: number) {
  if (activeCategoryId.value === id) return
  activeCategoryId.value = id
  loadArticles()
}
function handleSort(v: number) {
  if (activeSort.value === v) return
  activeSort.value = v
  loadArticles()
}

function handleOpen(a: ArticleDto) {
  uni.navigateTo({ url: `/pages-sub/article/detail?articleId=${a.articleId}` })
}
function goSearch() { uni.navigateTo({ url: '/pages-sub/search/search?type=1' }) }
function goPublish() { uni.navigateTo({ url: '/pages-sub/article/publish' }) }

onMounted(async () => {
  loadArticles()
  try {
    const cats = await getArticleCategoryTreeApi()
    if (cats.length > 0) {
      categories.value = [{ categoryId: 0, categoryName: '全部' } as CategoryNode].concat(cats)
    }
  } catch (e) {
    // 分类接口失败时只保留「全部」，列表本身仍可浏览
  }
})
</script>

<style lang="scss" scoped>
/* 社区 Tab 主题色（配色方案 §五：红棕主色 + 浅粉容器） */
$community-primary: #A8453C;
$community-container: #FBE4E0;

.community-panel {
  padding: 0 32rpx calc(200rpx + env(safe-area-inset-bottom));
  @include eduPageGradientCommunity;
}

/* ===== 搜索 + 发布 ===== */
.top-row { display: flex; align-items: center; margin-top: 8rpx; }
.search-box {
  flex: 1; display: flex; align-items: center; height: 80rpx; border-radius: 40rpx;
  padding: 0 28rpx; background-color: $edu-surface;
  box-shadow: 0 2rpx 10rpx rgba(0, 0, 0, 0.04);
}
.search-placeholder-text { flex: 1; font-size: 28rpx; color: $edu-text-hint; }
.search-icon { font-size: 36rpx; color: $edu-primary; }
.publish-btn {
  width: 80rpx; height: 80rpx; flex-shrink: 0; margin-left: 8rpx;
  display: flex; align-items: center; justify-content: center;
}
.publish-btn-pressed { opacity: 0.6; }
.publish-icon { font-size: 52rpx; font-weight: 600; color: $edu-primary; }

/* ===== 分类胶囊 ===== */
.category-tabs { margin-top: 24rpx; white-space: nowrap; }
.tabs-inner { display: inline-flex; align-items: center; }
.tab-pill {
  flex-shrink: 0; display: flex; align-items: center; justify-content: center;
  height: 72rpx; padding: 0 40rpx; border-radius: 36rpx; margin-right: 16rpx;
  border: 2rpx solid transparent; background-color: $edu-surface;
  box-shadow: 0 2rpx 10rpx rgba(0, 0, 0, 0.04);
}
.tab-pill-active {
  border-color: $community-primary;
  .tab-pill-text { color: $community-primary; font-weight: 600; }
}
.tab-pill-text { font-size: 28rpx; color: $edu-text-primary; }

/* ===== 排序 ===== */
.sort-tabs { display: flex; align-items: center; margin-top: 32rpx; padding: 0 8rpx; }
.sort-item { position: relative; margin-right: 56rpx; padding-bottom: 12rpx; }
.sort-text { font-size: 30rpx; color: $edu-text-secondary; }
.sort-item-active .sort-text { font-size: 32rpx; font-weight: 700; color: $edu-text-primary; }
.sort-underline {
  position: absolute; left: 50%; bottom: 0; transform: translateX(-50%);
  width: 40rpx; height: 6rpx; border-radius: 3rpx; background: $edu-primary;
}

/* ===== 广告位占位 ===== */
.ad-slot {
  margin-top: 28rpx; height: 200rpx; border-radius: 24rpx;
  background-color: rgba(255, 255, 255, 0.5);
  display: flex; align-items: center; justify-content: center;
}
.ad-slot-text { font-size: 28rpx; color: $edu-text-hint; }

/* ===== 文章卡片列表 ===== */
.article-list { margin-top: 28rpx; }
.article-card {
  padding: 32rpx; margin-bottom: 24rpx; border-radius: 20rpx;
  background-color: $edu-surface; box-shadow: 0 4rpx 20rpx rgba(0, 0, 0, 0.05);
}
.article-card-pressed { background-color: $edu-surface-variant; }
.article-title-row { display: flex; align-items: flex-start; }
.essence-badge {
  flex-shrink: 0; margin-top: 4rpx; margin-right: 12rpx; padding: 4rpx 14rpx;
  border-radius: 8rpx; background-color: $edu-primary; color: #FFFFFF;
  font-size: 22rpx; font-weight: 600;
}
.article-title {
  flex: 1; font-size: 34rpx; font-weight: 700; color: $edu-text-primary; line-height: 1.4;
  display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;
}
.article-summary {
  margin-top: 16rpx; font-size: 28rpx; color: $edu-text-secondary; line-height: 1.5;
  display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;
}
.article-meta { display: flex; align-items: center; margin-top: 24rpx; }
.author-avatar {
  width: 44rpx; height: 44rpx; border-radius: 50%; background-color: $community-container;
  display: flex; align-items: center; justify-content: center; margin-right: 12rpx; flex-shrink: 0;
}
.author-avatar-img { background-color: $edu-surface-variant; }
.author-char { font-size: 24rpx; color: $community-primary; font-weight: 600; }
.author-name { font-size: 26rpx; color: $edu-text-secondary; margin-right: 24rpx; }
.meta-count { font-size: 26rpx; color: $edu-text-hint; margin-right: 24rpx; }

/* ===== 加载更多 ===== */
.load-more { padding: 8rpx 0 24rpx; display: flex; justify-content: center; }
.load-more-text { font-size: 26rpx; color: $edu-primary; }
.load-more-end-text { font-size: 26rpx; color: $edu-text-hint; }
</style>
<template>
  <view class="community-panel">
    <!-- 搜索框（点击进入搜索页 type=1） -->
    <view class="search-box" @tap="goSearch">
      <text class="search-placeholder-text">搜索文章</text>
      <text class="search-icon">🔍</text>
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

    <LoadingState v-if="state === 'loading'" text="正在加载文章…" />
    <ErrorState v-else-if="state === 'error'" text="文章加载失败" @retry="loadArticles" />
    <EmptyState v-else-if="list.length === 0" text="还没有文章，来写第一篇吧" />
    <view class="article-list" v-else>
      <view
          v-for="(a, i) in list"
          :key="a.articleId"
          class="article-item"
          :class="{ 'article-divider': i < list.length - 1 }"
          @tap="handleOpen(a)"
      >
        <view class="article-main">
          <text class="article-title">{{ a.title }}</text>
          <text class="article-summary" v-if="a.summary">{{ a.summary }}</text>
          <view class="article-meta">
            <view class="author-avatar"><text class="author-char">{{ charOf(a.authorName) }}</text></view>
            <text class="author-name">{{ a.authorName }}</text>
            <text class="meta-count">{{ formatCount(a.viewCount) }} 阅读</text>
            <text class="meta-count">{{ a.commentCount }} 评论</text>
          </view>
        </view>
        <image v-if="a.coverUrl" class="article-cover" :src="a.coverUrl" mode="aspectFill" />
        <view v-else class="article-cover article-cover-ph"></view>
      </view>
    </view>

    <view class="load-more" v-if="list.length > 0 && hasMore" @tap="handleLoadMore">
      <text class="load-more-text">{{ loadingMore ? '加载中...' : '点击加载更多' }}</text>
    </view>
    <view class="load-more" v-else-if="list.length > 0">
      <text class="load-more-end-text">没有更多了</text>
    </view>

    <!-- 发布 FAB -->
    <view class="fab" hover-class="fab-pressed" @tap="goPublish">
      <text class="fab-icon">＋</text>
    </view>
  </view>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import LoadingState from '@/components/LoadingState.vue'
import ErrorState from '@/components/ErrorState.vue'
import EmptyState from '@/components/EmptyState.vue'
import { getArticleListApi } from '@/api/article'
import { getArticleCategoryTreeApi, type CategoryNode } from '@/api/category'
import type { ArticleDto } from '@/types/article'

const categories = ref<CategoryNode[]>([{ categoryId: 0, categoryName: '全部' }])
const sortTabs = [
  { label: '最新', value: 1 },
  { label: '最热', value: 2 },
  { label: '精华', value: 3 }
]
const activeCategoryId = ref<number>(0)
const activeSort = ref<number>(1)

const list = ref<ArticleDto[]>([])
const state = ref<'loading' | 'error' | 'ready'>('loading')
const hasMore = ref<boolean>(false)
const loadingMore = ref<boolean>(false)

function charOf(name: string): string {
  return (name || 'U').charAt(0)
}
function formatCount(n: number): string {
  if (n >= 10000) return (n / 10000).toFixed(1) + '万'
  return String(n)
}

async function loadCategories() {
  const res = await getArticleCategoryTreeApi()
  categories.value = [{ categoryId: 0, categoryName: '全部' }].concat(res || [])
}

async function loadArticles() {
  state.value = 'loading'
  try {
    const res = await getArticleListApi({
      categoryId: activeCategoryId.value || undefined,
      sort: activeSort.value
    })
    list.value = (res as ArticleDto[]) || []
    state.value = 'ready'
  } catch (e) {
    state.value = 'error'
  }
}

function handleCategory(id: number) { activeCategoryId.value = id; loadArticles() }
function handleSort(v: number) { activeSort.value = v; loadArticles() }

function handleOpen(a: ArticleDto) {
  uni.navigateTo({ url: `/pages-sub/article/detail?articleId=${a.articleId}` })
}
function goSearch() { uni.navigateTo({ url: '/pages-sub/search/search?type=1' }) }
function goPublish() { uni.navigateTo({ url: '/pages-sub/article/publish' }) }
function handleLoadMore() {
  if (!loadingMore.value) uni.showToast({ title: '加载更多（接口待接入）', icon: 'none' })
}

onMounted(() => {
  loadCategories()
  loadArticles()
})
</script>

<style lang="scss" scoped>
.community-panel {
  padding: 0 32rpx calc(200rpx + env(safe-area-inset-bottom));
  @include eduPageGradientWeak;
}

/* ===== 搜索框 ===== */
.search-box {
  display: flex; align-items: center; height: 80rpx; border-radius: 40rpx;
  margin-top: 8rpx; padding: 0 24rpx; @include eduSurfaceWash;
}
.search-placeholder-text { flex: 1; font-size: 28rpx; color: $edu-text-hint; }
.search-icon { font-size: 40rpx; color: $edu-primary; }

/* ===== 分类胶囊 ===== */
.category-tabs { margin-top: 24rpx; white-space: nowrap; }
.tabs-inner { display: inline-flex; align-items: center; }
.tab-pill {
  flex-shrink: 0; display: flex; align-items: center; justify-content: center;
  height: 72rpx; padding: 0 40rpx; border-radius: 36rpx; margin-right: 16rpx;
  border: 2rpx solid transparent; @include eduSurfaceWash;
}
.tab-pill-active {
  background-color: $edu-primary-container; border-color: $edu-primary;
  .tab-pill-text { color: $edu-primary; font-weight: 600; }
}
.tab-pill-text { font-size: 28rpx; color: $edu-text-primary; }

/* ===== 排序 ===== */
.sort-tabs { display: flex; align-items: center; margin-top: 28rpx; padding: 0 8rpx; }
.sort-item { position: relative; margin-right: 56rpx; padding-bottom: 12rpx; }
.sort-text { font-size: 30rpx; color: $edu-text-secondary; }
.sort-item-active .sort-text { font-size: 32rpx; font-weight: 700; color: $edu-text-primary; }
.sort-underline {
  position: absolute; left: 50%; bottom: 0; transform: translateX(-50%);
  width: 40rpx; height: 6rpx; border-radius: 3rpx; background: $edu-primary;
}

/* ===== 文章列表 ===== */
.article-list { margin-top: 12rpx; }
.article-item { position: relative; display: flex; align-items: flex-start; padding: 32rpx 0; }
.article-divider::after {
  content: ''; position: absolute; left: 0; right: 0; bottom: 0;
  height: 2rpx; background: rgba(0, 0, 0, 0.05);
}
.article-main { flex: 1; display: flex; flex-direction: column; padding-right: 24rpx; }
.article-title {
  font-size: 34rpx; font-weight: 700; color: $edu-text-primary; line-height: 1.4; margin-bottom: 12rpx;
  display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;
}
.article-summary {
  font-size: 28rpx; color: $edu-text-secondary; line-height: 1.5; margin-bottom: 20rpx;
  display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;
}
.article-meta { display: flex; align-items: center; }
.author-avatar {
  width: 44rpx; height: 44rpx; border-radius: 50%; background-color: $edu-primary-container;
  display: flex; align-items: center; justify-content: center; margin-right: 12rpx; flex-shrink: 0;
}
.author-char { font-size: 24rpx; color: #0C2C6B; font-weight: 600; }
.author-name { font-size: 26rpx; color: $edu-text-secondary; margin-right: 24rpx; }
.meta-count { font-size: 26rpx; color: $edu-text-hint; margin-right: 24rpx; }
.article-cover { width: 220rpx; height: 150rpx; border-radius: 16rpx; flex-shrink: 0; }
.article-cover-ph { background: linear-gradient(135deg, #DCE8FF 0%, #5B8DEF 100%); }

/* ===== 加载更多 ===== */
.load-more { padding: 32rpx 0 24rpx; display: flex; justify-content: center; }
.load-more-text { font-size: 26rpx; color: $edu-primary; }
.load-more-end-text { font-size: 26rpx; color: $edu-text-hint; }

/* ===== 发布 FAB ===== */
.fab {
  position: fixed; right: 40rpx; bottom: calc(136rpx + env(safe-area-inset-bottom));
  width: 112rpx; height: 112rpx; border-radius: 50%;
  @include eduBrandGradient; box-shadow: 0 12rpx 28rpx rgba(54, 119, 239, 0.4);
  display: flex; align-items: center; justify-content: center; z-index: 90;
}
.fab-pressed { opacity: 0.9; }
.fab-icon { font-size: 56rpx; color: #FFFFFF; }
</style>
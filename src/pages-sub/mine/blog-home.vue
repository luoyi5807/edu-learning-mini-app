<template>
  <view class="blog-home-page">
    <!-- 固定顶部栏：返回 + 标题 + 通知 -->
    <view class="nav-bar" :class="{ 'nav-bar-opaque': navBarOpaque }" :style="{ paddingTop: statusBarHeight + 'px' }">
      <view class="nav-bar-inner" :style="{ height: navContentHeight + 'px' }">
        <view class="nav-back" @tap="goBack">
          <text class="back-icon">←</text>
        </view>
        <text class="nav-title">{{ isSelf ? '我的主页' : '个人主页' }}</text>
        <view class="nav-bell" @tap="goNotification">
          <text class="bell-icon">🔔</text>
          <view class="bell-dot" v-if="unreadCount > 0"></view>
        </view>
      </view>
    </view>
    <view class="nav-placeholder" :style="{ height: (statusBarHeight + navContentHeight) + 'px' }"></view>

    <!-- 资料卡 -->
    <view class="profile-card">
      <image v-if="avatarUrl" class="avatar-lg" :src="avatarUrl" mode="aspectFill" />
      <view v-else class="avatar-lg avatar-fallback">
        <text class="avatar-char">{{ avatarChar }}</text>
      </view>

      <text class="nickname">{{ nickname }}</text>
      <text class="bio">{{ bio }}</text>
      <text class="gender-text">{{ genderText }}</text>

      <view class="stats-row">
        <view class="stat-item">
          <text class="stat-num">{{ formatCount(stats.followingCount) }}</text>
          <text class="stat-label">关注</text>
        </view>
        <view class="stat-item">
          <text class="stat-num">{{ formatCount(stats.fansCount) }}</text>
          <text class="stat-label">粉丝</text>
        </view>
        <view class="stat-item">
          <text class="stat-num">{{ formatCount(stats.likeCount) }}</text>
          <text class="stat-label">获赞</text>
        </view>
      </view>

      <view
          class="primary-action"
          :class="{ 'primary-action-pressed': actionPressed }"
          @touchstart="actionPressed = true"
          @touchend="actionPressed = false"
          @touchcancel="actionPressed = false"
          @tap="handleAction"
      >
        <text class="primary-action-text">{{ isSelf ? '编辑主页' : (isFollowed ? '已关注' : '＋ 关注') }}</text>
      </view>
    </view>

    <!-- 粉丝预览卡（无粉丝数据时不渲染占位） -->
    <view class="fans-card" v-if="stats.fansCount > 0 && fanPreview.length > 0">
      <view class="fan-avatars">
        <view
            v-for="(fan, idx) in fanPreview"
            :key="idx"
            class="fan-avatar"
            :style="{ backgroundColor: fan.color }"
        >
          <text class="fan-char">{{ fan.char }}</text>
        </view>
      </view>
      <text class="fans-text">等 {{ formatCount(stats.fansCount) }} 人关注</text>
    </view>

    <!-- 我的文章 -->
    <text class="section-title">{{ isSelf ? '我的文章' : 'TA 的文章' }}</text>
    <LoadingState v-if="articleState === 'loading'" text="正在加载文章…" />
    <ErrorState v-else-if="articleState === 'error'" text="文章加载失败" @retry="loadArticles" />
    <EmptyState
        v-else-if="articles.length === 0"
        :text="isSelf ? '还没有发布过文章' : 'TA 还没有发布文章'"
        :action-text="isSelf ? '去发布' : ''"
        @action="handleGoMyArticles"
    />
    <view class="article-list" v-else>
      <view v-for="item in articles" :key="item.articleId" class="article-card">
        <text class="article-title" @tap="handleArticleTap(item)">{{ item.title }}</text>
        <view class="article-foot">
          <text class="article-meta">{{ formatCount(item.viewCount) }} 阅读 · {{ item.likeCount }} 赞</text>
          <view class="article-actions" v-if="isSelf">
            <text class="action-link" @tap="handleArticleEdit(item)">编辑</text>
            <text class="action-link action-link-danger" @tap="handleArticleDelete(item)">删除</text>
          </view>
        </view>
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { ref, reactive, computed } from 'vue'
import { onLoad, onShow, onPageScroll } from '@dcloudio/uni-app'
import LoadingState from '@/components/LoadingState.vue'
import ErrorState from '@/components/ErrorState.vue'
import EmptyState from '@/components/EmptyState.vue'
import { useAuthStore } from '@/store/auth'
import { resolveFileUrl, getUserPublicProfileApi, followUserApi, unfollowUserApi, getFollowStatusApi, getFollowCountApi } from '@/api/user'
import { getMyArticlesApi, getUserPublishedArticlesApi, deleteArticleApi, type MyArticleDto } from '@/api/article'
import { useNotification } from '@/composables/useNotification'

const auth = useAuthStore()
const { unreadCount, refreshUnread } = useNotification()

/* ===== 顶部栏高度（含状态栏 + 胶囊区） ===== */
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

/* ===== 顶栏滚动变白 ===== */
const scrollTop = ref<number>(0)
const navBarOpaque = computed<boolean>(() => scrollTop.value > 40)
onPageScroll((e) => {
  scrollTop.value = e.scrollTop
})

/* ===== 本人 / 他人主页（他人主页入口：?userId=xxx） ===== */
const visitorId = ref<string>('')
const isSelf = computed<boolean>(() => {
  if (!visitorId.value) return true
  return String(visitorId.value) === String(auth.state.user?.userId ?? '')
})

const nickname = ref<string>('')
const avatarChar = ref<string>('U')
const avatarUrl = ref<string>('')
const bio = ref<string>('')
const genderText = ref<string>('')

function resolveGender(sex?: string): string {
  if (sex === '0') return '男'
  if (sex === '1') return '女'
  return '未知'
}

/** 本人主页：直接读 auth store */
function loadSelfProfile() {
  const u = auth.state.user
  nickname.value = u?.nickName || u?.userName || '未登录'
  avatarChar.value = (nickname.value || 'U').charAt(0)
  avatarUrl.value = resolveFileUrl(u?.avatar)
  bio.value = u?.remark || '还没有个人简介，去编辑主页写一句吧～'
  genderText.value = resolveGender(u?.sex)
}

/** 他人主页：走公开资料接口（当前为 mock） */
async function loadVisitorProfile(userId: number) {
  try {
    const p = await getUserPublicProfileApi(userId)
    nickname.value = p.nickName || ('用户' + userId)
    avatarChar.value = (nickname.value || 'U').charAt(0)
    avatarUrl.value = resolveFileUrl(p.avatar)
    bio.value = p.remark || '这个人很懒，什么都没留下。'
    genderText.value = resolveGender(p.sex)
  } catch (e) {
    uni.showToast({ title: '用户不存在', icon: 'none' })
  }
}

onLoad((query) => {
  visitorId.value = (query && query.userId) ? String(query.userId) : ''
  // 接口接入：GET user/blog-home/{userId}，返回资料 + articleCount/totalViewCount/...
})

// 编辑主页保存返回后重新取一次，保证资料同步
onShow(() => {
  if (isSelf.value) {
    loadSelfProfile()
    loadStats(auth.state.user?.userId ?? '')
  } else {
    loadVisitorProfile(Number(visitorId.value))
    loadStats(Number(visitorId.value))
    loadFollowState(Number(visitorId.value))
  }
  loadArticles()
  refreshUnread()
})

/* ===== 关注 / 粉丝 / 获赞统计 =====
 * 待后端补接口后接入（字段名已与后端约定，勿随意改）：
 *   GET user/stats/{userId} → { followingCount, fansCount, likeCount, recentFans:[{userId,nickName,avatar}] }
 *   POST user/follow/toggle → { isFollowed, fansCount }
 */
const stats = reactive({
  followingCount: 0,
  fansCount: 0,
  likeCount: 0
})

const isFollowed = ref<boolean>(false)

interface FanPreviewItem { char: string; color: string; avatar?: string }
const fanPreview = ref<FanPreviewItem[]>([])

/** 关注体系：粉丝数/关注数走 GET /api/v1/follow/count（资料无 C 端接口，仍 mock） */
async function loadStats(userId: number | string) {
  const uid = Number(userId)
  if (!uid) return
  try {
    const res = await getFollowCountApi(uid)
    stats.followingCount = res.followCount || 0
    stats.fansCount = res.fansCount || 0
  } catch (e) { /* 未就绪/失败：保持 0 */ }
}

/** 回填关注按钮初始态：GET /api/v1/follow/status */
async function loadFollowState(targetUserId: number) {
  if (!targetUserId) return
  try {
    const ids = await getFollowStatusApi([targetUserId])
    isFollowed.value = ids.indexOf(targetUserId) >= 0
  } catch (e) {
    isFollowed.value = false
  }
}

function formatCount(n: number): string {
  if (n >= 10000) return (n / 10000).toFixed(1) + '万'
  return String(n)
}

/* ===== 文章列表：GET user/articles（复用 article/my 的数据源） ===== */
const articles = ref<MyArticleDto[]>([])
const articleState = ref<'loading' | 'error' | 'ready'>('loading')

async function loadArticles() {
  articleState.value = 'loading'
  try {
    if (isSelf.value) {
      const res = await getMyArticlesApi()
      // 本人主页只展示已发布
      articles.value = (res || []).filter((a) => a.status === 2)
    } else {
      // 他人主页：走 user/blog-home/{userId}/articles
      const res = await getUserPublishedArticlesApi(Number(visitorId.value))
      articles.value = res || []
    }
    articleState.value = 'ready'
  } catch (e) {
    articleState.value = 'error'
  }
}

function handleGoMyArticles() {
  uni.navigateTo({ url: '/pages-sub/article/my' })
}

const actionPressed = ref<boolean>(false)

function goBack() {
  const pages = getCurrentPages()
  if (pages.length > 1) {
    uni.navigateBack()
  } else {
    uni.reLaunch({ url: '/pages/index/index' })
  }
}

function goNotification() { uni.navigateTo({ url: '/pages-sub/notification/notification' }) }

function handleAction() {
  if (isSelf.value) {
    uni.navigateTo({ url: '/pages-sub/mine/edit-profile' })
    return
  }
  const target = Number(visitorId.value)
  if (!target) return
  toggleFollow(target)
}

/** 关注/取关：后端幂等 add/cancel（非 toggle），按当前态二选一 */
async function toggleFollow(targetUserId: number) {
  try {
    const res = isFollowed.value
      ? await unfollowUserApi(targetUserId)
      : await followUserApi(targetUserId)
    isFollowed.value = !!res.active
    if (res.fansCount != null) stats.fansCount = res.fansCount
    uni.showToast({ title: isFollowed.value ? '已关注' : '已取消关注', icon: 'none' })
  } catch (e) {
    uni.showToast({ title: '操作失败', icon: 'none' })
  }
}

function handleArticleTap(item: MyArticleDto) {
  uni.navigateTo({ url: `/pages-sub/article/detail?articleId=${item.articleId}` })
}

function handleArticleEdit(item: MyArticleDto) {
  uni.navigateTo({ url: `/pages-sub/article/publish?articleId=${item.articleId}` })
}

async function handleArticleDelete(item: MyArticleDto) {
  uni.showModal({
    title: '提示',
    content: `确定删除《${item.title}》吗？`,
    confirmColor: '#D04030',
    success: async (r) => {
      if (!r.confirm) return
      await deleteArticleApi(item.articleId)
      await loadArticles()
      uni.showToast({ title: '已删除', icon: 'none' })
    }
  })
}

</script>

<style lang="scss" scoped>
.blog-home-page {
  min-height: 100vh;
  box-sizing: border-box;
  padding: 0 32rpx 60rpx;
  @include eduPageGradientStrong;
}

/* ===== 固定顶部栏 ===== */
.nav-bar {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  z-index: 99;
  background: transparent;
  transition: background-color 0.3s ease, box-shadow 0.3s ease;
}
.nav-bar-opaque { background: #FFFFFF; box-shadow: 0 2rpx 12rpx rgba(0, 0, 0, 0.06); }
.nav-bar-inner { display: flex; align-items: center; padding-left: 16rpx; padding-right: 16rpx; }
.nav-back { width: 72rpx; height: 72rpx; display: flex; align-items: center; justify-content: center; }
.back-icon { font-size: 44rpx; color: $edu-text-primary; }
.nav-title { flex: 1; font-size: 40rpx; font-weight: 700; color: $edu-text-primary; margin-left: 8rpx; }
.nav-bell { position: relative; width: 72rpx; height: 72rpx; display: flex; align-items: center; justify-content: center; }
.bell-icon { font-size: 40rpx; }
.bell-dot { position: absolute; top: 18rpx; right: 18rpx; width: 16rpx; height: 16rpx; border-radius: 50%; background: $edu-accent-coral; }

/* ===== 资料卡 ===== */
.profile-card {
  margin-top: 24rpx;
  padding: 56rpx 32rpx 40rpx;
  border-radius: 32rpx;
  background-color: $edu-surface;
  box-shadow: 0 8rpx 24rpx rgba(0, 0, 0, 0.04);
  display: flex;
  flex-direction: column;
  align-items: center;
}
.avatar-lg { width: 200rpx; height: 200rpx; border-radius: 50%; }
.avatar-fallback {
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: $edu-primary;
}
.avatar-char { font-size: 88rpx; font-weight: 700; color: #FFFFFF; }
.nickname { font-size: 44rpx; font-weight: 700; color: $edu-text-primary; margin-top: 32rpx; }
.bio {
  font-size: 30rpx;
  color: $edu-text-secondary;
  line-height: 1.5;
  margin-top: 20rpx;
  text-align: center;
}
.gender-text { font-size: 28rpx; color: $edu-text-hint; margin-top: 16rpx; }

.stats-row { display: flex; width: 100%; justify-content: space-around; margin-top: 44rpx; }
.stat-item { display: flex; flex-direction: column; align-items: center; }
.stat-num { font-size: 44rpx; font-weight: 700; color: $edu-text-primary; }
.stat-label { font-size: 26rpx; color: $edu-text-hint; margin-top: 8rpx; }

.primary-action {
  width: 100%;
  height: 96rpx;
  margin-top: 44rpx;
  border-radius: 48rpx;
  border: 2rpx solid $edu-outline;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.15s;
}
.primary-action-pressed { background-color: $edu-surface-variant; }
.primary-action-text { font-size: 32rpx; font-weight: 600; color: $edu-primary; }

/* ===== 粉丝预览卡 ===== */
.fans-card {
  margin-top: 24rpx;
  padding: 32rpx;
  border-radius: 32rpx;
  @include eduSurfaceWash;
  display: flex;
  align-items: center;
  justify-content: space-between;
}
.fan-avatars { display: flex; align-items: center; }
.fan-avatar {
  width: 72rpx;
  height: 72rpx;
  border-radius: 50%;
  margin-left: -18rpx;
  border: 4rpx solid #FFFFFF;
  display: flex;
  align-items: center;
  justify-content: center;
  box-sizing: border-box;
}
.fan-avatar:first-child { margin-left: 0; }
.fan-char { font-size: 28rpx; font-weight: 600; color: #FFFFFF; }
.fans-text { font-size: 28rpx; color: $edu-text-secondary; }

/* ===== 我的文章 ===== */
.section-title {
  display: block;
  font-size: 36rpx;
  font-weight: 700;
  color: $edu-text-primary;
  margin: 44rpx 0 20rpx;
}
.article-card {
  padding: 32rpx;
  border-radius: 28rpx;
  background-color: $edu-surface;
  box-shadow: 0 4rpx 16rpx rgba(0, 0, 0, 0.03);
  margin-bottom: 20rpx;
}
.article-title {
  font-size: 32rpx;
  font-weight: 600;
  color: $edu-text-primary;
  line-height: 1.4;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
.article-foot {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-top: 20rpx;
}
.article-meta { font-size: 26rpx; color: $edu-text-hint; }
.article-actions { display: flex; align-items: center; }
.action-link { font-size: 28rpx; color: $edu-primary; margin-left: 44rpx; padding: 8rpx 0; }
.action-link-danger { color: $edu-accent-coral; }

/* ===== 空态 ===== */
.empty { padding: 120rpx 0; display: flex; justify-content: center; }
.empty-text { font-size: 28rpx; color: $edu-text-hint; }
</style>
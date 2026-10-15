<!-- src/pages-sub/notification/notification.vue -->
<template>
  <view class="notice-page">
    <!-- 固定顶部栏：返回 + 标题 + 全部已读 -->
    <view class="nav-bar" :class="{ 'nav-bar-opaque': navBarOpaque }" :style="{ paddingTop: statusBarHeight + 'px' }">
      <view class="nav-bar-inner" :style="{ height: navContentHeight + 'px' }">
        <view class="nav-back" @tap="goBack"><text class="back-icon">←</text></view>
        <text class="nav-title">通知</text>
        <view class="nav-action" @tap="handleReadAll"><text class="nav-action-text">全部已读</text></view>
      </view>
    </view>
    <view class="nav-placeholder" :style="{ height: (statusBarHeight + navContentHeight) + 'px' }"></view>

    <!-- 分类 Tab：点赞 / 评论 / 关注 / 收藏 -->
    <scroll-view class="type-tabs" scroll-x :show-scrollbar="false">
      <view class="type-tabs-inner">
        <view
            v-for="tab in NOTICE_TABS"
            :key="tab.value"
            class="type-pill"
            :class="{ 'type-pill-active': activeType === tab.value }"
            @tap="handleTab(tab.value)"
        >
          <text class="type-pill-text">{{ tab.label }}</text>
          <view class="type-pill-dot" v-if="unreadOf(tab.value) > 0"></view>
        </view>
      </view>
    </scroll-view>

    <LoadingState v-if="state === 'loading'" text="正在加载通知…" />
    <ErrorState v-else-if="state === 'error'" text="加载失败" @retry="loadList" />
    <EmptyState v-else-if="list.length === 0" :text="emptyText" />
    <view class="notice-list" v-else>
      <view
          v-for="n in list"
          :key="n.noticeId"
          class="notice-card"
          @tap="handleOpen(n)"
      >
        <view class="notice-head">
          <view class="notice-unread-dot" v-if="!n.isRead"></view>
          <text class="notice-title">{{ n.title }}</text>
          <text class="notice-time">{{ n.createTime }}</text>
        </view>
        <text class="notice-content" v-if="n.content">{{ n.content }}</text>
      </view>
    </view>
    <view class="bottom-space"></view>
  </view>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { onLoad, onShow, onPageScroll } from '@dcloudio/uni-app'
import LoadingState from '@/components/LoadingState.vue'
import ErrorState from '@/components/ErrorState.vue'
import EmptyState from '@/components/EmptyState.vue'
import {
  getNotificationsApi,
  markNoticeReadApi,
  markAllNoticeReadApi,
  NOTICE_TABS,
  type NotificationDto
} from '@/api/notification'
import { useNotification } from '@/composables/useNotification'

const { refreshUnread } = useNotification()

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
const navBarOpaque = ref<boolean>(false)
onPageScroll((e) => { navBarOpaque.value = e.scrollTop > 40 })

const activeType = ref<number>(1)
const list = ref<NotificationDto[]>([])
const state = ref<'loading' | 'error' | 'ready'>('loading')

const emptyText = computed<string>(() => {
  const tab = NOTICE_TABS.find((t) => t.value === activeType.value)
  return '还没有' + (tab ? tab.label : '') + '消息'
})

/** 各分类未读数：切到该 Tab 前用于红点提示 */
const unreadMap = ref<Record<number, number>>({})
function unreadOf(type: number): number {
  return unreadMap.value[type] || 0
}

async function loadUnreadBadges() {
  const res = await getNotificationsApi()
  const map: Record<number, number> = {}
  ;(res || []).forEach((n) => {
    if (!n.isRead) map[n.type] = (map[n.type] || 0) + 1
  })
  unreadMap.value = map
}

async function loadList() {
  state.value = 'loading'
  try {
    const res = await getNotificationsApi(activeType.value)
    list.value = res || []
    state.value = 'ready'
  } catch (e) {
    state.value = 'error'
  }
}

function handleTab(v: number) {
  activeType.value = v
  loadList()
}

async function handleOpen(n: NotificationDto) {
  if (!n.isRead) {
    n.isRead = true
    await markNoticeReadApi(n.noticeId)
    unreadMap.value = { ...unreadMap.value, [n.type]: Math.max(0, (unreadMap.value[n.type] || 0) - 1) }
    refreshUnread()
  }
  if (n.type === 3) {
    // 关注：跳对方主页
    if (n.actorUserId) uni.navigateTo({ url: `/pages-sub/mine/blog-home?userId=${n.actorUserId}` })
    return
  }
  // 点赞 / 评论 / 收藏：跳对应文章
  if (n.targetType === 1 && n.targetId) {
    uni.navigateTo({ url: `/pages-sub/article/detail?articleId=${n.targetId}` })
  }
}

async function handleReadAll() {
  const hasAnyUnread = list.value.some((n) => !n.isRead) || Object.values(unreadMap.value).some((c) => c > 0)
  if (!hasAnyUnread) return
  await markAllNoticeReadApi()
  list.value = list.value.map((n) => ({ ...n, isRead: true }))
  // markAllNoticeReadApi 会把所有分类置为已读，这里整体清空，避免其它 Tab 红点残留
  unreadMap.value = {}
  refreshUnread()
  uni.showToast({ title: '已全部标为已读', icon: 'none' })
}

function goBack() {
  const pages = getCurrentPages()
  if (pages.length > 1) uni.navigateBack()
  else uni.reLaunch({ url: '/pages/index/index' })
}

onLoad(() => { loadList() })
onShow(() => { loadUnreadBadges() })
</script>

<style lang="scss" scoped>
.notice-page {
  min-height: 100vh;
  box-sizing: border-box;
  padding: 0 32rpx 60rpx;
  @include eduPageGradientStrong;
}

/* ===== 固定顶部栏 ===== */
.nav-bar {
  position: fixed;
  top: 0; left: 0; right: 0;
  z-index: 99;
  background: transparent;
  transition: background-color 0.3s ease, box-shadow 0.3s ease;
}
.nav-bar-opaque { background: #FFFFFF; box-shadow: 0 2rpx 12rpx rgba(0, 0, 0, 0.06); }
.nav-bar-inner { display: flex; align-items: center; padding-left: 16rpx; }
.nav-back { width: 72rpx; height: 72rpx; display: flex; align-items: center; justify-content: center; }
.back-icon { font-size: 44rpx; color: $edu-text-primary; }
.nav-title { flex: 1; font-size: 40rpx; font-weight: 700; color: $edu-text-primary; margin-left: 8rpx; }
.nav-action { padding: 0 24rpx; height: 72rpx; display: flex; align-items: center; justify-content: center; }
.nav-action-text { font-size: 28rpx; color: $edu-primary; }

/* ===== 分类 Tab ===== */
.type-tabs { margin-top: 24rpx; white-space: nowrap; }
.type-tabs-inner { display: inline-flex; align-items: center; }
.type-pill {
  position: relative;
  flex-shrink: 0;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  height: 72rpx;
  padding: 0 40rpx;
  border-radius: 36rpx;
  margin-right: 20rpx;
  @include eduSurfaceWash;
  box-shadow: 0 4rpx 12rpx rgba(0, 0, 0, 0.03);
}
.type-pill-active { background: $edu-primary; .type-pill-text { color: #FFFFFF; font-weight: 600; } }
.type-pill-text { font-size: 28rpx; color: $edu-text-secondary; }
.type-pill-dot { position: absolute; top: 12rpx; right: 16rpx; width: 14rpx; height: 14rpx; border-radius: 50%; background: $edu-accent-coral; }

/* ===== 通知列表 ===== */
.notice-list { margin-top: 24rpx; }
.notice-card {
  padding: 32rpx;
  margin-bottom: 24rpx;
  border-radius: 28rpx;
  background-color: $edu-surface;
  box-shadow: 0 8rpx 24rpx rgba(0, 0, 0, 0.04);
}
.notice-head { display: flex; align-items: center; }
.notice-unread-dot { width: 18rpx; height: 18rpx; border-radius: 50%; background: $edu-primary; margin-right: 16rpx; flex-shrink: 0; }
.notice-title { flex: 1; font-size: 32rpx; font-weight: 700; color: $edu-text-primary; line-height: 1.4; }
.notice-time { font-size: 24rpx; color: $edu-text-hint; margin-left: 16rpx; flex-shrink: 0; }
.notice-content {
  display: block;
  font-size: 28rpx;
  color: $edu-text-secondary;
  line-height: 1.6;
  margin-top: 16rpx;
  padding-left: 34rpx;
}

.bottom-space { height: 40rpx; }
</style>
<template>
  <view class="profile-panel">
    <view class="profile-card" @tap="handleGoBlogHome">
      <view v-if="profileLoading" class="profile-loading">
        <text class="profile-loading-text">正在加载资料…</text>
      </view>
      <block v-else>
        <view class="profile-main">
          <view class="avatar-col">
            <image v-if="user.avatar" class="avatar" :src="user.avatar" mode="aspectFill" />
            <view v-else class="avatar avatar-fallback">
              <text class="avatar-char">{{ user.avatarChar }}</text>
            </view>
            <text class="fans-count">{{ formatCount(user.fansCount) }} 粉丝</text>
          </view>
          <view class="info-col">
            <text class="nickname">{{ user.nickname }}</text>
            <text class="bio">{{ user.bio }}</text>
            <text class="gender">{{ user.gender }}</text>
          </view>
        </view>
        <view class="checkin-row" @tap.stop="handleCheckin">
          <text class="checkin-text">连续签到 {{ user.continueSignDay }} 天</text>
          <text class="checkin-link">{{ user.signedToday ? '今日已签到' : '去签到' }} ›</text>
        </view>
      </block>
    </view>

    <view class="menu-card">
      <view
          v-for="(item, idx) in menuGroup1"
          :key="item.key"
          class="menu-row"
          :class="{ 'menu-row-divider': idx < menuGroup1.length - 1 }"
          @tap="handleMenuTap(item)"
      >
        <text class="menu-icon">{{ item.icon }}</text>
        <text class="menu-label">{{ item.label }}</text>
        <text class="menu-arrow">›</text>
      </view>
    </view>

    <view class="menu-card">
      <view class="menu-row" @tap="handleMenuTap({ key: 'settings', label: '设置' })">
        <text class="menu-icon">⚙️</text>
        <text class="menu-label">设置</text>
        <text class="menu-arrow">›</text>
      </view>
      <view class="menu-row menu-row-divider" @tap="handleMenuTap({ key: 'logout', label: '退出登录' })">
        <text class="menu-icon">🚪</text>
        <text class="menu-label logout-text">退出登录</text>
        <text class="menu-arrow">›</text>
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted, onUnmounted } from 'vue'
import { useAuthStore } from '@/store/auth'
import { getSignCalendarApi, resolveFileUrl } from '@/api/user'
import { todayKey } from '@/config/apiStatus'
import { getToken } from '@/utils/request'

const auth = useAuthStore()
const profileLoading = ref<boolean>(false)

const user = reactive({
	nickname: '',
	avatar: '',
	avatarChar: '',
	bio: '',
	gender: '未知',
	fansCount: 0,
	continueSignDay: 0,
	signedToday: false
})

function formatCount(n: number): string {
	if (n >= 10000) return (n / 10000).toFixed(1) + '万'
	return String(n)
}

function resolveGender(sex?: string): string {
	if (sex === '0') return '男'
	if (sex === '1') return '女'
	return '未知'
}

async function loadProfile() {
	profileLoading.value = true
	try {
		if (!auth.state.user) await auth.fetchUserInfo()
		const u = auth.state.user
		if (u) {
			user.nickname = u.nickName || u.userName || '用户'
			user.avatarChar = (user.nickname || 'U').charAt(0)
			user.avatar = resolveFileUrl(u.avatar)
			user.gender = resolveGender(u.sex)
			user.bio = u.remark || '还没有个人简介~'
		} else {
			user.nickname = '未登录'
			user.avatarChar = '客'
		}
		await loadSignInfo()
	} catch (e: any) {
		// 蓝本 4.7：错误文案需区分「未登录」与「网络问题」
		if (!getToken()) {
			user.nickname = '未登录'
			user.avatarChar = '客'
			user.bio = '登录后可查看学习进度与签到记录'
		} else if (e && (e.code === 401 || e.code === 403)) {
			user.nickname = '登录已过期'
			user.avatarChar = '客'
			user.bio = '请重新登录后再试'
		} else {
			user.nickname = '资料加载失败'
			user.avatarChar = '客'
			user.bio = '网络连接异常，请检查后端服务是否已启动'
		}
	} finally {
		profileLoading.value = false
	}
}

/** 连续签到天数与今日签到状态：GET user/sign-calendar（API_READY 控制真假） */
async function loadSignInfo() {
	const t = new Date()
	const res = await getSignCalendarApi(t.getFullYear(), t.getMonth() + 1)
	user.continueSignDay = res.continueSignDay || 0
	user.signedToday = (res.signedDates || []).indexOf(todayKey()) >= 0
}

onMounted(() => {
	loadProfile()
	uni.$on('profile:updated', loadProfile)
	uni.$on('panel:refresh', handlePanelRefresh)
})

onUnmounted(() => {
	uni.$off('profile:updated', loadProfile)
	uni.$off('panel:refresh', handlePanelRefresh)
})

/** 从签到页返回时 Tab 不会重建，靠事件主动刷新签到状态 */
function handlePanelRefresh() {
	loadSignInfo()
}

interface MenuItem { key: string; label: string; icon?: string }
const menuGroup1: MenuItem[] = [
  { key: 'courses', label: '我的课程', icon: '🎬' },
  { key: 'stats', label: '学习数据', icon: '📊' },
  { key: 'articles', label: '我的文章', icon: '📝' },
  { key: 'history', label: '观看历史', icon: '🕐' },
  { key: 'favorites', label: '我的收藏', icon: '⭐' },
  { key: 'likes', label: '我的点赞', icon: '❤️' },
  { key: 'downloads', label: '我的下载', icon: '⬇️' },
  { key: 'notes', label: '笔记本', icon: '📖' },
  { key: 'todos', label: '待办', icon: '✅' },
  { key: 'task', label: '任务中心', icon: '📋' }
]

function handleMenuTap(item: MenuItem) {
  if (item.key === 'logout') {
    uni.showModal({
      title: '提示',
      content: '确定要退出登录吗？',
      success: async (r) => {
        if (r.confirm) {
          await auth.logout()
          uni.reLaunch({ url: '/pages-sub/auth/login' })
        }
      }
    })
    return
  }
  if (item.key === 'task') {
    uni.navigateTo({ url: '/pages-sub/checkin/task-center' })
    return
  }
  if (item.key === 'courses') {
    uni.navigateTo({ url: '/pages-sub/mine/courses' })
    return
  }
  if (item.key === 'articles') {
    uni.navigateTo({ url: '/pages-sub/article/my' })
    return
  }
  if (item.key === 'downloads') {
    uni.navigateTo({ url: '/pages-sub/mine/downloads' })
    return
  }
  if (item.key === 'todos') {
    uni.navigateTo({ url: '/pages-sub/todo/todos' })
    return
  }
  if (item.key === 'stats') {
    uni.navigateTo({ url: '/pages-sub/mine/study-stats' })
    return
  }
  if (item.key === 'notes') {
    uni.navigateTo({ url: '/pages-sub/note/notes' })
    return
  }
  if (item.key === 'favorites') {
    uni.navigateTo({ url: '/pages-sub/mine/favorites' })
    return
  }
  if (item.key === 'history') {
    uni.navigateTo({ url: '/pages-sub/mine/history' })
    return
  }
  if (item.key === 'likes') {
    uni.navigateTo({ url: '/pages-sub/mine/likes' })
    return
  }
  if (item.key === 'settings') {
    uni.navigateTo({ url: '/pages-sub/mine/settings' })
    return
  }
  uni.showToast({ title: `${item.label}开发中`, icon: 'none' })
}

function handleGoBlogHome() { uni.navigateTo({ url: '/pages-sub/mine/blog-home' }) }
function handleCheckin() { uni.navigateTo({ url: '/pages-sub/checkin/task-center' }) }
</script>

<style lang="scss" scoped>
.profile-panel {
  padding: 0 32rpx calc(100rpx + env(safe-area-inset-bottom));
  @include eduPageGradientStrong;
}
.profile-card { margin-top: 24rpx; border-radius: 32rpx; padding: 40rpx 32rpx 28rpx; @include eduWarmYellowGradient; }
.profile-loading { height: 160rpx; display: flex; align-items: center; justify-content: center; }
.profile-loading-text { font-size: 28rpx; color: $edu-text-hint; }
.profile-main { display: flex; align-items: flex-start; }
.avatar-col { display: flex; flex-direction: column; align-items: center; width: 160rpx; flex-shrink: 0; }
.avatar { width: 140rpx; height: 140rpx; border-radius: 50%; }
.avatar-fallback { display: flex; align-items: center; justify-content: center; background-color: #E7EBF5; }
.avatar-char { font-size: 60rpx; font-weight: 700; color: $edu-primary; }
.fans-count { margin-top: 16rpx; font-size: 26rpx; color: $edu-text-secondary; }
.info-col { flex: 1; display: flex; flex-direction: column; padding-left: 24rpx; padding-top: 8rpx; }
.nickname { font-size: 40rpx; font-weight: 700; color: $edu-text-primary; margin-bottom: 16rpx; }
.bio { font-size: 28rpx; color: $edu-text-secondary; line-height: 1.5; margin-bottom: 12rpx; }
.gender { font-size: 26rpx; color: $edu-text-hint; }
.checkin-row { display: flex; align-items: center; justify-content: space-between; margin-top: 28rpx; padding-top: 24rpx; border-top: 2rpx solid rgba(0, 0, 0, 0.05); }
.checkin-text { font-size: 26rpx; color: $edu-text-secondary; }
.checkin-link { font-size: 26rpx; color: $edu-primary; font-weight: 500; }
.menu-card { margin-top: 32rpx; border-radius: 32rpx; padding: 0 32rpx; @include eduSurfaceWash; }
.menu-row { position: relative; display: flex; align-items: center; height: 112rpx; }
.menu-row-divider::after { content: ''; position: absolute; left: 72rpx; right: 0; bottom: 0; height: 2rpx; background: $edu-divider; }
.menu-icon { width: 56rpx; font-size: 36rpx; margin-right: 16rpx; }
.menu-label { flex: 1; font-size: 32rpx; color: $edu-text-primary; }
.logout-text { color: $edu-accent-coral; }
.menu-arrow { font-size: 40rpx; color: $edu-text-hint; }
</style>
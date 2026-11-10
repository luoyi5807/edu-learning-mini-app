<template>
  <view class="profile-panel">
    <!-- 用户信息卡：头像 + 昵称同行，下方关注/粉丝/获赞三统计块 -->
    <view class="profile-card" @tap="handleGoBlogHome">
      <view v-if="profileLoading" class="profile-loading">
        <text class="profile-loading-text">正在加载资料…</text>
      </view>
      <block v-else>
        <view class="user-row">
          <image v-if="user.avatar" class="avatar" :src="user.avatar" mode="aspectFill" />
          <view v-else class="avatar avatar-fallback">
            <text class="avatar-char">{{ user.avatarChar }}</text>
          </view>
          <text class="nickname">{{ user.nickname }}</text>
        </view>
        <view class="stat-row">
          <view class="stat-box">
            <text class="stat-num">{{ user.followCount }}</text>
            <text class="stat-label">关注</text>
          </view>
          <view class="stat-box">
            <text class="stat-num">{{ user.fansCount }}</text>
            <text class="stat-label">粉丝</text>
          </view>
          <view class="stat-box">
            <text class="stat-num">{{ user.likedCount }}</text>
            <text class="stat-label">获赞</text>
          </view>
        </view>
      </block>
    </view>

    <!-- 功能宫格：彩色圆角图标 + 下方文字 -->
    <view class="menu-card">
      <view class="menu-grid">
        <view
            v-for="item in menuItems"
            :key="item.key"
            class="grid-item"
            hover-class="grid-item-pressed"
            @tap="handleMenuTap(item)"
        >
          <view class="grid-icon" :class="'grid-icon-' + item.color">
            <text class="grid-emoji">{{ item.icon }}</text>
          </view>
          <text class="grid-label" :class="{ 'grid-label-logout': item.key === 'logout' }">{{ item.label }}</text>
        </view>
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted, onUnmounted } from 'vue'
import { useAuthStore } from '@/store/auth'
import { getSignCalendarApi, getUserHomeApi, resolveFileUrl } from '@/api/user'
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
	followCount: 0,
	likedCount: 0,
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
		await loadHomeStats()
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

/** 关注/粉丝/获赞 + 资料回填：GET /api/v1/user/home（一次返回，获赞口径=我帖子被点赞之和） */
async function loadHomeStats() {
	if (!getToken()) return
	try {
		const h = await getUserHomeApi()
		if (h.userName) {
			user.nickname = h.userName
			user.avatarChar = h.userName.charAt(0)
		}
		if (h.avatar) user.avatar = resolveFileUrl(h.avatar)
		if (h.bio) user.bio = h.bio
		if (h.sexLabel) user.gender = h.sexLabel
		else if (h.sex) user.gender = resolveGender(h.sex)
		user.followCount = h.followCount || 0
		user.fansCount = h.fansCount || 0
		user.likedCount = h.likeReceivedCount || 0
	} catch (e) {
		// 失败保留 auth 资料，计数维持 0
	}
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
	loadHomeStats()
}

interface MenuItem { key: string; label: string; icon: string; color: string }
const menuItems: MenuItem[] = [
  { key: 'task', label: '任务中心', icon: '✅', color: 'green' },
  { key: 'stats', label: '学习数据', icon: '📅', color: 'blue' },
  { key: 'history', label: '观看历史', icon: '🕐', color: 'orange' },
  { key: 'favorites', label: '我的收藏', icon: '⭐', color: 'yellow' },
  { key: 'likes', label: '我的点赞', icon: '❤️', color: 'pink' },
  { key: 'notes', label: '笔记本', icon: '📖', color: 'purple' },
  { key: 'settings', label: '设置', icon: '⚙️', color: 'gray' },
  { key: 'logout', label: '退出登录', icon: '🚪', color: 'gray' }
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
</script>

<style lang="scss" scoped>
.profile-panel {
  padding: 0 32rpx calc(100rpx + env(safe-area-inset-bottom));
  @include eduPageGradientProfile;
}
.profile-card {
  margin-top: 24rpx; border-radius: 32rpx; padding: 40rpx 32rpx;
  background-color: $edu-surface; box-shadow: 0 6rpx 24rpx rgba(0, 0, 0, 0.05);
}
.profile-loading { height: 160rpx; display: flex; align-items: center; justify-content: center; }
.profile-loading-text { font-size: 28rpx; color: $edu-text-hint; }
.user-row { display: flex; align-items: center; }
.avatar { width: 120rpx; height: 120rpx; border-radius: 50%; flex-shrink: 0; }
.avatar-fallback { display: flex; align-items: center; justify-content: center; background-color: $edu-primary-container; }
.avatar-char { font-size: 56rpx; font-weight: 700; color: $edu-primary; }
.nickname { margin-left: 28rpx; font-size: 40rpx; font-weight: 700; color: $edu-text-primary; }
.stat-row { display: flex; margin-top: 36rpx; }
.stat-box {
  flex: 1; margin-right: 20rpx; border-radius: 20rpx; padding: 24rpx 0;
  display: flex; flex-direction: column; align-items: center; justify-content: center;
  background-color: $edu-surface-variant;
}
.stat-box:last-child { margin-right: 0; }
.stat-num { font-size: 36rpx; font-weight: 700; color: $edu-text-primary; }
.stat-label { margin-top: 8rpx; font-size: 26rpx; color: $edu-text-secondary; }
.menu-card {
  margin-top: 32rpx; border-radius: 32rpx; padding: 40rpx 24rpx 8rpx;
  background-color: $edu-surface; box-shadow: 0 6rpx 24rpx rgba(0, 0, 0, 0.05);
}
.menu-grid { display: flex; flex-wrap: wrap; }
.grid-item {
  width: 33.333%; box-sizing: border-box; margin-bottom: 40rpx;
  display: flex; flex-direction: column; align-items: center;
}
.grid-item-pressed { opacity: 0.7; }
.grid-icon {
  width: 108rpx; height: 108rpx; border-radius: 28rpx;
  display: flex; align-items: center; justify-content: center;
}
.grid-emoji { font-size: 52rpx; }
.grid-label { margin-top: 16rpx; font-size: 26rpx; color: $edu-text-primary; }
.grid-label-logout { color: $edu-accent-coral; }
/* 宫格图标底色（对齐设计图各功能主题色：浅底 + 彩色图标） */
.grid-icon-green  { background-color: #E6F5EA; }
.grid-icon-blue   { background-color: #E3ECFD; }
.grid-icon-orange { background-color: #FDEEDC; }
.grid-icon-yellow { background-color: #FBF3D6; }
.grid-icon-pink   { background-color: #FBE0E6; }
.grid-icon-purple { background-color: #EEE4F7; }
.grid-icon-gray   { background-color: #EEF0F4; }
</style>
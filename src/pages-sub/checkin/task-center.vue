<!-- src/pages-sub/checkin/task-center.vue -->
<template>
  <view class="task-page" :class="themeClass">
    <!-- 顶部栏：返回 + 标题 + 右侧「签到记录 / 规则」 -->
    <view class="nav-bar" :class="{ 'nav-bar-opaque': navBarOpaque }" :style="{ paddingTop: statusBarHeight + 'px' }">
      <view class="nav-bar-inner" :style="{ height: navContentHeight + 'px', paddingRight: capsuleReserve + 'px' }">
        <view class="nav-left">
          <view class="nav-back" @tap="goBack"><text class="back-icon">←</text></view>
          <text class="nav-title">任务中心</text>
        </view>
        <view class="nav-right">
          <text class="nav-link" @tap="goRecord">签到记录</text>
          <view class="nav-pill" @tap="showRules"><text class="nav-pill-text">规则</text></view>
        </view>
      </view>
    </view>
    <view class="nav-placeholder" :style="{ height: (statusBarHeight + navContentHeight) + 'px' }"></view>

    <!-- 积分总览卡 -->
    <view class="points-card">
      <view class="pc-head">
        <text class="pc-label">我的积分</text>
        <view class="pc-tag"><text class="pc-tag-text">今日任务 +{{ contentPoints }}</text></view>
      </view>
      <text class="pc-value">{{ points }}</text>
      <view class="pc-progress-row">
        <text class="pc-progress-label">今日任务积分</text>
        <text class="pc-progress-num">{{ contentPoints }} / {{ cap }}</text>
      </view>
      <view class="pc-bar"><view class="pc-bar-fill" :style="{ width: contentPercent + '%' }"></view></view>
      <view class="pc-foot">
        <view class="pc-stat"><text class="pc-stat-num">{{ continueSignDay }} 天</text><text class="pc-stat-label">连续签到</text></view>
        <view class="pc-stat"><text class="pc-stat-num">{{ totalSignDay }} 次</text><text class="pc-stat-label">累计签到</text></view>
        <text class="pc-remain">还可获得 {{ remainPoints }} 分</text>
      </view>
    </view>

    <!-- 每日签到 -->
    <view class="sign-card">
      <view class="sign-head">
        <view class="sign-head-l">
          <text class="sign-title">每日签到</text>
          <text class="sign-sub">7 天一个周期，连续签到每天多 +1 分</text>
        </view>
        <view class="sign-pill"><text class="sign-pill-text">第 {{ todayCycleDay }} / 7 天</text></view>
      </view>
      <view class="sign-days">
        <view v-for="chip in dayChips" :key="chip.day" class="day-chip"
              :class="{ 'day-chip-signed': chip.signed, 'day-chip-today': chip.isToday }">
          <text class="day-chip-name">{{ chip.label }}</text>
          <text class="day-chip-reward">+{{ chip.reward }}</text>
        </view>
      </view>
      <view class="sign-foot">
        <text class="sign-foot-l">连续签到 {{ continueSignDay }} 天</text>
        <text class="sign-foot-r">今日 +{{ todaySignReward }} 积分</text>
      </view>
      <view class="sign-btn" :class="{ 'sign-btn-done': signedToday }" @tap="handleCheckin">
        <text class="sign-btn-text">{{ signedToday ? '今日已签到' : '签到 +' + todayPoints + ' 积分' }}</text>
      </view>
    </view>

    <!-- 今日任务 -->
    <view class="section-head">
      <view class="section-head-l">
        <text class="section-title">今日任务</text>
        <text class="section-sub">完成下列任务即可获得积分，每日 0 点重置</text>
      </view>
      <text class="section-cap">上限 {{ cap }} 分</text>
    </view>

    <view class="task-card">
      <view class="task-icon ti-blue"><text class="task-icon-glyph">▶</text></view>
      <view class="task-body">
        <view class="task-title-row"><text class="task-name">观看课程视频</text><text class="task-badge">+5 积分</text></view>
        <text class="task-desc">课程视频观看满 30 秒，单个 +5 分；短视频不计分</text>
        <text class="task-note">同一课程视频只计一次</text>
      </view>
      <view class="task-btn" @tap="goLearn"><text class="task-btn-text">去学习</text></view>
    </view>

    <view class="task-card">
      <view class="task-icon ti-coral"><text class="task-icon-glyph">💬</text></view>
      <view class="task-body">
        <view class="task-title-row"><text class="task-name">浏览帖子</text><text class="task-badge">+5 积分</text></view>
        <text class="task-desc">社区文章 / 帖子浏览满 30 秒，每篇 +5 分</text>
        <text class="task-note">同一篇文章只计一次</text>
      </view>
      <view class="task-btn" @tap="goBrowse"><text class="task-btn-text">去浏览</text></view>
    </view>

    <view class="task-card">
      <view class="task-icon ti-yellow"><text class="task-icon-glyph">👁</text></view>
      <view class="task-body">
        <view class="task-title-row"><text class="task-name">观看广告</text><text class="task-badge">+10 积分</text></view>
        <text class="task-desc">完整看完一条广告 +10 分，同一广告每天只计 1 次</text>
        <text class="task-note">看完广告即可领取积分</text>
      </view>
      <view class="task-btn" @tap="handleWatchAd"><text class="task-btn-text">去观看</text></view>
    </view>

    <!-- 每日积分上限 -->
    <view class="cap-card">
      <view class="cap-icon"><text class="cap-icon-glyph">★</text></view>
      <view class="cap-body">
        <text class="cap-title">每日积分上限 {{ cap }} 分</text>
        <text class="cap-sub">今日已得 {{ contentPoints }} 分，还可获得 {{ remainPoints }} 分</text>
      </view>
    </view>

    <!-- 规则入口 -->
    <view class="rule-entry" @tap="showRules">
      <view class="rule-entry-icon"><text class="rule-entry-glyph">规</text></view>
      <view class="rule-entry-body">
        <text class="rule-entry-title">任务与积分规则</text>
        <text class="rule-entry-sub">签到周期、视频 / 帖子 / 广告计分与每日上限</text>
      </view>
      <text class="rule-entry-link">查看 ›</text>
    </view>

    <!-- 积分商城 -->
    <view class="section-head">
      <view class="section-head-l">
        <text class="section-title">积分商城</text>
        <text class="section-sub">用积分兑换奖品，具体奖品以商城页面为准</text>
      </view>
      <text class="section-cap">余额 {{ points }}</text>
    </view>
    <view class="mall-entry" @tap="goMall">
      <view class="mall-entry-icon"><text class="mall-entry-glyph">★</text></view>
      <view class="mall-entry-body">
        <text class="mall-entry-title">去兑换奖品</text>
        <text class="mall-entry-sub">查看可兑换奖品与所需积分</text>
      </view>
      <view class="mall-entry-btn"><text class="mall-entry-btn-text">进入商城</text></view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { onShow, onPageScroll } from '@dcloudio/uni-app'
import { getCheckinStatusApi, signApi } from '@/api/checkin'
import { getTodayContentPoints } from '@/api/points'
import { CONTINUOUS_REWARDS, CONTENT_DAILY_CAP } from '@/composables/pointsRule'
import { API_READY } from '@/config/apiStatus'
import { useAuthStore } from '@/store/auth'
import { showRewardedAd } from '@/composables/useRewardedAd'
import { useTheme } from '@/composables/useTheme'

const auth = useAuthStore()
const { themeClass } = useTheme()
const cap = CONTENT_DAILY_CAP

/* ===== 顶部栏高度（含状态栏 + 胶囊区） ===== */
const statusBarHeight = ref<number>(0)
const navContentHeight = ref<number>(44)
const capsuleReserve = ref<number>(100)
const sysInfo = uni.getSystemInfoSync()
statusBarHeight.value = sysInfo.statusBarHeight || 0
// #ifdef MP-WEIXIN
const menuButton = uni.getMenuButtonBoundingClientRect()
if (menuButton) {
  navContentHeight.value = (menuButton.top - statusBarHeight.value) * 2 + menuButton.height
  capsuleReserve.value = sysInfo.windowWidth - menuButton.left + 8
}
// #endif

const navBarOpaque = ref<boolean>(false)
onPageScroll((e) => { navBarOpaque.value = e.scrollTop > 40 })

/* ===== 数据 ===== */
const points = ref<number>(0)
const continueSignDay = ref<number>(0)
const totalSignDay = ref<number>(0)
const signedToday = ref<boolean>(false)
const todayPoints = ref<number>(0)
const contentPoints = ref<number>(0)   // 今日任务积分（内容类，来自本地缓存 / 后端 watch）

const remainPoints = computed<number>(() => Math.max(0, cap - contentPoints.value))
const contentPercent = computed<number>(() => Math.min(100, Math.round((contentPoints.value / cap) * 100)))

/* 7 天签到周期：今天处于周期内第几天（未签则今天=将要签的那一天） */
const todayCycleDay = computed<number>(() => {
  if (signedToday.value) return ((continueSignDay.value - 1) % 7) + 1
  return (continueSignDay.value % 7) + 1
})
const todaySignReward = computed<number>(() => CONTINUOUS_REWARDS[todayCycleDay.value - 1])
const dayChips = computed(() => CONTINUOUS_REWARDS.map((reward, i) => {
  const day = i + 1
  const isToday = day === todayCycleDay.value
  const signed = day < todayCycleDay.value || (isToday && signedToday.value)
  return { day, reward, isToday, signed, label: isToday ? '今天' : '第' + day + '天' }
}))

async function loadAll() {
  contentPoints.value = getTodayContentPoints()
  try {
    const st = await getCheckinStatusApi()
    signedToday.value = !!st.signedToday
    todayPoints.value = st.todayPoints || 0
    continueSignDay.value = st.continuousDays || 0
    totalSignDay.value = st.totalDays || 0
    points.value = st.balance || 0
  } catch (e) { /* 未登录/网络异常，request 已 toast */ }
}

async function handleCheckin() {
  if (signedToday.value) { uni.showToast({ title: '今天已经签到啦', icon: 'none' }); return }
  try {
    const r = await signApi()
    points.value = r.balance
    continueSignDay.value = r.continuousDays
    totalSignDay.value = r.totalDays
    signedToday.value = true
    uni.showToast({ title: `签到成功 +${r.points} 积分`, icon: 'none' })
  } catch (e: any) {
    uni.showToast({ title: (e && e.msg) ? e.msg : '签到失败', icon: 'none' })
  }
}

const adReady = API_READY.adReward
async function handleWatchAd() {
  if (!adReady) { uni.showToast({ title: '看广告领积分即将上线', icon: 'none' }); return }
  const uid = auth.state.user?.userId
  const finished = await showRewardedAd(uid, 10)
  if (finished) { uni.showToast({ title: '奖励发放中…', icon: 'none' }); setTimeout(loadAll, 2000) }
  else uni.showToast({ title: '看完视频才能领取积分哦', icon: 'none' })
}

/* ===== 交互 ===== */
function goBack() {
  const pages = getCurrentPages()
  if (pages.length > 1) uni.navigateBack()
  else uni.reLaunch({ url: '/pages/index/index' })
}
function goRecord() { uni.navigateTo({ url: '/pages-sub/checkin/record' }) }
function showRules() { uni.navigateTo({ url: '/pages-sub/checkin/points-rules' }) }
function goMall() { uni.navigateTo({ url: '/pages-sub/mall/mall' }) }
function goLearn() { uni.reLaunch({ url: '/pages/index/index' }) }
function goBrowse() { uni.reLaunch({ url: '/pages/index/index' }) }

onShow(loadAll)
</script>

<style lang="scss" scoped>
.task-page {
  min-height: 100vh;
  box-sizing: border-box;
  padding: 0 32rpx 60rpx;
  @include eduPageGradientStrong;
}

/* ===== 顶部栏 ===== */
.nav-bar { position: fixed; top: 0; left: 0; right: 0; z-index: 99; background: transparent; transition: background-color 0.3s ease, box-shadow 0.3s ease; }
.nav-bar-opaque { background: var(--edu-surface); box-shadow: 0 2rpx 12rpx rgba(0, 0, 0, 0.06); }
.nav-bar-inner { display: flex; align-items: center; justify-content: space-between; padding-left: 16rpx; }
.nav-left { display: flex; align-items: center; }
.nav-back { width: 72rpx; height: 72rpx; display: flex; align-items: center; justify-content: center; }
.back-icon { font-size: 44rpx; color: $edu-text-primary; }
.nav-title { font-size: 40rpx; font-weight: 700; color: $edu-text-primary; margin-left: 8rpx; }
.nav-right { display: flex; align-items: center; }
.nav-link { font-size: 28rpx; color: $edu-text-secondary; margin-right: 20rpx; }
.nav-pill { height: 60rpx; padding: 0 28rpx; border-radius: 30rpx; display: flex; align-items: center; justify-content: center; background-color: $edu-surface-variant; }
.nav-pill-text { font-size: 26rpx; color: $edu-text-primary; font-weight: 500; }

/* ===== 积分总览卡 ===== */
.points-card { margin-top: 24rpx; border-radius: 32rpx; padding: 36rpx 40rpx 40rpx; @include eduBrandGradient; box-shadow: 0 16rpx 32rpx rgba(54, 119, 239, 0.25); }
.pc-head { display: flex; align-items: center; justify-content: space-between; }
.pc-label { font-size: 28rpx; color: rgba(255, 255, 255, 0.9); }
.pc-tag { height: 48rpx; padding: 0 24rpx; border-radius: 24rpx; display: flex; align-items: center; background: rgba(255, 255, 255, 0.22); }
.pc-tag-text { font-size: 24rpx; color: #FFFFFF; font-weight: 600; }
.pc-value { display: block; font-size: 88rpx; font-weight: 800; color: #FFFFFF; line-height: 1.2; margin: 8rpx 0 20rpx; }
.pc-progress-row { display: flex; align-items: center; justify-content: space-between; }
.pc-progress-label { font-size: 26rpx; color: rgba(255, 255, 255, 0.9); }
.pc-progress-num { font-size: 26rpx; color: #FFFFFF; font-weight: 600; }
.pc-bar { height: 12rpx; border-radius: 6rpx; background: rgba(255, 255, 255, 0.25); margin: 16rpx 0 28rpx; overflow: hidden; }
.pc-bar-fill { height: 100%; border-radius: 6rpx; background: $edu-accent-yellow; }
.pc-foot { display: flex; align-items: center; }
.pc-stat { display: flex; flex-direction: column; margin-right: 48rpx; }
.pc-stat-num { font-size: 32rpx; font-weight: 700; color: #FFFFFF; }
.pc-stat-label { font-size: 22rpx; color: rgba(255, 255, 255, 0.8); margin-top: 4rpx; }
.pc-remain { margin-left: auto; font-size: 26rpx; color: rgba(255, 255, 255, 0.9); }

/* ===== 每日签到卡 ===== */
.sign-card { margin-top: 28rpx; border-radius: 32rpx; padding: 36rpx 32rpx; background-color: $edu-surface; box-shadow: 0 8rpx 24rpx rgba(0, 0, 0, 0.04); }
.sign-head { display: flex; align-items: flex-start; justify-content: space-between; }
.sign-title { display: block; font-size: 34rpx; font-weight: 700; color: $edu-text-primary; }
.sign-sub { display: block; font-size: 24rpx; color: $edu-text-hint; margin-top: 8rpx; }
.sign-pill { height: 48rpx; padding: 0 22rpx; border-radius: 24rpx; display: flex; align-items: center; background-color: $edu-primary-container; }
.sign-pill-text { font-size: 24rpx; color: $edu-primary; font-weight: 600; }
.sign-days { display: flex; justify-content: space-between; margin: 32rpx 0 8rpx; }
.day-chip { width: 76rpx; height: 108rpx; border-radius: 18rpx; display: flex; flex-direction: column; align-items: center; justify-content: center; background-color: $edu-surface-variant; }
.day-chip-name { font-size: 20rpx; color: $edu-text-hint; }
.day-chip-reward { font-size: 26rpx; font-weight: 700; color: $edu-text-hint; margin-top: 8rpx; }
.day-chip-signed { background-color: $edu-primary-container; }
.day-chip-signed .day-chip-name { color: $edu-primary; }
.day-chip-signed .day-chip-reward { color: $edu-primary; }
.day-chip-today { background: linear-gradient(135deg, #5B9BFF 0%, #3677EF 100%); }
.day-chip-today .day-chip-name { color: rgba(255, 255, 255, 0.9); }
.day-chip-today .day-chip-reward { color: #FFFFFF; }
.sign-foot { display: flex; align-items: center; justify-content: space-between; margin-top: 24rpx; }
.sign-foot-l { font-size: 26rpx; color: $edu-text-secondary; }
.sign-foot-r { font-size: 26rpx; color: $edu-accent-teal; font-weight: 600; }
.sign-btn { margin-top: 28rpx; height: 96rpx; border-radius: 24rpx; display: flex; align-items: center; justify-content: center; @include eduBrandGradient; }
.sign-btn-done { background: $edu-surface-variant; }
.sign-btn-text { font-size: 32rpx; font-weight: 700; color: #FFFFFF; }
.sign-btn-done .sign-btn-text { color: $edu-text-hint; }

/* ===== 区块标题 ===== */
.section-head { display: flex; align-items: flex-end; justify-content: space-between; margin: 44rpx 0 24rpx; }
.section-title { display: block; font-size: 34rpx; font-weight: 700; color: $edu-text-primary; }
.section-sub { display: block; font-size: 24rpx; color: $edu-text-hint; margin-top: 8rpx; }
.section-cap { font-size: 24rpx; color: $edu-text-hint; }

/* ===== 任务卡 ===== */
.task-card { display: flex; align-items: center; border-radius: 24rpx; padding: 32rpx 28rpx; background-color: $edu-surface; box-shadow: 0 8rpx 24rpx rgba(0, 0, 0, 0.04); margin-bottom: 24rpx; }
.task-icon { width: 88rpx; height: 88rpx; border-radius: 24rpx; display: flex; align-items: center; justify-content: center; flex-shrink: 0; }
.ti-blue { background-color: $edu-primary-container; }
.ti-coral { background-color: $edu-tab-community-bg; }
.ti-yellow { background-color: #FBEFD2; }
.task-icon-glyph { font-size: 40rpx; color: $edu-primary; }
.task-body { flex: 1; min-width: 0; margin: 0 24rpx; }
.task-title-row { display: flex; align-items: center; }
.task-name { font-size: 32rpx; font-weight: 700; color: $edu-text-primary; }
.task-badge { margin-left: 16rpx; height: 40rpx; padding: 0 16rpx; border-radius: 20rpx; display: flex; align-items: center; background-color: #FBEFD2; font-size: 22rpx; color: #96650C; font-weight: 600; }
.task-desc { display: block; font-size: 24rpx; color: $edu-text-secondary; margin-top: 12rpx; line-height: 1.4; }
.task-note { display: block; font-size: 22rpx; color: $edu-text-hint; margin-top: 8rpx; }
.task-btn { height: 64rpx; padding: 0 32rpx; border-radius: 32rpx; display: flex; align-items: center; justify-content: center; background-color: $edu-primary-container; flex-shrink: 0; }
.task-btn-text { font-size: 26rpx; color: $edu-primary; font-weight: 600; }

/* ===== 上限卡 ===== */
.cap-card { display: flex; align-items: center; border-radius: 24rpx; padding: 28rpx; background-color: $edu-surface-variant; margin: 8rpx 0 24rpx; }
.cap-icon { width: 64rpx; height: 64rpx; border-radius: 50%; background-color: #FBEFD2; display: flex; align-items: center; justify-content: center; flex-shrink: 0; }
.cap-icon-glyph { font-size: 32rpx; color: #F0B000; }
.cap-body { margin-left: 24rpx; }
.cap-title { display: block; font-size: 30rpx; font-weight: 700; color: $edu-text-primary; }
.cap-sub { display: block; font-size: 24rpx; color: $edu-text-secondary; margin-top: 8rpx; }

/* ===== 规则入口 ===== */
.rule-entry { display: flex; align-items: center; border-radius: 24rpx; padding: 28rpx; background-color: $edu-surface; box-shadow: 0 8rpx 24rpx rgba(0, 0, 0, 0.04); margin-bottom: 8rpx; }
.rule-entry-icon { width: 64rpx; height: 64rpx; border-radius: 18rpx; background-color: $edu-primary-container; display: flex; align-items: center; justify-content: center; flex-shrink: 0; }
.rule-entry-glyph { font-size: 30rpx; color: $edu-primary; font-weight: 700; }
.rule-entry-body { flex: 1; margin: 0 24rpx; }
.rule-entry-title { display: block; font-size: 30rpx; font-weight: 700; color: $edu-text-primary; }
.rule-entry-sub { display: block; font-size: 24rpx; color: $edu-text-hint; margin-top: 8rpx; }
.rule-entry-link { font-size: 26rpx; color: $edu-primary; }

/* ===== 商城入口 ===== */
.mall-entry { display: flex; align-items: center; border-radius: 24rpx; padding: 32rpx 28rpx; background-color: $edu-surface; box-shadow: 0 8rpx 24rpx rgba(0, 0, 0, 0.04); }
.mall-entry-icon { width: 88rpx; height: 88rpx; border-radius: 24rpx; background-color: #FBEFD2; display: flex; align-items: center; justify-content: center; flex-shrink: 0; }
.mall-entry-glyph { font-size: 40rpx; color: #F0B000; }
.mall-entry-body { flex: 1; margin: 0 24rpx; }
.mall-entry-title { display: block; font-size: 32rpx; font-weight: 700; color: $edu-text-primary; }
.mall-entry-sub { display: block; font-size: 24rpx; color: $edu-text-hint; margin-top: 8rpx; }
.mall-entry-btn { height: 72rpx; padding: 0 40rpx; border-radius: 36rpx; display: flex; align-items: center; justify-content: center; @include eduBrandGradient; flex-shrink: 0; }
.mall-entry-btn-text { font-size: 28rpx; font-weight: 600; color: #FFFFFF; }
</style>
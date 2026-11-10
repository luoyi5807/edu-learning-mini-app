<template>
  <view class="task-page">
    <!-- 固定顶部栏：返回 + 标题 + 右侧「签到记录」 -->
    <view class="nav-bar" :class="{ 'nav-bar-opaque': navBarOpaque }" :style="{ paddingTop: statusBarHeight + 'px' }">
      <view
          class="nav-bar-inner"
          :style="{ height: navContentHeight + 'px', paddingRight: capsuleReserve + 'px' }"
      >
        <view class="nav-left">
          <view class="nav-back" @tap="goBack">
            <text class="back-icon">←</text>
          </view>
          <text class="nav-title">任务中心</text>
        </view>
        <view class="record-btn" @tap="goRecord">
          <text class="record-btn-text">签到记录</text>
        </view>
      </view>
    </view>
    <view class="nav-placeholder" :style="{ height: (statusBarHeight + navContentHeight) + 'px' }"></view>

    <!-- 积分卡（品牌渐变） -->
    <view class="points-card">
      <text class="points-label">我的积分</text>
      <text class="points-value">{{ points }}</text>
      <view class="points-foot">
        <text class="points-foot-text">连续签到 {{ continueSignDay }} 天</text>
        <text class="points-foot-text">累计签到 {{ totalSignDay }} 次</text>
      </view>
    </view>

    <!-- 签到按钮（青绿） -->
    <view
        class="checkin-btn"
        :class="{ 'checkin-btn-done': signedToday }"
        @tap="handleCheckin"
    >
      <text class="checkin-btn-text">{{ signedToday ? '今日已签到' : `签到 +${todayPoints} 积分` }}</text>
    </view>

    <!-- 看激励视频领积分（adReward 未就绪时置灰提示） -->
    <view class="ad-card" :class="{ 'ad-card-off': !adReady }" @tap="handleWatchAd">
      <view class="ad-card-info">
        <text class="ad-card-title">看激励视频领积分</text>
        <text class="ad-card-sub">
          {{ adReady
              ? `每次 +${adConfig.pointsPerView} 积分 · 今日 ${adConfig.todayUsed}/${adConfig.dailyLimit}`
              : '即将上线，敬请期待' }}
        </text>
      </view>
      <view class="ad-card-btn">
        <text class="ad-card-btn-text">{{ adReady ? '去观看' : '开发中' }}</text>
      </view>
    </view>

    <!-- 免广告权益状态 -->
    <view class="info-card">
      <view class="status-dot" :class="{ 'status-dot-on': hasAdFree }"></view>
      <text class="status-text">{{ hasAdFree ? `免广告权益剩余 ${adFreeMinutes} 分钟` : '当前无免广告权益' }}</text>
    </view>

    <!-- 规则入口 -->
    <view class="info-card info-card-between" @tap="showRules">
      <text class="rules-title">积分获取与兑换规则</text>
      <text class="rules-link">查看 ›</text>
    </view>

    <!-- 兑换区 -->
    <text class="section-title">积分兑换免广告</text>
    <view class="exchange-card" v-for="p in exchangeProducts" :key="p.tier">
      <view class="exchange-info">
        <text class="exchange-name">{{ p.name }}</text>
        <text class="exchange-cost">{{ p.costPoints }} 积分</text>
      </view>
      <view class="exchange-btn" :class="{ 'exchange-btn-disabled': points < p.costPoints }" @tap="handleExchange(p)">
        <text class="exchange-btn-text">兑换</text>
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { onLoad, onPageScroll } from '@dcloudio/uni-app'
import { getCheckinStatusApi, signApi } from '@/api/checkin'
import { getPointsAccountApi, getExchangeTiersApi, exchangeAdFreeApi, type ExchangeTier } from '@/api/points'
import { getAdRewardConfigApi, refreshBalanceAfterAd, type AdRewardConfig } from '@/api/adReward'
import { showRewardedAd } from '@/composables/useRewardedAd'
import { API_READY } from '@/config/apiStatus'
import { useAuthStore } from '@/store/auth'

const auth = useAuthStore()

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

/* ===== 顶栏滚动变白 ===== */
const navBarOpaque = ref<boolean>(false)
onPageScroll((e) => {
  navBarOpaque.value = e.scrollTop > 40
})

/* ===== 数据（对接 /api/v1/checkin + /api/v1/points） ===== */
const points = ref<number>(0)
const continueSignDay = ref<number>(0)
const totalSignDay = ref<number>(0)
const signedToday = ref<boolean>(false)
const todayPoints = ref<number>(0)   // 今天签到可得几分

// 免广告权益（全部用服务端算好的值）
const hasAdFree = ref<boolean>(false)
const adFreeMinutes = ref<number>(0)

// 兑换档位（后端下发）
interface ExchangeProduct { tier: number; name: string; costPoints: number; minutes: number }
const exchangeProducts = ref<ExchangeProduct[]>([])

// 看激励视频得积分（开关未就绪时 adReady=false，按钮仅提示开发中）
const adReady = ref<boolean>(API_READY.adReward)
const adConfig = ref<AdRewardConfig>({ pointsPerView: 0, dailyLimit: 0, todayUsed: 0 })
const adWatching = ref<boolean>(false)

async function loadAdConfig() {
  try { adConfig.value = await getAdRewardConfigApi() } catch (e) { /* ignore */ }
}

/** 看激励视频领积分：前端只负责调起 + 稍后刷新余额，真正加分在后端 SSV 回调 */
async function handleWatchAd() {
  if (!adReady.value) {
    uni.showToast({ title: '看广告领积分即将上线', icon: 'none' })
    return
  }
  if (adConfig.value.todayUsed >= adConfig.value.dailyLimit) {
    uni.showToast({ title: '今日观看次数已用完', icon: 'none' })
    return
  }
  if (adWatching.value) return
  adWatching.value = true
  try {
    const uid = auth.state.user?.userId
    const finished = await showRewardedAd(uid, adConfig.value.pointsPerView)
    if (!finished) {
      uni.showToast({ title: '看完视频才能领取积分哦', icon: 'none' })
      return
    }
    uni.showToast({ title: '奖励发放中…', icon: 'none' })
    // SSV 回调有延迟：轮询刷新余额（最多 ~6 秒），涨了即确认到账
    const before = points.value
    for (let i = 0; i < 6; i++) {
      await new Promise(r => setTimeout(r, 1000))
      const bal = await refreshBalanceAfterAd()
      if (bal > before) { points.value = bal; loadAdConfig(); uni.showToast({ title: `+${bal - before} 积分已到账`, icon: 'none' }); break }
      points.value = bal
    }
  } finally {
    adWatching.value = false
  }
}

/* ===== 交互 ===== */
function goBack() {
  const pages = getCurrentPages()
  if (pages.length > 1) uni.navigateBack()
  else uni.reLaunch({ url: '/pages/index/index' })
}

function goRecord() {
  uni.navigateTo({ url: '/pages-sub/checkin/record' })
}

/** 拉取签到状态 + 积分账户 */
async function loadAll() {
  try {
    const st = await getCheckinStatusApi()
    signedToday.value = !!st.signedToday
    todayPoints.value = st.todayPoints || 0
    continueSignDay.value = st.continuousDays || 0
    totalSignDay.value = st.totalDays || 0
    points.value = st.balance || 0

    const acc = await getPointsAccountApi()
    points.value = acc.balance || 0
    hasAdFree.value = !!acc.adFree
    adFreeMinutes.value = acc.adFreeRemainMinutes || 0
  } catch (e) { /* 未登录/网络异常，request 已 toast */ }
}

/** 拉取兑换档位 */
async function loadTiers() {
  try {
    const tiers: ExchangeTier[] = await getExchangeTiersApi()
    exchangeProducts.value = tiers.map((t) => ({ tier: t.tier, name: t.label, costPoints: t.cost, minutes: t.minutes }))
  } catch (e) { /* ignore */ }
}

/** 每日签到（成功后用服务端返回值刷新） */
async function handleCheckin() {
  if (signedToday.value) {
    uni.showToast({ title: '今天已经签到啦', icon: 'none' })
    return
  }
  try {
    const r = await signApi()
    points.value = r.balance
    continueSignDay.value = r.continuousDays
    totalSignDay.value = r.totalDays
    signedToday.value = true
    todayPoints.value = 0
    uni.showToast({ title: `签到成功 +${r.points} 积分`, icon: 'none' })
  } catch (e: any) {
    uni.showToast({ title: (e && e.msg) ? e.msg : '签到失败', icon: 'none' })
  }
}

function showRules() {
  uni.navigateTo({ url: '/pages-sub/checkin/points-rules' })
}

/** 兑换免广告（成功后读服务端余额与剩余分钟） */
async function handleExchange(p: ExchangeProduct) {
  if (points.value < p.costPoints) {
    uni.showToast({ title: '积分不足', icon: 'none' })
    return
  }
  try {
    const r = await exchangeAdFreeApi(p.tier)
    points.value = r.balance
    hasAdFree.value = !!r.adFree
    adFreeMinutes.value = r.adFreeRemainMinutes || 0
    uni.showToast({ title: `兑换成功，${p.name}`, icon: 'none' })
  } catch (e: any) {
    uni.showToast({ title: (e && e.msg) ? e.msg : '兑换失败', icon: 'none' })
  }
}

onLoad(() => {
  loadAll()
  loadTiers()
  loadAdConfig()
})
</script>

<style lang="scss" scoped>
.task-page {
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
.nav-bar-inner { display: flex; align-items: center; justify-content: space-between; padding-left: 16rpx; }
.nav-left { display: flex; align-items: center; }
.nav-back { width: 72rpx; height: 72rpx; display: flex; align-items: center; justify-content: center; }
.back-icon { font-size: 44rpx; color: $edu-text-primary; }
.nav-title { font-size: 40rpx; font-weight: 700; color: $edu-text-primary; margin-left: 8rpx; }
.record-btn {
  height: 64rpx; padding: 0 28rpx; border-radius: 32rpx;
  display: flex; align-items: center; justify-content: center;
  background-color: $edu-primary-container;
}
.record-btn-text { font-size: 26rpx; color: $edu-primary; font-weight: 500; }

/* ===== 积分卡 ===== */
.points-card {
  margin-top: 24rpx;
  border-radius: 32rpx;
  padding: 44rpx 40rpx 36rpx;
  display: flex;
  flex-direction: column;
  align-items: center;
  @include eduBrandGradient;
  box-shadow: 0 16rpx 32rpx rgba(54, 119, 239, 0.25);
}
.points-label { font-size: 28rpx; color: rgba(255, 255, 255, 0.9); }
.points-value { font-size: 96rpx; font-weight: 800; color: #FFFFFF; line-height: 1.2; margin: 8rpx 0 24rpx; }
.points-foot { display: flex; align-items: center; justify-content: center; }
.points-foot-text { font-size: 26rpx; color: rgba(255, 255, 255, 0.9); margin: 0 24rpx; }

/* ===== 签到按钮 ===== */
.checkin-btn {
  margin-top: 32rpx;
  height: 108rpx;
  border-radius: 24rpx;
  display: flex; align-items: center; justify-content: center;
  background: linear-gradient(135deg, #00C2D4 0%, #00A2B6 100%);
  box-shadow: 0 12rpx 24rpx rgba(0, 176, 192, 0.22);
}
.checkin-btn-done { background: $edu-surface-variant; box-shadow: none; }
.checkin-btn-text { font-size: 34rpx; font-weight: 700; color: #FFFFFF; }
.checkin-btn-done .checkin-btn-text { color: $edu-text-hint; }

/* ===== 信息卡 ===== */
.info-card {
  margin-top: 28rpx;
  min-height: 108rpx;
  border-radius: 24rpx;
  padding: 0 32rpx;
  display: flex; align-items: center;
  background-color: $edu-surface-variant;
}
.info-card-between { justify-content: space-between; }
.status-dot { width: 16rpx; height: 16rpx; border-radius: 50%; background-color: $edu-text-hint; margin-right: 20rpx; flex-shrink: 0; }
.status-dot-on { background-color: $edu-accent-teal; }
.status-text { font-size: 30rpx; color: $edu-text-secondary; }
.rules-title { font-size: 32rpx; font-weight: 600; color: $edu-text-primary; }
.rules-link { font-size: 28rpx; color: $edu-primary; }

/* ===== 兑换区 ===== */
.section-title { display: block; font-size: 34rpx; font-weight: 700; color: $edu-text-primary; margin: 44rpx 0 24rpx; }
.exchange-card {
  border-radius: 24rpx;
  padding: 32rpx;
  display: flex; align-items: center; justify-content: space-between;
  background-color: $edu-surface-variant;
  margin-bottom: 24rpx;
}
.exchange-info { display: flex; flex-direction: column; }
.exchange-name { font-size: 32rpx; font-weight: 600; color: $edu-text-primary; margin-bottom: 12rpx; }
.exchange-cost { font-size: 26rpx; color: $edu-text-hint; }
.exchange-btn {
  height: 72rpx; padding: 0 48rpx; border-radius: 36rpx;
  display: flex; align-items: center; justify-content: center;
  background-color: $edu-primary;
}
.exchange-btn-disabled { background-color: $edu-outline; }
.exchange-btn-text { font-size: 28rpx; font-weight: 500; color: #FFFFFF; }

/* ===== 看激励视频领积分 ===== */
.ad-card {
  margin-top: 28rpx; border-radius: 24rpx; padding: 28rpx 32rpx;
  display: flex; align-items: center; justify-content: space-between;
  background: linear-gradient(135deg, #FFF3E0 0%, #FFE6C7 100%);
}
.ad-card-off { background: $edu-surface-variant; }
.ad-card-info { display: flex; flex-direction: column; }
.ad-card-title { font-size: 32rpx; font-weight: 600; color: $edu-text-primary; margin-bottom: 10rpx; }
.ad-card-sub { font-size: 24rpx; color: $edu-text-secondary; }
.ad-card-btn {
  height: 68rpx; padding: 0 40rpx; border-radius: 34rpx;
  display: flex; align-items: center; justify-content: center;
  background-color: #F59300;
}
.ad-card-off .ad-card-btn { background-color: $edu-outline; }
.ad-card-btn-text { font-size: 28rpx; font-weight: 500; color: #FFFFFF; }
</style>
<!-- src/pages-sub/checkin/points-rules.vue -->
<template>
  <view class="rules-page" :class="themeClass">
    <view class="nav-bar" :class="{ 'nav-bar-opaque': navBarOpaque }" :style="{ paddingTop: statusBarHeight + 'px' }">
      <view class="nav-bar-inner" :style="{ height: navContentHeight + 'px' }">
        <view class="nav-back" @tap="goBack"><text class="back-icon">←</text></view>
        <text class="nav-title">任务与积分规则</text>
      </view>
    </view>
    <view class="nav-placeholder" :style="{ height: (statusBarHeight + navContentHeight) + 'px' }"></view>

    <!-- 做任务，赚积分（概览） -->
    <view class="overview-card">
      <view class="ov-head">
        <text class="ov-title">做任务，赚积分</text>
        <view class="ov-pill"><text class="ov-pill-text">每日上限 {{ cap }} 分</text></view>
      </view>
      <text class="ov-sub">完成任务即可获得积分，积分可在积分商城兑换奖品。</text>
      <view class="ov-grid">
        <view class="ov-item" v-for="o in overview" :key="o.key">
          <text class="ov-num">{{ o.value }}</text>
          <text class="ov-key">{{ o.key }}</text>
        </view>
      </view>
    </view>

    <!-- 签到任务 -->
    <view class="rule-card">
      <view class="rc-head">
        <view class="rc-icon ri-teal"><text class="rc-icon-glyph">📅</text></view>
        <view class="rc-head-text">
          <text class="rc-title">签到任务</text>
          <text class="rc-sub">7 天一个周期，每天最多签到 1 次</text>
        </view>
      </view>
      <view class="rc-days">
        <view class="rc-day" v-for="d in signChips" :key="d.day">
          <text class="rc-day-name">第{{ d.day }}天</text>
          <text class="rc-day-reward">+{{ d.reward }}</text>
        </view>
      </view>
      <view class="bullet" v-for="(b, i) in signBullets" :key="'sb'+i">
        <text class="bullet-dot">•</text><text class="bullet-text">{{ b }}</text>
      </view>
    </view>

    <!-- 其余规则卡（数据驱动） -->
    <view class="rule-card" v-for="s in sections" :key="s.title">
      <view class="rc-head">
        <view class="rc-icon" :class="'ri-' + s.bg"><text class="rc-icon-glyph">{{ s.icon }}</text></view>
        <view class="rc-head-text">
          <text class="rc-title">{{ s.title }}</text>
          <text class="rc-sub">{{ s.sub }}</text>
        </view>
      </view>
      <view class="bullet" v-for="(b, i) in s.bullets" :key="s.title+i">
        <text class="bullet-dot">•</text><text class="bullet-text">{{ b }}</text>
      </view>
    </view>

    <text class="foot-note">规则以服务端结算为准，每日 0 点重置任务进度</text>
  </view>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { onPageScroll } from '@dcloudio/uni-app'
import { CONTINUOUS_REWARDS, CONTENT_DAILY_CAP } from '@/composables/pointsRule'
import { useTheme } from '@/composables/useTheme'

const { themeClass } = useTheme()

const cap = CONTENT_DAILY_CAP

/* ===== 顶部栏高度 ===== */
const statusBarHeight = ref<number>(0)
const navContentHeight = ref<number>(44)
const sysInfo = uni.getSystemInfoSync()
statusBarHeight.value = sysInfo.statusBarHeight || 0
// #ifdef MP-WEIXIN
const menuButton = uni.getMenuButtonBoundingClientRect()
if (menuButton) navContentHeight.value = (menuButton.top - statusBarHeight.value) * 2 + menuButton.height
// #endif

const navBarOpaque = ref<boolean>(false)
onPageScroll((e) => { navBarOpaque.value = e.scrollTop > 40 })

/* ===== 概览 ===== */
const overview = [
  { value: '+1~7', key: '签到' },
  { value: '+5', key: '课程视频' },
  { value: '+5', key: '帖子' },
  { value: '+10', key: '广告' }
]

/* ===== 签到档位 ===== */
const signChips = CONTINUOUS_REWARDS.map((reward, i) => ({ day: i + 1, reward }))
const signBullets = [
  '每 7 天为一个周期，每人每天最多产生 1 条签到记录。',
  '周期内第 1 天签到 +1 分，连续第 2 天 +2 分，依次递增至第 7 天 +7 分。',
  '一个周期结束后，下一次签到重新从新周期的第 1 天计算（+1 分），连续签到天数继续累计。',
  '周期内出现断签，本周期作废；从断签后的第一次签到起，重新从第 1 天（+1 分）开始计算。'
]

/* ===== 其余规则卡 ===== */
interface RuleSection { icon: string; bg: string; title: string; sub: string; bullets: string[] }
const sections: RuleSection[] = [
  {
    icon: '▶', bg: 'blue', title: '观看课程视频', sub: '仅课程视频计入积分，短视频不计分',
    bullets: [
      '仅课程视频（课程详情 / 播放页）计入积分，视频 Tab 的短视频不再获得积分。',
      '单个课程视频观看满 30 秒，才可获得 5 积分。',
      '每个课程视频内容最多获得 5 分，同一内容不重复计分。',
      '观看时长从视频实际开始播放后累计，拖动进度条不计入有效观看时长。'
    ]
  },
  {
    icon: '💬', bg: 'coral', title: '浏览帖子', sub: '社区文章与帖子',
    bullets: [
      '每篇文章 / 帖子浏览时长达到 30 秒，才可获得 5 积分。',
      '每篇文章 / 帖子最多获得 5 分，同一内容不重复计分。'
    ]
  },
  {
    icon: '👁', bg: 'yellow', title: '观看广告', sub: '完整观看才算有效',
    bullets: [
      '完整看完一条广告，可获得 10 积分。',
      '同一广告内容每天只计 1 次，次日可再次观看并重新计分。',
      '中途关闭、未播放完的广告不计分。'
    ]
  },
  {
    icon: '✓', bg: 'blue', title: '每日积分上限', sub: '所有任务合并计算',
    bullets: [
      '以上所有任务当日获得的积分合计不超过 50 分。',
      '达到 50 分后，继续完成任务不再增加积分，超出部分不计入。',
      '每日 0 点重置任务进度与当日积分统计；已获得的积分余额不受影响。'
    ]
  },
  {
    icon: '★', bg: 'yellow', title: '积分商城', sub: '用积分兑换奖品',
    bullets: [
      '任务获得的积分可在积分商城兑换奖品。',
      '具体可兑换奖品、所需积分与库存以积分商城页面为准。',
      '兑换只扣减积分余额，不影响任务进度与每日积分统计。'
    ]
  }
]

function goBack() {
  const pages = getCurrentPages()
  if (pages.length > 1) uni.navigateBack()
  else uni.reLaunch({ url: '/pages/index/index' })
}
</script>

<style lang="scss" scoped>
.rules-page { min-height: 100vh; box-sizing: border-box; padding: 0 32rpx 60rpx; @include eduPageGradientStrong; }

/* ===== 顶部栏 ===== */
.nav-bar { position: fixed; top: 0; left: 0; right: 0; z-index: 99; background: transparent; transition: background-color 0.3s ease, box-shadow 0.3s ease; }
.nav-bar-opaque { background: var(--edu-surface); box-shadow: 0 2rpx 12rpx rgba(0, 0, 0, 0.06); }
.nav-bar-inner { display: flex; align-items: center; padding-left: 16rpx; }
.nav-back { width: 72rpx; height: 72rpx; display: flex; align-items: center; justify-content: center; }
.back-icon { font-size: 44rpx; color: $edu-text-primary; }
.nav-title { font-size: 40rpx; font-weight: 700; color: $edu-text-primary; margin-left: 8rpx; }

/* ===== 概览卡 ===== */
.overview-card { margin-top: 24rpx; border-radius: 32rpx; padding: 36rpx 32rpx; background-color: $edu-surface-variant; }
.ov-head { display: flex; align-items: center; justify-content: space-between; }
.ov-title { font-size: 36rpx; font-weight: 800; color: $edu-text-primary; }
.ov-pill { height: 48rpx; padding: 0 22rpx; border-radius: 24rpx; display: flex; align-items: center; background-color: $edu-primary-container; }
.ov-pill-text { font-size: 24rpx; color: $edu-primary; font-weight: 600; }
.ov-sub { display: block; font-size: 26rpx; color: $edu-text-secondary; margin-top: 16rpx; }
.ov-grid { display: flex; margin-top: 32rpx; }
.ov-item { flex: 1; display: flex; flex-direction: column; align-items: center; }
.ov-num { font-size: 40rpx; font-weight: 800; color: $edu-primary; }
.ov-item:nth-child(3) .ov-num { color: $edu-accent-coral; }
.ov-item:nth-child(4) .ov-num { color: #F0B000; }
.ov-key { font-size: 24rpx; color: $edu-text-secondary; margin-top: 10rpx; }

/* ===== 规则卡 ===== */
.rule-card { margin-top: 28rpx; border-radius: 32rpx; padding: 36rpx 32rpx; background-color: $edu-surface; box-shadow: 0 8rpx 24rpx rgba(0, 0, 0, 0.04); }
.rc-head { display: flex; align-items: center; }
.rc-icon { width: 72rpx; height: 72rpx; border-radius: 20rpx; display: flex; align-items: center; justify-content: center; flex-shrink: 0; }
.ri-blue { background-color: $edu-primary-container; }
.ri-teal { background-color: #DCF2F5; }
.ri-coral { background-color: $edu-tab-community-bg; }
.ri-yellow { background-color: #FBEFD2; }
.rc-icon-glyph { font-size: 36rpx; }
.rc-head-text { margin-left: 24rpx; }
.rc-title { display: block; font-size: 34rpx; font-weight: 700; color: $edu-text-primary; }
.rc-sub { display: block; font-size: 24rpx; color: $edu-text-hint; margin-top: 8rpx; }

.rc-days { display: flex; justify-content: space-between; margin: 32rpx 0 8rpx; }
.rc-day { width: 76rpx; height: 100rpx; border-radius: 18rpx; display: flex; flex-direction: column; align-items: center; justify-content: center; background-color: #DCF2F5; }
.rc-day-name { font-size: 20rpx; color: #0E6E78; }
.rc-day-reward { font-size: 26rpx; font-weight: 700; color: #0E6E78; margin-top: 8rpx; }

.bullet { display: flex; align-items: flex-start; margin-top: 20rpx; }
.bullet-dot { font-size: 28rpx; color: $edu-primary; margin-right: 16rpx; line-height: 1.6; }
.bullet-text { flex: 1; font-size: 28rpx; color: $edu-text-secondary; line-height: 1.6; }

.foot-note { display: block; font-size: 24rpx; color: $edu-text-hint; text-align: center; margin-top: 40rpx; }
</style>
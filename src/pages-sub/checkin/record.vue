<template>
  <view class="record-page">
    <!-- 固定顶部栏：返回 + 标题 -->
    <view class="nav-bar" :class="{ 'nav-bar-opaque': navBarOpaque }" :style="{ paddingTop: statusBarHeight + 'px' }">
      <view class="nav-bar-inner" :style="{ height: navContentHeight + 'px' }">
        <view class="nav-back" @tap="goBack">
          <text class="back-icon">←</text>
        </view>
        <text class="nav-title">签到记录</text>
      </view>
    </view>
    <view class="nav-placeholder" :style="{ height: (statusBarHeight + navContentHeight) + 'px' }"></view>

    <!-- 日历卡 -->
    <view class="calendar-card">
      <view class="month-row">
        <text class="month-title">{{ year }} 年 {{ month }} 月</text>
        <view class="month-switch">
          <view
              class="month-btn"
              :class="{ 'month-btn-disabled': atEarliestMonth }"
              hover-class="month-btn-pressed"
              @tap="shiftMonth(-1)"
          >
            <text class="month-btn-icon">‹</text>
          </view>
          <view
              class="month-btn"
              :class="{ 'month-btn-disabled': atLatestMonth }"
              hover-class="month-btn-pressed"
              @tap="shiftMonth(1)"
          >
            <text class="month-btn-icon">›</text>
          </view>
        </view>
      </view>

      <view class="week-row">
        <text v-for="w in weekLabels" :key="w" class="week-cell">{{ w }}</text>
      </view>

      <view class="day-grid">
        <view v-for="(cell, idx) in cells" :key="idx" class="day-cell">
          <view
              v-if="!cell.blank"
              class="day-dot"
              :class="{ 'day-dot-signed': cell.signed && !cell.isToday, 'day-dot-today': cell.isToday }"
          >
            <text
                class="day-text"
                :class="{ 'day-text-signed': cell.signed && !cell.isToday, 'day-text-today': cell.isToday }"
            >{{ cell.day }}</text>
          </view>
        </view>
      </view>

      <view class="legend-row">
        <view class="legend-item">
          <view class="legend-dot legend-dot-signed"></view>
          <text class="legend-text">已签到</text>
        </view>
        <view class="legend-item">
          <view class="legend-dot legend-dot-today"></view>
          <text class="legend-text">今天</text>
        </view>
      </view>
    </view>

    <!-- 汇总统计（全局值，不随月份切换变化） -->
    <view class="stat-row">
      <view class="stat-card">
        <text class="stat-value">{{ summary.continueSignDay }} 天</text>
        <text class="stat-label">连续签到</text>
      </view>
      <view class="stat-card">
        <text class="stat-value">{{ summary.totalSignDay }} 天</text>
        <text class="stat-label">累计签到</text>
      </view>
      <view class="stat-card">
        <text class="stat-value">{{ summary.points }}</text>
        <text class="stat-label">总积分</text>
      </view>
    </view>

    <!-- 签到明细：三态 -->
    <text class="section-title">{{ month }} 月签到记录</text>
    <LoadingState v-if="state === 'loading'" text="正在加载签到记录…" />
    <ErrorState v-else-if="state === 'error'" text="签到记录加载失败" @retry="loadCalendar" />
    <EmptyState v-else-if="monthRecords.length === 0" text="该月还没有签到记录" />
    <view class="record-list" v-else>
      <view v-for="r in monthRecords" :key="r.dateKey" class="record-card">
        <view class="record-check">
          <text class="record-check-icon">✓</text>
        </view>
        <text class="record-date">{{ r.label }}</text>
        <text class="record-points">+{{ r.points }} 积分</text>
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
import LoadingState from '@/components/LoadingState.vue'
import ErrorState from '@/components/ErrorState.vue'
import EmptyState from '@/components/EmptyState.vue'

/** 页面数据状态：蓝本 5.1 三态统一 */
const state = ref<'loading' | 'error' | 'ready'>('loading')
import { ref, reactive, computed } from 'vue'
import { onLoad, onPageScroll } from '@dcloudio/uni-app'
import { rewardOf } from '@/composables/pointsRule'
import { getSignCalendarApi } from '@/api/user'

/* ===================================================================
 * 日期处理约定（防 off-by-one）：
 * 1. 唯一数据源是 monthStart（当月 1 号的 Date 对象），year/month 由它派生；
 * 2. 所有月份加减交给 Date 构造函数（自动跨年进/借位），不做 y*12+m 逆解；
 * 3. 日期字符串只「生成」不「解析」，展示所需的星期一律由 Date 对象算。
 * =================================================================== */

const WEEK_GAP = 24

function pad(n: number): string {
  return n < 10 ? '0' + n : String(n)
}

/** 当天 0 点，避免时分秒干扰比较 */
function todayNoon(): Date {
  const t = new Date()
  return new Date(t.getFullYear(), t.getMonth(), t.getDate())
}

/** 某年某月（month 为 1-12）的 1 号 */
function firstDayOfMonth(y: number, m: number): Date {
  return new Date(y, m - 1, 1)
}

/** 某年某月（month 为 1-12）的最后一天日号：下个月第 0 天 = 本月月末 */
function daysOfMonth(y: number, m: number): number {
  return new Date(y, m, 0).getDate()
}

/** 两个「月初」相差几个月（a - b） */
function monthGap(a: Date, b: Date): number {
  return (a.getFullYear() - b.getFullYear()) * 12 + (a.getMonth() - b.getMonth())
}

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
onPageScroll((e) => {
  navBarOpaque.value = e.scrollTop > 40
})

/* ===== 当前查看的月份（唯一状态源） ===== */
const today = todayNoon()
const latestStart = firstDayOfMonth(today.getFullYear(), today.getMonth() + 1)

const monthStart = ref<Date>(latestStart)
const year = computed<number>(() => monthStart.value.getFullYear())
const month = computed<number>(() => monthStart.value.getMonth() + 1)
const isCurrentMonth = computed<boolean>(() => monthStart.value.getTime() === latestStart.getTime())
/** 相对今天往回第几个月：0 = 本月，-23 = 最早可见 */
const offsetFromToday = computed<number>(() => monthGap(monthStart.value, latestStart))
const atLatestMonth = computed<boolean>(() => offsetFromToday.value >= 0)
const atEarliestMonth = computed<boolean>(() => offsetFromToday.value <= -(WEEK_GAP - 1))

/* ===== 日历数据（接口：GET user/sign-calendar?year&month → signedDates） ===== */
const signedDates = ref<string[]>([])
/** 当月已签到的「日号」集合，模板判断用，避免字符串拼接比对 */
const signedDaySet = computed<Set<number>>(() => {
  const set = new Set<number>()
  signedDates.value.forEach((key) => {
    const day = Number(key.slice(-2))
    if (day > 0) set.add(day)
  })
  return set
})

function dateKeyOf(day: number): string {
  return `${year.value}-${pad(month.value)}-${pad(day)}`
}

const summary = reactive({
  continueSignDay: 0,
  totalSignDay: 0,
  points: 0
})

interface DayCell { day: number; signed: boolean; isToday: boolean; blank: boolean }

const cells = computed<DayCell[]>(() => {
  const y = year.value
  const m = month.value
  const firstWeekday = monthStart.value.getDay()
  const total = daysOfMonth(y, m)
  const list: DayCell[] = []
  for (let i = 0; i < firstWeekday; i++) {
    list.push({ day: 0, signed: false, isToday: false, blank: true })
  }
  for (let d = 1; d <= total; d++) {
    const isToday = isCurrentMonth.value && today.getDate() === d
    list.push({
      day: d,
      signed: signedDaySet.value.has(d),
      isToday,
      blank: false
    })
  }
  return list
})

/* ===== 签到明细（字段对齐 checkins/records） ===== */
interface MonthRecord { dateKey: string; label: string; points: number }

const weekdayNames = ['周日', '周一', '周二', '周三', '周四', '周五', '周六']

/** 由日号正序生成记录并倒序取最近 6 条，星期由 Date 现算 */
const monthRecords = computed<MonthRecord[]>(() => {
  const days = Array.from(signedDaySet.value).sort((a, b) => b - a).slice(0, 6)
  const total = signedDaySet.value.size
  return days.map((day, idx) => {
    const d = firstDayOfMonth(year.value, month.value)
    const weekday = new Date(d.getFullYear(), d.getMonth(), day).getDay()
    return {
      dateKey: dateKeyOf(day),
      label: `${pad(month.value)}-${pad(day)} ${weekdayNames[weekday]}`,
      // TODO 接口接入后改用后端返回的 record.points，前端不再推算
      points: rewardOf(Math.max(1, total - idx))
    }
  })
})

function goBack() {
  const pages = getCurrentPages()
  if (pages.length > 1) uni.navigateBack()
  else uni.reLaunch({ url: '/pages/index/index' })
}

/* ===== 月份切换 ===== */
function shiftMonth(delta: number) {
  const target = new Date(monthStart.value.getFullYear(), monthStart.value.getMonth() + delta, 1)
  const gap = monthGap(target, latestStart)

  if (gap > 0) {
    uni.showToast({ title: '不能查看未来月份', icon: 'none' })
    return
  }
  if (gap < -(WEEK_GAP - 1)) {
    uni.showToast({ title: `最多查看近 ${WEEK_GAP} 个月记录`, icon: 'none' })
    return
  }
  monthStart.value = target
  loadCalendar()
}

/** 点击日期查看当天记录（预留：后续可跳签到详情） */
function handleDayTap(cell: DayCell) {
  if (cell.blank || !cell.signed) return
  uni.showToast({ title: `${dateKeyOf(cell.day)} 已签到`, icon: 'none' })
}

/** 按月加载日历，切月只重跑这个函数 */
async function loadCalendar() {
  state.value = 'loading'
  try {
    const res = await getSignCalendarApi(year.value, month.value)
    signedDates.value = res.signedDates || []
    summary.continueSignDay = res.continueSignDay || 0
    summary.totalSignDay = res.totalSignDay || 0
    state.value = 'ready'
  } catch (e) {
    state.value = 'error'
  }
}

/** 总积分属用户中心，与日历独立；进页取一次，不随月份变化 */
function loadSummary() {
  summary.points = 286
  // 接口接入：GET user/profile → points
}

onLoad(() => {
  loadCalendar()
  loadSummary()
})
</script>

<style lang="scss" scoped>
.record-page {
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
.nav-title { font-size: 40rpx; font-weight: 700; color: $edu-text-primary; margin-left: 8rpx; }

/* ===== 日历卡 ===== */
.calendar-card {
  margin-top: 24rpx;
  padding: 40rpx 32rpx 36rpx;
  border-radius: 32rpx;
  background-color: $edu-surface-variant;
}
.month-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 32rpx;
}
.month-title {
  font-size: 36rpx;
  font-weight: 700;
  color: $edu-text-primary;
}
.month-switch { display: flex; align-items: center; }
.month-btn {
  width: 72rpx;
  height: 72rpx;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: $edu-surface;
  transition: background-color 0.15s ease;
}
.month-btn + .month-btn { margin-left: 16rpx; }
.month-btn-pressed { background-color: $edu-primary-container; }
.month-btn-disabled { background-color: transparent; }
.month-btn-icon { font-size: 44rpx; line-height: 48rpx; color: $edu-primary; }
.month-btn-disabled .month-btn-icon { color: $edu-text-hint; }

.week-row { display: flex; }
.week-cell {
  width: 14.285%;
  text-align: center;
  font-size: 26rpx;
  color: $edu-text-hint;
  margin-bottom: 20rpx;
}
.day-grid { display: flex; flex-wrap: wrap; }
.day-cell { width: 14.285%; display: flex; align-items: center; justify-content: center; height: 96rpx; }
.day-dot {
  width: 80rpx;
  height: 80rpx;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
}
.day-dot-signed { background-color: $edu-primary-container; }
.day-dot-today { background-color: $edu-primary; }
.day-text { font-size: 30rpx; color: $edu-text-secondary; }
.day-text-signed { color: $edu-primary; }
.day-text-today { color: #FFFFFF; font-weight: 600; }

.legend-row { display: flex; align-items: center; margin-top: 28rpx; }
.legend-item { display: flex; align-items: center; margin-right: 48rpx; }
.legend-dot { width: 28rpx; height: 28rpx; border-radius: 50%; margin-right: 12rpx; }
.legend-dot-signed { background-color: $edu-primary-container; }
.legend-dot-today { background-color: $edu-primary; }
.legend-text { font-size: 26rpx; color: $edu-text-secondary; }

/* ===== 汇总统计 ===== */
.stat-row { display: flex; align-items: center; justify-content: space-between; margin-top: 28rpx; }
.stat-card {
  flex: 1;
  margin-right: 20rpx;
  padding: 36rpx 24rpx;
  border-radius: 24rpx;
  background-color: $edu-surface-variant;
  display: flex;
  flex-direction: column;
  align-items: center;
}
.stat-card:last-child { margin-right: 0; }
.stat-value { font-size: 40rpx; font-weight: 700; color: $edu-primary; margin-bottom: 16rpx; }
.stat-label { font-size: 26rpx; color: $edu-text-secondary; }

/* ===== 签到明细 ===== */
.section-title {
  display: block;
  font-size: 34rpx;
  font-weight: 700;
  color: $edu-text-primary;
  margin: 44rpx 0 24rpx;
}
.record-card {
  display: flex;
  align-items: center;
  padding: 32rpx;
  border-radius: 24rpx;
  background-color: $edu-surface-variant;
  margin-bottom: 20rpx;
}
.record-check {
  width: 72rpx;
  height: 72rpx;
  border-radius: 50%;
  background-color: $edu-primary-container;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 24rpx;
  flex-shrink: 0;
}
.record-check-icon { font-size: 34rpx; font-weight: 700; color: $edu-primary; }
.record-date { flex: 1; font-size: 32rpx; color: $edu-text-primary; }
.record-points { font-size: 32rpx; font-weight: 700; color: $edu-primary; }

/* ===== 空态 ===== */
.empty { padding: 120rpx 0; display: flex; justify-content: center; }
.empty-text { font-size: 28rpx; color: $edu-text-hint; }
</style>
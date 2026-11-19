/**
 * 连续签到积分奖励表：第 1~7 天分别 1/2/3/4/5/6/7 分，第 8 天起按 7 天周期循环。
 * 与后端 CheckinRule.TIERS、《19_积分规则》《08_任务中心》设计稿同源（旧稿 5/8/…/20 已废弃）。
 */
export const CONTINUOUS_REWARDS: number[] = [1, 2, 3, 4, 5, 6, 7]

/** 按连续天数取当日奖励，断签由后端重置为 1 */
export function rewardOf(continuousDay: number): number {
    const len = CONTINUOUS_REWARDS.length
    const day = continuousDay > 0 ? continuousDay : 1
    return CONTINUOUS_REWARDS[(day - 1) % len]
}

/* ===== 任务积分规则（与后端 PointsSource 定稿一致，2026-11-11） ===== */
/** 观看课程小节 / 浏览帖子：单条内容看满该秒数得 CONTENT_POINTS 分，每天每内容只发一次 */
export const CONTENT_MIN_SECONDS = 30
export const CONTENT_POINTS = 5
/** 课程 + 帖子两类内容合计每日上限（即今日任务积分封顶） */
export const CONTENT_DAILY_CAP = 50
/** 完整看完一条激励视频得 AD_POINTS 分，每天最多 AD_DAILY_LIMIT 条（不占内容 50 分额度） */
export const AD_POINTS = 10
export const AD_DAILY_LIMIT = 3

/** 积分兑换免广告档位（产品已决定下线，保留仅供历史引用，UI 不再展示） */
export interface AdFreeProduct {
    points: number
    minutes: number
    label: string
}

export const AD_FREE_PRODUCTS: AdFreeProduct[] = [
    { points: 10, minutes: 30, label: '免广告 30 分钟' },
    { points: 30, minutes: 120, label: '免广告 2 小时' },
    { points: 100, minutes: 1440, label: '免广告 24 小时' }
]
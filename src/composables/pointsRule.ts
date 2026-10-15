/** 连续签到积分奖励表：第 1~7 天，7 天后按周期循环（与「积分获取规则」页同源） */
export const CONTINUOUS_REWARDS: number[] = [5, 8, 10, 12, 15, 18, 20]

/** 按连续天数取当日奖励，断签由后端重置为 1 */
export function rewardOf(continuousDay: number): number {
    const len = CONTINUOUS_REWARDS.length
    const day = continuousDay > 0 ? continuousDay : 1
    return CONTINUOUS_REWARDS[(day - 1) % len]
}

/** 积分兑换免广告档位 */
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
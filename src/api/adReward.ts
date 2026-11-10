// src/api/adReward.ts
import { get, v1 } from '@/utils/request'
import { API_READY } from '@/config/apiStatus'
import { getPointsAccountApi } from '@/api/points'

/** 看广告得积分配置（后端 /api/v1/ad/reward/config 下发；未就绪时走 mock） */
export interface AdRewardConfig {
    pointsPerView: number   // 每看完一条激励视频的积分（服务端定，前端只展示）
    dailyLimit: number      // 每日上限次数（防刷）
    todayUsed: number       // 今日已看次数
}

/** 拉取看广告配置；开关关闭时返回本地 mock，页面照常渲染 */
export function getAdRewardConfigApi(): Promise<AdRewardConfig> {
    if (!API_READY.adReward) {
        return Promise.resolve({ pointsPerView: 10, dailyLimit: 5, todayUsed: 0 })
    }
    return get(v1('/ad/reward/config'))
}

/** 看完广告后刷新余额（SSV 回调可能有延迟，调用方应轮询/延时再取） */
export async function refreshBalanceAfterAd(): Promise<number> {
    const acc = await getPointsAccountApi()
    return acc.balance || 0
}
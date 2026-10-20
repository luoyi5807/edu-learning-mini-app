// src/api/points.ts
import { get, post, v1 } from '@/utils/request'
import { API_READY } from '@/config/apiStatus'

/** GET /api/v1/points/账户 */
export interface PointsAccount {
    balance: number
    adFree: boolean
    adFreeExpireTime: string | null
    adFreeRemainMinutes: number
}

/** 兑换档位 */
export interface ExchangeTier {
    tier: number
    cost: number
    minutes: number
    label: string
}

/** POST /api/v1/points/exchange 返回 */
export interface ExchangeResult extends PointsAccount {
    cost: number
    label: string
}

/** 我的积分账户（余额 + 免广告权益） */
export function getPointsAccountApi(): Promise<PointsAccount> {
    if (!API_READY.points) return Promise.resolve({ balance: 286, adFree: false, adFreeExpireTime: null, adFreeRemainMinutes: 0 })
    return get(v1('/points/account'))
}

/** 免广告兑换档位 */
export async function getExchangeTiersApi(): Promise<ExchangeTier[]> {
    if (!API_READY.points) return []
    const res: any = await get(v1('/points/exchange/tiers'))
    return (res && Array.isArray(res.tiers)) ? res.tiers : []
}

/** 兑换免广告（tier：1=10分/30分钟 2=30分/2小时 3=100分/24小时） */
export function exchangeAdFreeApi(tier: number): Promise<ExchangeResult> {
    if (!API_READY.points) return Promise.reject({ code: 501, msg: '后端未连接' })
    return post(v1('/points/exchange'), { tier: String(tier) })
}
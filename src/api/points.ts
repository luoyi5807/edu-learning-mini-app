// src/api/points.ts
import { get, post, v1 } from '@/utils/request'
import { API_READY, todayKey } from '@/config/apiStatus'
import { CONTENT_DAILY_CAP } from '@/composables/pointsRule'

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

/** 我的积分账户：GET /api/v1/points/account（后端已补齐，余额/免广告权益都是响应顶层字段） */
export async function getPointsAccountApi(): Promise<PointsAccount> {
    if (!API_READY.points) return { balance: 286, adFree: false, adFreeExpireTime: null, adFreeRemainMinutes: 0 }
    const body: any = await get(v1('/points/account'), {}, { showError: false })
    return {
        balance: Number(body?.balance) || 0,
        adFree: body?.adFree === true || body?.adFree === 'true' || body?.adFree === 1,
        adFreeExpireTime: body?.adFreeExpireTime || null,
        adFreeRemainMinutes: Number(body?.adFreeRemainMinutes) || 0
    }
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

/* ===================== 观看/阅读上报（积分获取） ===================== */

/** POST /api/v1/points/watch 返回 */
export interface WatchResult {
    awardedPoints: number
    todayContentPoints: number
    todayContentLimit: number
    watchedSeconds: number
}

const DAILY_TASK_KEY = 'dailyTaskPoints'
interface DailyTaskCache { date: string; contentPoints: number }

function readDailyCache(): DailyTaskCache {
    const today = todayKey()
    const raw = uni.getStorageSync(DAILY_TASK_KEY)
    if (raw && raw.date === today) return raw as DailyTaskCache
    return { date: today, contentPoints: 0 }
}

/** 任务中心「今日任务积分 X/50」：读本地缓存（由 watch/report 成功后写入，跨天自动归零） */
export function getTodayContentPoints(): number {
    return readDailyCache().contentPoints
}
export function setTodayContentPoints(v: number): void {
    const c = readDailyCache()
    c.contentPoints = v
    uni.setStorageSync(DAILY_TASK_KEY, c)
}

/**
 * 上报观看/阅读时长：帖子浏览、课程小节观看都走这里。
 * 服务端按「同一内容当天只发一次 + 每日 50 分封顶」去重，返回 awardedPoints=0 时前端无需提示。
 * 成功后把服务端算好的 todayContentPoints 落本地，供任务中心展示进度。
 */
export async function reportWatchApi(targetType: 'post' | 'courseVideo', targetId: number, seconds: number): Promise<WatchResult> {
    if (!API_READY.pointsWatch) {
        return { awardedPoints: 0, todayContentPoints: getTodayContentPoints(), todayContentLimit: CONTENT_DAILY_CAP, watchedSeconds: seconds }
    }
    const res: any = await post(v1('/points/watch'), {
        targetType, targetId: String(targetId), seconds: String(seconds)
    }, { showError: false })
    const out: WatchResult = {
        awardedPoints: Number(res?.awardedPoints) || 0,
        todayContentPoints: Number(res?.todayContentPoints) || getTodayContentPoints(),
        todayContentLimit: Number(res?.todayContentLimit) || CONTENT_DAILY_CAP,
        watchedSeconds: Number(res?.watchedSeconds) || 0
    }
    setTodayContentPoints(out.todayContentPoints)
    return out
}

/* ===================== 激励视频奖励上报 ===================== */

/** POST /api/v1/points/ad/reward 返回 */
export interface AdRewardResult {
    awardedPoints: number
    todayAdCount: number
    todayAdLimit: number
}

/**
 * 看完广告后上报。服务端约束：adId ≤64 字符且同 adId 只计 1 次、seconds ≥15、每天最多 3 条。
 * @param adId 本次广告唯一标识（前端生成，模拟模式也用真实上报以验证服务端链路）
 * @param seconds 观看秒数，模拟模式按 15 保底
 */
export async function reportAdRewardApi(adId: string, seconds = 15): Promise<AdRewardResult> {
    if (!API_READY.adReward) return { awardedPoints: 10, todayAdCount: 1, todayAdLimit: 3 }
    const res: any = await post(v1('/points/ad/reward'), { adId, seconds: String(seconds) }, { showError: false })
    return {
        awardedPoints: Number(res?.awardedPoints) || 0,
        todayAdCount: Number(res?.todayAdCount) || 0,
        todayAdLimit: Number(res?.todayAdLimit) || 3
    }
}

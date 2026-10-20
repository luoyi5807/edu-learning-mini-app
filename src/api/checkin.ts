// src/api/checkin.ts
import { get, post, v1 } from '@/utils/request'
import { API_READY } from '@/config/apiStatus'

/** GET /api/v1/checkin/status 返回 */
export interface CheckinStatus {
    signedToday: boolean
    todayPoints: number
    continuousDays: number
    totalDays: number
    balance: number
    today: string          // yyyy-MM-dd（服务端东八区）
}

/** POST /api/v1/checkin/sign 返回 */
export interface SignResult {
    points: number
    continuousDays: number
    totalDays: number
    balance: number
    signDate: string
}

/** GET /api/v1/checkin/calendar 返回 */
export interface CheckinCalendar {
    year: number
    month: number
    days: number[]         // 当月已签到的「日号」
    today: string
    signedToday: boolean
}

/** 签到记录行 learning_checkin */
export interface CheckinRecordDto {
    checkinId: number
    signDate: string       // yyyy-MM-dd
    points: number
    continuousDays: number
    createTime: string
}

/** GET /api/v1/checkin/rules 返回 */
export interface CheckinRules {
    tiers: { day: number; points: number }[]
    loopDays: number
    dailyLimit: number
    dailyTip: string
    resetNote: string
    loopNote: string
}

/* ===== mock 兜底（API_READY.checkin=false 时） ===== */
const mockStatus: CheckinStatus = { signedToday: false, todayPoints: 18, continuousDays: 12, totalDays: 132, balance: 286, today: '' }

/** 每日签到（无入参，用户身份由 Token 决定） */
export function signApi(): Promise<SignResult> {
    if (!API_READY.checkin) return Promise.resolve({ points: 18, continuousDays: 13, totalDays: 133, balance: 304, signDate: mockStatus.today })
    return post(v1('/checkin/sign'))
}

/** 签到状态（任务中心头部 / 签到大按钮） */
export function getCheckinStatusApi(): Promise<CheckinStatus> {
    if (!API_READY.checkin) return Promise.resolve({ ...mockStatus })
    return get(v1('/checkin/status'))
}

/** 某月签到日历 */
export function getCheckinCalendarApi(year: number, month: number): Promise<CheckinCalendar> {
    if (!API_READY.checkin) return Promise.resolve({ year, month, days: [], today: '', signedToday: false })
    return get(v1('/checkin/calendar'), { year, month })
}

/** 我的签到记录（分页） */
export async function getCheckinRecordsApi(pageNum = 1, pageSize = 100): Promise<CheckinRecordDto[]> {
    if (!API_READY.checkin) return Promise.resolve([])
    const body: any = await get(v1('/checkin/records'), { pageNum, pageSize })
    return (body && Array.isArray(body.rows)) ? body.rows : []
}

/** 签到积分规则 */
export function getCheckinRulesApi(): Promise<CheckinRules> {
    if (!API_READY.checkin) {
        return Promise.resolve({
            tiers: [5, 8, 10, 12, 15, 18, 20].map((points, i) => ({ day: i + 1, points })),
            loopDays: 7, dailyLimit: 1, dailyTip: '每天可签到一次',
            resetNote: '中断一天后连续天数重新从 1 开始', loopNote: '连续 7 天后从第 1 档重新循环'
        })
    }
    return get(v1('/checkin/rules'))
}
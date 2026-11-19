import { get, post, v1 } from '@/utils/request'
import { API_READY } from '@/config/apiStatus'
import { setTodayContentPoints, getTodayContentPoints } from '@/api/points'

export interface StudyWeekItem { date: string; weekday: string; minutes: number }
export interface StudyStats {
    todayMinutes: number
    continuousDays: number
    weekMinutes: StudyWeekItem[]
    completedCourses: number
    noteCount: number
    todoCount: number
}

/** 学习数据总览：GET /api/v1/learn/stats（后端字段平铺在顶层） */
export function getStudyStatsApi(): Promise<StudyStats> {
    if (!API_READY.study) {
        return Promise.resolve({ todayMinutes: 0, continuousDays: 0, weekMinutes: [], completedCourses: 0, noteCount: 0, todoCount: 0 })
    }
    return get(v1('/learn/stats')).then((r: any) => ({
        todayMinutes: r?.todayMinutes || 0,
        continuousDays: r?.continuousDays || 0,
        weekMinutes: Array.isArray(r?.weekMinutes) ? r.weekMinutes : [],
        completedCourses: r?.completedCourses || 0,
        noteCount: r?.noteCount || 0,
        todoCount: r?.todoCount || 0
    }))
}

/** POST /api/v1/learn/report 返回 */
export interface StudyReportResult {
    todayMinutes: number
    todaySeconds: number
    awardedPoints: number
    todayContentPoints: number
}

/**
 * 课程小节播放心跳上报：既记学习时长，后端内部又按「累计满 30 秒 +5 分、同一小节每天一次」结算积分。
 * seconds 传「本次新增观看秒数」（不是总时长）；finished=1 表示学完（只增不减）。
 * 短视频不调用（产品已定：短视频不计分）。
 */
export async function reportStudyApi(params: {
    targetType: 'courseVideo' | 'shortVideo'
    videoId: number
    seconds: number
    finished?: number
    duration?: number
}): Promise<StudyReportResult> {
    if (!API_READY.learnReport) {
        return { todayMinutes: 0, todaySeconds: params.seconds, awardedPoints: 0, todayContentPoints: getTodayContentPoints() }
    }
    const body: Record<string, string> = {
        targetType: params.targetType,
        videoId: String(params.videoId),
        seconds: String(params.seconds)
    }
    if (params.finished != null) body.finished = String(params.finished)
    if (params.duration != null) body.duration = String(params.duration)
    const res: any = await post(v1('/learn/report'), body, { showError: false })
    const tcp = Number(res?.todayContentPoints) || 0
    if (res && typeof res.todayContentPoints === 'number') setTodayContentPoints(tcp)
    return {
        todayMinutes: Number(res?.todayMinutes) || 0,
        todaySeconds: Number(res?.todaySeconds) || 0,
        awardedPoints: Number(res?.awardedPoints) || 0,
        todayContentPoints: tcp
    }
}

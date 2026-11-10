import { get, v1 } from '@/utils/request'
import { API_READY } from '@/config/apiStatus'

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
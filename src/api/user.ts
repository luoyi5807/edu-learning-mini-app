import { get, put, post, del, getToken, v1 } from '@/utils/request'
import { BASE_URL } from '@/config/env'
import { API_READY, formatDateKey } from '@/config/apiStatus'
import type { SysUser } from '@/api/auth'

/** 资料更新入参 —— 对应契约 PUT user/profile {nickname,avatar,gender,bio} */
export interface ProfileUpdateParams {
    nickName?: string
    sex?: string      // RuoYi 编码：0男 1女 2未知
    remark?: string   // 暂用备注字段承载「个人简介」，契约里为 bio
    avatar?: string
}

/** 相对路径（/profile/avatar/xxx.png）补全为可访问的完整地址 */
export function resolveFileUrl(path?: string): string {
    if (!path) return ''
    return path.startsWith('http') ? path : BASE_URL + path
}

/** GET /system/user/profile → RuoYi 把用户对象放在顶层 info */
export function getProfileApi() {
    return get('/system/user/profile')
}

/** PUT /system/user/profile */
export function updateProfileApi(params: ProfileUpdateParams) {
    return put('/system/user/profile', params)
}

/** 修改密码：RuoYi POST /system/user/profile/updatePwd；契约里为 PUT auth/change-password */
export function updatePwdApi(oldPassword: string, newPassword: string) {
    return post('/system/user/profile/updatePwd', { oldPassword, newPassword })
}

/**
 * 头像上传：RuoYi 为 PUT /system/user/profile/avatar（multipart，字段名 avatarfile）
 * 契约里对应 POST files/upload，接入 C 端后改 url 与字段名即可
 */
export function uploadAvatarApi(filePath: string): Promise<string> {
    return new Promise<string>((resolve, reject) => {
        uni.uploadFile({
            url: BASE_URL + '/system/user/profile/avatar',
            filePath,
            name: 'avatarfile',
            header: { Authorization: 'Bearer ' + getToken() },
            success: (res) => {
                if (res.statusCode !== 200) {
                    reject(new Error('HTTP ' + res.statusCode))
                    return
                }
                let body: any
                try {
                    body = JSON.parse(res.data)
                } catch (e) {
                    reject(new Error('头像响应解析失败'))
                    return
                }
                if (body.code !== 200) {
                    reject(body)
                    return
                }
                resolve(body.img || body.url || body.fileName || '')
            },
            fail: reject
        })
    })
}

/* ===================== 签到日历 ===================== */

/** 契约 GET user/sign-calendar?year&month → {continueSignDay,totalSignDay,signedDates} */
export interface SignCalendarResult {
    continueSignDay: number
    totalSignDay: number
    signedDates: string[]
}

/** mock：当月签到到昨天（便于测试今日签到），历史月整月签到但逢周六漏签 */
function mockSignCalendar(year: number, month: number): SignCalendarResult {
    const today = new Date()
    const isCurrent = today.getFullYear() === year && today.getMonth() + 1 === month
    const daysInMonth = new Date(year, month, 0).getDate()
    const lastDay = isCurrent ? today.getDate() - 1 : daysInMonth
    const signedDates: string[] = []
    for (let d = 1; d <= lastDay; d++) {
        if (!isCurrent && new Date(year, month - 1, d).getDay() === 6) continue
        signedDates.push(formatDateKey(year, month, d))
    }
    return { continueSignDay: 12, totalSignDay: 132, signedDates }
}

export function getSignCalendarApi(year: number, month: number): Promise<SignCalendarResult> {
    if (!API_READY.signCalendar) return Promise.resolve(mockSignCalendar(year, month))
    return get(v1('/user/sign-calendar'), { year, month })
}

/* ===================== 我的课程 ===================== */

/** 契约 GET user/courses → MyCourseDto（studyProgress 百分比 + lastStudyTime） */
export interface MyCourseDto {
    courseId: number
    title: string
    coverUrl: string
    instructorName: string
    totalLessons: number
    finishedLessons: number
    studyProgress: number
    lastStudyTime: string
}

function mockMyCourses(): MyCourseDto[] {
    return [
        { courseId: 2001, title: 'Kotlin 进阶：协程与流', coverUrl: '', instructorName: '李老师', totalLessons: 24, finishedLessons: 15, studyProgress: 63, lastStudyTime: '2026-10-13 21:40' },
        { courseId: 2002, title: '微信小程序从 0 到 1', coverUrl: '', instructorName: '王同学', totalLessons: 32, finishedLessons: 32, studyProgress: 100, lastStudyTime: '2026-09-30 10:05' },
        { courseId: 2003, title: '后端接口设计规范实务', coverUrl: '', instructorName: '张架构', totalLessons: 18, finishedLessons: 3, studyProgress: 17, lastStudyTime: '2026-10-11 08:22' }
    ]
}

export function getMyCoursesApi(keyword?: string): Promise<MyCourseDto[]> {
    if (!API_READY.myCourses) {
        const kw = (keyword || '').trim()
        const list = mockMyCourses()
        return Promise.resolve(kw ? list.filter((c) => c.title.indexOf(kw) >= 0) : list)
    }
    return get(v1('/user/courses'), { keyword })
}

/* ===================== 我的下载 ===================== */

/** 契约 GET user/download-records?resourceType=；resourceType 语义同 targetType：1文章 2课程视频 */
export interface DownloadRecordDto {
    recordId: number
    resourceType: number
    targetId: number
    title: string
    sizeText: string
    progressSeconds?: number
    downloadTime: string
}

const mockDownloads: DownloadRecordDto[] = [
    { recordId: 1, resourceType: 2, targetId: 2001, title: 'Kotlin 协程与流 · 第 08 节 结构化并发', sizeText: '186 MB', progressSeconds: 742, downloadTime: '2026-10-12 22:15' },
    { recordId: 2, resourceType: 2, targetId: 2001, title: 'Kotlin 协程与流 · 第 09 节 异常传播', sizeText: '174 MB', downloadTime: '2026-10-12 22:16' },
    { recordId: 3, resourceType: 1, targetId: 101, title: 'Kotlin 协程取消机制完全指南（离线稿）', sizeText: '1.2 MB', downloadTime: '2026-10-08 14:30' }
]

export function getDownloadRecordsApi(resourceType?: number): Promise<DownloadRecordDto[]> {
    if (!API_READY.downloadRecords) {
        return Promise.resolve(
            resourceType ? mockDownloads.filter((d) => d.resourceType === resourceType) : mockDownloads.slice()
        )
    }
    return get(v1('/user/download-records'), { resourceType })
}

export function removeDownloadRecordApi(recordId: number): Promise<void> {
    const idx = mockDownloads.findIndex((d) => d.recordId === recordId)
    if (idx >= 0) mockDownloads.splice(idx, 1)
    if (!API_READY.downloadRecords) return Promise.resolve()
    return del(v1('/user/download-records/' + recordId))
}

/* ===================== 他人公开资料（社区/评论头像跳转用） ===================== */

/** 契约 GET user/blog-home/{userId} → 公开资料（不含邮箱/手机号等隐私字段） */
export interface PublicUserProfileDto {
    userId: number
    nickName: string
    avatar?: string
    sex?: string        // RuoYi 编码：0男 1女 2未知
    remark?: string     // 个人简介
}

/** mock 数据源：覆盖 mockFeed 作者（1-6）与评论 SAMPLE_POOL（11-16） */
const MOCK_PUBLIC_USERS: Record<number, PublicUserProfileDto> = {
    1:  { userId: 1,  nickName: '张三',     sex: '0', remark: 'Kotlin / 协程爱好者，记录每一次踩坑。' },
    2:  { userId: 2,  nickName: '李四',     sex: '0', remark: 'Android 转小程序，前端摸鱼选手。' },
    3:  { userId: 3,  nickName: '王五',     sex: '1', remark: 'Compose 性能优化狂魔。' },
    4:  { userId: 4,  nickName: '陈老师',   sex: '0', remark: '后端架构 · 接口设计 · 十年搬砖。' },
    5:  { userId: 5,  nickName: '赵六',     sex: '0', remark: '25 届秋招 survivor，欢迎交流。' },
    6:  { userId: 6,  nickName: '孙七',     sex: '1', remark: '读书、散步、写点生活随笔。' },
    11: { userId: 11, nickName: '码上开花', sex: '0', remark: '看到 CancellationException 就兴奋。' },
    12: { userId: 12, nickName: '后端小白', sex: '2', remark: 'Java / Spring 学习中。' },
    13: { userId: 13, nickName: '张三同学', sex: '0', remark: '同一个名字，不同的张三。' },
    14: { userId: 14, nickName: '求知的鱼', sex: '1', remark: '愿所有 bug 都能复现。' },
    15: { userId: 15, nickName: 'Lucas',    sex: '0', remark: 'Full-stack tinkerer.' },
    16: { userId: 16, nickName: '山有木兮', sex: '1', remark: '写代码也写诗。' },
    21: { userId: 21, nickName: '张老师',   sex: '0', remark: 'Machine Learning · 从入门到实战主讲。' },
    22: { userId: 22, nickName: '刘老师',   sex: '0', remark: 'Python 编程基础 · 讲解爱好者。' },
    23: { userId: 23, nickName: '王老师',   sex: '1', remark: 'UI / 视觉设计 · 色彩与构图。' }
}

/** 他人主页资料：接口就绪前走 mock，就绪后只改本函数，页面零改动 */
export function getUserPublicProfileApi(userId: number): Promise<PublicUserProfileDto> {
    if (!API_READY.followStats) {
        const hit = MOCK_PUBLIC_USERS[userId]
        if (hit) return Promise.resolve({ ...hit })
        return Promise.resolve({
            userId,
            nickName: '用户' + userId,
            sex: '2',
            remark: '这个人很懒，什么都没留下。'
        })
    }
    return get(v1('/user/blog-home/' + userId))
}

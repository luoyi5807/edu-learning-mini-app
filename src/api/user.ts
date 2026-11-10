import { get, post, del, getToken, v1 } from '@/utils/request'
import { BASE_URL } from '@/config/env'
import { API_READY, formatDateKey } from '@/config/apiStatus'
import { useAuthStore } from '@/store/auth'
import { getCheckinCalendarApi, getCheckinStatusApi } from '@/api/checkin'

// 本地资料缓存 key（与 store/auth.ts 一致）
const APP_USER_KEY = 'appUser'

interface LocalAppUser {
    userId: number
    userName: string
    nickName: string
    avatar: string
    sex: string
    remark: string
}

/** 资料更新入参（页面沿用 nickName/sex/remark 语义，接后端时映射 nickname/gender/bio） */
export interface ProfileUpdateParams {
    nickName?: string
    sex?: string      // 0男 1女 2未知（页面选择器语义）
    remark?: string   // 承载「个人简介」，C 端字段为 bio
    avatar?: string
}

/** 已含协议（http/wxfile/cloud 等）原样返回；相对路径补全 BASE_URL */
export function resolveFileUrl(path?: string): string {
    if (!path) return ''
    return /^[a-z][a-z\d+\-.]*:\/\//i.test(path) ? path : BASE_URL + path
}

/** 后端 profile/home 返回（字段平铺在顶层）→ 前端 AuthUser 视图模型
 *  昵称 userName→nickName、简介 bio→remark；头像保持后端原值（绝对/相对皆可） */
function mapProfileToUser(r: any): LocalAppUser {
    return {
        userId: r?.userId ?? 0,
        userName: r?.userName || '',
        nickName: r?.userName || '',
        avatar: r?.avatar || '',
        sex: r?.sex || '2',
        remark: r?.bio || ''
    }
}

function readLocalProfile(): LocalAppUser | null {
    const raw = uni.getStorageSync(APP_USER_KEY)
    return raw ? (JSON.parse(raw) as LocalAppUser) : null
}

function writeLocalProfile(patch: Partial<LocalAppUser>): LocalAppUser {
    const base: LocalAppUser = readLocalProfile() ||
        { userId: 0, userName: '', nickName: '', avatar: '', sex: '2', remark: '' }
    const merged: LocalAppUser = { ...base, ...patch }
    uni.setStorageSync(APP_USER_KEY, JSON.stringify(merged))
    return merged
}

/**
 * 读取 C 端资料：GET /api/v1/user/profile（后端已就绪）。
 * 后端字段平铺在顶层（userName/avatar/sex/bio），这里归一成 { code, msg, info }，
 * info 结构与 edit-profile 的 fillForm 期望一致。开关关时回落本地登录缓存。
 */
export async function getProfileApi(): Promise<any> {
    if (API_READY.userProfile) {
        const res: any = await get(v1('/user/profile'))
        return { code: res.code, msg: res.msg, info: mapProfileToUser(res) }
    }
    return { code: 200, msg: 'ok', info: readLocalProfile() }
}

/** 更新资料：POST /api/v1/user/profile（JSON）。成功后同步本地缓存，页面立即可见。 */
export async function updateProfileApi(params: ProfileUpdateParams): Promise<any> {
    if (API_READY.userProfile) {
        const res: any = await post(v1('/user/profile'), {
            userName: params.nickName,
            avatar: params.avatar,
            sex: params.sex,
            bio: params.remark
        })
        const merged = mapProfileToUser(res)
        useAuthStore().setUser(merged)
        return { code: res.code, msg: res.msg, info: merged }
    }
    const merged = writeLocalProfile({
        nickName: params.nickName,
        sex: params.sex,
        remark: params.remark,
        avatar: params.avatar
    })
    useAuthStore().setUser(merged)
    return { code: 200, msg: 'ok' }
}

/** 修改密码：POST /api/v1/user/password（需 confirmPassword）。
 *  成功会吊销该账号全部 Token（含当前设备），调用方据 reLoginRequired 清本地并跳登录。 */
export function updatePwdApi(oldPassword: string, newPassword: string, confirmPassword: string): Promise<any> {
    if (API_READY.userProfile) {
        return post(v1('/user/password'), { oldPassword, newPassword, confirmPassword })
    }
    return Promise.reject({ code: 501, msg: '后端暂未开放修改密码' })
}

/** 头像上传：POST /api/v1/upload（multipart，字段名 file，仅图片≤5MB），返回可直接展示的完整 url。 */
export function uploadAvatarApi(filePath: string): Promise<string> {
    if (API_READY.userProfile) {
        const token = getToken()
        return new Promise<string>((resolve, reject) => {
            uni.uploadFile({
                url: BASE_URL + v1('/upload'),
                filePath,
                name: 'file',
                header: { Authorization: token.startsWith('Bearer ') ? token : 'Bearer ' + token },
                success: (res) => {
                    if (res.statusCode !== 200) { reject(new Error('HTTP ' + res.statusCode)); return }
                    let body: any
                    try { body = JSON.parse(res.data) } catch { reject(new Error('头像响应解析失败')); return }
                    if (body.code !== 200 && body.code !== 0) { reject(body); return }
                    resolve(body.url || (body.data && body.data.url) || body.fileName || '')
                },
                fail: reject
            })
        })
    }
    return Promise.resolve(filePath)
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
    if (!API_READY.checkin) return Promise.resolve(mockSignCalendar(year, month))
    // 后端拆两个接口：calendar 给当月已签日号，status 给连续/累计天数
    return Promise.all([getCheckinCalendarApi(year, month), getCheckinStatusApi()]).then(([cal, st]) => {
        const signedDates = (cal.days || []).map((d) => formatDateKey(year, month, d))
        return { continueSignDay: st.continuousDays || 0, totalSignDay: st.totalDays || 0, signedDates }
    })
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

/** 他人主页资料：GET /api/v1/user/publicProfile?userId=（后端已就绪，含关注态与计数） */
export async function getUserPublicProfileApi(userId: number): Promise<PublicUserProfileDto> {
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
    const r: any = await get(v1('/user/publicProfile'), { userId })
    return {
        userId: r?.userId ?? userId,
        nickName: r?.userName || ('用户' + userId),
        avatar: r?.avatar || '',
        sex: r?.sex || '2',
        remark: r?.bio || ''
    }
}

/** 个人主页首屏：GET /api/v1/user/home —— 资料 + 关注/粉丝/获赞 + 粉丝预览，一次拿全 */
export interface UserHomeResult {
    userId: number
    userName: string
    avatar: string
    sex: string
    sexLabel: string
    bio: string
    followCount: number
    fansCount: number
    likeReceivedCount: number
    fanPreview: Array<{ userId: number; userName: string; avatar: string }>
}
export function getUserHomeApi(): Promise<UserHomeResult> {
    return get(v1('/user/home')).then((r: any) => ({
        userId: r?.userId ?? 0,
        userName: r?.userName || '',
        avatar: r?.avatar || '',
        sex: r?.sex || '2',
        sexLabel: r?.sexLabel || '',
        bio: r?.bio || '',
        followCount: r?.followCount || 0,
        fansCount: r?.fansCount || 0,
        likeReceivedCount: r?.likeReceivedCount || 0,
        fanPreview: Array.isArray(r?.fanPreview) ? r.fanPreview : []
    }))
}

/* ===================== 关注体系 /api/v1/follow ===================== */

/** 关注某人（幂等 add，JSON 出口）→ {active:true, fansCount} */
export function followUserApi(targetUserId: number): Promise<{ active: boolean; fansCount: number }> {
    if (!API_READY.follow) return Promise.resolve({ active: true, fansCount: 0 })
    return post(v1('/follow/add'), { targetUserId: String(targetUserId) })
}

/** 取消关注（幂等 cancel，JSON 出口）→ {active:false, fansCount} */
export function unfollowUserApi(targetUserId: number): Promise<{ active: boolean; fansCount: number }> {
    if (!API_READY.follow) return Promise.resolve({ active: false, fansCount: 0 })
    return post(v1('/follow/cancel'), { targetUserId: String(targetUserId) })
}

/** 批量查：当前用户已关注的目标ID（回填按钮态） */
export function getFollowStatusApi(userIds: number[]): Promise<number[]> {
    if (!API_READY.follow || userIds.length === 0) return Promise.resolve([])
    return get(v1('/follow/status'), { userIds: userIds.join(',') })
        .then((res: any) => (res && Array.isArray(res.ids) ? res.ids : []))
}

/** 某用户的粉丝数 + 关注数（userId 缺省查自己） */
export function getFollowCountApi(userId: number): Promise<{ fansCount: number; followCount: number }> {
    if (!API_READY.follow) return Promise.resolve({ fansCount: 0, followCount: 0 })
    return get(v1('/follow/count'), { userId })
}

/* ===================== 关注 / 粉丝列表 /api/v1/follow/following · /fans ===================== */

/** 后端 learning_follow 行（userName / avatar 是「展示用户」的昵称头像，非本表列） */
export interface BackendFollow {
    followId: number
    userId: number            // 关注者（谁点的关注）
    followUserId: number      // 被关注者
    createTime?: string
    userName?: string
    avatar?: string
}

/** 关注 / 粉丝列表统一视图模型 */
export interface FollowUserDto {
    userId: number            // 本条要展示、可点进主页的用户ID
    nickName: string
    avatar: string
    followTime: string        // 关注发生时间
}

/**
 * 我关注的人：GET /api/v1/follow/following?userId=
 * userId 只是「查谁的列表」，不传 = 自己（后端从 Token 取）；展示的是 followUserId 那一位。
 */
export async function getFollowingListApi(userId?: number): Promise<FollowUserDto[]> {
    if (!API_READY.follow) return Promise.resolve([])
    const query: Record<string, any> = { pageNum: 1, pageSize: 100 }
    if (userId) query.userId = userId
    const body: any = await get(v1('/follow/following'), query)
    const rows: BackendFollow[] = (body && Array.isArray(body.rows)) ? body.rows : []
    return rows.map((f) => ({
        userId: f.followUserId,
        nickName: f.userName || ('用户' + f.followUserId),
        avatar: resolveFileUrl(f.avatar),
        followTime: f.createTime || ''
    }))
}

/**
 * 我的粉丝：GET /api/v1/follow/fans?userId=
 * userId 只是「查谁的粉丝」，不传 = 自己；展示的是 userId 那一位（关注者）。
 */
export async function getFansListApi(userId?: number): Promise<FollowUserDto[]> {
    if (!API_READY.follow) return Promise.resolve([])
    const query: Record<string, any> = { pageNum: 1, pageSize: 100 }
    if (userId) query.userId = userId
    const body: any = await get(v1('/follow/fans'), query)
    const rows: BackendFollow[] = (body && Array.isArray(body.rows)) ? body.rows : []
    return rows.map((f) => ({
        userId: f.userId,
        nickName: f.userName || ('用户' + f.userId),
        avatar: resolveFileUrl(f.avatar),
        followTime: f.createTime || ''
    }))
}

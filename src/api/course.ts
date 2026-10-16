import { get, post, del, v1 } from '@/utils/request'
import { API_READY } from '@/config/apiStatus'
import { BASE_URL } from '@/config/env'
import type { Course, CourseDetailDto, ChapterDto, LessonDto, PlayInfoDto, CourseRatingDto } from '@/types/course'

const mockCourses: Course[] = [
    { courseId: 1, title: 'Machine Learning 从入门到实战', coverUrl: '', instructorName: '张老师', studentCount: 1200, categoryId: 3, categoryName: 'IT 解决方案', videoType: 2, isFree: 1, duration: 3696, viewCount: 12000, likeCount: 236, favoriteCount: 96, commentCount: 6, averageScore: 4.4, ratingCount: 128, totalLessons: 5 },
    { courseId: 2, title: 'Data Science 数据分析实战', coverUrl: '', instructorName: '李老师', studentCount: 960, categoryId: 3, categoryName: 'IT 解决方案', videoType: 2, isFree: 0 },
    { courseId: 3, title: 'UI 设计从零基础到精通', coverUrl: '', instructorName: '王老师', studentCount: 680, categoryId: 1, categoryName: '艺术', videoType: 2, isFree: 1 },
    { courseId: 4, title: '创业融资与商业计划书', coverUrl: '', instructorName: '陈老师', studentCount: 450, categoryId: 2, categoryName: '商业', videoType: 2, isFree: 0 },
    { courseId: 5, title: 'Python 编程基础入门', coverUrl: '', instructorName: '刘老师', studentCount: 1500, categoryId: 3, categoryName: 'IT 解决方案', videoType: 1, isFree: 1, duration: 210, viewCount: 6800, likeCount: 410, favoriteCount: 88, commentCount: 22 },
    { courseId: 6, title: '品牌视觉与平面设计实务', coverUrl: '', instructorName: '赵老师', studentCount: 0, categoryId: 1, categoryName: '艺术', videoType: 2, isFree: 1 }
]

/** 短视频流（videoType=1），对齐《参考安卓》4.5 视频 Tab */
const mockShortVideos: Course[] = [
    { courseId: 1, title: 'Machine Learning 从入门到实战', coverUrl: '', instructorName: '张老师', instructorId: 21, studentCount: 1200, categoryId: 3, categoryName: 'IT 解决方案', videoType: 1, isFree: 1, duration: 45, viewCount: 12000, likeCount: 320, favoriteCount: 96, commentCount: 18, transcodeStatus: 1 },
    { courseId: 5, title: 'Python 编程基础入门', coverUrl: '', instructorName: '刘老师', instructorId: 22, studentCount: 1500, categoryId: 3, categoryName: 'IT 解决方案', videoType: 1, isFree: 1, duration: 210, viewCount: 6800, likeCount: 410, favoriteCount: 88, commentCount: 22, transcodeStatus: 1 },
    { courseId: 5001, title: '三分钟搞懂梯度下降', coverUrl: '', instructorName: '陈老师', instructorId: 4, studentCount: 0, categoryId: 3, categoryName: 'IT 解决方案', videoType: 1, isFree: 1, duration: 186, viewCount: 8600, likeCount: 540, favoriteCount: 132, commentCount: 32, transcodeStatus: 1 },
    { courseId: 5002, title: '配色灵感：如何做一套耐看的界面', coverUrl: '', instructorName: '王老师', instructorId: 23, studentCount: 0, categoryId: 1, categoryName: '艺术', videoType: 1, isFree: 1, duration: 96, viewCount: 5400, likeCount: 280, favoriteCount: 64, commentCount: 11, transcodeStatus: 1 }
]

/** mock 播放地址（VOD 未接入，用可公网访问的样例视频跑通播放器） */
const SAMPLE_PLAY_URL = 'https://qiniu-web-assets.dcloud.net.cn/unidoc/zh/2minute-demo.mp4'

export interface CourseListParams {
    pageNum?: number
    pageSize?: number
    categoryId?: number
    courseName?: string
    sortBy?: 'createTime' | 'likeCount' | 'avgScore'
}

/** 后端 learning_course 返回的行结构（列名已 as 驼峰） */
export interface BackendCourse {
    courseId: number
    courseName: string
    categoryId: number
    categoryName?: string
    coverUrl?: string
    intro?: string
    likeCount?: number
    favoriteCount?: number
    commentCount?: number
    ratingCount?: number
    ratingScore?: number
    avgScore?: number | null
    status?: string
    createTime?: string
}

/** 后端 learning_short_video 行 */
export interface BackendShortVideo {
    videoId: number
    videoTitle: string
    userId: number
    videoUrl?: string
    coverUrl?: string
    intro?: string
    duration?: number
    viewCount?: number
    likeCount?: number
    favoriteCount?: number
    commentCount?: number
    status?: string
    userName?: string
}

/** 相对路径 → 绝对地址（/profile/... 需拼后端 BASE_URL；已是 http(s) 原样返回）
 *  路径含空格/中文/全角符号时 encodeURI 编码，避免 404 */
function absUrl(p?: string): string {
    if (!p) return ''
    if (/^https?:\/\//i.test(p)) return p
    const path = p.startsWith('/') ? p : '/' + p
    return BASE_URL + encodeURI(path)
}

/** 后端短视频 → 前端 Course 视图模型（videoType=1，playUrl/coverUrl 转绝对） */
function normalizeShortVideo(v: BackendShortVideo): Course {
    return {
        courseId: v.videoId,
        title: v.videoTitle || '',
        coverUrl: absUrl(v.coverUrl),
        playUrl: absUrl(v.videoUrl),
        instructorName: v.userName || '',
        instructorId: v.userId,
        studentCount: 0,
        categoryId: 0,
        categoryName: '',
        videoType: 1,
        isFree: 1,
        duration: v.duration || 0,
        viewCount: v.viewCount || 0,
        likeCount: v.likeCount || 0,
        favoriteCount: v.favoriteCount || 0,
        commentCount: v.commentCount || 0,
        description: v.intro || ''
    }
}

/** 后端字段 → 前端 Course 视图模型：courseName→title、avgScore→averageScore；
 *  后端无讲师/在学人数，用 categoryName 占位、ratingCount 近似热度 */
function normalizeCourse(c: BackendCourse): Course {
    return {
        courseId: c.courseId,
        title: c.courseName || '',
        coverUrl: c.coverUrl || '',
        instructorName: c.categoryName || '',
        studentCount: c.ratingCount || 0,
        categoryId: c.categoryId || 0,
        categoryName: c.categoryName || '',
        videoType: 2,
        isFree: 1,
        likeCount: c.likeCount || 0,
        favoriteCount: c.favoriteCount || 0,
        commentCount: c.commentCount || 0,
        averageScore: (typeof c.avgScore === 'number' ? c.avgScore : undefined),
        ratingCount: c.ratingCount || 0,
        description: c.intro || ''
    }
}

function mockPage(params: CourseListParams): Course[] {
    if (!params.categoryId || params.categoryId === 0) return mockCourses.slice()
    return mockCourses.filter((c) => c.categoryId === params.categoryId)
}

/** GET /api/v1/course/list —— 分页课程列表，返回 { list, total } */
export async function getCourseListApi(params: CourseListParams = {}): Promise<CoursePageResult> {
    if (!API_READY.courseList) {
        const list = mockPage(params)
        return { list, total: list.length }
    }
    const query: Record<string, any> = {
        pageNum: params.pageNum ?? 1,
        pageSize: params.pageSize ?? 10,
        sortBy: params.sortBy || 'createTime'
    }
    if (params.categoryId && params.categoryId > 0) query.categoryId = params.categoryId
    if (params.courseName) query.courseName = params.courseName

    const body: any = await get(v1('/course/list'), query)
    const rows: BackendCourse[] = (body && Array.isArray(body.rows)) ? body.rows : []
    const total = (body && typeof body.total !== 'undefined') ? Number(body.total) : rows.length
    return { list: rows.map(normalizeCourse), total }
}

/** 课程搜索：GET /api/v1/search/course?keyword= —— 复用 normalizeCourse，返回 Course[] */
export async function searchCoursesApi(keyword: string): Promise<Course[]> {
    if (!API_READY.searchCourse) {
        const kw = keyword.trim()
        return kw ? mockCourses.filter((c) => c.title.indexOf(kw) >= 0) : mockCourses.slice()
    }
    const body: any = await get(v1('/search/course'), { keyword: keyword.trim(), pageNum: 1, pageSize: 20 })
    const rows: BackendCourse[] = (body && Array.isArray(body.rows)) ? body.rows : []
    return rows.map(normalizeCourse)
}

/** GET /api/v1/search/video —— 空关键词=热门短视频流，返回 Course[]（videoType=1） */
export async function getShortVideosApi(params: { pageNum?: number; pageSize?: number } = {}): Promise<Course[]> {
    if (!API_READY.videoList) return mockShortVideos.slice()
    const body: any = await get(v1('/search/video'), {
        keyword: '',
        pageNum: params.pageNum ?? 1,
        pageSize: params.pageSize ?? 20
    })
    const rows: BackendShortVideo[] = (body && Array.isArray(body.rows)) ? body.rows : []
    return rows.map(normalizeShortVideo)
}

/* ===================== 课程详情 / 章节目录 ===================== */

const joinedIds = new Set<number>([2])   // mock：已加入 courseId=2

function makeLessons(courseId: number, chapterId: number, prefix: string, rows: [string, number, boolean?][]): LessonDto[] {
    return rows.map((r, i) => ({
        lessonId: chapterId * 100 + i + 1,
        courseId,
        chapterId,
        title: `${prefix}.${i + 1} ${r[0]}`,
        duration: r[1],
        isFree: i === 0 ? 1 : 0,
        transcodeStatus: 1,
        isFinished: !!r[2],
        progressSeconds: r[2] ? r[1] : 0
    }))
}

function buildChapters(courseId: number): ChapterDto[] {
    if (courseId === 1) {
        const c1: ChapterDto = {
            chapterId: 101, courseId, title: '第一章：环境搭建', lessonCount: 3,
            lessons: makeLessons(courseId, 101, '1', [['开发环境准备', 536, true], ['第一个程序', 720], ['常见问题排查', 420]])
        }
        const c2: ChapterDto = {
            chapterId: 102, courseId, title: '第二章：核心概念', lessonCount: 2,
            lessons: makeLessons(courseId, 102, '2', [['数据结构概览', 900], ['算法复杂度', 1080]])
        }
        return [c1, c2]
    }
    const gen: ChapterDto = {
        chapterId: courseId * 10 + 1, courseId, title: '第一章：入门导览', lessonCount: 2,
        lessons: makeLessons(courseId, courseId * 10 + 1, '1', [['课程介绍', 320, true], ['学习路径', 480]])
    }
    return [gen]
}

function buildMockDetail(courseId: number): CourseDetailDto {
    const base = mockCourses.find((c) => c.courseId === courseId) || mockShortVideos.find((c) => c.courseId === courseId) || mockCourses[0]
    const chapters = buildChapters(courseId)
    const totalLessons = chapters.reduce((s, c) => s + c.lessons.length, 0)
    return {
        ...base,
        videoType: 2,
        description: '本课程从零开始，带你完整走一遍核心知识体系。每个章节都配有实操演示与课后练习，覆盖常见坑点与最佳实践，学完可以直接上手真实项目。',
        averageScore: base.averageScore ?? 4.4,
        ratingCount: base.ratingCount ?? 128,
        viewCount: base.viewCount ?? 12000,
        likeCount: base.likeCount ?? 236,
        favoriteCount: base.favoriteCount ?? 96,
        commentCount: base.commentCount ?? 6,
        totalLessons,
        chapters,
        isJoined: joinedIds.has(courseId),
        recentLikers: [
            { userId: 1, nickName: '张三' }, { userId: 2, nickName: '李四' }, { userId: 3, nickName: '王五' },
            { userId: 5, nickName: '赵六' }, { userId: 4, nickName: '陈老师' }
        ]
    }
}

/** GET courses/{courseId} —— 课程详情（含章节目录） */
export function getCourseDetailApi(courseId: number): Promise<CourseDetailDto> {
    if (!API_READY.courseDetail) return Promise.resolve(buildMockDetail(courseId))
    return get(v1('/courses/' + courseId))
}

/** GET courses/{courseId}/play-info —— 播放凭证（lessonId 缺省为短视频） */
export function getPlayInfoApi(courseId: number, lessonId?: number): Promise<PlayInfoDto> {
    if (!API_READY.playInfo) {
        return Promise.resolve({ playUrl: SAMPLE_PLAY_URL, expireTime: '', watermarkText: '', duration: 0 })
    }
    return get(v1('/courses/' + courseId + '/play-info'), { lessonId })
}

/** POST user/courses/{courseId} —— 加入学习 */
export function joinCourseApi(courseId: number): Promise<{ isJoined: boolean }> {
    if (!API_READY.joinCourse) { joinedIds.add(courseId); return Promise.resolve({ isJoined: true }) }
    return post(v1('/user/courses/' + courseId))
}

/** DELETE user/courses/{courseId} —— 退出学习 */
export function leaveCourseApi(courseId: number): Promise<void> {
    if (!API_READY.joinCourse) { joinedIds.delete(courseId); return Promise.resolve() }
    return del(v1('/user/courses/' + courseId))
}

/** 评分信息 GET /api/v1/rating/info?courseId= → {myScore, avgScore, ratingCount}（未评/无人评为 null） */
export function getRatingInfoApi(courseId: number): Promise<{ myScore: number | null; avgScore: number | null; ratingCount: number }> {
    if (!API_READY.courseRating) return Promise.resolve({ myScore: null, avgScore: null, ratingCount: 0 })
    return get(v1('/rating/info'), { courseId })
}

/** 评分（后端 score 为 1-5 整数）：未评过走 /rating/add，已评过走 /rating/update */
export async function rateCourseApi(courseId: number, score: number): Promise<{ averageScore: number; ratingCount: number }> {
    const intScore = Math.min(5, Math.max(1, Math.round(score)))
    if (!API_READY.courseRating) return { averageScore: intScore, ratingCount: 129 }
    const info: any = await get(v1('/rating/info'), { courseId })
    const path = (info && info.myScore != null) ? '/rating/update' : '/rating/add'
    const res: any = await post(v1(path), { courseId: String(courseId), score: String(intScore) })
    return { averageScore: Number(res && res.avgScore != null ? res.avgScore : intScore), ratingCount: Number((res && res.ratingCount) || 0) }
}

const mockRatings: CourseRatingDto[] = [
    { ratingId: 1, userId: 1, nickName: '张三', score: 5, createTime: '2026-09-12 10:00:00' },
    { ratingId: 2, userId: 2, nickName: '李四', score: 4, createTime: '2026-09-12 11:20:00' },
    { ratingId: 3, userId: 3, nickName: '王五', score: 4.5, createTime: '2026-09-12 13:05:00' }
]

/** 评分列表：后端无 C 端「评分明细」接口，仅有聚合 /rating/info → 故始终返回 mock（不调不存在的路径） */
export function getCourseRatingsApi(courseId: number): Promise<CourseRatingDto[]> {
    return Promise.resolve(mockRatings.slice())
}

/** 秒 → mm:ss / h:mm:ss */
export function formatDuration(sec: number): string {
    const s = Math.max(0, Math.floor(sec || 0))
    const h = Math.floor(s / 3600), m = Math.floor((s % 3600) / 60), ss = s % 60
    const p = (n: number) => (n < 10 ? '0' + n : '' + n)
    return h > 0 ? `${h}:${p(m)}:${p(ss)}` : `${p(m)}:${p(ss)}`
}

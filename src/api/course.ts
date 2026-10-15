import { get, post, del, v1 } from '@/utils/request'
import { API_READY } from '@/config/apiStatus'
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

export interface CourseListParams { pageNum?: number; pageSize?: number; categoryId?: number; videoType?: number; sort?: number }

/** GET courses */
export function getCourseListApi(params: CourseListParams = {}): Promise<Course[]> {
    if (!API_READY.courses) return Promise.resolve(mockCourses.slice())
    return get(v1('/courses'), params)
}

/** 课程搜索：content/search?type=2 */
export function searchCoursesApi(keyword: string): Promise<Course[]> {
    if (!API_READY.courses) {
        const kw = keyword.trim()
        return Promise.resolve(kw ? mockCourses.filter((c) => c.title.indexOf(kw) >= 0) : mockCourses.slice())
    }
    return get(v1('/content/search'), { keyword, type: 2 })
}

/** GET courses?videoType=1 —— 短视频流 */
export function getShortVideosApi(params: { pageNum?: number; pageSize?: number } = {}): Promise<Course[]> {
    if (!API_READY.courses) return Promise.resolve(mockShortVideos.slice())
    return get(v1('/courses'), { videoType: 1, ...params })
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

/** POST courses/{courseId}/rating —— 评分（0.5~5.0，步进 0.5） */
export function rateCourseApi(courseId: number, score: number): Promise<{ averageScore: number; ratingCount: number }> {
    if (!API_READY.courseRating) return Promise.resolve({ averageScore: score, ratingCount: 129 })
    return post(v1('/courses/' + courseId + '/rating'), { score })
}

const mockRatings: CourseRatingDto[] = [
    { ratingId: 1, userId: 1, nickName: '张三', score: 5, createTime: '2026-09-12 10:00:00' },
    { ratingId: 2, userId: 2, nickName: '李四', score: 4, createTime: '2026-09-12 11:20:00' },
    { ratingId: 3, userId: 3, nickName: '王五', score: 4.5, createTime: '2026-09-12 13:05:00' }
]

/** GET courses/{courseId}/ratings —— 评分列表 */
export function getCourseRatingsApi(courseId: number): Promise<CourseRatingDto[]> {
    if (!API_READY.courseRating) return Promise.resolve(mockRatings.slice())
    return get(v1('/courses/' + courseId + '/ratings'))
}

/** 秒 → mm:ss / h:mm:ss */
export function formatDuration(sec: number): string {
    const s = Math.max(0, Math.floor(sec || 0))
    const h = Math.floor(s / 3600), m = Math.floor((s % 3600) / 60), ss = s % 60
    const p = (n: number) => (n < 10 ? '0' + n : '' + n)
    return h > 0 ? `${h}:${p(m)}:${p(ss)}` : `${p(m)}:${p(ss)}`
}

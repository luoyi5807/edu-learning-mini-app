/**
 * 后端接口就绪开关（对齐《参考安卓的效果实现.md》第六章 /api/v1 契约）
 * false = 走本地 mock；后端补齐该接口后置 true，页面代码零改动。
 * RuoYi 已具备的能力（登录/注册/资料/改密/头像）不在此表，直接走真实请求。
 */
export const API_READY = {
    /** GET user/sign-calendar */
    signCalendar: false,
    /** GET user/courses */
    myCourses: false,
    /** GET user/articles */
    myArticles: false,
    /** GET articles（社区文章列表） */
    articles: false,
    /** 分类列表 GET /article/category/list、/course/category/list（后端已就绪） */
    categories: true,
    /** GET articles/{id}（文章详情） */
    articleDetail: false,
    /** 发布 / 编辑文章 */
    articlePublish: false,
    /** 评论 GET/POST comments */
    comment: false,
    /** 点赞 / 收藏 toggle */
    interaction: false,
    /** 内容搜索 / 热词 */
    search: false,
    /** 笔记 notes（列表/新增/详情） */
    notes: false,
    /** GET courses（课程列表 / 课程搜索） */
    courses: false,
    /** GET courses/{id}（课程详情 / 章节目录） */
    courseDetail: false,
    /** GET courses/{id}/play-info（播放凭证） */
    playInfo: false,
    /** POST/DELETE user/courses/{id}（加入 / 退出学习） */
    joinCourse: false,
    /** 课程评分 POST/GET courses/{id}/rating(s) */
    courseRating: false,
    /** GET user/download-records */
    downloadRecords: false,
    /** GET todos */
    todos: false,
    /** 关注体系（后端待补，见适配清单第七章） */
    followStats: false,
    /** 通知消息 GET/POST notifications（点赞/评论/关注/收藏聚合） */
    notification: false
}

function pad(n: number): string {
    return n < 10 ? '0' + n : String(n)
}

/** 生成 YYYY-MM-DD */
export function formatDateKey(y: number, m: number, d: number): string {
    return `${y}-${pad(m)}-${pad(d)}`
}

export function todayKey(): string {
    const t = new Date()
    return formatDateKey(t.getFullYear(), t.getMonth() + 1, t.getDate())
}
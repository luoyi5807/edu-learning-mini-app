/**
 * 后端接口就绪开关（对齐《参考安卓的效果实现.md》第六章 /api/v1 契约）
 * false = 走本地 mock；后端补齐该接口后置 true，页面代码零改动。
 * RuoYi 已具备的能力（登录/注册/资料/改密/头像）不在此表，直接走真实请求。
 */
export const API_READY = {
    /** GET user/sign-calendar */
    signCalendar: true,
    /** 签到 /api/v1/checkin/*（sign/status/calendar/records/rules，后端已就绪） */
    checkin: true,
    /** 积分与免广告兑换 /api/v1/points/*（account/exchange，后端已就绪；account 返回顶层 balance/adFree/adFreeExpireTime/adFreeRemainMinutes） */
    points: true,
    /** GET user/courses */
    myCourses: false,
    /** 我的文章 GET /api/v1/post/myList + 删除 POST /api/v1/post/remove（后端已就绪；myList 无 viewCount/分类/时间，列表按缺省补零） */
    myArticles: true,
    /** 社区文章列表：走 /api/v1/post/list（服务端按 categoryId / sortBy / featured 过滤 + 分页，
     *  返回 summary、coverUrl、avatar、viewCount，卡片直接展示真实数据） */
    articles: true,
    /** 分类列表 GET /api/v1/category/list?categoryType=course|article（后端已就绪：返回 {code,rows:[{categoryId,categoryName}],total}，扁平无树） */
    categories: true,
    /** C 端资料/改密/头像：GET/POST /api/v1/user/profile、POST /api/v1/user/password、POST /api/v1/upload（后端已就绪，改密后吊销全部 Token 需重登） */
    userProfile: true,
    /** 文章详情 GET /api/v1/post/info?postId=（后端已就绪：返回 PostDetail，正文为 Markdown 原文，前端渲染） */
    articleDetail: true,
    /** 发布文章 POST /api/v1/post/add + 编辑回显 GET /api/v1/post/info（后端已就绪；统一先审后发，无草稿/编辑保存/撤回接口，这几项仍走本地） */
    articlePublish: true,
    /** 评论 GET/POST comments */
    comment: true,
    /** 点赞 / 收藏 toggle */
    interaction: true,
    /** 帖子/文章搜索 GET /api/v1/search/post（已切真）；热词后端无接口，getHotWordsApi 恒走本地 */
    search: true,
    /** 笔记 /api/v1/note/*（add/edit/remove/list/info，后端已就绪） */
    notes: true,
    /** GET courses（课程列表 / 课程搜索） */
    courses: false,
    /** GET /api/v1/search/video（短视频列表/热门榜，已对接真实后端） */
    videoList: true,
    /** GET /api/v1/search/course（课程搜索，已对接真实后端） */
    searchCourse: true,
    /** GET /api/v1/course/list（课程列表，已对接真实后端：分页 + 排序） */
    courseList: true,
    /** 轮播图 / 广告位 GET /api/v1/banner/list（后端已就绪：按 categoryId 取窗口，只返回目标课程可见的轮播；不传=「全部」窗口） */
    banner: true,
    /** GET /api/v1/course/{courseId}（课程详情：三段式 course+chapters(带videos)+散videos，视频含直链 videoUrl，后端已就绪） */
    courseDetail: true,
    /** GET courses/{id}/play-info（播放凭证） */
    playInfo: false,
    /** POST/DELETE user/courses/{id}（加入 / 退出学习） */
    joinCourse: false,
    /** 课程评分 POST/GET courses/{id}/rating(s) */
    courseRating: true,
    /** GET user/download-records */
    downloadRecords: false,
    /** GET todos */
    todos: false,
    /** 关注动作/数量 /api/v1/follow（add/cancel/status/count） */
    follow: true,
    /** 他人主页资料 GET /api/v1/user/publicProfile（后端已就绪：资料+关注/粉丝/获赞+isFollowing） */
    followStats: true,
    /** 个人主页首屏 GET /api/v1/user/home（资料+关注+粉丝+获赞+粉丝预览，一次返回） */
    userHome: true,
    /** 学习数据 GET /api/v1/learn/stats（今日/连续/本周/完成课程/笔记/待办） */
    study: true,
    /** 观看历史 GET /api/v1/history/list（短视频/课程/文章混合时间线） */
    history: true,
    /** 我的点赞/收藏 GET /api/v1/interaction/myLikes · /myFavorites */
    myInteractions: true,
    /** 话题列表 GET /api/v1/topic/list（发布页话题标签选择） */
    topics: true,
    /** 通知消息 GET/POST notifications（点赞/评论/关注/收藏聚合；list 支持 type 服务端过滤；评论/回复通知携带 commentId，配合 GET /comment/locate 精准跳转） */
    notification: true,
    /** 看激励视频得积分：POST /api/v1/points/ad/reward 已就绪（看完即报：adId + seconds≥15，每条 +10 分、每天 3 条封顶，非 SSV 回调）。
     *  但微信流量主激励视频广告位未申请（AD_REWARDED_VIDEO 为空，无真实广告可看）→ 暂保持 false，防无广告场景刷分 */
    adReward: false,
    /** 观看/阅读上报 POST /api/v1/points/watch（后端已就绪：post/courseVideo，满 30 秒 +5，内容类 50 分/天封顶，服务端去重） */
    pointsWatch: true,
    /** 学习时长上报 POST /api/v1/learn/report（后端已就绪：courseVideo 心跳，记学习时长并内部结算积分；短视频不上报） */
    learnReport: true,
    /** 积分商城 /api/v1/shop/*（product/category/order/exchange/address，后端已就绪：兑换当场返回兑换码；地址为独立地址簿，不随兑换提交、无配送状态） */
    mall: true
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
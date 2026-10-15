import { get, post, del, put, v1 } from '@/utils/request'
import { API_READY } from '@/config/apiStatus'
import type { ArticleDto, ArticleDetailDto, ArticleTag } from '@/types/article'

/* ===================== 社区文章列表（GET articles） ===================== */

export interface ArticleListParams {
    pageNum?: number
    pageSize?: number
    categoryId?: number
    tagId?: number
    sort?: number   // 1最新 2最热 3精华
}

const mockFeed: ArticleDto[] = [
    { articleId: 108, title: '项目实战：从零搭一个学习打卡 App', summary: '需求、选型、上线全流程复盘', coverUrl: '', authorId: 2, authorName: '李四', categoryName: '项目实战', categoryId: 3, viewCount: 1980, likeCount: 132, commentCount: 8, publishTime: '2026-09-10 14:00', essence: 1 },
    { articleId: 101, title: 'Kotlin 协程取消机制完全指南', summary: '结构化并发为什么必须向上抛 CancellationException', coverUrl: '', authorId: 1, authorName: '张三', categoryName: '技术分享', categoryId: 1, viewCount: 1200, likeCount: 32, commentCount: 3, publishTime: '2026-09-28 10:12', essence: 0 },
    { articleId: 102, title: '我是如何三个月从零学会 Android 的', summary: '踩过的坑与有效的学习路径', coverUrl: '', authorId: 2, authorName: '李四', categoryName: '学习心得', categoryId: 2, viewCount: 1630, likeCount: 88, commentCount: 4, publishTime: '2026-09-24 15:40', essence: 1 },
    { articleId: 103, title: 'Compose 重组优化实战', summary: '把一次列表滚动从 32ms 降到 8ms', coverUrl: '', authorId: 3, authorName: '王五', categoryName: '技术分享', categoryId: 1, viewCount: 2060, likeCount: 120, commentCount: 5, publishTime: '2026-09-22 09:05', essence: 1 },
    { articleId: 104, title: '后端接口设计中的 10 个常见错误', summary: '分页、错误码、幂等……一次讲清楚', coverUrl: '', authorId: 4, authorName: '陈老师', categoryName: '技术分享', categoryId: 1, viewCount: 2490, likeCount: 156, commentCount: 6, publishTime: '2026-09-20 21:00', essence: 0 },
    { articleId: 105, title: '秋招复盘：我拿到的那几个 offer', summary: '项目、八股、HR 面的真实经验', coverUrl: '', authorId: 5, authorName: '赵六', categoryName: '求职就业', categoryId: 4, viewCount: 3120, likeCount: 210, commentCount: 12, publishTime: '2026-09-18 18:30', essence: 1 },
    { articleId: 106, title: 'uni-app 分包与首屏体积优化', summary: '主包压到 1.5M 以内的实操记录', coverUrl: '', authorId: 1, authorName: '张三', categoryName: '技术分享', categoryId: 1, viewCount: 760, likeCount: 40, commentCount: 2, publishTime: '2026-09-15 11:20', essence: 0 },
    { articleId: 107, title: '周末去了趟国家图书馆', summary: '记录一天安静读书的时光', coverUrl: '', authorId: 6, authorName: '孙七', categoryName: '生活随笔', categoryId: 5, viewCount: 430, likeCount: 25, commentCount: 1, publishTime: '2026-09-12 20:00', essence: 0 }
]

/** 社区文章列表。sort：1最新(按ID倒序) 2最热(按阅读) 3精华 */
export function getArticleListApi(params: ArticleListParams = {}): Promise<ArticleDto[]> {
    if (!API_READY.articles) {
        const { categoryId, sort = 1 } = params
        let list = mockFeed.slice()
        if (categoryId) list = list.filter((a) => a.categoryId === categoryId)
        if (sort === 3) list = list.filter((a) => a.essence === 1)
        if (sort === 2) list.sort((a, b) => b.viewCount - a.viewCount)
        else list.sort((a, b) => b.articleId - a.articleId)
        return Promise.resolve(list)
    }
    return get(v1('/articles'), params)
}

/** 供评论 mock 使用：返回某文章列表里展示的评论数，保证列表与详情条数一致 */
export function getMockArticleCommentCount(articleId: number): number {
    const a = mockFeed.find((x) => x.articleId === articleId)
    return a ? a.commentCount : 0
}

/**
 * 我的发布 —— 契约 GET user/articles?status=
 * status：0草稿 1待审核 2已发布 3驳回 4下架
 */
export interface MyArticleDto {
    articleId: number
    title: string
    summary?: string
    coverUrl?: string
    categoryName?: string
    status: number
    rejectReason?: string
    viewCount: number
    likeCount: number
    commentCount: number
    publishTime: string
    createTime?: string
}

export const ARTICLE_STATUS_TABS: { label: string; value: number | '' }[] = [
    { label: '全部', value: '' },
    { label: '草稿', value: 0 },
    { label: '待审核', value: 1 },
    { label: '已发布', value: 2 },
    { label: '驳回', value: 3 }
]

export const ARTICLE_STATUS_TEXT: Record<number, string> = {
    0: '草稿',
    1: '待审核',
    2: '已发布',
    3: '已驳回',
    4: '已下架'
}

const mockArticles: MyArticleDto[] = [
    { articleId: 101, title: 'Kotlin 协程取消机制完全指南', categoryName: '移动开发', status: 2, viewCount: 1200, likeCount: 32, commentCount: 8, publishTime: '2026-09-28 10:12' },
    { articleId: 102, title: '后端接口设计中的 10 个常见错误', categoryName: '后端', status: 2, viewCount: 860, likeCount: 21, commentCount: 3, publishTime: '2026-09-20 15:40' },
    { articleId: 103, title: 'uni-app 分包与首屏体积优化', categoryName: '小程序', status: 1, viewCount: 0, likeCount: 0, commentCount: 0, publishTime: '' },
    { articleId: 104, title: 'Compose 布局迁移到小程序的对照笔记', categoryName: '移动开发', status: 0, viewCount: 0, likeCount: 0, commentCount: 0, publishTime: '' },
    { articleId: 105, title: '关于深度学习的一点粗浅理解', categoryName: '人工智能', status: 3, rejectReason: '引用数据缺少来源，补充后重新提交', viewCount: 0, likeCount: 0, commentCount: 0, publishTime: '' },
    { articleId: 106, title: 'SCSS 设计系统在前端的落地实践', categoryName: '前端', status: 0, viewCount: 0, likeCount: 0, commentCount: 0, publishTime: '' }
]

export function getMyArticlesApi(status?: number): Promise<MyArticleDto[]> {
    if (!API_READY.myArticles) {
        const list = mockArticles.slice().sort((a, b) => b.articleId - a.articleId)
        return Promise.resolve(status === undefined || status === null ? list : list.filter((a) => a.status === status))
    }
    return get(v1('/user/articles'), { status })
}

/**
 * 他人主页文章：契约 GET user/blog-home/{userId}/articles
 * mock 阶段直接从社区 mockFeed 按 authorId 过滤，返回结构复用 MyArticleDto
 */
export function getUserPublishedArticlesApi(userId: number): Promise<MyArticleDto[]> {
    if (!API_READY.myArticles) {
        const list = mockFeed
            .filter((a) => a.authorId === userId)
            .map<MyArticleDto>((a) => ({
                articleId: a.articleId,
                title: a.title,
                summary: a.summary,
                categoryName: a.categoryName,
                status: 2,
                viewCount: a.viewCount,
                likeCount: a.likeCount,
                commentCount: a.commentCount,
                publishTime: a.publishTime
            }))
        return Promise.resolve(list)
    }
    return get(v1('/user/blog-home/' + userId + '/articles'))
}

/** 撤回已发布 → 回到草稿：POST articles/{id}/withdraw */
export function withdrawArticleApi(articleId: number): Promise<void> {
    const item = mockArticles.find((a) => a.articleId === articleId)
    if (item) item.status = 0
    if (!API_READY.myArticles) return Promise.resolve()
    return post(v1('/articles/' + articleId + '/withdraw'))
}

/** 删除：DELETE articles/{id} */
export function deleteArticleApi(articleId: number): Promise<void> {
    const idx = mockArticles.findIndex((a) => a.articleId === articleId)
    if (idx >= 0) mockArticles.splice(idx, 1)
    if (!API_READY.myArticles) return Promise.resolve()
    return del(v1('/articles/' + articleId))
}

/** 提交审核：草稿 → 待审核（走 PUT articles/{id} 的 publish 字段） */
export function submitArticleApi(articleId: number): Promise<void> {
    return putArticleStatusApi(articleId, 1)
}

function putArticleStatusApi(articleId: number, status: number): Promise<void> {
    const item = mockArticles.find((a) => a.articleId === articleId)
    if (item) item.status = status
    if (!API_READY.myArticles) return Promise.resolve()
    return put(v1('/articles/' + articleId), { publish: status === 1 ? 1 : 0 })
}

/* ===================== 标签池 / 详情 / 发布 ===================== */

const TAG_POOL: ArticleTag[] = [
    { tagId: 1, tagName: 'Android', useCount: 120 },
    { tagId: 2, tagName: 'Kotlin', useCount: 98 },
    { tagId: 3, tagName: 'Compose', useCount: 60 },
    { tagId: 4, tagName: 'Java', useCount: 150 },
    { tagId: 5, tagName: '后端', useCount: 88 },
    { tagId: 6, tagName: '小程序', useCount: 45 },
    { tagId: 7, tagName: '求职', useCount: 70 },
    { tagId: 8, tagName: '人工智能', useCount: 110 }
]

const ARTICLE_TAG_MAP: Record<number, number[]> = {
    101: [2, 1, 3], 102: [1, 7], 103: [3, 1], 104: [5, 4],
    105: [7], 106: [6], 107: [], 108: [1, 6]
}

const MOCK_CONTENT_HTML =
    '<p>这是富文本正文，用来验证<strong>加粗</strong>、图片宽度、表格与代码块渲染。</p>' +
    '<h3>一、背景</h3>' +
    '<p>结构化并发为什么必须向上抛 CancellationException。正文由后端返回 HTML，客户端用 rich-text 渲染并注入适配样式。</p>' +
    '<pre><code>catch (e: CancellationException) { throw e }</code></pre>'

function tagsOf(articleId: number): ArticleTag[] {
    return (ARTICLE_TAG_MAP[articleId] || []).map((id) => TAG_POOL.find((t) => t.tagId === id)!).filter(Boolean)
}

function buildMockDetail(a: ArticleDto): ArticleDetailDto {
    const idx = mockFeed.findIndex((x) => x.articleId === a.articleId)
    return {
        articleId: a.articleId, title: a.title, summary: a.summary, content: MOCK_CONTENT_HTML,
        coverUrl: a.coverUrl, authorId: a.authorId, authorName: a.authorName,
        categoryId: a.categoryId, categoryName: a.categoryName, tags: tagsOf(a.articleId),
        viewCount: a.viewCount, likeCount: a.likeCount, commentCount: a.commentCount,
        favoriteCount: Math.floor(a.likeCount / 3), publishTime: a.publishTime, status: 2,
        isLiked: false, isFavorited: false,
        prevArticle: idx > 0 ? { articleId: mockFeed[idx - 1].articleId, title: mockFeed[idx - 1].title } : null,
        nextArticle: idx >= 0 && idx < mockFeed.length - 1 ? { articleId: mockFeed[idx + 1].articleId, title: mockFeed[idx + 1].title } : null
    }
}

/** GET articles/{articleId} */
export function getArticleDetailApi(articleId: number): Promise<ArticleDetailDto> {
    if (!API_READY.articleDetail) {
        const base = mockFeed.find((a) => a.articleId === articleId) || mockFeed[0]
        return Promise.resolve(buildMockDetail(base))
    }
    return get(v1('/articles/' + articleId))
}

/** GET article-tags（按 useCount 排序） */
export function getArticleTagsApi(): Promise<ArticleTag[]> {
    if (!API_READY.articles) return Promise.resolve(TAG_POOL.slice().sort((a, b) => (b.useCount || 0) - (a.useCount || 0)))
    return get(v1('/article-tags'))
}

/** 标签聚合：GET articles?tagId= */
export function getArticlesByTagApi(tagId: number): Promise<ArticleDto[]> {
    if (!API_READY.articles) {
        return Promise.resolve(mockFeed.filter((a) => (ARTICLE_TAG_MAP[a.articleId] || []).indexOf(tagId) >= 0))
    }
    return get(v1('/articles'), { tagId })
}

/** 供编辑页回填：按 id 取一条 MyArticle（mock） */
export function getEditableArticleApi(articleId: number): Promise<MyArticleDto | undefined> {
    if (!API_READY.articlePublish) return Promise.resolve(mockArticles.find((a) => a.articleId === articleId))
    return get(v1('/articles/' + articleId))
}

export interface PublishArticleParams {
    title: string
    summary?: string
    content: string
    coverUrl?: string
    categoryId: number
    tagIds?: number[]
    publish: number   // 0 草稿  1 提交审核
}

/** POST articles（新建） */
export function publishArticleApi(params: PublishArticleParams): Promise<{ articleId: number; status: number }> {
    if (!API_READY.articlePublish) {
        const id = mockArticles.reduce((m, a) => Math.max(m, a.articleId), 100) + 1
        mockArticles.push({
            articleId: id, title: params.title, summary: params.summary, categoryName: '',
            status: params.publish === 1 ? 1 : 0, viewCount: 0, likeCount: 0, commentCount: 0, publishTime: ''
        })
        return Promise.resolve({ articleId: id, status: params.publish === 1 ? 1 : 0 })
    }
    return post(v1('/articles'), params)
}

/** PUT articles/{id}（编辑保存） */
export function updateArticleApi(articleId: number, params: Partial<PublishArticleParams>): Promise<void> {
    if (!API_READY.articlePublish) {
        const a = mockArticles.find((x) => x.articleId === articleId)
        if (a) {
            if (params.title !== undefined) a.title = params.title
            if (params.summary !== undefined) a.summary = params.summary
        }
        return Promise.resolve()
    }
    return put(v1('/articles/' + articleId), params)
}

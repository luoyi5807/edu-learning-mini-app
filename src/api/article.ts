import { get, post, v1 } from '@/utils/request'
import { API_READY } from '@/config/apiStatus'
import { BASE_URL } from '@/config/env'
import type { ArticleDto, ArticleDetailDto, ArticleTag } from '@/types/article'

/* ===================== 社区文章列表（GET articles） ===================== */

export interface ArticleListParams {
    pageNum?: number
    pageSize?: number
    categoryId?: number
    tagId?: number
    sort?: number   // 1最新 2最热 3精华
}

/** 社区信息流一页数据：list 已映射，total 用于判断是否还有下一页 */
export interface ArticleListResult {
    list: ArticleDto[]
    total: number
}

/** 后端 learning_post 行（/api/v1/search/post 返回，列表不含正文 content） */
export interface BackendPost {
    postId: number
    postTitle: string
    categoryId?: number
    userId: number
    likeCount?: number
    favoriteCount?: number
    commentCount?: number
    status?: string
    isFeatured?: string        // '0' 否 / '1' 是
    categoryName?: string
    userName?: string          // 作者昵称
    createTime?: string
}

/** 后端 /api/v1/post/list 行（PostListSummary）：摘要/首图由服务端从正文算好，
 *  另带 viewCount（阅读数）与 avatar（作者头像），社区卡片直接展示 */
export interface BackendPostListItem {
    postId: number
    postTitle: string
    summary?: string
    coverUrl?: string
    isFeatured?: string        // '0' 否 / '1' 是
    userName?: string
    avatar?: string
    viewCount?: number
    likeCount?: number
    favoriteCount?: number
    commentCount?: number
    createTime?: string
}

/** 相对路径（/profile/upload/...）补全为后端绝对地址 */
function absUrl(path?: string): string {
    if (!path) return ''
    return /^[a-z][a-z\d+\-.]*:\/\//i.test(path) ? path : BASE_URL + (path.startsWith('/') ? '' : '/') + path
}

function normalizePostListItem(p: BackendPostListItem): ArticleDto {
    return {
        articleId: p.postId,
        title: p.postTitle || '',
        summary: p.summary || '',
        coverUrl: absUrl(p.coverUrl),
        authorId: 0,
        authorName: p.userName || '用户',
        authorAvatar: absUrl(p.avatar),
        viewCount: p.viewCount || 0,
        likeCount: p.likeCount || 0,
        commentCount: p.commentCount || 0,
        publishTime: p.createTime || '',
        status: 2,
        essence: p.isFeatured === '1' ? 1 : 0
    }
}

/** 社区文章列表。sort：1最新(createTime) 2最热(likeCount) 3精华(featured=true)，筛选与分页全部交给后端 */
export async function getArticleListApi(params: ArticleListParams = {}): Promise<ArticleListResult> {
    const { categoryId, sort = 1, pageNum = 1, pageSize = 20 } = params
    if (!API_READY.articles) {
        let list = mockFeed.slice()
        if (categoryId) list = list.filter((a) => a.categoryId === categoryId)
        if (sort === 3) list = list.filter((a) => a.essence === 1)
        if (sort === 2) list.sort((a, b) => b.viewCount - a.viewCount)
        else list.sort((a, b) => b.articleId - a.articleId)
        const start = (pageNum - 1) * pageSize
        return { list: list.slice(start, start + pageSize), total: list.length }
    }
    const query: Record<string, any> = { pageNum, pageSize }
    if (categoryId && categoryId > 0) query.categoryId = categoryId
    if (sort === 2) query.sortBy = 'likeCount'
    if (sort === 3) query.featured = true
    const body: any = await get(v1('/post/list'), query)
    const rows: BackendPostListItem[] = (body && Array.isArray(body.rows)) ? body.rows : []
    return { list: rows.map(normalizePostListItem), total: Number(body && body.total) || 0 }
}

/** mock 社区信息流（仅在对应开关为 false 时使用；补齐此前遗漏的定义，避免 mock 分支 ReferenceError） */
const mockFeed: ArticleDto[] = [
    { articleId: 101, title: 'Kotlin 协程取消机制完全指南', authorId: 1, authorName: '张三', categoryName: '移动开发', categoryId: 1, viewCount: 1200, likeCount: 32, commentCount: 8, publishTime: '2026-09-28 10:12', essence: 1 },
    { articleId: 102, title: '后端接口设计中的 10 个常见错误', authorId: 4, authorName: '陈老师', categoryName: '后端', categoryId: 5, viewCount: 860, likeCount: 21, commentCount: 3, publishTime: '2026-09-20 15:40' },
    { articleId: 103, title: 'uni-app 分包与首屏体积优化', authorId: 2, authorName: '李四', categoryName: '小程序', categoryId: 6, viewCount: 540, likeCount: 18, commentCount: 2, publishTime: '2026-09-18 09:05' },
    { articleId: 104, title: 'Compose 布局迁移到小程序的对照笔记', authorId: 3, authorName: '王五', categoryName: '移动开发', categoryId: 1, viewCount: 430, likeCount: 12, commentCount: 1, publishTime: '2026-09-15 20:30' },
    { articleId: 105, title: '关于深度学习的一点粗浅理解', authorId: 5, authorName: '赵六', categoryName: '人工智能', categoryId: 8, viewCount: 300, likeCount: 9, commentCount: 0, publishTime: '2026-09-10 14:00' },
    { articleId: 106, title: 'SCSS 设计系统在前端的落地实践', authorId: 2, authorName: '李四', categoryName: '前端', categoryId: 6, viewCount: 260, likeCount: 7, commentCount: 0, publishTime: '2026-09-05 11:20' }
]

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

/** 后端 /post/myList 行（PostSummary）：仅 postId/postTitle/status/auditRemark/likeCount/favoriteCount */
export interface BackendPostSummary {
    postId: number
    postTitle: string
    status?: string            // 后端：0发布 1草稿 2下架 3待审 4驳回
    auditRemark?: string | null
    likeCount?: number
    favoriteCount?: number
}

/** 后端帖子状态字符 → 前端数值：0→2(已发布) 1→0(草稿) 2→4(已下架) 3→1(待审核) 4→3(已驳回) */
function backendStatusToFe(s?: string): number {
    switch (s) {
        case '0': return 2
        case '1': return 0
        case '2': return 4
        case '3': return 1
        case '4': return 3
        default: return 2
    }
}

/** 后端 PostSummary → MyArticleDto（myList 无浏览量/分类/时间，按缺省补 0/''） */
function normalizeMyPost(p: BackendPostSummary): MyArticleDto {
    return {
        articleId: p.postId,
        title: p.postTitle || '',
        categoryName: '',
        status: backendStatusToFe(p.status),
        rejectReason: p.auditRemark || '',
        viewCount: 0,
        likeCount: p.likeCount || 0,
        commentCount: 0,
        publishTime: '',
        createTime: ''
    }
}

/** 我的发布：GET /api/v1/post/myList（分页，一次多取，状态 Tab 前端过滤） */
export function getMyArticlesApi(status?: number): Promise<MyArticleDto[]> {
    if (!API_READY.myArticles) {
        const list = mockArticles.slice().sort((a, b) => b.articleId - a.articleId)
        return Promise.resolve(status === undefined || status === null ? list : list.filter((a) => a.status === status))
    }
    return get(v1('/post/myList'), { pageNum: 1, pageSize: 100 }).then((body: any) => {
        const rows: BackendPostSummary[] = (body && Array.isArray(body.rows)) ? body.rows : []
        const list = rows.map(normalizeMyPost)
        return status === undefined || status === null ? list : list.filter((a) => a.status === status)
    })
}

/**
 * 他人主页文章：契约 GET user/blog-home/{userId}/articles
 * 后端暂无「他人主页/他人文章」客户端接口，恒走本地（按 authorId 过滤 mockFeed），不发无效请求
 */
export function getUserPublishedArticlesApi(userId: number): Promise<MyArticleDto[]> {
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

/** 撤回已发布 → 回到草稿：后端暂无撤回接口，保持本地 no-op，不发无效请求 */
export function withdrawArticleApi(articleId: number): Promise<void> {
    const item = mockArticles.find((a) => a.articleId === articleId)
    if (item) item.status = 0
    return Promise.resolve()
}

/** 删除：POST /api/v1/post/remove?postId=（后端从 Token 校验作者，软删并级联清理互动/评论） */
export function deleteArticleApi(articleId: number): Promise<void> {
    if (!API_READY.myArticles) {
        const idx = mockArticles.findIndex((a) => a.articleId === articleId)
        if (idx >= 0) mockArticles.splice(idx, 1)
        return Promise.resolve()
    }
    return post(v1('/post/remove') + '?postId=' + articleId).then(() => undefined)
}

/** 提交审核：后端无「草稿→待审」状态接口（App 端统一发布即提交审核），保持本地 no-op */
export function submitArticleApi(articleId: number): Promise<void> {
    const item = mockArticles.find((a) => a.articleId === articleId)
    if (item) item.status = 1
    return Promise.resolve()
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

/** 后端 PostDetail（GET /api/v1/post/info）：正文 content 为 Markdown 原文 */
export interface BackendPostDetail {
    postId: number
    postTitle: string
    status?: string
    auditRemark?: string | null
    content?: string
    userId: number
    userName?: string
    avatar?: string
    categoryName?: string
    createTime?: string
    viewCount?: number
    likeCount?: number
    commentCount?: number
}

function escapeHtml(s: string): string {
    return s.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;')
}

/** 行内 Markdown：转义后再处理 `code`、**粗体**、*斜体*、![]()、[]() */
function mdInline(s: string): string {
    let out = escapeHtml(s)
    out = out.replace(/`([^`]+)`/g, '<code>$1</code>')
    out = out.replace(/\*\*([^*]+)\*\*/g, '<strong>$1</strong>')
    out = out.replace(/\*([^*]+)\*/g, '<em>$1</em>')
    out = out.replace(/!\[([^\]]*)\]\(([^)]+)\)/g, '<img alt="$1" src="$2" style="max-width:100%"/>')
    out = out.replace(/\[([^\]]+)\]\(([^)]+)\)/g, '<a href="$2">$1</a>')
    return out
}

/** 轻量 Markdown → HTML（供 rich-text 渲染）：代码块、标题、无序列表、段落、行内样式 */
function mdToHtml(md: string): string {
    if (!md) return ''
    const lines = md.replace(/\r\n/g, '\n').split('\n')
    let html = ''
    let inCode = false
    let inList = false
    const codeBuf: string[] = []
    const closeList = () => { if (inList) { html += '</ul>'; inList = false } }
    for (const raw of lines) {
        const trimmed = raw.trim()
        if (/^``/.test(trimmed)) {
            if (inCode) { html += '<pre><code>' + escapeHtml(codeBuf.join('\n')) + '</code></pre>'; codeBuf.length = 0; inCode = false }
            else { closeList(); inCode = true }
            continue
        }
        if (inCode) { codeBuf.push(raw); continue }
        if (!trimmed) { closeList(); continue }
        const h = /^(#{1,6})\s+(.*)$/.exec(trimmed)
        if (h) { closeList(); const lv = Math.min(h[1].length, 3); html += `<h${lv}>` + mdInline(h[2]) + `</h${lv}>`; continue }
        const li = /^[-*+]\s+(.*)$/.exec(trimmed)
        if (li) { if (!inList) { html += '<ul>'; inList = true } html += '<li>' + mdInline(li[1]) + '</li>'; continue }
        closeList()
        html += '<p>' + mdInline(trimmed) + '</p>'
    }
    if (inCode) html += '<pre><code>' + escapeHtml(codeBuf.join('\n')) + '</code></pre>'
    closeList()
    // 相对图片地址（/profile/... 等）补全为绝对地址，rich-text 才能加载
    return html.replace(/src="(?!https?:)([^"]*)"/g, (_m, p: string) => 'src="' + BASE_URL + (p.startsWith('/') ? '' : '/') + p + '"')
}

/** 后端 PostDetail → 前端 ArticleDetailDto；话题/上一篇下一篇后端暂无，置空 */
function normalizePostDetail(d: BackendPostDetail): ArticleDetailDto {
    return {
        articleId: d.postId,
        title: d.postTitle || '',
        content: mdToHtml(d.content || ''),
        authorId: d.userId,
        authorName: d.userName || '用户',
        authorAvatar: d.avatar || '',
        categoryName: d.categoryName || '',
        tags: [],
        viewCount: d.viewCount || 0,
        likeCount: d.likeCount || 0,
        commentCount: d.commentCount || 0,
        favoriteCount: 0,
        publishTime: d.createTime || '',
        status: Number(d.status ?? 0),
        isLiked: false,
        isFavorited: false,
        prevArticle: null,
        nextArticle: null
    }
}

/** GET /api/v1/post/info?postId= —— 文章详情（真实数据；Markdown 正文转 HTML） */
export async function getArticleDetailApi(articleId: number): Promise<ArticleDetailDto> {
    if (!API_READY.articleDetail) {
        const base = mockFeed.find((a) => a.articleId === articleId) || mockFeed[0]
        return buildMockDetail(base)
    }
    const body: any = await get(v1('/post/info'), { postId: articleId })
    const data: BackendPostDetail = (body && body.data) ? body.data : (body as BackendPostDetail)
    return normalizePostDetail(data)
}

/** 话题标签池：GET /api/v1/topic/list（后端就绪则取真实话题；关闭时回落本地 TAG_POOL） */
export async function getArticleTagsApi(): Promise<ArticleTag[]> {
    if (!API_READY.topics) {
        return TAG_POOL.slice().sort((a, b) => (b.useCount || 0) - (a.useCount || 0))
    }
    const body: any = await get(v1('/topic/list'), { pageNum: 1, pageSize: 50 })
    const rows: any[] = (body && Array.isArray(body.rows)) ? body.rows : []
    return rows
        .map((t) => ({ tagId: t.topicId, tagName: t.topicName, useCount: t.postCount || 0 }))
        .sort((a, b) => (b.useCount || 0) - (a.useCount || 0))
}

/** 标签聚合：后端无标签接口，恒走本地匹配 */
export function getArticlesByTagApi(tagId: number): Promise<ArticleDto[]> {
    return Promise.resolve(mockFeed.filter((a) => (ARTICLE_TAG_MAP[a.articleId] || []).indexOf(tagId) >= 0))
}

/** 供编辑页回填：GET /api/v1/post/info?postId=（后端已就绪；分类ID不返回，编辑页需重选分类） */
export function getEditableArticleApi(articleId: number): Promise<MyArticleDto | undefined> {
    if (!API_READY.articlePublish) return Promise.resolve(mockArticles.find((a) => a.articleId === articleId))
    return get(v1('/post/info'), { postId: articleId }).then((body: any) => {
        const d: BackendPostDetail = (body && body.data) ? body.data : (body as BackendPostDetail)
        if (!d || !d.postId) return undefined
        return {
            articleId: d.postId,
            title: d.postTitle || '',
            summary: '',
            categoryName: d.categoryName || '',
            status: backendStatusToFe(d.status),
            rejectReason: d.auditRemark || '',
            viewCount: d.viewCount || 0,
            likeCount: d.likeCount || 0,
            commentCount: d.commentCount || 0,
            publishTime: d.createTime || ''
        } as MyArticleDto
    })
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

/** POST /api/v1/post/add（JSON）—— 提交审核；后端统一先审后发（落 status=3），无草稿接口 */
export function publishArticleApi(params: PublishArticleParams): Promise<{ articleId: number; status: number }> {
    if (!API_READY.articlePublish) {
        const id = mockArticles.reduce((m, a) => Math.max(m, a.articleId), 100) + 1
        mockArticles.push({
            articleId: id, title: params.title, summary: params.summary, categoryName: '',
            status: params.publish === 1 ? 1 : 0, viewCount: 0, likeCount: 0, commentCount: 0, publishTime: ''
        })
        return Promise.resolve({ articleId: id, status: params.publish === 1 ? 1 : 0 })
    }
    if (params.publish === 0) {
        return Promise.reject({ code: 501, msg: '后端暂不支持草稿，请直接发布提交审核' })
    }
    // 后端 /add 的 JSON 出口按 Map<String,String> 绑定，字段值统一转字符串
    return post(v1('/post/add'), {
        postTitle: params.title,
        categoryId: String(params.categoryId),
        content: params.content
    }).then((res: any) => ({ articleId: Number(res && res.postId), status: 1 }))
}

/** 编辑保存：后端暂无编辑接口，明确提示，不发无效请求（请删除后重新发布） */
export function updateArticleApi(articleId: number, params: Partial<PublishArticleParams>): Promise<void> {
    if (!API_READY.articlePublish) {
        const a = mockArticles.find((x) => x.articleId === articleId)
        if (a && params.title !== undefined) a.title = params.title
        return Promise.resolve()
    }
    return Promise.reject({ code: 501, msg: '后端暂不支持编辑，请删除后重新发布' })
}

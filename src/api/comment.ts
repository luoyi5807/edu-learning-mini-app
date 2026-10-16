import { get, post, v1 } from '@/utils/request'
import { API_READY } from '@/config/apiStatus'
import { getMockArticleCommentCount } from './article'
import type { CommentDto } from '@/types/article'

export interface CommentPage { list: CommentDto[]; nextCursor: string; hasMore: boolean; total?: number }

let seq = 9000

/* 按 targetType:targetId 独立存评论，避免跨文章串评论 */
const store: Record<string, CommentDto[]> = {}
function keyOf(targetType: number, targetId: number): string { return targetType + ':' + targetId }

const SAMPLE_POOL = [
    { userId: 11, nickName: '码上开花', content: '讲得太清楚了，终于搞懂取消传播了！', likeCount: 12, replyCount: 2 },
    { userId: 12, nickName: '后端小白', content: '请问和 Java 的 try-with-resources 有什么异同？', likeCount: 3, replyCount: 1 },
    { userId: 13, nickName: '张三', content: '作者补充了一张时序图，见正文末尾。', likeCount: 8, replyCount: 0 },
    { userId: 14, nickName: '求知的鱼', content: '终于看懂了，感谢分享！', likeCount: 5, replyCount: 0 },
    { userId: 15, nickName: 'Lucas', content: '有没有配套的示例代码仓库？', likeCount: 1, replyCount: 3 },
    { userId: 16, nickName: '山有木兮', content: '写得很系统，期待下一篇。', likeCount: 2, replyCount: 0 }
]

/* 楼中楼：每条根评论的回复集合 */
const replyStore: Record<number, CommentDto[]> = {}
function makeReplies(rootId: number, n: number): CommentDto[] {
    const arr: CommentDto[] = []
    for (let i = 0; i < n; i++) {
        arr.push({ commentId: rootId * 100 + i + 1, userId: 300 + i, nickName: '路人' + (i + 1), content: '这是针对该评论的第 ' + (i + 1) + ' 条回复。', createTime: '2026-09-1' + ((i % 9) + 1) + ' 12:0' + (i % 6), likeCount: i % 4, isLiked: false, replyCount: 0 })
    }
    return arr
}

/* 视频/课程评论（targetType=2）mock 池，对齐《参考安卓》4.5 CommentsSheet */
const VIDEO_SAMPLE_POOL = [
    { userId: 1, nickName: '张三', content: '讲得很清晰，第一章就解决了我卡了很久的环境问题。', likeCount: 12, replyCount: 2 },
    { userId: 2, nickName: '李四', content: '希望能补充一下复杂度的推导过程。', likeCount: 5, replyCount: 0 },
    { userId: 3, nickName: '王五', content: '已加入学习，进度到第二章了。', likeCount: 2, replyCount: 1 },
    { userId: 4, nickName: '陈老师', content: '实操演示很到位，课后练习也刚刚好。', likeCount: 7, replyCount: 0 },
    { userId: 5, nickName: '赵六', content: '试看章节就很有收获，已经下单了。', likeCount: 3, replyCount: 0 },
    { userId: 6, nickName: '孙七', content: '讲师节奏把握得很好，推荐！', likeCount: 4, replyCount: 0 }
]

function seedVideoSample(targetId: number): CommentDto[] {
    const arr: CommentDto[] = []
    for (let i = 0; i < VIDEO_SAMPLE_POOL.length; i++) {
        const t = VIDEO_SAMPLE_POOL[i]
        const commentId = 200000 + targetId * 100 + i + 1
        const c: CommentDto = {
            commentId,
            userId: t.userId,
            nickName: t.nickName,
            content: t.content,
            createTime: '2026-09-12 1' + (i % 3) + ':0' + (i % 6) + ':00',
            likeCount: t.likeCount,
            isLiked: false,
            replyCount: t.replyCount
        }
        if (t.replyCount > 0) {
            const reps: CommentDto[] = []
            for (let j = 0; j < t.replyCount; j++) {
                reps.push({
                    commentId: commentId * 100 + j + 1,
                    userId: 300 + j,
                    nickName: j === 0 ? '李四' : '路人' + (j + 1),
                    content: j === 0 ? '同感，1.3 那节特别有用' : '第 ' + (j + 1) + ' 条回复。',
                    createTime: '2026-09-12 15:2' + j + ':00',
                    likeCount: 0,
                    isLiked: false,
                    replyCount: 0,
                    replyToUserName: j === 0 ? t.nickName : undefined
                })
            }
            replyStore[commentId] = reps
            c.replies = reps.slice(0, 2)
        }
        arr.push(c)
    }
    return arr
}

/** 按文章在列表展示的评论数，生成对应条数的 mock 评论 */
function seedSample(targetId: number): CommentDto[] {
    const count = getMockArticleCommentCount(targetId)
    const arr: CommentDto[] = []
    for (let i = 0; i < count; i++) {
        const t = SAMPLE_POOL[i % SAMPLE_POOL.length]
        const commentId = targetId * 1000 + i + 1
        const c: CommentDto = {
            commentId,
            userId: t.userId,
            nickName: t.nickName,
            content: t.content,
            createTime: '2026-09-' + (10 + (i % 15)) + ' 1' + (i % 9) + ':2' + (i % 6),
            likeCount: t.likeCount,
            isLiked: false,
            replyCount: t.replyCount
        }
        if (t.replyCount > 0) {
            replyStore[commentId] = makeReplies(commentId, t.replyCount)
            c.replies = replyStore[commentId].slice(0, 2)   // hotReplies 预览 2 条
        }
        arr.push(c)
    }
    return arr
}

function list(targetType: number, targetId: number): CommentDto[] {
    const k = keyOf(targetType, targetId)
    if (!store[k]) store[k] = targetType === 1 ? seedSample(targetId) : (targetType === 2 ? seedVideoSample(targetId) : [])
    return store[k]
}

/** 后端 learning_comment 行（children 内联二级回复） */
export interface BackendComment {
    commentId: number
    userId: number
    targetType: string
    targetId: number
    parentId?: number | null
    replyUserId?: number | null
    content: string
    createTime: string
    userName?: string
    replyUserName?: string
    children?: BackendComment[] | null
}

function normalizeComment(c: BackendComment): CommentDto {
    const replies = Array.isArray(c.children) ? c.children.map(normalizeComment) : []
    return {
        commentId: c.commentId,
        userId: c.userId,
        nickName: c.userName || '用户',
        content: c.content || '',
        createTime: c.createTime || '',
        likeCount: 0,
        isLiked: false,
        replyCount: replies.length,
        replies,
        replyToUserName: c.replyUserName || undefined,
        parentId: c.parentId ?? undefined
    }
}

/** GET /api/v1/comment/list —— 一级评论（含内联 children），total 为一级评论数 */
export async function getCommentsApi(targetType: number, targetId: number, cursor?: string, size = 20): Promise<CommentPage> {
    if (!API_READY.comment) {
        return { list: list(targetType, targetId).slice(), nextCursor: '', hasMore: false }
    }
    const body: any = await get(v1('/comment/list'), { targetType, targetId, pageNum: 1, pageSize: size })
    const rows: BackendComment[] = (body && Array.isArray(body.rows)) ? body.rows : []
    const arr = rows.map(normalizeComment)
    const total = (body && body.total != null) ? Number(body.total) : arr.length
    return { list: arr, nextCursor: '', hasMore: false, total }
}

/** 楼中楼：后端已随列表内联返回 children，无独立接口；保留签名兼容旧调用 */
export function getRepliesApi(rootId: number, cursor?: string, size = 20): Promise<CommentPage> {
    return Promise.resolve({ list: [], nextCursor: '', hasMore: false })
}

export interface AddCommentParams {
    targetType: number
    targetId: number
    rootId?: number
    parentId?: number
    replyToUserId?: number
    replyToUserName?: string
    content: string
}

/** POST /api/v1/comment/add（JSON 出口）—— parentId = 被回复评论ID，一级不传 */
export async function addCommentApi(params: AddCommentParams): Promise<{ commentId: number; status: number }> {
    if (!API_READY.comment) {
        const id = ++seq
        const me: CommentDto = { commentId: id, userId: 0, nickName: '我', content: params.content, createTime: '刚刚', likeCount: 0, isLiked: false, replyCount: 0, parentId: params.parentId, replyToUserName: params.replyToUserName }
        if (params.rootId) {
            const arr = replyStore[params.rootId] || (replyStore[params.rootId] = [])
            arr.push(me)
        } else {
            list(params.targetType, params.targetId).unshift(me)
        }
        return { commentId: id, status: 1 }
    }
    const body: Record<string, string> = {
        targetType: String(params.targetType),
        targetId: String(params.targetId),
        content: params.content
    }
    if (params.parentId) body.parentId = String(params.parentId)
    const res: any = await post(v1('/comment/add'), body)
    return { commentId: Number((res && res.commentId) || 0), status: 1 }
}

/** 评论点赞：后端无该接口，纯本地、不发请求 */
export function likeCommentApi(commentId: number, isLikedNow: boolean): Promise<{ isLiked: boolean }> {
    return Promise.resolve({ isLiked: !isLikedNow })
}

/** POST /api/v1/comment/remove（JSON 出口） */
export function deleteCommentApi(commentId: number): Promise<{ count: number }> {
    if (!API_READY.comment) return Promise.resolve({ count: 0 })
    return post(v1('/comment/remove'), { commentId: String(commentId) })
}
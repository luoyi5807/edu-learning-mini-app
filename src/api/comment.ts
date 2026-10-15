import { get, post, del, v1 } from '@/utils/request'
import { API_READY } from '@/config/apiStatus'
import { getMockArticleCommentCount } from './article'
import type { CommentDto } from '@/types/article'

export interface CommentPage { list: CommentDto[]; nextCursor: string; hasMore: boolean }

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

/** GET comments（游标分页） */
export function getCommentsApi(targetType: number, targetId: number, cursor?: string, size = 10): Promise<CommentPage> {
    if (!API_READY.comment) {
        return Promise.resolve({ list: list(targetType, targetId).slice(), nextCursor: '', hasMore: false })
    }
    return get(v1('/comments'), { targetType, targetId, cursor, size })
}

/** GET comments/{rootId}/replies（楼中楼，游标分页） */
export function getRepliesApi(rootId: number, cursor?: string, size = 20): Promise<CommentPage> {
    if (!API_READY.comment) {
        return Promise.resolve({ list: (replyStore[rootId] || []).slice(), nextCursor: '', hasMore: false })
    }
    return get(v1('/comments/' + rootId + '/replies'), { cursor, size })
}

export interface AddCommentParams {
    targetType: number
    targetId: number
    rootId?: number           // 楼中楼：所属根评论 ID（不传即根评论）
    parentId?: number         // 楼中楼：直接被回复的评论 ID
    replyToUserId?: number    // 楼中楼：被回复用户 ID
    replyToUserName?: string  // 楼中楼：被回复用户昵称（展示用）
    content: string
}

/** POST comments */
export function addCommentApi(params: AddCommentParams): Promise<{ commentId: number; status: number }> {
    if (!API_READY.comment) {
        const id = ++seq
        const me: CommentDto = {
            commentId: id,
            userId: 0,
            nickName: '我',
            content: params.content,
            createTime: '刚刚',
            likeCount: 0,
            isLiked: false,
            replyCount: 0,
            parentId: params.parentId,
            replyToUserId: params.replyToUserId,
            replyToUserName: params.replyToUserName
        }
        if (params.rootId) {
            // 楼中楼：写入 replyStore，并让根评论的 replyCount +1
            const arr = replyStore[params.rootId] || (replyStore[params.rootId] = [])
            arr.push(me)
            for (const k in store) {
                const root = store[k].find((x) => x.commentId === params.rootId)
                if (root) {
                    root.replyCount = (root.replyCount || 0) + 1
                    break
                }
            }
        } else {
            list(params.targetType, params.targetId).unshift(me)
        }
        return Promise.resolve({ commentId: id, status: 1 })
    }
    return post(v1('/comments'), params)
}

/** 评论点赞 */
export function likeCommentApi(commentId: number, isLikedNow: boolean): Promise<{ isLiked: boolean }> {
    if (!API_READY.comment) {
        for (const k in store) {
            const c = store[k].find((x) => x.commentId === commentId)
            if (c) { c.isLiked = !isLikedNow; c.likeCount += isLikedNow ? -1 : 1; break }
        }
        return Promise.resolve({ isLiked: !isLikedNow })
    }
    return post(v1('/comments/' + commentId + '/like/toggle'))
}

export function deleteCommentApi(commentId: number): Promise<void> {
    if (!API_READY.comment) {
        for (const k in store) {
            const i = store[k].findIndex((x) => x.commentId === commentId)
            if (i >= 0) { store[k].splice(i, 1); break }
        }
        return Promise.resolve()
    }
    return del(v1('/comments/' + commentId))
}
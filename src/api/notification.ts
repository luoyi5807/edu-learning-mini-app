// src/api/notification.ts
import { get, post, v1 } from '@/utils/request'
import { API_READY } from '@/config/apiStatus'

/** 后端 learning_notification 行（列名已 as 驼峰） */
export interface BackendNotification {
    notificationId: number
    userId: number
    fromUserId: number
    type: string                 // 1点赞 2收藏 3评论 4关注 5回复评论
    targetType?: string | null   // 1帖子 3短视频；关注类为 null（课程永不产生通知）
    targetId?: number | null
    content?: string             // 仅评论类有值
    isRead: string               // 0未读 1已读
    readTime?: string | null
    createTime: string           // yyyy-MM-dd HH:mm:ss
    fromUserName?: string        // 触发者登录名
    fromUserAvatar?: string
}

/** 前端通知视图模型 */
export interface NotificationDto {
    noticeId: number
    type: number
    actorUserId?: number
    actorUserName: string
    title: string
    content?: string
    createTime: string
    isRead: boolean
    targetType?: number
    targetId?: number
    avatar?: string
}

/** 分类 Tab：value 严格对齐后端 type 编码 */
export const NOTICE_TABS: { label: string; value: number }[] = [
    { label: '点赞', value: 1 },
    { label: '收藏', value: 2 },
    { label: '评论', value: 3 },
    { label: '关注', value: 4 },
    { label: '回复', value: 5 }
]

const TYPE_ACTION: Record<number, string> = {
    1: '赞了你',
    2: '收藏了你',
    3: '评论了你',
    4: '关注了你',
    5: '回复了你的评论'
}

function normalizeNotification(n: BackendNotification): NotificationDto {
    const type = Number(n.type)
    const name = n.fromUserName || '有人'
    return {
        noticeId: n.notificationId,
        type,
        actorUserId: n.fromUserId,
        actorUserName: name,
        title: name + ' ' + (TYPE_ACTION[type] || '给你发来一条通知'),
        content: n.content || '',
        createTime: n.createTime || '',
        isRead: n.isRead === '1',
        targetType: (n.targetType != null && n.targetType !== '') ? Number(n.targetType) : undefined,
        targetId: (n.targetId != null) ? Number(n.targetId) : undefined,
        avatar: n.fromUserAvatar || ''
    }
}

const mockNotifications: NotificationDto[] = [
    { noticeId: 1, type: 1, actorUserId: 11, actorUserName: '小明', title: '小明 赞了你', content: '', createTime: '2026-10-16 10:00:00', isRead: false, targetType: 1, targetId: 101 }
]

/** GET /api/v1/notification/list —— 后端不支持按 type 过滤，取回后前端按 type 客户端过滤 */
export async function getNotificationsApi(type?: number): Promise<NotificationDto[]> {
    if (!API_READY.notification) {
        const arr = mockNotifications.slice()
        return type ? arr.filter((n) => n.type === type) : arr
    }
    const body: any = await get(v1('/notification/list'), { pageNum: 1, pageSize: 50 })
    const rows: BackendNotification[] = (body && Array.isArray(body.rows)) ? body.rows : []
    let list = rows.map(normalizeNotification)
    if (type) list = list.filter((n) => n.type === type)
    return list
}

/** GET /api/v1/notification/unreadCount —— 响应顶层含 count */
export function getUnreadCountApi(): Promise<{ count: number }> {
    if (!API_READY.notification) {
        return Promise.resolve({ count: mockNotifications.filter((n) => !n.isRead).length })
    }
    return get(v1('/notification/unreadCount'))
}

/** POST /api/v1/notification/read —— JSON body {notificationId}，响应含最新 count */
export function markNoticeReadApi(noticeId: number): Promise<{ count: number }> {
    if (!API_READY.notification) return Promise.resolve({ count: 0 })
    return post(v1('/notification/read'), { notificationId: String(noticeId) })
}

/** POST /api/v1/notification/readAll —— 幂等，响应 count 必为 0 */
export function markAllNoticeReadApi(): Promise<{ count: number }> {
    if (!API_READY.notification) return Promise.resolve({ count: 0 })
    return post(v1('/notification/readAll'))
}
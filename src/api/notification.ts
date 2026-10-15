// src/api/notification.ts
import { get, post, v1 } from '@/utils/request'
import { API_READY } from '@/config/apiStatus'

/**
 * 通知消息 —— 契约 GET notifications?type=
 * type：1点赞 2评论 3关注 4收藏（与社区 targetType 语义一致，3 为关注体系专属）
 */
export interface NotificationDto {
    noticeId: number
    type: number              // 1点赞 2评论 3关注 4收藏
    actorUserId?: number      // 触发者（用于跳主页）
    actorUserName: string     // 触发者昵称
    title: string             // 主标题，如「小明赞了你的文章」
    content?: string          // 详情描述
    createTime: string        // 相对时间展示串
    isRead: boolean
    targetType?: number       // 1文章 2课程（点赞/评论/收藏跳转用）
    targetId?: number
}

export const NOTICE_TABS: { label: string; value: number }[] = [
    { label: '点赞', value: 1 },
    { label: '评论', value: 2 },
    { label: '关注', value: 3 },
    { label: '收藏', value: 4 }
]

let seq = 5000
const mockNotifications: NotificationDto[] = [
    { noticeId: 1, type: 1, actorUserId: 11, actorUserName: '小明', title: '小明赞了你的文章', content: '「Kotlin 协程取消机制完全指南」收到 32 个赞，最近：小明 10 分钟前赞', createTime: '10 分钟前', isRead: false, targetType: 1, targetId: 101 },
    { noticeId: 2, type: 1, actorUserId: 14, actorUserName: '小红', title: '小红赞了你的文章', content: '「Compose 重组优化实战」收到 18 个赞，最近：小红 1 小时前赞', createTime: '1 小时前', isRead: false, targetType: 1, targetId: 103 },
    { noticeId: 3, type: 1, actorUserId: 15, actorUserName: 'Lucas', title: 'Lucas 等 5 人赞了你的文章', content: '「后端接口设计中的 10 个常见错误」收到 5 个赞', createTime: '3 小时前', isRead: true, targetType: 1, targetId: 104 },
    { noticeId: 4, type: 2, actorUserId: 12, actorUserName: '后端小白', title: '后端小白评论了你的文章', content: '「Kotlin 协程取消机制完全指南」：请问和 Java 的 try-with-resources 有什么异同？', createTime: '20 分钟前', isRead: false, targetType: 1, targetId: 101 },
    { noticeId: 5, type: 2, actorUserId: 13, actorUserName: '张三', title: '张三回复了你的评论', content: '「uni-app 分包与首屏体积优化」：主包压缩后首屏大概快了多少？', createTime: '2 小时前', isRead: true, targetType: 1, targetId: 106 },
    { noticeId: 6, type: 3, actorUserId: 16, actorUserName: '山有木兮', title: '山有木兮 关注了你', content: 'TA 有 12 篇文章，粉丝 340', createTime: '30 分钟前', isRead: false },
    { noticeId: 7, type: 3, actorUserId: 5, actorUserName: '赵六', title: '赵六 关注了你', content: '25 届秋招 survivor，欢迎交流', createTime: '昨天 18:20', isRead: true },
    { noticeId: 8, type: 4, actorUserId: 15, actorUserName: 'Lucas', title: 'Lucas 收藏了你的文章', content: '「Kotlin 协程取消机制完全指南」被加入收藏', createTime: '1 小时前', isRead: false, targetType: 1, targetId: 101 }
]

/** GET notifications?type= —— 未读优先、时间倒序 */
export function getNotificationsApi(type?: number): Promise<NotificationDto[]> {
    if (!API_READY.notification) {
        let list = mockNotifications.slice()
        if (type) list = list.filter((n) => n.type === type)
        list.sort((a, b) => Number(a.isRead) - Number(b.isRead))
        return Promise.resolve(list)
    }
    return get(v1('/notifications'), { type })
}

/** 未读数量（红点用）：GET notifications/unread-count */
export function getUnreadCountApi(): Promise<{ count: number }> {
    if (!API_READY.notification) {
        return Promise.resolve({ count: mockNotifications.filter((n) => !n.isRead).length })
    }
    return get(v1('/notifications/unread-count'))
}

/** 单条已读：POST notifications/{id}/read */
export function markNoticeReadApi(noticeId: number): Promise<void> {
    if (!API_READY.notification) {
        const n = mockNotifications.find((x) => x.noticeId === noticeId)
        if (n) n.isRead = true
        return Promise.resolve()
    }
    return post(v1('/notifications/' + noticeId + '/read'))
}

/** 全部已读：POST notifications/read-all */
export function markAllNoticeReadApi(): Promise<void> {
    if (!API_READY.notification) {
        mockNotifications.forEach((n) => { n.isRead = true })
        return Promise.resolve()
    }
    return post(v1('/notifications/read-all'))
}
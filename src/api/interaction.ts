import { get, post, v1 } from '@/utils/request'
import { API_READY } from '@/config/apiStatus'

// targetType：1帖子 2课程 3短视频 ；type：1点赞 2收藏
function toggleApi(targetType: number, targetId: number, type: number): Promise<{ active: boolean; count: number }> {
    if (!API_READY.interaction) return Promise.resolve({ active: false, count: 0 })
    // 后端 toggle 是表单/查询参数、无 JSON 出口 → 参数拼在 URL query 上
    return post(v1('/interaction/toggle') + `?targetType=${targetType}&targetId=${targetId}&type=${type}`)
}

/** 点赞 toggle（保留旧签名，内部走 /interaction/toggle type=1） */
export async function toggleLikeApi(targetType: number, targetId: number, isLikedNow: boolean): Promise<{ isLiked: boolean; likeCount?: number }> {
    if (!API_READY.interaction) return { isLiked: !isLikedNow }
    const r = await toggleApi(targetType, targetId, 1)
    return { isLiked: !!r.active, likeCount: Number(r.count) }
}

/** 收藏 toggle（旧签名，内部走 /interaction/toggle type=2） */
export async function toggleFavoriteApi(targetType: number, targetId: number, isFavoritedNow: boolean): Promise<{ isFavorited: boolean; favoriteCount?: number }> {
    if (!API_READY.interaction) return { isFavorited: !isFavoritedNow }
    const r = await toggleApi(targetType, targetId, 2)
    return { isFavorited: !!r.active, favoriteCount: Number(r.count) }
}

/** 批量回填：当前用户已点赞/已收藏的目标ID（列表页初始化按钮态） */
export function getInteractionStatusApi(targetType: number, type: number, targetIds: number[]): Promise<number[]> {
    if (!API_READY.interaction || targetIds.length === 0) return Promise.resolve([])
    return get(v1('/interaction/status'), { targetType, type, targetIds: targetIds.join(',') })
        .then((res: any) => (res && Array.isArray(res.ids) ? res.ids : []))
}

/** 分享上报：后端无 C 端分享接口 → 本地空实现 */
export function reportShareApi(targetType: number, targetId: number, platform: number): Promise<void> {
    return Promise.resolve()
}
import { post, v1 } from '@/utils/request'
import { API_READY } from '@/config/apiStatus'

/** 点赞 toggle：targetType 1文章 2视频课程 3评论 */
export function toggleLikeApi(targetType: number, targetId: number, isLikedNow: boolean): Promise<{ isLiked: boolean; likeCount?: number }> {
    if (!API_READY.interaction) return Promise.resolve({ isLiked: !isLikedNow })
    return post(v1('/likes/toggle'), { targetType, targetId })
}

/** 收藏 toggle */
export function toggleFavoriteApi(targetType: number, targetId: number, isFavoritedNow: boolean): Promise<{ isFavorited: boolean }> {
    if (!API_READY.interaction) return Promise.resolve({ isFavorited: !isFavoritedNow })
    return post(v1('/favorites/toggle'), { targetType, targetId })
}

/** 分享上报 */
export function reportShareApi(targetType: number, targetId: number, platform: number): Promise<void> {
    if (!API_READY.interaction) return Promise.resolve()
    return post(v1('/shares'), { targetType, targetId, platform })
}
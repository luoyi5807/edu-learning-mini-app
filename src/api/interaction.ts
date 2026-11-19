import { get, post, v1 } from '@/utils/request'
import { API_READY } from '@/config/apiStatus'
import { BASE_URL } from '@/config/env'
import type { UserTargetItem } from '@/types/user'

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

/* ===================== 我的点赞 / 收藏 / 观看历史（列表页） ===================== */

/** 相对路径补全为后端绝对地址 */
function absCover(p?: string): string {
    if (!p) return ''
    return /^[a-z][a-z\d+\-.]*:\/\//i.test(p) ? p : BASE_URL + (p.startsWith('/') ? '' : '/') + p
}
/** 后端 targetType 字符串 → 前端数值：post→1(文章) course→2(课程) shortVideo→3(短视频) */
function mapTargetType(t?: string): number {
    if (t === 'post') return 1
    if (t === 'shortVideo') return 3
    return 2
}

interface BackendMyInteraction {
    interactionId?: number
    targetType?: string
    targetId: number
    title?: string
    coverUrl?: string
    author?: string
    createTime?: string
}
function normalizeMyInteraction(r: BackendMyInteraction): UserTargetItem {
    return {
        targetType: mapTargetType(r.targetType),
        targetId: r.targetId,
        title: r.title || '',
        cover: absCover(r.coverUrl),
        collectTime: r.createTime || ''
    }
}

/** 我的点赞：GET /api/v1/interaction/myLikes?targetType=（post/course/shortVideo，不传=全部） */
export async function getMyLikesApi(targetType?: string): Promise<UserTargetItem[]> {
    if (!API_READY.myInteractions) return []
    const query: Record<string, any> = { pageNum: 1, pageSize: 50 }
    if (targetType) query.targetType = targetType
    const body: any = await get(v1('/interaction/myLikes'), query)
    const rows: BackendMyInteraction[] = (body && Array.isArray(body.rows)) ? body.rows : []
    return rows.map(normalizeMyInteraction)
}

/** 我的收藏：GET /api/v1/interaction/myFavorites?targetType= */
export async function getMyFavoritesApi(targetType?: string): Promise<UserTargetItem[]> {
    if (!API_READY.myInteractions) return []
    const query: Record<string, any> = { pageNum: 1, pageSize: 50 }
    if (targetType) query.targetType = targetType
    const body: any = await get(v1('/interaction/myFavorites'), query)
    const rows: BackendMyInteraction[] = (body && Array.isArray(body.rows)) ? body.rows : []
    return rows.map(normalizeMyInteraction)
}

interface BackendHistory {
    historyId?: number
    targetType?: string
    targetId: number
    videoId?: number
    title?: string
    coverUrl?: string
    subtitle?: string
    position?: number
    duration?: number
    lastViewTime?: string
    sourceDeleted?: boolean
}
function normalizeHistory(r: BackendHistory): UserTargetItem {
    return {
        targetType: mapTargetType(r.targetType),
        targetId: r.targetId,
        videoId: r.videoId || undefined,
        title: r.title || '',
        cover: absCover(r.coverUrl),
        collectTime: r.lastViewTime || '',
        progressSeconds: r.position || 0,
        duration: r.duration || 0
    }
}

/** 观看历史上报：POST /api/v1/history/report（后端 JSON 出口按 Map<String,String> 绑定，值统一转字符串）
 *  shortVideo/course 带 position（跟随最新，重看覆盖）；post 无进度只记时间；course 另传 videoId 定位小节 */
export function reportHistoryApi(params: {
    targetType: 'shortVideo' | 'course' | 'post'
    targetId: number
    videoId?: number
    position?: number
    duration?: number
}): Promise<any> {
    if (!API_READY.history) return Promise.resolve(null)
    const body: Record<string, string> = { targetType: params.targetType, targetId: String(params.targetId) }
    if (params.videoId) body.videoId = String(params.videoId)
    if (params.position != null) body.position = String(Math.floor(params.position))
    if (params.duration != null) body.duration = String(Math.floor(params.duration))
    return post(v1('/history/report'), body, { showError: false, silentAuth: true })
}

/** 断点查询返回：found=false 表示无历史，从头播 */
export interface HistoryProgressResult {
    found: boolean
    videoId?: number      // 课程：上次观看的小节ID
    position?: number     // 该小节内看到第几秒
    duration?: number
    lastViewTime?: string
}

/** 查断点：GET /api/v1/history/progress?targetType=&targetId=（shortVideo / course） */
export function getHistoryProgressApi(targetType: 'shortVideo' | 'course', targetId: number): Promise<HistoryProgressResult> {
    if (!API_READY.history) return Promise.resolve({ found: false })
    return get(v1('/history/progress'), { targetType, targetId }, { showError: false, silentAuth: true }).then((r: any) => ({
        found: !!(r && r.found),
        videoId: r?.videoId,
        position: r?.position,
        duration: r?.duration,
        lastViewTime: r?.lastViewTime
    }))
}

/** 观看历史：GET /api/v1/history/list?targetType=（短视频/课程/文章混合时间线，带续播进度） */
export async function getHistoryListApi(targetType?: string): Promise<UserTargetItem[]> {
    if (!API_READY.history) return []
    const query: Record<string, any> = { pageNum: 1, pageSize: 50 }
    if (targetType) query.targetType = targetType
    const body: any = await get(v1('/history/list'), query)
    const rows: BackendHistory[] = (body && Array.isArray(body.rows)) ? body.rows : []
    return rows.map(normalizeHistory)
}

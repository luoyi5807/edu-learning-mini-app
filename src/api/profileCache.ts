import { getUserPublicProfileApi } from './user'

export interface MiniProfile { nickName: string; avatar: string }

const cache = new Map<number, MiniProfile>()

/**
 * 后端列表接口（短视频/评论）不返回头像昵称，用 publicProfile 按 userId 补查。
 * 同一用户全会话只请求一次；失败缓存空值不重试。avatar 为相对路径，由调用方拼绝对地址。
 */
export async function fillProfiles<T>(
    rows: T[],
    getUserId: (r: T) => number | undefined,
    apply: (r: T, p: MiniProfile) => void
): Promise<void> {
    const ids = Array.from(new Set(rows.map(getUserId).filter((x): x is number => !!x && !cache.has(x))))
    await Promise.all(ids.map(async (uid) => {
        try {
            const p = await getUserPublicProfileApi(uid)
            cache.set(uid, { nickName: p.nickName || '', avatar: p.avatar || '' })
        } catch (e) {
            cache.set(uid, { nickName: '', avatar: '' })
        }
    }))
    rows.forEach((r) => {
        const uid = getUserId(r)
        const hit = uid ? cache.get(uid) : undefined
        if (hit) apply(r, hit)
    })
}
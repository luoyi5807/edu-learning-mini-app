import { get, v1 } from '@/utils/request'
import { API_READY } from '@/config/apiStatus'
import type { ArticleDto } from '@/types/article'
import { getArticleListApi } from './article'

/** 后端 learning_post 行（搜索/列表返回，正文 content 不在列表 SQL 中） */
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
    userName?: string          // 作者昵称（后端关联 sys_user 查出）
    createTime?: string
}

/** 后端 Post → 前端 ArticleDto：postId→articleId、postTitle→title、userName→authorName、
 *  isFeatured→essence；后端无浏览量/封面/摘要，viewCount 置 0、coverUrl/summary 留空 */
function normalizePost(p: BackendPost): ArticleDto {
    return {
        articleId: p.postId,
        title: p.postTitle || '',
        coverUrl: '',
        authorId: p.userId,
        authorName: p.userName || '用户',
        categoryName: p.categoryName || '',
        categoryId: p.categoryId,
        viewCount: 0,
        likeCount: p.likeCount || 0,
        commentCount: p.commentCount || 0,
        publishTime: p.createTime || '',
        status: 2,
        essence: p.isFeatured === '1' ? 1 : 0
    }
}

/** 热门搜索词：后端无独立热词接口（适配清单 §H：搜索仅 video/post/course），
 *  恒走本地占位，不打下不存在的路径；开关 search 置真也不影响这里。 */
export function getHotWordsApi(size = 10): Promise<string[]> {
    const pool = ['Machine Learning', 'Java', '数据分析', 'Compose', '面试题', 'Python', 'Kotlin', '英语口语']
    return Promise.resolve(pool.slice(0, size))
}

/** 文章/帖子搜索：GET /api/v1/search/post?keyword= —— 只搜标题、固定按点赞数倒序、只返回已发布 */
export async function searchArticlesApi(keyword: string): Promise<ArticleDto[]> {
    const kw = keyword.trim()
    if (!API_READY.search) {
        const list = (await getArticleListApi({ pageSize: 100 })).list
        return kw ? list.filter((a) => a.title.indexOf(kw) >= 0 || (a.summary || '').indexOf(kw) >= 0) : list
    }
    const body: any = await get(v1('/search/post'), { keyword: kw, pageNum: 1, pageSize: 20 })
    const rows: BackendPost[] = (body && Array.isArray(body.rows)) ? body.rows : []
    return rows.map(normalizePost)
}

/** 搜索历史本地持久化 */
const HISTORY_KEY = 'searchHistory'
export function getSearchHistory(): string[] {
    return uni.getStorageSync(HISTORY_KEY) || []
}
export function addSearchHistory(keyword: string) {
    const kw = keyword.trim()
    if (!kw) return
    let list: string[] = getSearchHistory()
    list = [kw].concat(list.filter((k) => k !== kw)).slice(0, 10)
    uni.setStorageSync(HISTORY_KEY, list)
}
export function clearSearchHistory() {
    uni.removeStorageSync(HISTORY_KEY)
}
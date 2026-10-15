import { get, v1 } from '@/utils/request'
import { API_READY } from '@/config/apiStatus'
import type { ArticleDto } from '@/types/article'
import { getArticleListApi } from './article'

/** 热门搜索词（Redis ZSET Top10） */
export function getHotWordsApi(size = 10): Promise<string[]> {
    if (!API_READY.search) return Promise.resolve(['Machine Learning', 'Java', '数据分析', 'Compose', '面试题', 'Python', 'Kotlin', '英语口语'])
    return get(v1('/content/search/hot-words'), { size })
}

/** 文章搜索：content/search?type=1 */
export function searchArticlesApi(keyword: string): Promise<ArticleDto[]> {
    if (!API_READY.search) {
        const kw = keyword.trim()
        return getArticleListApi({}).then((list) => (kw ? list.filter((a) => a.title.indexOf(kw) >= 0 || (a.summary || '').indexOf(kw) >= 0) : list))
    }
    return get(v1('/content/search'), { keyword, type: 1 })
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
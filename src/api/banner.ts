import { get, v1 } from '@/utils/request'
import { API_READY } from '@/config/apiStatus'
import { BASE_URL } from '@/config/env'

/** 轮播图视图模型（imageUrl 已转绝对地址） */
export interface Banner {
    bannerId: number
    categoryId: number
    categoryName: string
    title: string
    imageUrl: string
    courseId: number
    courseName: string
    orderNum: number
}

/** 后端 learning_banner 行（列名已 as 驼峰） */
interface BackendBanner {
    bannerId: number
    categoryId: number
    categoryName?: string
    title: string
    imageUrl?: string
    courseId: number
    courseName?: string
    orderNum?: number
}

/** 相对路径 → 绝对地址（/profile/... 拼 BASE_URL；已是 http(s) 原样返回） */
function absUrl(p?: string): string {
    if (!p) return ''
    if (/^https?:\/\//i.test(p)) return p
    const path = p.startsWith('/') ? p : '/' + p
    return BASE_URL + encodeURI(path)
}

function normalize(b: BackendBanner): Banner {
    return {
        bannerId: b.bannerId,
        categoryId: b.categoryId || 0,
        categoryName: b.categoryName || '',
        title: b.title || '',
        imageUrl: absUrl(b.imageUrl),
        courseId: b.courseId,
        courseName: b.courseName || '',
        orderNum: b.orderNum || 0
    }
}

const mockBanners: Banner[] = [
    { bannerId: 1, categoryId: 0, categoryName: '全部', title: 'Machine Learning 从入门到实战', imageUrl: '', courseId: 1, courseName: 'Machine Learning 从入门到实战', orderNum: 1 },
    { bannerId: 2, categoryId: 0, categoryName: '全部', title: 'Python 编程基础入门', imageUrl: '', courseId: 5, courseName: 'Python 编程基础入门', orderNum: 2 }
]

/**
 * GET /api/v1/banner/list —— 轮播图列表（不分页，返回 {code:0, rows, total}）
 * @param categoryId 类别窗口；不传 = 「全部」窗口（后端 category_id=0）
 */
export async function getBannerListApi(categoryId?: number): Promise<Banner[]> {
    if (!API_READY.banner) return mockBanners.slice()
    const query: Record<string, any> = {}
    if (categoryId && categoryId > 0) query.categoryId = categoryId
    const body: any = await get(v1('/banner/list'), query)
    const rows: BackendBanner[] = (body && Array.isArray(body.rows)) ? body.rows : []
    return rows.map(normalize)
}
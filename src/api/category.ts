import { get, v1 } from '@/utils/request'
import { API_READY } from '@/config/apiStatus'

export interface CategoryNode {
    categoryId: number
    categoryName: string
    iconUrl?: string
    sort?: number
    children?: CategoryNode[]
}

function mockArticleCategories(): CategoryNode[] {
    return [
        { categoryId: 1, categoryName: '技术分享' },
        { categoryId: 2, categoryName: '学习心得' },
        { categoryId: 3, categoryName: '项目实战' },
        { categoryId: 4, categoryName: '求职就业' },
        { categoryId: 5, categoryName: '生活随笔' }
    ]
}

function mockCourseCategories(): CategoryNode[] {
    return [
        { categoryId: 1, categoryName: '艺术' },
        { categoryId: 2, categoryName: '商业' },
        { categoryId: 3, categoryName: 'IT 解决方案' }
    ]
}

/** 后端返回 AjaxResult/TableDataInfo：这里兼容 data 与 rows 两种列表出口 */
async function fetchCategoryList(path: string, query?: Record<string, any>): Promise<CategoryNode[]> {
    const res: any = await get(path, query)
    if (!res) return []
    if (Array.isArray(res.data)) return res.data
    if (Array.isArray(res.rows)) return res.rows
    return []
}

/** 文章分类（C 端接口待后端补 /api/v1/category/list，就绪后翻 categories 开关） */
export function getArticleCategoryTreeApi(): Promise<CategoryNode[]> {
    if (!API_READY.categories) return Promise.resolve(mockArticleCategories())
    return fetchCategoryList(v1('/category/list'), { categoryType: 'article' })
}

/** 课程分类（C 端接口待后端补 /api/v1/category/list，就绪后翻 categories 开关） */
export function getCourseCategoryListApi(): Promise<CategoryNode[]> {
    if (!API_READY.categories) return Promise.resolve(mockCourseCategories())
    return fetchCategoryList(v1('/category/list'), { categoryType: 'course' })
}
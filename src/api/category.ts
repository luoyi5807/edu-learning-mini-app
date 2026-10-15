import { get } from '@/utils/request'
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

/** 后端返回 AjaxResult：{ code, msg, data: CategoryVO[] }，这里取出 data */
async function fetchCategoryList(path: string): Promise<CategoryNode[]> {
    const res: any = await get(path, undefined, { auth: false })
    return (res && Array.isArray(res.data)) ? res.data : []
}

/** GET /article/category/list —— 文章分类（小程序免登录） */
export function getArticleCategoryTreeApi(): Promise<CategoryNode[]> {
    if (!API_READY.categories) return Promise.resolve(mockArticleCategories())
    return fetchCategoryList('/article/category/list')
}

/** GET /course/category/list —— 课程分类（小程序免登录） */
export function getCourseCategoryListApi(): Promise<CategoryNode[]> {
    if (!API_READY.categories) return Promise.resolve(mockCourseCategories())
    return fetchCategoryList('/course/category/list')
}
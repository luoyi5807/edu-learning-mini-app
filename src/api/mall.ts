// src/api/mall.ts
// 积分商城：对接真实接口 /api/v1/shop/*（后端已就绪）。
// 商品/分类/兑换记录来自服务端；兑换成功当场返回兑换码（扣库存+扣积分同一事务）；
// 地址是独立的用户地址簿（后端明确不做配送、兑换不携带地址），仅在确认页展示默认地址。
import { get, post, v1 } from '@/utils/request'
import { BASE_URL } from '@/config/env'
import { API_READY } from '@/config/apiStatus'

/* ===================== 数据模型（对齐后端 camelCase 出参） ===================== */
export interface MallCategory { categoryId: number; categoryName: string; orderNum?: number }

export interface MallProduct {
    productId: number
    categoryId?: number
    categoryName?: string
    productName: string
    coverUrl?: string
    pointsPrice: number
    stock: number
    soldCount?: number
    description?: string
}

/** POST /shop/exchange 响应（字段平铺在响应顶层） */
export interface ExchangeResult {
    orderId: number
    redemptionCode: string
    productId: number
    productName: string
    pointsCost: number
    balance: number
}

/** 兑换记录行（learning_shop_order 快照字段） */
export interface ExchangeRecord {
    orderId: number
    redemptionCode: string
    productId: number
    productName: string
    coverUrl?: string
    pointsCost: number
    createTime: string
}

export interface MallAddress {
    addressId?: number
    receiverName: string
    receiverPhone: string
    detailAddress: string
    isDefault?: boolean
}

/** 相对路径补 BASE_URL，完整地址原样透传（与头像/封面同一规则） */
export function toProductUrl(path?: string): string {
    if (!path) return ''
    return /^[a-z][a-z\d+\-.]*:\/\//i.test(path) ? path : BASE_URL + path
}

/* ===================== 商品与分类 ===================== */

/** GET /api/v1/shop/category/list —— 启用中的商品分类（不分页） */
export async function getMallCategoriesApi(): Promise<MallCategory[]> {
    if (!API_READY.mall) return []
    const body: any = await get(v1('/shop/category/list'), {}, { showError: false })
    return (body && Array.isArray(body.rows)) ? body.rows : []
}

/** GET /api/v1/shop/product/list —— 商品列表（服务端分页 + categoryId/keyword 过滤） */
export async function getMallProductsApi(query: {
    pageNum?: number; pageSize?: number; categoryId?: number; keyword?: string
} = {}): Promise<{ list: MallProduct[]; total: number }> {
    if (!API_READY.mall) return { list: [], total: 0 }
    const params: Record<string, any> = { pageNum: query.pageNum || 1, pageSize: query.pageSize || 100 }
    if (query.categoryId) params.categoryId = query.categoryId
    if (query.keyword) params.keyword = query.keyword
    const body: any = await get(v1('/shop/product/list'), params)
    const list: MallProduct[] = (body && Array.isArray(body.rows)) ? body.rows : []
    list.forEach((p) => { p.coverUrl = toProductUrl(p.coverUrl) })
    return { list, total: Number(body?.total) || list.length }
}

/** GET /api/v1/shop/product/detail —— 商品详情（下架/删除返回 null） */
export async function getMallProductDetailApi(productId: number): Promise<MallProduct | null> {
    if (!API_READY.mall) return null
    const body: any = await get(v1('/shop/product/detail'), { productId: String(productId) }, { showError: false })
    const data = body && body.data
    if (!data) return null
    data.coverUrl = toProductUrl(data.coverUrl)
    return data as MallProduct
}

/* ===================== 兑换 ===================== */

/** POST /api/v1/shop/exchange —— 成功当场返回兑换码与扣减后余额；库存不足/积分不足由 request 统一 toast */
export function exchangeProductApi(productId: number): Promise<ExchangeResult> {
    return post(v1('/shop/exchange'), { productId: String(productId) })
}

/* ===================== 我的兑换记录 ===================== */

/** GET /api/v1/shop/order/list —— 分页、按兑换时间倒序 */
export async function getExchangeRecordsApi(pageNum = 1, pageSize = 20): Promise<{ list: ExchangeRecord[]; total: number }> {
    if (!API_READY.mall) return { list: [], total: 0 }
    const body: any = await get(v1('/shop/order/list'), { pageNum, pageSize })
    const list: ExchangeRecord[] = (body && Array.isArray(body.rows)) ? body.rows : []
    list.forEach((r) => { r.coverUrl = toProductUrl(r.coverUrl) })
    return { list, total: Number(body?.total) || list.length }
}

/* ===================== 收货地址簿 ===================== */

/** GET /api/v1/shop/address/list —— 我的地址（默认在前，不分页） */
export async function getAddressListApi(): Promise<MallAddress[]> {
    if (!API_READY.mall) return []
    const body: any = await get(v1('/shop/address/list'), {}, { showError: false })
    const rows: any[] = (body && Array.isArray(body.rows)) ? body.rows : []
    return rows.map((r) => ({
        addressId: Number(r.addressId),
        receiverName: r.receiverName || '',
        receiverPhone: r.receiverPhone || '',
        detailAddress: r.detailAddress || '',
        isDefault: r.isDefault === '1' || r.isDefault === true || r.isDefault === 'Y'
    }))
}

/** 默认地址（兑换确认页「收货信息」卡片）；没有则返回 null */
export async function getDefaultAddressApi(): Promise<MallAddress | null> {
    const list = await getAddressListApi()
    return list.find((a) => a.isDefault) || list[0] || null
}

/** 有 addressId 走 /address/edit，否则走 /address/add（第一条自动成为默认） */
export function saveAddressApi(a: MallAddress): Promise<any> {
    const data: Record<string, string> = {
        receiverName: a.receiverName,
        receiverPhone: a.receiverPhone,
        detailAddress: a.detailAddress,
        isDefault: a.isDefault ? '1' : '0'
    }
    if (a.addressId) {
        data.addressId = String(a.addressId)
        return post(v1('/shop/address/edit'), data)
    }
    return post(v1('/shop/address/add'), data)
}

/** POST /api/v1/shop/address/remove */
export function removeAddressApi(addressId: number): Promise<any> {
    return post(v1('/shop/address/remove'), { addressId: String(addressId) })
}

/* ===================== 展示工具 ===================== */
export function maskPhone(phone: string): string {
    const p = (phone || '').replace(/\s/g, '')
    if (p.length < 7) return p
    return p.slice(0, 3) + '****' + p.slice(-4)
}

export function totalConsumed(records: ExchangeRecord[]): number {
    return records.reduce((s, r) => s + (r.pointsCost || 0), 0)
}
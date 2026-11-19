import { BASE_URL, SUCCESS_CODE, API_PREFIX } from '@/config/env'

const TOKEN_KEY = 'accessToken' // 与 splash.vue 门禁使用的 key 保持一致

/** RuoYi AjaxResult：code/msg/data 平铺，业务字段(token/user/roles/...)也在顶层 */
export interface ApiResult<T = any> {
    code: number
    msg: string
    data?: T
    [key: string]: any
}

export function getToken(): string {
    return uni.getStorageSync(TOKEN_KEY) || ''
}
export function setToken(token: string) {
    uni.setStorageSync(TOKEN_KEY, token)
}
export function clearToken() {
    uni.removeStorageSync(TOKEN_KEY)
}

/** 拼接 C 端业务接口完整路径（/api/v1/...）；RuoYi 管理端接口不要用这个 */
export function v1(path: string): string {
    return API_PREFIX + (path.startsWith('/') ? path : '/' + path)
}

/** 成功码兼容：RuoYi 后端 code=0；0/200 都视为成功 */
function isSuccessCode(code: number): boolean {
    return code === 0 || code === 200
}

/** 幂等 Token，防止写操作连点重复提交 */
function genIdempotentToken(): string {
    return Date.now().toString(36) + Math.random().toString(36).slice(2, 10)
}

interface RequestOptions {
    url: string
    method?: 'GET' | 'POST' | 'PUT' | 'PATCH' | 'DELETE'
    data?: Record<string, any> | any
    header?: Record<string, string>
    /** 是否自动带 token，默认 true */
    auth?: boolean
    /** 业务/HTTP 错误是否自动 toast，默认 true */
    showError?: boolean
    /** 401 时不弹提示、不跳登录页（观看历史上报/查断点这类后台尽力型请求用），默认 false */
    silentAuth?: boolean
}

function toLogin() {
    uni.reLaunch({ url: '/pages-sub/auth/login' })
}

/** GET 查询参数里 undefined/null/'' 会被拼成 "undefined" 等字符串导致后端参数绑定 500，发送前统一剔除 */
function pruneEmpty(data: any): any {
    if (!data || typeof data !== 'object' || Array.isArray(data)) return data
    const out: Record<string, any> = {}
    Object.keys(data).forEach((k) => {
        const v = data[k]
        if (v !== undefined && v !== null && v !== '') out[k] = v
    })
    return out
}

export function request<T = any>(opts: RequestOptions): Promise<ApiResult<T>> {
    const { url, method = 'GET', data, header = {}, auth = true, showError = true, silentAuth = false } = opts
    const sendData = method === 'GET' ? pruneEmpty(data) : data
    // 调用方传的多为 /api/v1/xxx 相对路径，统一在此拼 BASE_URL；已是完整 http(s) 地址则原样
    const fullUrl = /^https?:\/\//i.test(url) ? url : BASE_URL + (url.startsWith('/') ? url : '/' + url)

    return new Promise<ApiResult<T>>((resolve, reject) => {
        const headers: Record<string, string> = { 'Content-Type': 'application/json', ...header }
        if (auth) {
            const token = getToken()
            if (token) headers['Authorization'] = token.startsWith('Bearer ') ? token : 'Bearer ' + token
        }
        if (method === 'POST' || method === 'PUT') {
            headers['X-Idempotent-Token'] = genIdempotentToken()
        }

        uni.request({
            url: fullUrl,
            method: method as any,
            data: sendData,
            timeout: 15000,
            header: headers,
            success: (res: any) => {
                const body: any = res
                // HTTP 401：Token 缺失/失效（后端无刷新机制），清理本地并跳登录重登
                if (body.statusCode === 401) {
                    clearToken()
                    if (!silentAuth) {
                        if (showError) uni.showToast({ title: '登录已过期，请重新登录', icon: 'none' })
                        toLogin()
                    }
                    reject(new Error('HTTP 401'))
                    return
                }
                if (body.statusCode !== 200) {
                    if (showError) uni.showToast({ title: `请求失败(${body.statusCode})`, icon: 'none' })
                    reject(new Error('HTTP ' + body.statusCode))
                    return
                }

                const r = body.data as ApiResult<T>
                // 业务层：兼容契约 code=0 与 RuoYi code=200，其余视为失败
                if (r && typeof r.code !== 'undefined' && !isSuccessCode(r.code)) {
                    if (r.code === 401) {
                        clearToken()
                        if (!silentAuth) {
                            if (showError) uni.showToast({ title: r.msg || r.message || '登录已过期', icon: 'none' })
                            toLogin()
                        }
                    } else if (showError) {
                        uni.showToast({ title: r.msg || r.message || '操作失败', icon: 'none' })
                    }
                    reject(r)
                    return
                }
                // 归一化：契约用 message、RuoYi 用 msg，补齐双字段，页面读取任一个都可用
                if (r) {
                    if (typeof r.message === 'undefined' && typeof r.msg !== 'undefined') r.message = r.msg
                    if (typeof r.msg === 'undefined' && typeof r.message !== 'undefined') r.msg = r.message
                }
                resolve(r)
            },
            fail: (err: any) => {
                if (showError) uni.showToast({ title: '网络请求失败', icon: 'none' })
                reject(err)
            }
        })
    })
}

export const get = <T = any>(url: string, data?: any, opt?: Partial<RequestOptions>) =>
    request<T>({ url, method: 'GET', data, ...opt })
export const post = <T = any>(url: string, data?: any, opt?: Partial<RequestOptions>) =>
    request<T>({ url, method: 'POST', data, ...opt })
export const put = <T = any>(url: string, data?: any, opt?: Partial<RequestOptions>) =>
    request<T>({ url, method: 'PUT', data, ...opt })
export const patch = <T = any>(url: string, data?: any, opt?: Partial<RequestOptions>) =>
    request<T>({ url, method: 'PATCH', data, ...opt })
export const del = <T = any>(url: string, data?: any, opt?: Partial<RequestOptions>) =>
    request<T>({ url, method: 'DELETE', data, ...opt })
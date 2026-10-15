import { BASE_URL, SUCCESS_CODE, API_PREFIX } from '@/config/env'

const TOKEN_KEY = 'accessToken' // 与 splash.vue 门禁使用的 key 保持一致
const REFRESH_KEY = 'refreshToken'

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

/** 成功码兼容：契约 code=0，RuoYi code=200，两者都视为成功 */
function isSuccessCode(code: number): boolean {
    return code === 0 || code === SUCCESS_CODE
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
    /** 内部标记：401 后是否已尝试刷新重放，避免死循环 */
    __retried?: boolean
}

function toLogin() {
    uni.reLaunch({ url: '/pages-sub/auth/login' })
}

/** 用 refreshToken 换取新 accessToken（静默，不带业务 toast） */
function doRefresh(): Promise<boolean> {
    const rt = uni.getStorageSync(REFRESH_KEY)
    if (!rt) return Promise.resolve(false)
    return new Promise<boolean>((resolve) => {
        uni.request({
            url: BASE_URL + '/api/user/refreshToken',
            method: 'POST',
            header: {
                'Content-Type': 'application/json',
                Authorization: rt.startsWith('Bearer ') ? rt : 'Bearer ' + rt
            },
            timeout: 15000,
            success: (res: any) => {
                const body = res && res.data
                if (body && (body.code === 0 || body.code === 200) && body.data && body.data.accessToken) {
                    let t: string = body.data.accessToken
                    if (t.startsWith('Bearer ')) t = t.slice(7)
                    setToken(t)
                    resolve(true)
                } else {
                    resolve(false)
                }
            },
            fail: () => resolve(false)
        })
    })
}

export function request<T = any>(opts: RequestOptions): Promise<ApiResult<T>> {
    const { url, method = 'GET', data, header = {}, auth = true, showError = true } = opts

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
            url: BASE_URL + url,
            method: method as any,
            data,
            header: headers,
            timeout: 15000,
            success: (res) => {
                // HTTP 401：先尝试静默刷新一次并重放，失败才跳登录
                if (res.statusCode === 401) {
                    if (!opts.__retried && auth) {
                        doRefresh().then((ok) => {
                            if (ok) {
                                request<T>({ ...opts, __retried: true }).then(resolve).catch(reject)
                            } else {
                                clearToken()
                                if (showError) uni.showToast({ title: '登录已过期，请重新登录', icon: 'none' })
                                toLogin()
                                reject(new Error('HTTP 401'))
                            }
                        })
                        return
                    }
                    clearToken()
                    if (showError) uni.showToast({ title: '登录已过期，请重新登录', icon: 'none' })
                    toLogin()
                    reject(new Error('HTTP 401'))
                    return
                }
                if (res.statusCode !== 200) {
                    if (showError) uni.showToast({ title: `请求失败(${res.statusCode})`, icon: 'none' })
                    reject(new Error('HTTP ' + res.statusCode))
                    return
                }

                const body = res.data as ApiResult<T>
                // 业务层：兼容契约 code=0 与 RuoYi code=200，其余视为失败
                if (body && typeof body.code !== 'undefined' && !isSuccessCode(body.code)) {
                    if (body.code === 401) {
                        clearToken()
                        if (showError) uni.showToast({ title: body.msg || body.message || '登录已过期', icon: 'none' })
                        toLogin()
                    } else if (showError) {
                        uni.showToast({ title: body.msg || body.message || '操作失败', icon: 'none' })
                    }
                    reject(body)
                    return
                }
                // 归一化：契约用 message、RuoYi 用 msg，补齐双字段，页面读取任一个都可用
                if (body) {
                    if (typeof body.message === 'undefined' && typeof body.msg !== 'undefined') body.message = body.msg
                    if (typeof body.msg === 'undefined' && typeof body.message !== 'undefined') body.msg = body.message
                }
                resolve(body)
            },
            fail: (err) => {
                if (showError) uni.showToast({ title: '网络异常，请确认后端服务已启动', icon: 'none' })
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
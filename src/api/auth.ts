import { get, post } from '@/utils/request'

// C 端认证接口前缀（learning-user，独立于若依后台 sys_user）
const USER_API = '/api/user'

/** 兼容旧代码：api/user.ts 仍以此类型标注后台资料接口返回 */
export interface SysUser {
    userId: number
    userName: string
    nickName: string
    avatar: string
    email?: string
    phonenumber?: string
    sex?: string
    remark?: string
    [key: string]: any
}

export interface LoginParams {
    username: string
    password: string
    code: string
    uuid: string
}

export interface RegisterParams {
    username: string
    password: string
    nickname: string
    code: string
    uuid: string
}

export interface CaptchaResult {
    captchaEnabled: boolean
    uuid?: string
    img?: string
}

/** C 端登录用户信息（LoginVO：无 getInfo，登录即返回） */
export interface AppUserVO {
    userId: number
    username: string
    nickname: string
    avatar: string
}

/** 登录响应：token / refreshToken 后端已自带 "Bearer " 前缀 */
export interface LoginResult extends AppUserVO {
    token: string
    refreshToken: string
}

/** GET /captchaImage —— 复用若依图形验证码（Redis key 与 C 端校验一致；后端需保证 captchaEnabled=true） */
export function fetchCaptcha() {
    return get<CaptchaResult>('/captchaImage', undefined, { auth: false })
}

/** POST /api/user/login → AjaxResult.data = LoginResult */
export function loginApi(params: LoginParams) {
    return post<LoginResult>(`${USER_API}/login`, params, { auth: false })
}

/** POST /api/user/register（nickname 必填） */
export function registerApi(params: RegisterParams) {
    return post<{ userId: number; username: string }>(`${USER_API}/register`, params, { auth: false })
}

/** POST /api/user/logout */
export function logoutApi() {
    return post(`${USER_API}/logout`, undefined, { showError: false })
}

/** POST /api/user/refreshToken —— Header 传 refreshToken，换新 accessToken */
export function refreshTokenApi(refreshToken: string) {
    return post<{ accessToken: string }>(`${USER_API}/refreshToken`, undefined, {
        auth: false,
        showError: false,
        header: { Authorization: refreshToken.startsWith('Bearer ') ? refreshToken : 'Bearer ' + refreshToken }
    })
}
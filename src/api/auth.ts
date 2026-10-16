import { get, post } from '@/utils/request'

// C 端认证接口：RuoYi 复用 sys_user，手机号登录，前缀 /api/v1
const AUTH_API = '/api/v1'

export interface LoginParams {
    phone: string
    password: string
}

export interface RegisterParams {
    phone: string
    password: string
    confirmPassword: string
}

/** 登录响应：业务字段平铺在顶层；token 为裸 UUID(无 Bearer)，无 refreshToken */
export interface LoginResult {
    code: number
    msg: string
    token: string
    expireTime: string
    userId: number
    phonenumber: string
    userName: string
    roles: string[]
    [key: string]: any
}

/** POST /api/v1/login —— { phone, password } */
export function loginApi(params: LoginParams) {
    return post<LoginResult>(`${AUTH_API}/login`, params, { auth: false })
}

/** POST /api/v1/register —— { phone, password, confirmPassword }（需 sys.account.registerUser=true） */
export function registerApi(params: RegisterParams) {
    return post(`${AUTH_API}/register`, params, { auth: false })
}

/** POST /api/v1/logout —— 幂等吊销当前 token */
export function logoutApi() {
    return post(`${AUTH_API}/logout`, undefined, { showError: false })
}

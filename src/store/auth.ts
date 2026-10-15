import { reactive } from 'vue'
import { getToken, setToken, clearToken } from '@/utils/request'
import { loginApi, logoutApi, type LoginParams } from '@/api/auth'

const REFRESH_KEY = 'refreshToken'
const USER_KEY = 'appUser'

/** 统一的用户视图模型：兼容资料页读取的 nickName/userName/sex/remark 等字段 */
export interface AuthUser {
    userId: number
    userName: string   // = C 端 username
    nickName: string   // = C 端 nickname
    avatar: string
    sex: string        // C 端暂未提供，占位 '2'（未知）
    remark: string     // C 端个人简介待后端 profile 接口，占位 ''
}

/** 后端 token 自带 "Bearer " 前缀，存储前统一剥离，发送时由 request 拼接 */
function bare(t: string): string {
    return t && t.startsWith('Bearer ') ? t.slice(7) : t
}

function readCacheUser(): AuthUser | null {
    const raw = uni.getStorageSync(USER_KEY)
    return raw ? (JSON.parse(raw) as AuthUser) : null
}

const state = reactive({
    token: getToken() as string,
    refreshToken: (uni.getStorageSync(REFRESH_KEY) || '') as string,
    user: readCacheUser() as AuthUser | null
})

function persistUser(u: AuthUser | null) {
    state.user = u
    if (u) uni.setStorageSync(USER_KEY, JSON.stringify(u))
    else uni.removeStorageSync(USER_KEY)
}

async function login(params: LoginParams) {
    const res: any = await loginApi(params)
    const d = res && res.data
    if (!d || !d.token) throw new Error('登录响应未返回 token')
    const access = bare(d.token)
    const refresh = bare(d.refreshToken)
    setToken(access)
    uni.setStorageSync(REFRESH_KEY, refresh)
    state.token = access
    state.refreshToken = refresh
    persistUser({
        userId: d.userId,
        userName: d.username || '',
        nickName: d.nickname || '',
        avatar: d.avatar || '',
        sex: '2',
        remark: ''
    })
    return state.user
}

/** 兼容旧调用（ProfilePanel / edit-profile）：C 端无 getInfo，直接返回登录时缓存的资料 */
async function fetchUserInfo(): Promise<AuthUser | null> {
    if (!state.user) state.user = readCacheUser()
    return state.user
}

/** 资料页保存后可回填缓存 */
function setUser(patch: Partial<AuthUser>) {
    const merged = { ...(state.user as AuthUser), ...patch } as AuthUser
    persistUser(merged)
}

async function logout() {
    try { await logoutApi() } catch (e) { /* 忽略网络错误，本地照常清理 */ }
    reset()
}

function reset() {
    clearToken()
    uni.removeStorageSync(REFRESH_KEY)
    state.token = ''
    state.refreshToken = ''
    persistUser(null)
}

export function useAuthStore() {
    return { state, login, logout, reset, fetchUserInfo, setUser }
}
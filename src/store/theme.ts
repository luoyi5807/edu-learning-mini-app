import { reactive, computed } from 'vue'

export type ThemeMode = 'light' | 'dark' | 'system'
const VALID: ThemeMode[] = ['light', 'dark', 'system']

const state = reactive({
    mode: 'system' as ThemeMode,
    systemDark: false
})

function readStoredMode(): ThemeMode {
    const saved = uni.getStorageSync('themeMode')
    return VALID.indexOf(saved) >= 0 ? saved : 'system'
}

function detectSystem() {
    try {
        const info: any = uni.getSystemInfoSync()
        state.systemDark = info && info.theme === 'dark'
    } catch (e) {}
}

/** App.vue onLaunch 调一次 */
export function initTheme() {
    state.mode = readStoredMode()
    detectSystem()
    // #ifdef MP-WEIXIN
    const u = uni as any
    if (typeof u.onThemeChange === 'function') {
        u.onThemeChange((res: any) => { state.systemDark = res && res.theme === 'dark' })
    }
    // #endif
}

export const themeMode = computed<ThemeMode>(() => state.mode)

/** 当前是否深色（含跟随系统） */
export const resolvedDark = computed<boolean>(() =>
    state.mode === 'dark' || (state.mode === 'system' && state.systemDark)
)

/** 页面根节点绑定：.theme-dark/.theme-light 覆盖全局 CSS 变量 */
export const themeClass = computed<string>(() => (resolvedDark.value ? 'theme-dark' : 'theme-light'))

export function setThemeMode(mode: ThemeMode) {
    if (VALID.indexOf(mode) < 0) return
    state.mode = mode
    uni.setStorageSync('themeMode', mode)
    detectSystem()
}
import { themeClass, themeMode, resolvedDark, setThemeMode } from '@/store/theme'

/** 页面用法：根 view 绑 :class="themeClass" 即接入换肤 */
export function useTheme() {
    return { themeClass, themeMode, resolvedDark, setThemeMode }
}
// src/composables/useNotification.ts
import { ref, computed } from 'vue'
import { getUnreadCountApi } from '@/api/notification'

/**
 * 通知未读状态（模块级共享）
 * 首页铃铛 / 个人主页铃铛 / blog-home 铃铛 / 通知页读取同一份数据，
 * 任一处 refreshUnread() 后所有红点同步更新；未读为 0 时红点自动消失。
 */
const unreadCount = ref<number>(0)
const hasUnread = computed<boolean>(() => unreadCount.value > 0)

export function useNotification() {
    /** 拉取未读数刷新红点（进页 / 返回时调用） */
    async function refreshUnread() {
        try {
            const res = await getUnreadCountApi()
            unreadCount.value = res.count || 0
        } catch (e) {
            unreadCount.value = 0
        }
    }

    return { unreadCount, hasUnread, refreshUnread }
}
// src/composables/useRewardedAd.ts
import { AD_REWARDED_VIDEO } from '@/config/env'

/**
 * 调起微信激励视频；完整看完 resolve(true)，中途关闭/失败 resolve(false)。
 * @param userId 学习用户ID：透传给微信 SSV，回调时原样带回给后端认人（务必传真实 userId）
 * @param rewardAmount 展示用奖励值（真实加分以服务端 AD_REWARD_POINTS 为准，不信此值）
 */
export function showRewardedAd(userId?: string | number, rewardAmount = 10): Promise<boolean> {
    return new Promise((resolve) => {
        // #ifdef MP-WEIXIN
        if (!AD_REWARDED_VIDEO) { resolve(false); return }
        const ad: any = wx.createRewardedVideoAd({ adUnitId: AD_REWARDED_VIDEO })

        // 关键：把 userId 塞进服务端校验数据，微信回调时带回，后端据此发奖
        if (userId != null && typeof ad.setServerSideVerificationData === 'function') {
            ad.setServerSideVerificationData({
                userId: String(userId),
                rewardItem: '积分',
                rewardAmount,
                customData: `${Date.now()}`
            })
        }

        const onClose = (res: any) => {
            ad.offClose(onClose)
            resolve(!!(res && res.isEnded))
        }
        ad.onError(() => { ad.offClose(onClose); resolve(false) })
        ad.onClose(onClose)
        ad.load().then(() => ad.show()).catch(() => ad.show())
        // #endif
        // #ifndef MP-WEIXIN
        resolve(false)
        // #endif
    })
}

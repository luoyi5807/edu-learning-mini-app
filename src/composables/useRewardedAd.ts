// src/composables/useRewardedAd.ts
import { AD_REWARDED_VIDEO, AD_REWARDED_PROVIDER, AD_PID_REWARDED, AD_SIMULATE } from '@/config/env'

/**
 * 调起激励视频；完整看完 resolve(true)，中途关闭/失败 resolve(false)。
 * 优先级：真实广告位 ID > 模拟模式（AD_SIMULATE）。
 * @param userId 学习用户ID：透传给微信 SSV，回调时原样带回给后端认人（务必传真实 userId）
 * @param rewardAmount 展示用奖励值（真实加分以服务端 AD_REWARD_POINTS 为准，不信此值）
 */
export function showRewardedAd(userId?: string | number, rewardAmount = 10): Promise<boolean> {
    return new Promise((resolve) => {
        // #ifdef APP-PLUS
        if (AD_REWARDED_PROVIDER === 'uniad' && AD_PID_REWARDED) {
            const ad: any = uni.createRewardedVideoAd({ adpid: AD_PID_REWARDED })
            const onClose = (res: any) => { ad.offClose(onClose); resolve(!!(res && res.isEnded)) }
            ad.onError(() => { ad.offClose(onClose); resolve(false) })
            ad.onClose(onClose)
            ad.load().then(() => ad.show()).catch(() => ad.show())
            return
        }
        resolve(false)
        // #endif
        // #ifdef MP-WEIXIN
        if (AD_SIMULATE) {
            uni.showModal({
                title: '模拟广告',
                content: `当前未配置真实广告位，模拟观看 ${rewardAmount} 积分激励视频？`,
                confirmText: '看完了',
                cancelText: '取消',
                success: (m) => resolve(!!m.confirm)
            })
            return
        }
        if (AD_REWARDED_PROVIDER === 'wx' && AD_REWARDED_VIDEO) {
            const ad: any = wx.createRewardedVideoAd({ adUnitId: AD_REWARDED_VIDEO })
            if (userId != null && typeof ad.setServerSideVerificationData === 'function') {
                ad.setServerSideVerificationData({
                    userId: String(userId),
                    rewardItem: '积分',
                    rewardAmount,
                    customData: `${Date.now()}`
                })
            }
            const onClose = (res: any) => { ad.offClose(onClose); resolve(!!(res && res.isEnded)) }
            ad.onError(() => { ad.offClose(onClose); resolve(false) })
            ad.onClose(onClose)
            ad.load().then(() => ad.show()).catch(() => ad.show())
            return
        }
        resolve(false)
        // #endif
        // #ifndef APP-PLUS || MP-WEIXIN
        resolve(false)
        // #endif
    })
}

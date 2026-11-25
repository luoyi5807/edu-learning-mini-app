// 后端 RuoYi 服务地址 —— 联调只需改这里
// ⚠️ RuoYi 默认 server.port=80，是 :80（不是 8080！）
// ⚠️ 微信开发者工具模拟器：http://127.0.0.1 可用，但必须勾选【不校验合法域名、web-view、TLS 以及 HTTPS 证书】
// ⚠️ 真机预览：127.0.0.1 无效，需改成电脑局域网 IP，例如 http://192.168.1.100
// 新服务器后端（陈怡酉 2026-11-18 提供，注意端口是 1000）
export const BASE_URL = 'http://192.168.100.3:1000'

// RuoYi AjaxResult 成功码：Type.SUCCESS = 0（不是 200）
export const SUCCESS_CODE = 0

// C 端业务接口前缀：/api/v1（对齐适配清单）
export const API_PREFIX = '/api/v1'

// ===== 微信流量主广告位 ID（在微信公众平台「流量主 → 广告位管理」创建后填入）=====
// 留空 = 不展示真实广告（组件不渲染），本地/未开通时安全
export const AD_BANNER_COMMUNITY = ''   // 社区首页 Banner，形如 'adunit-xxxxxxxx'
export const AD_BANNER_HOME = ''         // 首页课程 Tab Banner
export const AD_BANNER_COURSE = ''      // 课程详情 Banner
export const AD_BANNER_ARTICLE = ''     // 文章详情 Banner
export const AD_BANNER_FEED = ''        // 短视频信息流广告位
export const AD_REWARDED_VIDEO = ''     // 激励视频（看广告得积分）

// 激励视频来源：'wx' = 微信原生流量主(adUnitId)；'uniad' = uni-ad(adpid)
// 有自建后端做 SSV 回调 → 用 'wx'；要 App+小程序统一聚合 → 用 'uniad'
export const AD_REWARDED_PROVIDER = 'uniad'   // 'wx' | 'uniad'
export const AD_PID_REWARDED = '1819020042'   // uni-ad 激励视频 adpid
export const AD_PID_BANNER = ''               // uni-ad Banner 类 adpid（待填）

// 开发/演示模式：AD_SIMULATE=true 时，Banner 渲染高仿真广告卡、激励视频弹全屏倒计时播放层，
// 看完仍走真实上报接口发积分，用于「看起来已正式接入」的演示/答辩。拿到真实 adpid 后置 false 即切回真广告。
export const AD_SIMULATE = true

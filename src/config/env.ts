// 后端 RuoYi 服务地址 —— 联调只需改这里
// ⚠️ RuoYi 默认 server.port=80，是 :80（不是 8080！）
// ⚠️ 微信开发者工具模拟器：http://127.0.0.1 可用，但必须勾选【不校验合法域名、web-view、TLS 以及 HTTPS 证书】
// ⚠️ 真机预览：127.0.0.1 无效，需改成电脑局域网 IP，例如 http://192.168.1.100
export const BASE_URL = 'http://127.0.0.1:80'

// RuoYi AjaxResult 成功码：Type.SUCCESS = 0（不是 200）
export const SUCCESS_CODE = 0

// C 端业务接口前缀：/api/v1（对齐适配清单）
export const API_PREFIX = '/api/v1'

// ===== 微信流量主广告位 ID（在微信公众平台「流量主 → 广告位管理」创建后填入）=====
// 留空 = 不展示真实广告（组件不渲染），本地/未开通时安全
export const AD_BANNER_COMMUNITY = ''   // 社区首页 Banner，形如 'adunit-xxxxxxxx'
export const AD_BANNER_HOME = ''        // 首页 Banner
export const AD_REWARDED_VIDEO = ''     // 激励视频（看广告得积分）

// 激励视频来源：'wx' = 微信原生流量主(adUnitId)；'uniad' = uni-ad(adpid)
// 有自建后端做 SSV 回调 → 用 'wx'；要 App+小程序统一聚合 → 用 'uniad'
export const AD_REWARDED_PROVIDER: 'wx' | 'uniad' = 'wx'
export const AD_PID_REWARDED = ''       // 走 uni-ad 时填 adpid，例如 '1507xxxxxx'

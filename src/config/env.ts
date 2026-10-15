// 后端 RuoYi 服务地址 —— 联调只需改这里
// ⚠️ 微信开发者工具模拟器：http://127.0.0.1:8080 可用，但必须在
//    工具「详情 → 本地设置」勾选【不校验合法域名、web-view（业务域名）、TLS 版本以及 HTTPS 证书】。
// ⚠️ 真机预览：127.0.0.1 无效，需改成电脑局域网 IP，例如 http://192.168.1.100:8080。
export const BASE_URL = 'http://127.0.0.1:8080'

// RuoYi 约定：登录 token 在响应顶层字段 token；业务成功码 200
export const SUCCESS_CODE = 200

// C 端业务接口前缀：对齐《参考安卓》第六章 /api/v1 契约（见适配清单冲突#3）
// 注意：RuoYi 现有管理端接口（/login、/getInfo、/system/*、/common/*）不带此前缀
export const API_PREFIX = '/api/v1'

// 后端 RuoYi 服务地址 —— 联调只需改这里
// ⚠️ RuoYi 默认 server.port=80，是 :80（不是 8080！）
// ⚠️ 微信开发者工具模拟器：http://127.0.0.1 可用，但必须勾选【不校验合法域名、web-view、TLS 以及 HTTPS 证书】
// ⚠️ 真机预览：127.0.0.1 无效，需改成电脑局域网 IP，例如 http://192.168.1.100
export const BASE_URL = 'http://127.0.0.1:80'

// RuoYi AjaxResult 成功码：Type.SUCCESS = 0（不是 200）
export const SUCCESS_CODE = 0

// C 端业务接口前缀：/api/v1（对齐适配清单）
export const API_PREFIX = '/api/v1'

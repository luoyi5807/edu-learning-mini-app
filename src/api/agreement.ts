// src/api/agreement.ts
/**
 * 平台协议 API（后端 learning-user 模块 ApiV1AgreementController）
 * 免登录白名单接口，未登录也能查看协议。
 * - GET /api/v1/agreement/list          已启用协议列表 {rows, total}
 * - GET /api/v1/agreement/{type}        协议详情 {code:0, data:{title, content(HTML), updateTime...}}
 * type: user_agreement | privacy_policy | about_us
 */
import { get, v1 } from '@/utils/request'

export interface AgreementItem {
  agreementId: number
  agreementType: string   // user_agreement / privacy_policy / about_us
  typeLabel: string       // 后端翻译好的类型中文名
  title: string
  orderNum: number
  status: string
  updateTime?: string
}

export interface AgreementDetail extends AgreementItem {
  content: string          // HTML 富文本
}

/** 协议类型 → 页面默认标题（后端未配置时用） */
export const AGREEMENT_DEFAULT_TITLE: Record<string, string> = {
  user_agreement: '用户协议',
  privacy_policy: '隐私政策',
  about_us: '关于我们'
}

/** 已启用的协议列表（管理端后台配置，C 端一般仅用于校验某类型是否存在） */
export async function getAgreementListApi(): Promise<AgreementItem[]> {
  const body: any = await get(v1('/agreement/list'), {}, { showError: false })
  return (body && body.rows) || []
}

/** 按类型取协议详情；后端 data 可能直接平铺，做双路兜底 */
export async function getAgreementDetailApi(type: string): Promise<AgreementDetail | null> {
  const body: any = await get(v1('/agreement/' + type), {}, { showError: false })
  const d = (body && body.data) ? body.data : body
  if (!d || (!d.content && !d.title)) return null
  return d as AgreementDetail
}
export interface AgentSession {
    sessionId: number
    title: string
    rounds: number
    /** 展示用时间，形如 "11-24 00:09" */
    timeText: string
}

/** 后端 AI 未接入前，历史抽屉用本地 mock（对齐设计稿 02-历史对话抽屉） */
export const MOCK_AGENT_SESSIONS: AgentSession[] = [
    { sessionId: 1, title: '我最近 7 天学了多久？', rounds: 2, timeText: '11-24 00:09' },
    { sessionId: 2, title: '把这门课做成一份 PPT', rounds: 1, timeText: '11-23 23:36' },
    { sessionId: 3, title: '我最近 7 天学了多久？', rounds: 1, timeText: '11-23 23:22' },
    { sessionId: 4, title: '最近 7 天每门课学多久？', rounds: 1, timeText: '11-23 23:18' },
    { sessionId: 5, title: '总结一门课，列出重点', rounds: 4, timeText: '11-23 22:34' }
]

/** 能力标签（输入栏下方一行，单选）：key 供后续弹层/接口区分能力 */
export interface AgentCapability { key: string; label: string; icon: string }
export const AGENT_CAPABILITIES: AgentCapability[] = [
    { key: 'summary', label: '课程摘要', icon: '📄' },
    { key: 'qa', label: '课程问答', icon: '❓' },
    { key: 'video', label: '视频总结', icon: '🎬' },
    { key: 'ppt', label: '生成PPT', icon: '🗂' },
    { key: 'sql', label: '查数据', icon: '📊' }
]

/** 空状态「试试这样问」建议卡：点击填入输入框并预选对应能力 */
export interface AgentSuggestion { text: string; icon: string; tone: 'blue' | 'teal'; capability: string }
export const AGENT_SUGGESTIONS: AgentSuggestion[] = [
    { text: '总结一门课，列出重点', icon: '📑', tone: 'blue', capability: 'summary' },
    { text: '这条视频讲了什么？', icon: '🎞', tone: 'teal', capability: 'video' },
    { text: '我最近 7 天学了多久？', icon: '🗄', tone: 'teal', capability: 'sql' },
    { text: '把这门课做成一份 PPT', icon: '🗂', tone: 'teal', capability: 'ppt' }
]

/** 选择课程弹层数据（后端 AI 未接入前用本地 mock；desc 为课程简介一行） */
export interface AgentCourse { courseId: number; title: string; desc: string }
export const AGENT_COURSES: AgentCourse[] = [
    { courseId: 1, title: '深入理解 Redis', desc: '缓存原理、集群与高可用实践' },
    { courseId: 2, title: 'Java 从入门到实战', desc: '环境搭建、语法、面向对象与集合框架' },
    { courseId: 3, title: 'MySQL 性能优化实战', desc: '索引、执行计划与慢查询治理' }
]

/* ===== 对话消息流（图7 摘要卡 / 图8 PPT 卡；后端 AI 未接入前用本地 mock）===== */
export type AgentMsgRole = 'user' | 'agent'
export type AgentAnswerKind = 'summary' | 'ppt' | 'text' | 'sql' | 'answer'

export interface AgentSummaryBullet { label: string; text: string }
export interface AgentSummaryPayload {
    heading: string
    intro: string
    bullets: AgentSummaryBullet[]
    sources: string[]
    footnote: string
}
export interface AgentPptSlide { title: string; subtitle: string }
export interface AgentPptPayload {
    deckTitle: string
    slides: AgentPptSlide[]
    footnote: string
    /** 后端生成的 PPTX 下载地址（OSS） */
    fileUrl?: string
    fileName?: string
}
/** RAG 引用来源（后端 refs 元素：{course, chapter, ...}） */
export interface AgentRefItem { course?: string; chapter?: string; lesson?: string }
/** SQL 查数结果（后端 /agent/sql/ask：{answer, sql, rows, rowCount, error}） */
export interface AgentSqlPayload { answer: string; sql?: string; rows: any[]; rowCount?: number; error?: boolean }
/** 加强版回答卡（图433）：答案 + 依据要点 + 来源章节卡（带时间戳）+ 脚注 */
export interface AgentAnswerSource { title: string; sub?: string; time?: string }
export interface AgentAnswerBullet { label: string; text: string }
export interface AgentAnswerPayload { answer: string; bullets: AgentAnswerBullet[]; sources: AgentAnswerSource[]; footnote?: string }
export interface AgentMessage {
    id: number
    role: AgentMsgRole
    text?: string
    kind?: AgentAnswerKind
    capabilityLabel?: string
    courseTitle?: string
    summary?: AgentSummaryPayload
    ppt?: AgentPptPayload
    sql?: AgentSqlPayload
    answer?: AgentAnswerPayload
    refs?: AgentRefItem[]
    actions?: string[]
    /** 流式回答中：末尾显示光标 */
    streaming?: boolean
}

export function capabilityLabel(key: string): string {
    const c = AGENT_CAPABILITIES.find((x) => x.key === key)
    return c ? c.label : '课程问答'
}

let _mid = 1000
const nextId = () => ++_mid

export function makeUserMsg(text: string): AgentMessage {
    return { id: nextId(), role: 'user', text }
}

export function makeSummaryMsg(courseTitle: string): AgentMessage {
    return {
        id: nextId(), role: 'agent', kind: 'summary',
        capabilityLabel: '课程摘要', courseTitle,
        summary: {
            heading: `《${courseTitle}》学习摘要`,
            intro: '课程先讲清核心概念与适用场景，再通过示例串起完整链路，最后给出常见故障的排查顺序。适合已经上手、想系统补齐知识点的同学。',
            bullets: [
                { label: '核心概念', text: '先分清各组件职责与边界，避免只记命令。' },
                { label: '学习路径', text: '概念 → 单机示例 → 集群与容错 → 性能调优。' },
                { label: '易错点', text: '配置项默认值、异常分支与降级策略最容易被忽略。' },
                { label: '建议练习', text: '挑一条失败链路，从日志反推原因并复现。' }
            ],
            sources: ['第 1 章 · 课程目录与章节结构', '第 2 章 · 示例链路与关键配置', '第 3 章 · 常见故障与排查顺序'],
            footnote: '演示内容：每条结论都会标注对应章节。'
        },
        actions: ['regenerate', 'toPpt']
    }
}

export function makePptMsg(courseTitle: string): AgentMessage {
    return {
        id: nextId(), role: 'agent', kind: 'ppt',
        capabilityLabel: '生成PPT', courseTitle,
        ppt: {
            deckTitle: `《${courseTitle}》课程汇报`,
            slides: [
                { title: courseTitle, subtitle: '学习总结 · 2026-11' },
                { title: '核心概念与边界', subtitle: '组件职责 · 适用场景' },
                { title: '学习路径', subtitle: '概念 → 示例 → 集群 → 调优' },
                { title: '易错点梳理', subtitle: '默认值 · 异常分支 · 降级' },
                { title: '练习与排查', subtitle: '从日志反推原因并复现' }
            ],
            footnote: '共 5 页 · 可全屏演示，也能导出 PDF 分享。'
        },
        actions: ['regenerate']
    }
}

export function makeTextMsg(label: string, courseTitle: string, text: string, refs?: AgentRefItem[]): AgentMessage {
    return { id: nextId(), role: 'agent', kind: 'text', capabilityLabel: label, courseTitle, text, refs, actions: ['regenerate'] }
}

/** 加强版回答卡（后端未就绪时的演示数据，对齐设计稿 433） */
export function makeAnswerMsg(courseTitle: string): AgentMessage {
    return {
        id: nextId(), role: 'agent', kind: 'answer',
        capabilityLabel: '课程问答', courseTitle,
        answer: {
            answer: '课程把知识点拆成「概念—示例—排错」三段：先明确每个组件解决什么问题，再用最小示例验证，最后按排查顺序处理异常。重点不是背结论，而是能说清每一步为什么这样做。',
            bullets: [
                { label: '依据', text: '第 1 章 核心概念与适用场景' },
                { label: '依据', text: '第 2 章 示例链路与关键配置' },
                { label: '依据', text: '第 3 章 常见异常与排查顺序' }
            ],
            sources: [
                { title: '第 1 章 · 核心概念与适用场景', sub: '定义与边界', time: '00:32' },
                { title: '第 2 章 · 示例链路与关键配置', sub: '最小示例', time: '06:18' }
            ],
            footnote: '演示内容：答案会带章节片段和时间戳。'
        },
        actions: ['regenerate', 'toPpt', 'toForum']
    }
}

/** 安全解析 JSON 字符串 */
export function safeParseJson(s?: string | null): any {
    if (!s) return null
    try { return JSON.parse(s) } catch { return null }
}

/** 后端 PPT 任务 outputJson（{url,fileName,slides,outline}）→ 前端 PPT 卡数据 */
export function pptFromOutput(out: any): AgentPptPayload {
    const o = (out && out.outline) || {}
    const slides: AgentPptSlide[] = []
    slides.push({ title: o.title || '课程汇报', subtitle: o.subtitle || '智能学习平台 · AI 生成' })
    ;(o.sections || []).forEach((s: any) => slides.push({ title: s.title || '', subtitle: s.summary || '' }))
    const hl = (o.highlights || []).filter(Boolean)
    if (hl.length) slides.push({ title: '核心亮点', subtitle: hl.join(' · ') })
    const kp = (o.keyPoints || []).filter(Boolean)
    if (kp.length) slides.push({ title: '关键要点', subtitle: kp.join(' · ') })
    slides.push({ title: o.closing || '谢谢观看', subtitle: 'AI GENERATED PRESENTATION' })
    const pageTotal = (out && out.slides) || slides.length
    return {
        deckTitle: o.title || '课程汇报',
        slides,
        footnote: `共 ${pageTotal} 页 · 可全屏演示，也能下载 PPTX`,
        fileUrl: out && out.url,
        fileName: out && out.fileName
    }
}

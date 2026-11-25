import { get, post, v1 } from '@/utils/request'
import { API_READY } from '@/config/apiStatus'
import { MOCK_AGENT_SESSIONS, type AgentSession, type AgentRefItem } from '@/types/agent'

const READY = API_READY.agent

/* ===================== 类型 ===================== */
export interface AgentChatResult { sessionId: number; messageId: number; answer: string; refs: AgentRefItem[] }
export interface AgentMessageRow { messageId: number; sessionId: number; role: string; content: string; contentType?: string; refsJson?: string; createTime?: string }
export interface AgentTaskRow { taskId: number; taskType: string; status: string; progress: number; outputJson?: string; errorMsg?: string }
export interface AgentSqlResult { answer: string; sql?: string; rows: any[]; rowCount?: number; error?: string }

/* ===================== 会话历史 ===================== */
function toTimeText(s?: string): string {
  if (!s) return ''
  const m = String(s).replace('T', ' ').match(/\d{4}-(\d{2})-(\d{2})\s+(\d{2}):(\d{2})/)
  return m ? `${m[1]}-${m[2]} ${m[3]}:${m[4]}` : String(s)
}

/** 我的会话列表 GET /api/v1/agent/sessions */
export function listSessionsApi(pageNum = 1, pageSize = 20): Promise<{ rows: AgentSession[]; total: number }> {
  if (!READY) return Promise.resolve({ rows: MOCK_AGENT_SESSIONS.slice(), total: MOCK_AGENT_SESSIONS.length })
  return get(v1('/agent/sessions'), { pageNum, pageSize }).then((r: any) => {
    const rows: AgentSession[] = (r.rows || []).map((s: any) => ({
      sessionId: s.sessionId,
      title: s.title || '新对话',
      rounds: 0,
      timeText: toTimeText(s.lastMessageTime || s.createTime)
    }))
    return { rows, total: r.total || rows.length }
  })
}

/** 某会话消息 GET /api/v1/agent/sessions/{id}/messages */
export function listMessagesApi(sessionId: number): Promise<AgentMessageRow[]> {
  if (!READY) return Promise.resolve([])
  return get(v1(`/agent/sessions/${sessionId}/messages`)).then((r: any) => r.rows || [])
}

/** 新建会话 POST /api/v1/agent/sessions */
export function createSessionApi(title?: string): Promise<number> {
  if (!READY) return Promise.resolve(0)
  return post(v1('/agent/sessions'), { title }).then((r: any) => r?.session?.sessionId || 0)
}

/* ===================== 问答 ===================== */
/** 课程 RAG 同步问答 POST /api/v1/agent/chat */
export function agentChat(body: { sessionId?: number; question: string; courseId?: number }): Promise<AgentChatResult> {
  if (!READY) return Promise.resolve({ sessionId: body.sessionId || 0, messageId: 0, answer: '（智能体未接入）这是本地占位回答。', refs: [] })
  return post(v1('/agent/chat'), body, { showError: false }).then((r: any) => ({
    sessionId: r.sessionId,
    messageId: r.messageId,
    answer: r.answer || '',
    refs: Array.isArray(r.refs) ? r.refs : []
  }))
}

/** 流式问答提交（结果经 WS 推送）POST /api/v1/agent/chat/stream */
export function agentChatStream(body: { sessionId?: number; question: string; courseId?: number }): Promise<{ requestId: string; sessionId: number }> {
  return post(v1('/agent/chat/stream'), body, { showError: false }).then((r: any) => ({ requestId: r.requestId, sessionId: r.sessionId }))
}

/* ===================== 异步任务：视频总结 / PPT ===================== */
export function videoSummaryApi(videoId: number): Promise<number> {
  return post(v1('/agent/video/summary'), { videoId }).then((r: any) => r.taskId)
}
export function pptGenerateApi(topic: string, pages = 6): Promise<number> {
  return post(v1('/agent/ppt/generate'), { topic, pages }).then((r: any) => r.taskId)
}
export function getTaskApi(taskId: number): Promise<AgentTaskRow> {
  return get(v1(`/agent/tasks/${taskId}`)).then((r: any) => r.task)
}

/** 轮询任务直到 SUCCESS/FAILED（后端 progress/status 落库） */
export function pollTask(taskId: number, opts?: { interval?: number; timeout?: number; onProgress?: (t: AgentTaskRow) => void }): Promise<AgentTaskRow> {
  const interval = opts?.interval || 2000
  const timeout = opts?.timeout || 180000
  const start = Date.now()
  return new Promise((resolve, reject) => {
    const tick = async () => {
      try {
        const task = await getTaskApi(taskId)
        if (opts?.onProgress) opts.onProgress(task)
        if (task.status === 'SUCCESS' || task.status === 'FAILED') return resolve(task)
        if (Date.now() - start > timeout) return reject(new Error('任务超时'))
        setTimeout(tick, interval)
      } catch (e) { reject(e) }
    }
    tick()
  })
}

/* ===================== SQL 问答（自然语言查数据）===================== */
export function sqlAskApi(question: string): Promise<AgentSqlResult> {
  return post(v1('/agent/sql/ask'), { question }, { showError: false }).then((r: any) => ({
    answer: r.answer || '', sql: r.sql, rows: Array.isArray(r.rows) ? r.rows : [], rowCount: r.rowCount, error: r.error
  }))
}

/** 解析消息 refsJson */
export function parseRefs(json?: string): AgentRefItem[] {
  if (!json) return []
  try { const a = JSON.parse(json); return Array.isArray(a) ? a : [] } catch { return [] }
}
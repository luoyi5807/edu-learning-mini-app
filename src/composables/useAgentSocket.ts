import { BASE_URL } from '@/config/env'
import { getToken } from '@/utils/request'
import { useAuthStore } from '@/store/auth'

/**
 * 智能体 WebSocket 通道（微信小程序 uni.connectSocket）。
 * 连接 /ws/forum?token=，订阅 user:{userId}，把 agent.start/delta/done/error 分发给订阅者。
 * 模块级单例：整 App 一条连接，多处 onAgentEvent 复用。
 */
type Handler = (data: any) => void
const listeners: Record<string, Set<Handler>> = {}
let task: any = null
let open = false

function buildUrl(): string {
  const proto = /^https/i.test(BASE_URL) ? 'wss' : 'ws'
  const host = BASE_URL.replace(/^https?:\/\//i, '')
  return `${proto}://${host}/ws/forum?token=${getToken()}`
}

export function connectAgentSocket(): void {
  if (open || !getToken()) return
  task = uni.connectSocket({ url: buildUrl(), complete: () => {} })
  task.onOpen(() => {
    open = true
    const uid = useAuthStore().state.user?.userId
    if (uid) task.send({ data: JSON.stringify({ action: 'subscribe', topics: ['user:' + uid] }) })
  })
  task.onMessage((res: any) => {
    let msg: any
    try { msg = JSON.parse(res.data) } catch (e) { return }
    if (!msg || typeof msg.type !== 'string') return
    const set = listeners[msg.type]
    if (set) set.forEach((h) => { try { h(msg.data) } catch (e) {} })
  })
  task.onClose(() => { open = false })
  task.onError(() => { open = false })
}

/** 订阅某类事件，返回取消函数。type 例：'agent.delta' */
export function onAgentEvent(type: string, h: Handler): () => void {
  if (!listeners[type]) listeners[type] = new Set()
  listeners[type].add(h)
  return () => { if (listeners[type]) listeners[type].delete(h) }
}

/** 当前 WS 是否已连通（决定走流式还是同步兜底） */
export function isAgentSocketOpen(): boolean { return open }

export function closeAgentSocket(): void {
  if (task) { try { task.close({}) } catch (e) {} task = null }
  open = false
}
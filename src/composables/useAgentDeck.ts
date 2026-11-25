import { ref } from 'vue'
import type { AgentPptPayload } from '@/types/agent'

/** 模块级共享：助手页生成的 PPT 卡 → 全屏演示页读取 */
const deck = ref<AgentPptPayload | null>(null)

export function useAgentDeck() {
  function setDeck(p: AgentPptPayload) { deck.value = p }
  function clearDeck() { deck.value = null }
  return { deck, setDeck, clearDeck }
}
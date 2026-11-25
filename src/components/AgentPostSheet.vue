<template>
  <view class="ask-root" v-if="visible">
    <view class="ask-mask" @tap="close"></view>
    <view class="ask-sheet">
      <!-- 头部 -->
      <view class="ask-head">
        <view class="ask-avatar"><text class="ask-avatar-emoji">✦</text></view>
        <view class="ask-head-text">
          <text class="ask-title">问阿星</text>
          <text class="ask-sub">关于《{{ title }}》</text>
        </view>
        <view class="ask-close" @tap="close"><text class="ask-close-icon">✕</text></view>
      </view>

      <!-- 主体 -->
      <scroll-view class="ask-body" scroll-y :show-scrollbar="false" :scroll-into-view="scrollInto" scroll-with-animation>
        <!-- 空状态：建议（图11）-->
        <block v-if="!messages.length">
          <text class="ask-hint">可以问我这篇帖子的内容、思路，或者有没有相关讨论。</text>
          <text class="ask-hint-title">试试这样问</text>
          <view class="sug-card" v-for="s in suggestions" :key="s" @tap="ask(s)">
            <text class="sug-star">✦</text>
            <text class="sug-text">{{ s }}</text>
            <text class="sug-arrow">↗</text>
          </view>
        </block>

        <!-- 对话（图12）-->
        <block v-else>
          <view class="msg" :class="m.role === 'user' ? 'msg-user' : 'msg-agent'" v-for="m in messages" :key="m.id">
            <view v-if="m.role === 'user'" class="bubble-user"><text class="bubble-user-text">{{ m.text }}</text></view>
            <view v-else class="bubble-agent">
              <text class="bubble-agent-text">{{ m.text }}</text>
              <block v-if="m.cites && m.cites.length">
                <text class="cite-label">引用帖子</text>
                <view class="cite-card" v-for="(c, i) in m.cites" :key="i">
                  <text class="cite-icon">💬</text>
                  <view class="cite-body">
                    <text class="cite-title">{{ c.title }}</text>
                    <text class="cite-excerpt">{{ c.excerpt }}</text>
                  </view>
                </view>
              </block>
            </view>
          </view>
          <view id="ask-bottom" class="ask-anchor"></view>
        </block>
      </scroll-view>

      <!-- 输入栏 -->
      <view class="ask-input-bar">
        <input class="ask-input" v-model="input" placeholder="就这篇帖子提问…" placeholder-class="ask-ph" confirm-type="send" @confirm="ask('')" />
        <view class="ask-send" :class="{ 'ask-send-active': canSend }" @tap="ask('')"><text class="ask-send-icon">↑</text></view>
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { ref, computed, nextTick, watch } from 'vue'
import { API_READY } from '@/config/apiStatus'
import { agentChat } from '@/api/agent'

interface Cite { title: string; excerpt: string }
interface SheetMsg { id: number; role: 'user' | 'agent'; text: string; cites?: Cite[] }

const props = defineProps<{ visible: boolean; title: string }>()
const emit = defineEmits<{ (e: 'close'): void }>()

const suggestions: string[] = ['这篇帖子讲了什么？', '帮我把要点列出来', '有没有相关的帖子？']
const messages = ref<SheetMsg[]>([])
const input = ref<string>('')
const sending = ref<boolean>(false)
const scrollInto = ref<string>('')

const canSend = computed<boolean>(() => !!input.value.trim() && !sending.value)

let _id = 0
const uid = () => ++_id
function scrollBottom() { scrollInto.value = ''; nextTick(() => { scrollInto.value = 'ask-bottom' }) }
function close() { emit('close') }

/* 后端未就绪时用对齐设计图的演示回答；就绪后走真实 RAG 问答 */
const DEMO_ANSWER = '这篇帖子分享了用 uni-app 开发小程序的 5 个实用心得：先理清分包与预加载策略，再把跨端差异收敛到适配层，状态用轻量 store 统一管理，长列表用懒加载与虚拟滚动，最后用条件编译隔离平台专属逻辑。[E1]\n\n作者强调「先跑通再优化」，每个坑都配了复现步骤与修复前后对比，适合已经上手、想补齐工程化细节的同学。[E2]'
const DEMO_CITES: Cite[] = [
  { title: '计算机网络3天速成', excerpt: '分包预加载配置项与命中时机，避免首屏白屏。' },
  { title: '计算机网络3天速成', excerpt: '跨端适配层收敛差异，条件编译隔离平台逻辑。' }
]

async function ask(preset: string) {
  const q = (preset || input.value).trim()
  if (!q || sending.value) return
  messages.value.push({ id: uid(), role: 'user', text: q })
  input.value = ''
  scrollBottom()

  if (!API_READY.agent) {
    messages.value.push({ id: uid(), role: 'agent', text: DEMO_ANSWER, cites: DEMO_CITES })
    scrollBottom()
    return
  }

  sending.value = true
  try {
    const res = await agentChat({ question: q })
    const cites: Cite[] = (res.refs || [])
      .map((r) => ({ title: r.course || '', excerpt: r.chapter || r.lesson || '' }))
      .filter((c) => !!c.title)
    messages.value.push({ id: uid(), role: 'agent', text: res.answer || '（暂无回答）', cites })
  } catch (e: any) {
    messages.value.push({ id: uid(), role: 'agent', text: (e && (e.msg || e.message)) || '智能体服务暂不可用', cites: [] })
  } finally {
    sending.value = false
    scrollBottom()
  }
}

/* 每次重新打开清空会话 */
watch(() => props.visible, (v) => { if (v) { messages.value = []; input.value = '' } })
</script>

<style lang="scss" scoped>
.ask-root { position: fixed; top: 0; left: 0; right: 0; bottom: 0; z-index: 300; }
.ask-mask { position: absolute; top: 0; left: 0; right: 0; bottom: 0; background: rgba(0, 0, 0, 0.4); }
.ask-sheet {
  position: absolute; left: 0; right: 0; bottom: 0; height: 86vh;
  display: flex; flex-direction: column;
  background-color: $edu-surface; border-radius: 32rpx 32rpx 0 0;
  @include eduPageGradientStrong;
}

/* 头部 */
.ask-head { display: flex; align-items: center; padding: 32rpx 32rpx 16rpx; }
.ask-avatar { width: 76rpx; height: 76rpx; border-radius: 50%; @include eduBrandGradient; display: flex; align-items: center; justify-content: center; margin-right: 16rpx; flex-shrink: 0; }
.ask-avatar-emoji { font-size: 38rpx; color: #FFFFFF; }
.ask-head-text { display: flex; flex-direction: column; flex: 1; min-width: 0; }
.ask-title { font-size: 36rpx; font-weight: 700; color: $edu-text-primary; }
.ask-sub { font-size: 24rpx; color: $edu-text-hint; margin-top: 4rpx; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
.ask-close { width: 64rpx; height: 64rpx; border-radius: 50%; background-color: $edu-surface-variant; display: flex; align-items: center; justify-content: center; flex-shrink: 0; }
.ask-close-icon { font-size: 32rpx; color: $edu-text-secondary; }

/* 主体 */
.ask-body { flex: 1; min-height: 0; padding: 8rpx 32rpx 16rpx; box-sizing: border-box; }
.ask-hint { display: block; font-size: 28rpx; color: $edu-text-secondary; line-height: 1.6; margin-top: 8rpx; }
.ask-hint-title { display: block; font-size: 26rpx; color: $edu-text-hint; margin: 28rpx 0 16rpx; }
.sug-card { display: flex; align-items: center; padding: 30rpx 28rpx; margin-bottom: 20rpx; border-radius: 24rpx; background-color: $edu-surface; box-shadow: 0 6rpx 18rpx rgba(0, 0, 0, 0.04); }
.sug-star { font-size: 30rpx; color: $edu-primary; margin-right: 18rpx; }
.sug-text { flex: 1; font-size: 30rpx; color: $edu-text-primary; }
.sug-arrow { font-size: 30rpx; color: $edu-text-hint; }

/* 对话 */
.msg { margin-bottom: 24rpx; }
.msg-user { display: flex; justify-content: flex-end; }
.msg-agent { display: block; }
.bubble-user { max-width: 78%; padding: 20rpx 28rpx; border-radius: 28rpx 28rpx 8rpx 28rpx; @include eduBrandGradient; }
.bubble-user-text { font-size: 30rpx; color: #FFFFFF; line-height: 1.5; }
.bubble-agent { max-width: 92%; padding: 24rpx 28rpx; border-radius: 8rpx 28rpx 28rpx 28rpx; background-color: $edu-surface; box-shadow: 0 6rpx 18rpx rgba(0, 0, 0, 0.04); }
.bubble-agent-text { font-size: 30rpx; color: $edu-text-primary; line-height: 1.7; white-space: pre-wrap; }
.cite-label { display: block; font-size: 24rpx; color: $edu-text-hint; margin: 24rpx 0 12rpx; }
.cite-card { display: flex; align-items: flex-start; padding: 20rpx 24rpx; border-radius: 16rpx; background-color: $edu-surface-variant; margin-bottom: 12rpx; }
.cite-icon { font-size: 28rpx; color: $edu-primary; margin-right: 14rpx; }
.cite-body { flex: 1; min-width: 0; }
.cite-title { display: block; font-size: 28rpx; font-weight: 700; color: $edu-text-primary; }
.cite-excerpt { display: block; font-size: 24rpx; color: $edu-text-secondary; line-height: 1.5; margin-top: 6rpx; }
.ask-anchor { height: 1rpx; }

/* 输入栏 */
.ask-input-bar { display: flex; align-items: center; padding: 16rpx 24rpx calc(16rpx + env(safe-area-inset-bottom)); }
.ask-input { flex: 1; height: 84rpx; border-radius: 42rpx; background-color: $edu-surface; padding: 0 28rpx; font-size: 30rpx; color: $edu-text-primary; box-shadow: 0 4rpx 14rpx rgba(0, 0, 0, 0.04); }
.ask-ph { color: $edu-text-hint; font-size: 30rpx; }
.ask-send { width: 84rpx; height: 84rpx; border-radius: 50%; background-color: $edu-surface-variant; display: flex; align-items: center; justify-content: center; margin-left: 16rpx; flex-shrink: 0; }
.ask-send-icon { font-size: 40rpx; color: $edu-text-hint; }
.ask-send-active { @include eduBrandGradient; .ask-send-icon { color: #FFFFFF; } }
</style>
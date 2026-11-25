<template>
  <view class="assistant-page" :class="themeClass">
    <!-- 顶部栏：菜单开抽屉 · 阿星头像/名称/副标题 · 关闭 -->
    <view class="nav-bar" :style="{ paddingTop: statusBarHeight + 'px' }">
      <view class="nav-inner" :style="{ height: navContentHeight + 'px' }">
        <view class="nav-menu" @tap="drawerVisible = true"><text class="menu-icon">☰</text></view>
        <view class="nav-brand">
          <view class="nav-avatar"><text class="nav-avatar-emoji">✦</text></view>
          <view class="nav-brand-text">
            <text class="nav-name">阿星</text>
            <text class="nav-sub">学习不迷路，阿星来帮助</text>
          </view>
        </view>
        <view class="nav-close" @tap="goBack"><text class="nav-close-icon">✕</text></view>
      </view>
    </view>

    <!-- 主体：无消息→空状态；有消息→对话流（图7 摘要卡 / 图8 PPT 卡） -->
    <scroll-view class="agent-body" scroll-y :show-scrollbar="false" :scroll-into-view="scrollIntoId" scroll-with-animation>
      <view class="empty" v-if="!hasMessages">
        <text class="empty-title">试试这样问</text>
        <view class="sug-list">
          <view class="sug-card" v-for="s in suggestions" :key="s.text" @tap="useSuggestion(s)">
            <view class="sug-icon" :class="'sug-icon-' + s.tone"><text class="sug-icon-emoji">{{ s.icon }}</text></view>
            <text class="sug-text">{{ s.text }}</text>
            <text class="sug-add">⊕</text>
          </view>
        </view>
        <text class="empty-hint">点一下会填进输入框，阿星会自动判断用哪种能力。</text>
      </view>

      <view class="msg-list" v-else>
        <view class="msg" :class="m.role === 'user' ? 'msg-user' : 'msg-agent'" v-for="m in messages" :key="m.id">
          <!-- 用户气泡 -->
          <view v-if="m.role === 'user'" class="bubble-user"><text class="bubble-user-text">{{ m.text }}</text></view>
          <!-- 助手回答 -->
          <template v-else>
            <view class="answer-head">
              <text class="answer-by">按「{{ m.capabilityLabel }}」回答</text>
              <view class="answer-course" v-if="m.courseTitle" @tap="openCapabilityConfig">
                <text class="answer-course-text">{{ m.courseTitle }}</text>
                <text class="answer-course-caret">⌄</text>
              </view>
            </view>
            <AgentSummaryCard v-if="m.kind === 'summary' && m.summary" :summary="m.summary" />
            <AgentPptCard v-else-if="m.kind === 'ppt' && m.ppt" :ppt="m.ppt" @present="onPresent" @export="onExportPpt" />
            <AgentSqlCard v-else-if="m.kind === 'sql' && m.sql" :data="m.sql" />
            <AgentAnswerCard v-else-if="m.kind === 'answer' && m.answer" :data="m.answer" />
            <view v-else class="bubble-agent">
              <text class="bubble-agent-text">{{ m.text }}</text><text class="bubble-caret" v-if="m.streaming">▍</text>
              <view class="ref-row" v-if="m.refs && m.refs.length">
                <text class="ref-chip" v-for="(rf, i) in m.refs" :key="i">{{ rf.course }}<text v-if="rf.chapter"> · {{ rf.chapter }}</text></text>
              </view>
            </view>
            <view class="action-row" v-if="m.actions && m.actions.length">
              <view class="action-chip" v-if="m.actions && m.actions.indexOf('regenerate') >= 0" @tap="onRegenerate(m)">
                <text class="action-chip-icon">↻</text><text class="action-chip-text">重新生成</text>
              </view>
              <view class="action-chip" v-if="m.actions && m.actions.indexOf('toPpt') >= 0" @tap="onMakePpt(m)">
                <text class="action-chip-icon">🗂</text><text class="action-chip-text">做成 PPT</text>
              </view>
              <view class="action-chip" v-if="m.actions && m.actions.indexOf('toForum') >= 0" @tap="onSendToForum(m)">
                <text class="action-chip-icon">👥</text><text class="action-chip-text">发到论坛</text>
              </view>
            </view>
          </template>
        </view>
        <view id="msg-bottom" class="bottom-anchor"></view>
      </view>
    </scroll-view>

    <!-- 底部输入栏 -->
    <view class="input-bar">
      <view class="input-card">
        <!-- 已选课程（点能力标签的 ⌄ 选好后只用于这条消息） -->
        <view class="ctx-row" v-if="selectedCourse">
          <text class="ctx-icon">🎯</text>
          <text class="ctx-text">课程：{{ selectedCourse.title }}</text>
          <text class="ctx-remove" @tap="selectedCourse = null">✕</text>
        </view>
        <!-- 已上传图片（点 ＋ 选图，缩略图带移除角标） -->
        <view class="attach-row" v-if="attachments.length">
          <view class="attach-item" v-for="(p, i) in attachments" :key="p">
            <image class="attach-img" :src="p" mode="aspectFill" />
            <view class="attach-remove" @tap="removeAttachment(i)"><text class="attach-remove-icon">✕</text></view>
          </view>
        </view>
        <input
          class="agent-input"
          v-model="inputText"
          :placeholder="placeholder"
          placeholder-class="agent-ph"
          confirm-type="send"
          @confirm="onSend"
        />
        <view class="tool-row">
          <view class="cap-plus" @tap="onPlus"><text class="cap-plus-icon">＋</text></view>
          <scroll-view class="cap-scroll" scroll-x :show-scrollbar="false">
            <view class="cap-track">
              <view
                v-for="c in capabilities"
                :key="c.key"
                class="cap-chip"
                :class="{ 'cap-chip-active': selectedCapability === c.key }"
                @tap="onChipTap(c.key)"
              >
                <text class="cap-chip-icon">{{ c.icon }}</text>
                <text class="cap-chip-label">{{ c.label }}</text>
                <text v-if="selectedCapability === c.key" class="cap-chip-caret">⌄</text>
                <text v-if="selectedCapability === c.key" class="cap-chip-remove" @tap.stop="clearCapability">✕</text>
              </view>
            </view>
          </scroll-view>
          <view class="send-btn" :class="{ 'send-btn-active': canSend }" @tap="onSend"><text class="send-icon">↑</text></view>
        </view>
      </view>
    </view>

    <AgentHistoryDrawer
      :visible="drawerVisible"
      :sessions="sessions"
      :current-id="currentId"
      :status-bar-height="statusBarHeight"
      @close="drawerVisible = false"
      @new-chat="onNewChat"
      @select="onSelect"
      @open-memory="onOpenMemory"
    />

    <AgentCourseSheet
      :visible="courseSheetVisible"
      :courses="courses"
      @close="courseSheetVisible = false"
      @select="onPickCourse"
    />
  </view>
</template>

<script setup lang="ts">
import { ref, computed, nextTick } from 'vue'
import { onLoad, onUnload } from '@dcloudio/uni-app'
import AgentHistoryDrawer from '@/components/AgentHistoryDrawer.vue'
import AgentCourseSheet from '@/components/AgentCourseSheet.vue'
import AgentSummaryCard from '@/components/AgentSummaryCard.vue'
import AgentPptCard from '@/components/AgentPptCard.vue'
import AgentSqlCard from '@/components/AgentSqlCard.vue'
import AgentAnswerCard from '@/components/AgentAnswerCard.vue'
import {
  MOCK_AGENT_SESSIONS, AGENT_CAPABILITIES, AGENT_SUGGESTIONS, AGENT_COURSES,
  capabilityLabel, makeUserMsg, makeSummaryMsg, makePptMsg, makeTextMsg, makeAnswerMsg,
  pptFromOutput, safeParseJson,
  type AgentSuggestion, type AgentCourse, type AgentMessage, type AgentPptPayload, type AgentRefItem
} from '@/types/agent'
import { useAgentDeck } from '@/composables/useAgentDeck'
import { connectAgentSocket, onAgentEvent, isAgentSocketOpen } from '@/composables/useAgentSocket'
import { listSessionsApi, listMessagesApi, agentChat, agentChatStream, pptGenerateApi, pollTask, sqlAskApi, parseRefs } from '@/api/agent'
import { API_READY } from '@/config/apiStatus'
import { useTheme } from '@/composables/useTheme'

const { themeClass } = useTheme()
const { setDeck } = useAgentDeck()

const statusBarHeight = ref<number>(0)
const navContentHeight = ref<number>(44)
const sysInfo = uni.getSystemInfoSync()
statusBarHeight.value = sysInfo.statusBarHeight || 0
// #ifdef MP-WEIXIN
const menuButton = uni.getMenuButtonBoundingClientRect()
if (menuButton) {
  navContentHeight.value = (menuButton.top - statusBarHeight.value) * 2 + menuButton.height
}
// #endif

/* ===== 抽屉 ===== */
const drawerVisible = ref<boolean>(false)
const sessions = ref(MOCK_AGENT_SESSIONS.slice())
const currentId = ref<number>(1)
const currentSessionId = ref<number>(0)
const sending = ref<boolean>(false)

/** 拉取真实历史会话填充抽屉（后端未就绪时保持 mock） */
async function refreshSessions() {
  if (!API_READY.agent) return
  try {
    const { rows } = await listSessionsApi(1, 20)
    if (rows && rows.length) sessions.value = rows
  } catch (e) { /* 静默，保留 mock */ }
}
refreshSessions()
connectAgentSocket()

/* ===== WS 流式回调（同一时刻仅一条流，按 currentStream 路由）===== */
let currentStream: AgentMessage | null = null
function onWsDelta(d: any) {
  if (!currentStream) return
  currentStream.text = (currentStream.text || '') + ((d && d.content) || '')
  scrollToBottom()
}
function onWsDone(d: any) {
  if (!currentStream) return
  currentStream.streaming = false
  if (d && Array.isArray(d.refs)) currentStream.refs = d.refs
  if (d && d.sessionId) { currentSessionId.value = d.sessionId; currentId.value = d.sessionId }
  currentStream = null
  sending.value = false
  refreshSessions()
  scrollToBottom()
}
function onWsError(d: any) {
  if (!currentStream) return
  currentStream.streaming = false
  if (!currentStream.text) currentStream.text = '（智能体服务暂不可用）'
  currentStream = null
  sending.value = false
  uni.showToast({ title: (d && d.message) || '流式回答失败', icon: 'none' })
}
const offWs: Array<() => void> = [
  onAgentEvent('agent.delta', onWsDelta),
  onAgentEvent('agent.done', onWsDone),
  onAgentEvent('agent.error', onWsError)
]
onUnload(() => { offWs.forEach((f) => f()); currentStream = null })

/* ===== 输入与能力 ===== */
const capabilities = AGENT_CAPABILITIES
const suggestions = AGENT_SUGGESTIONS
const courses = AGENT_COURSES
const inputText = ref<string>('')
const selectedCapability = ref<string>('')
const attachments = ref<string[]>([])
const selectedCourse = ref<AgentCourse | null>(null)
const courseSheetVisible = ref<boolean>(false)

/* ===== 对话流 ===== */
const messages = ref<AgentMessage[]>([])
const hasMessages = computed<boolean>(() => messages.value.length > 0)
const scrollIntoId = ref<string>('')

const placeholder = computed<string>(() => {
  if (selectedCourse.value) return `就《${selectedCourse.value.title}》提问…`
  return selectedCapability.value ? '可以补充要求，也可以直接发送' : '问课程、查数据、做 PPT…'
})
const canSend = computed<boolean>(() => !!inputText.value.trim() || !!selectedCapability.value || attachments.value.length > 0)

function clearCapability() { selectedCapability.value = ''; selectedCourse.value = null }
function openCapabilityConfig() { courseSheetVisible.value = true }

/* 点未选中标签=选中；点已选中标签=打开课程弹层（不依赖双击时间间隔，PC 模拟器也能稳定触发）；取消用标签上的 ✕ */
function onChipTap(key: string) {
  if (selectedCapability.value === key) {
    openCapabilityConfig()
  } else {
    selectedCapability.value = key
  }
}
function onPickCourse(c: AgentCourse) { selectedCourse.value = c; courseSheetVisible.value = false }
function useSuggestion(s: AgentSuggestion) {
  inputText.value = s.text
  if (s.capability) selectedCapability.value = s.capability
}
function onPlus() {
  uni.chooseImage({
    count: 9,
    success: (res: any) => {
      const paths = (res && res.tempFilePaths) || []
      paths.forEach((p: string) => attachments.value.push(p))
    },
    fail: () => {}
  })
}
function removeAttachment(i: number) { attachments.value.splice(i, 1) }

/* ===== 发送与回答（后端 AI 未接入前用本地 mock 生成卡片）===== */
const CAP_DEFAULT_TEXT: Record<string, string> = {
  summary: '帮我总结这门课的重点',
  ppt: '把这门课做成一份 PPT',
  video: '这条视频讲了什么？',
  qa: '这门课的重点是什么？',
  sql: '我最近 7 天学了多久？'
}
/** 未手动选能力时，按问题关键词自动判断（团队约定：手动选了则严格用该能力） */
function detectCapability(t: string): string {
  const s = (t || '').toLowerCase()
  if (/ppt|幻灯片|演示|汇报/.test(s)) return 'ppt'
  if (/数据|统计|多久|多少|几天|时长|排行|学了/.test(s)) return 'sql'
  if (/视频|这条|影片|片段/.test(s)) return 'video'
  if (/总结|摘要|重点|梳理|大纲/.test(s)) return 'summary'
  return 'qa'
}
function replyCourse(): string { return selectedCourse.value?.title || '深入理解 Redis' }
function scrollToBottom() { scrollIntoId.value = ''; nextTick(() => { scrollIntoId.value = 'msg-bottom' }) }

async function onSend() {
  if (!canSend.value || sending.value) return
  const manual = selectedCapability.value
  const rawInput = inputText.value.trim()
  const cap = manual || detectCapability(rawInput || '你好，阿星')
  const text = rawInput || (manual ? CAP_DEFAULT_TEXT[manual] : '你好，阿星')
  const course = replyCourse()
  messages.value.push(makeUserMsg(text))
  inputText.value = ''
  attachments.value = []
  scrollToBottom()

  // 后端未就绪：本地 mock 卡片
  if (!API_READY.agent) {
    if (cap === 'summary') messages.value.push(makeSummaryMsg(course))
    else if (cap === 'ppt') messages.value.push(makePptMsg(course))
    else if (cap === 'qa') messages.value.push(makeAnswerMsg(course))
    else messages.value.push(makeTextMsg(capabilityLabel(cap), course, '（本地占位）后端智能体未接入。'))
    scrollToBottom()
    return
  }

  // PPT：异步任务轮询
  if (cap === 'ppt') { await runPpt(text, course); return }

  // SQL 查数：自然语言 → SELECT → 结果表
  if (cap === 'sql') { await runSql(text); return }

  // 视频总结：改由播放器页发起（那里有真实 video_id）
  if (cap === 'video') { uni.showToast({ title: '请在视频播放页点「阿星总结」', icon: 'none' }); return }

  // 课程问答 / 课程摘要：WS 流式优先，未连通则同步兜底
  const courseId = selectedCourse.value ? selectedCourse.value.courseId : undefined
  if (isAgentSocketOpen()) await sendStream(text, cap, courseId)
  else await sendSync(text, cap, courseId)
}

/** 流式 RAG 问答：先占位气泡，WS 增量填充 */
async function sendStream(text: string, cap: string, courseId?: number) {
  const msg = makeTextMsg(capabilityLabel(cap), selectedCourse.value?.title || '', '')
  msg.streaming = true
  messages.value.push(msg)
  currentStream = msg
  sending.value = true
  scrollToBottom()
  const guard = setTimeout(() => {
    if (currentStream === msg) {
      msg.streaming = false
      if (!msg.text) msg.text = '（回答超时，请稍后重试）'
      currentStream = null
      sending.value = false
    }
  }, 60000)
  try {
    const res = await agentChatStream({ sessionId: currentSessionId.value || undefined, question: text, courseId })
    currentSessionId.value = res.sessionId
    currentId.value = res.sessionId
  } catch (e) {
    if (currentStream === msg) { currentStream = null; sending.value = false }
    msg.streaming = false
    await sendSync(text, cap, courseId, msg)
  } finally {
    clearTimeout(guard)
  }
}

/** 同步 RAG 问答（WS 不可用或流式提交失败时兜底） */
async function sendSync(text: string, cap: string, courseId?: number, reuse?: AgentMessage) {
  sending.value = true
  try {
    const res = await agentChat({ sessionId: currentSessionId.value || undefined, question: text, courseId })
    currentSessionId.value = res.sessionId
    currentId.value = res.sessionId
    if (reuse) { reuse.text = res.answer; reuse.refs = res.refs }
    else messages.value.push(makeTextMsg(capabilityLabel(cap), selectedCourse.value?.title || '', res.answer, res.refs))
    refreshSessions()
  } catch (e: any) {
    const errText = (e && (e.msg || e.message)) || '智能体服务暂不可用'
    if (reuse) { if (!reuse.text) reuse.text = errText }
    else uni.showToast({ title: errText, icon: 'none' })
  } finally {
    sending.value = false
    scrollToBottom()
  }
}

/** PPT 生成：提交异步任务 + 轮询进度，成功后渲染可下载卡片 */
async function runPpt(text: string, course: string) {
  sending.value = true
  const topic = text && text !== CAP_DEFAULT_TEXT.ppt ? text : course
  const msg = makeTextMsg('生成PPT', course, '正在生成 PPT，请稍候…')
  messages.value.push(msg)
  scrollToBottom()
  try {
    const taskId = await pptGenerateApi(topic, 6)
    const task = await pollTask(taskId, {
      interval: 2000,
      timeout: 180000,
      onProgress: (t) => { if (t.status === 'RUNNING') { msg.text = `正在生成 PPT… ${t.progress || 0}%`; scrollToBottom() } }
    })
    if (task.status === 'SUCCESS') {
      msg.kind = 'ppt'
      msg.ppt = pptFromOutput(safeParseJson(task.outputJson))
      msg.text = undefined
    } else {
      msg.text = 'PPT 生成失败：' + (task.errorMsg || '未知错误')
    }
  } catch (e: any) {
    msg.text = 'PPT 生成失败：' + ((e && (e.msg || e.message)) || '服务暂不可用')
  } finally {
    sending.value = false
    scrollToBottom()
  }
}

/** SQL 查数：/agent/sql/ask → 答案 + 结果表卡 */
async function runSql(text: string) {
  sending.value = true
  const msg = makeTextMsg('查数据', '', '正在查询数据…')
  messages.value.push(msg)
  scrollToBottom()
  try {
    const res = await sqlAskApi(text)
    msg.kind = 'sql'
    msg.sql = { answer: res.answer, sql: res.sql, rows: res.rows, rowCount: res.rowCount, error: res.error }
    msg.text = undefined
  } catch (e: any) {
    msg.text = '查询失败：' + ((e && (e.msg || e.message)) || '服务暂不可用')
  } finally {
    sending.value = false
    scrollToBottom()
  }
}

function onRegenerate(m: AgentMessage) {
  const course = m.courseTitle || replyCourse()
  if (m.kind === 'summary') messages.value.push(makeSummaryMsg(course))
  else if (m.kind === 'ppt') messages.value.push(makePptMsg(course))
  else if (m.kind === 'answer') messages.value.push(makeAnswerMsg(course))
  else messages.value.push(makeTextMsg(m.capabilityLabel || '课程问答', course, '已重新生成回答（后端 AI 接入后展示真实结果）。'))
  scrollToBottom()
}

function onMakePpt(m: AgentMessage) {
  const course = m.courseTitle || replyCourse()
  messages.value.push(makeUserMsg(`把《${course}》做成一份 PPT`))
  messages.value.push(makePptMsg(course))
  scrollToBottom()
}

/** 发到论坛：把回答内容带到发帖页预填 */
function onSendToForum(m: AgentMessage) {
  const content = (m.answer && m.answer.answer) || m.text || ''
  if (!content) { uni.showToast({ title: '暂无可发布内容', icon: 'none' }); return }
  const title = m.courseTitle ? `《${m.courseTitle}》学习问答` : '阿星学习问答'
  uni.navigateTo({
    url: `/pages-sub/article/publish?title=${encodeURIComponent(title)}&content=${encodeURIComponent(content)}`
  })
}

function onPresent(p: AgentPptPayload) { setDeck(p); uni.navigateTo({ url: '/pages-sub/agent/present' }) }
function onExportPpt(p: AgentPptPayload) {
  if (!p || !p.fileUrl) { uni.showToast({ title: '暂无可下载文件', icon: 'none' }); return }
  uni.showLoading({ title: '下载中…' })
  uni.downloadFile({
    url: p.fileUrl,
    success: (res: any) => {
      uni.hideLoading()
      if (res.statusCode !== 200) { uni.showToast({ title: '下载失败', icon: 'none' }); return }
      uni.openDocument({ filePath: res.tempFilePath, fileType: 'pptx', showMenu: true, fail: () => uni.showToast({ title: '该文件无法直接打开', icon: 'none' }) })
    },
    fail: () => { uni.hideLoading(); uni.showToast({ title: '下载失败', icon: 'none' }) }
  })
}

/* ===== 抽屉事件 ===== */
function onNewChat() {
  drawerVisible.value = false
  inputText.value = ''
  selectedCapability.value = ''
  selectedCourse.value = null
  attachments.value = []
  messages.value = []
  currentSessionId.value = 0
  uni.showToast({ title: '已开启新对话', icon: 'none' })
}
async function onSelect(id: number) {
  currentId.value = id
  currentSessionId.value = id
  drawerVisible.value = false
  if (!API_READY.agent) return
  try {
    const rows = await listMessagesApi(id)
    messages.value = rows.map((r) => ({
      id: r.messageId || Math.floor(Math.random() * 1e9),
      role: (r.role === 'assistant' ? 'agent' : 'user') as 'agent' | 'user',
      kind: 'text',
      text: r.content || '',
      refs: parseRefs(r.refsJson)
    }))
    scrollToBottom()
  } catch (e) { /* 保持当前 */ }
}
function onOpenMemory() {
  uni.showToast({ title: '记忆管理（待接入）', icon: 'none' })
}

function goBack() {
  const pages = getCurrentPages()
  if (pages.length > 1) uni.navigateBack()
  else uni.reLaunch({ url: '/pages/index/index' })
}

/* 从课程详情「问这门课程」进入：预选课程 + 占位符课程化 */
onLoad((query) => {
  const cid = Number((query && query.courseId) || 0)
  const ct = query && query.courseTitle ? decodeURIComponent(String(query.courseTitle)) : ''
  if (ct) selectedCourse.value = { courseId: cid, title: ct, desc: '' }
})
</script>

<style lang="scss" scoped>
.assistant-page {
  display: flex;
  flex-direction: column;
  height: 100vh;
  box-sizing: border-box;
  @include eduPageGradientStrong;
}

/* 顶部栏 */
.nav-bar { padding-left: 16rpx; padding-right: 16rpx; }
.nav-inner { display: flex; align-items: center; }
.nav-menu { width: 76rpx; height: 76rpx; border-radius: 50%; background-color: $edu-surface; display: flex; align-items: center; justify-content: center; box-shadow: 0 4rpx 12rpx rgba(0, 0, 0, 0.05); flex-shrink: 0; }
.menu-icon { font-size: 36rpx; color: $edu-text-primary; }
.nav-brand { display: flex; align-items: center; margin-left: 16rpx; flex: 1; min-width: 0; }
.nav-avatar { width: 72rpx; height: 72rpx; border-radius: 50%; @include eduBrandGradient; display: flex; align-items: center; justify-content: center; margin-right: 16rpx; flex-shrink: 0; }
.nav-avatar-emoji { font-size: 36rpx; color: #FFFFFF; }
.nav-brand-text { display: flex; flex-direction: column; }
.nav-name { font-size: 40rpx; font-weight: 700; color: $edu-text-primary; line-height: 1.2; }
.nav-sub { font-size: 24rpx; color: $edu-text-hint; margin-top: 4rpx; }
.nav-close { width: 76rpx; height: 76rpx; border-radius: 50%; background-color: $edu-surface; display: flex; align-items: center; justify-content: center; box-shadow: 0 4rpx 12rpx rgba(0, 0, 0, 0.05); flex-shrink: 0; }
.nav-close-icon { font-size: 36rpx; color: $edu-text-primary; }

/* 主体 */
.agent-body { flex: 1; min-height: 0; padding: 8rpx 32rpx 24rpx; box-sizing: border-box; }
.empty-title { display: block; font-size: 36rpx; font-weight: 700; color: $edu-text-primary; margin: 16rpx 0 24rpx; }
.sug-card {
  display: flex; align-items: center; padding: 28rpx; margin-bottom: 24rpx;
  border-radius: 28rpx; background-color: $edu-surface;
  box-shadow: 0 8rpx 24rpx rgba(0, 0, 0, 0.04);
}
.sug-icon { width: 72rpx; height: 72rpx; border-radius: 20rpx; display: flex; align-items: center; justify-content: center; margin-right: 24rpx; flex-shrink: 0; }
.sug-icon-blue { background-color: rgba(54, 119, 239, 0.12); }
.sug-icon-teal { background-color: rgba(0, 176, 192, 0.12); }
.sug-icon-emoji { font-size: 40rpx; }
.sug-icon-blue .sug-icon-emoji { color: $edu-primary; }
.sug-icon-teal .sug-icon-emoji { color: $edu-accent-teal; }
.sug-text { flex: 1; font-size: 32rpx; color: $edu-text-primary; }
.sug-add { font-size: 40rpx; color: $edu-text-hint; margin-left: 12rpx; }
.empty-hint { display: block; font-size: 26rpx; color: $edu-text-hint; margin-top: 8rpx; }

/* 对话流 */
.msg-list { padding-top: 8rpx; }
.msg { margin-bottom: 32rpx; }
.msg-user { display: flex; justify-content: flex-end; }
.msg-agent { display: block; }
.bubble-user { max-width: 78%; padding: 22rpx 30rpx; border-radius: 28rpx 28rpx 8rpx 28rpx; @include eduBrandGradient; }
.bubble-user-text { font-size: 30rpx; color: #FFFFFF; line-height: 1.5; }
.answer-head { display: flex; align-items: center; margin-bottom: 16rpx; }
.answer-by { font-size: 26rpx; color: $edu-text-hint; margin-right: 16rpx; }
.answer-course { display: inline-flex; align-items: center; padding: 8rpx 20rpx; border-radius: 24rpx; background-color: rgba(54, 119, 239, 0.12); }
.answer-course-text { font-size: 26rpx; color: $edu-primary; }
.answer-course-caret { font-size: 24rpx; color: $edu-primary; margin-left: 8rpx; }
.bubble-agent { max-width: 88%; padding: 24rpx 28rpx; border-radius: 8rpx 28rpx 28rpx 28rpx; background-color: $edu-surface; box-shadow: 0 6rpx 18rpx rgba(0, 0, 0, 0.04); }
.bubble-agent-text { font-size: 30rpx; color: $edu-text-primary; line-height: 1.6; }
.bubble-caret { font-size: 30rpx; color: $edu-primary; margin-left: 4rpx; animation: caret-blink 1s steps(2, start) infinite; }
@keyframes caret-blink { to { visibility: hidden; } }
.ref-row { display: flex; flex-wrap: wrap; margin-top: 16rpx; }
.ref-chip { font-size: 22rpx; color: $edu-primary; background-color: rgba(54, 119, 239, 0.10); padding: 6rpx 16rpx; border-radius: 16rpx; margin-right: 12rpx; margin-bottom: 8rpx; }
.action-row { display: flex; margin-top: 20rpx; }
.action-chip { display: inline-flex; align-items: center; height: 68rpx; padding: 0 28rpx; border-radius: 34rpx; background-color: $edu-surface; box-shadow: 0 6rpx 16rpx rgba(0, 0, 0, 0.05); margin-right: 20rpx; }
.action-chip-icon { font-size: 28rpx; color: $edu-text-secondary; margin-right: 10rpx; }
.action-chip-text { font-size: 28rpx; color: $edu-text-secondary; }
.bottom-anchor { height: 1rpx; }

/* 输入栏 */
.input-bar { padding: 16rpx 24rpx calc(16rpx + env(safe-area-inset-bottom)); }
.input-card {
  border-radius: 32rpx; background-color: $edu-surface;
  border: 2rpx solid rgba(54, 119, 239, 0.22);
  padding: 20rpx 20rpx 16rpx;
}
/* 已选课程标签行 */
.ctx-row { display: flex; align-items: center; margin-bottom: 12rpx; padding: 10rpx 20rpx; border-radius: 16rpx; background-color: rgba(54, 119, 239, 0.10); }
.ctx-icon { font-size: 26rpx; margin-right: 10rpx; }
.ctx-text { flex: 1; font-size: 26rpx; color: $edu-primary; }
.ctx-remove { font-size: 26rpx; color: $edu-text-hint; padding: 0 8rpx; }
/* 已上传图片缩略图行 */
.attach-row { display: flex; flex-wrap: wrap; margin-bottom: 12rpx; }
.attach-item { position: relative; width: 140rpx; height: 140rpx; margin-right: 16rpx; margin-bottom: 8rpx; }
.attach-img { width: 140rpx; height: 140rpx; border-radius: 20rpx; }
.attach-remove { position: absolute; top: -10rpx; right: -10rpx; width: 40rpx; height: 40rpx; border-radius: 50%; background-color: rgba(0, 0, 0, 0.55); display: flex; align-items: center; justify-content: center; }
.attach-remove-icon { font-size: 24rpx; color: #FFFFFF; }
.agent-input { height: 64rpx; font-size: 30rpx; color: $edu-text-primary; padding: 0 8rpx; }
.agent-ph { color: $edu-text-hint; font-size: 30rpx; }
.tool-row { display: flex; align-items: center; margin-top: 12rpx; }
.cap-plus { width: 64rpx; height: 64rpx; border-radius: 50%; background-color: $edu-surface-variant; display: flex; align-items: center; justify-content: center; flex-shrink: 0; margin-right: 16rpx; }
.cap-plus-icon { font-size: 40rpx; color: $edu-primary; }
.cap-scroll { flex: 1; min-width: 0; white-space: nowrap; }
.cap-track { display: inline-flex; align-items: center; }
.cap-chip {
  display: inline-flex; align-items: center; height: 64rpx; padding: 0 24rpx;
  border-radius: 32rpx; background-color: $edu-surface-variant; margin-right: 16rpx; flex-shrink: 0;
}
.cap-chip-icon { font-size: 26rpx; margin-right: 8rpx; }
.cap-chip-label { font-size: 28rpx; color: $edu-text-secondary; }
.cap-chip-active { background-color: $edu-primary; .cap-chip-label { color: #FFFFFF; } .cap-chip-icon, .cap-chip-caret, .cap-chip-remove { color: #FFFFFF; } }
.cap-chip-caret { font-size: 30rpx; line-height: 1; margin-left: 10rpx; }
.cap-chip-remove { font-size: 28rpx; line-height: 1; margin-left: 14rpx; padding: 0 4rpx; }

.send-btn { width: 72rpx; height: 72rpx; border-radius: 50%; background-color: $edu-surface-variant; display: flex; align-items: center; justify-content: center; flex-shrink: 0; margin-left: 12rpx; }
.send-icon { font-size: 36rpx; color: $edu-text-hint; }
.send-btn-active { @include eduBrandGradient; .send-icon { color: #FFFFFF; } }
</style>
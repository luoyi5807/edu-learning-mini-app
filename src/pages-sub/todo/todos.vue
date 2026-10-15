<template>
  <view class="todos-page">
    <view class="nav-bar" :class="{ 'nav-bar-opaque': navBarOpaque }" :style="{ paddingTop: statusBarHeight + 'px' }">
      <view class="nav-bar-inner" :style="{ height: navContentHeight + 'px' }">
        <view class="nav-back" @tap="goBack"><text class="back-icon">←</text></view>
        <text class="nav-title">我的待办</text>
      </view>
    </view>
    <view class="nav-placeholder" :style="{ height: (statusBarHeight + navContentHeight) + 'px' }"></view>

    <!-- 状态筛选 -->
    <view class="filter-tabs">
      <view
          v-for="tab in statusTabs"
          :key="String(tab.value)"
          class="filter-pill"
          :class="{ 'filter-pill-active': activeStatus === tab.value }"
          @tap="handleStatus(tab.value)"
      >
        <text class="filter-pill-text">{{ tab.label }}</text>
      </view>
    </view>

    <!-- 优先级筛选 -->
    <scroll-view class="priority-row" scroll-x :show-scrollbar="false">
      <view class="priority-inner">
        <view
            v-for="p in priorityTabs"
            :key="String(p.value)"
            class="pri-chip"
            :class="{ 'pri-chip-active': activePriority === p.value }"
            @tap="handlePriority(p.value)"
        >
          <text class="pri-chip-text">{{ p.label }}</text>
        </view>
      </view>
    </scroll-view>

    <LoadingState v-if="state === 'loading'" text="正在加载待办…" />
    <ErrorState v-else-if="state === 'error'" text="加载失败" @retry="loadList" />
    <EmptyState v-else-if="list.length === 0" text="没有待办了，太棒了！" />
    <view class="todo-list" v-else>
      <view v-for="t in list" :key="t.todoId" class="todo-item" :class="{ 'todo-done': t.status === 1 }">
        <view class="check" :class="{ 'check-on': t.status === 1 }" @tap="handleToggle(t)">
          <text v-if="t.status === 1" class="check-icon">✓</text>
        </view>
        <view class="todo-body" @tap="openEdit(t)">
          <view class="todo-top">
            <text class="pri-tag" :class="'pri-' + t.priority">{{ priorityText(t.priority) }}</text>
            <text class="todo-title" :class="{ 'title-done': t.status === 1 }">{{ t.title }}</text>
          </view>
          <text class="todo-desc" v-if="t.description">{{ t.description }}</text>
          <view class="todo-foot">
            <text class="deadline" v-if="t.deadline">⏰ {{ t.deadline }}</text>
            <text class="done-time" v-if="t.status === 1 && t.finishTime">完成于 {{ t.finishTime }}</text>
          </view>
        </view>
        <text class="todo-del" @tap.stop="handleDelete(t)">🗑</text>
      </view>
    </view>

    <!-- 新增 FAB -->
    <view class="fab" hover-class="fab-pressed" @tap="openAdd">
      <text class="fab-icon">＋</text>
    </view>

    <!-- 新增/编辑弹层 -->
    <view v-if="sheetVisible" class="sheet-mask" @tap="closeSheet">
      <view class="sheet-panel" @tap.stop>
        <text class="sheet-title">{{ editingId ? '编辑待办' : '新增待办' }}</text>

        <input class="sheet-input" v-model="form.title" placeholder="标题（必填）" placeholder-class="sheet-ph" :maxlength="50" />
        <textarea class="sheet-textarea" v-model="form.description" placeholder="描述（选填）" placeholder-class="sheet-ph" :maxlength="200" auto-height />

        <picker mode="date" :value="form.deadlineDate" @change="onDeadlineChange">
          <view class="sheet-field">
            <text class="sheet-field-label">截止时间</text>
            <text class="sheet-field-value">{{ form.deadline || '未设置' }}</text>
            <text class="sheet-field-arrow">›</text>
          </view>
        </picker>

        <text class="sheet-sub">优先级</text>
        <view class="pri-picker-row">
          <view
              v-for="p in priorityOptions"
              :key="p.value"
              class="pri-pill"
              :class="{ 'pri-pill-active': form.priority === p.value }"
              @tap="form.priority = p.value"
          >
            <text class="pri-pill-text">{{ p.label }}</text>
          </view>
        </view>

        <text v-if="formError" class="sheet-error">{{ formError }}</text>

        <view class="sheet-actions">
          <view class="sheet-btn sheet-btn-cancel" @tap="closeSheet"><text class="sheet-cancel-text">取消</text></view>
          <view class="sheet-btn sheet-btn-save" :class="{ 'sheet-btn-disabled': saving }" @tap="handleSave">
            <text class="sheet-save-text">{{ saving ? '保存中…' : '保存' }}</text>
          </view>
        </view>
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { ref, reactive } from 'vue'
import { onLoad, onShow, onPageScroll } from '@dcloudio/uni-app'
import LoadingState from '@/components/LoadingState.vue'
import ErrorState from '@/components/ErrorState.vue'
import EmptyState from '@/components/EmptyState.vue'
import {
  getTodosApi,
  addTodoApi,
  updateTodoApi,
  setTodoStatusApi,
  removeTodoApi,
  TODO_PRIORITY_TEXT,
  type TodoDto
} from '@/api/todo'

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

const navBarOpaque = ref<boolean>(false)
onPageScroll((e) => { navBarOpaque.value = e.scrollTop > 40 })

/* ===== 筛选 ===== */
const statusTabs = [
  { label: '全部', value: '' as number | '' },
  { label: '未完成', value: 0 },
  { label: '已完成', value: 1 }
]
const priorityTabs = [
  { label: '全部优先级', value: 0 },
  { label: '高', value: 1 },
  { label: '中', value: 2 },
  { label: '低', value: 3 }
]
const activeStatus = ref<number | ''>('')
const activePriority = ref<number>(0)

const list = ref<TodoDto[]>([])
const state = ref<'loading' | 'error' | 'ready'>('loading')

function priorityText(p: number): string {
  return TODO_PRIORITY_TEXT[p] || '中'
}

async function loadList() {
  state.value = 'loading'
  try {
    const res = await getTodosApi(
        activeStatus.value === '' ? undefined : activeStatus.value,
        activePriority.value || undefined
    )
    list.value = res || []
    state.value = 'ready'
  } catch (e) {
    state.value = 'error'
  }
}

function handleStatus(v: number | '') { activeStatus.value = v; loadList() }
function handlePriority(v: number) { activePriority.value = v; loadList() }

/* ===== 完成切换（乐观更新） ===== */
async function handleToggle(t: TodoDto) {
  const next = t.status === 1 ? 0 : 1
  const idx = list.value.findIndex((x) => x.todoId === t.todoId)
  const prev = list.value[idx]
  list.value[idx] = { ...prev, status: next }              // 乐观
  try {
    await setTodoStatusApi(t.todoId, next)
    await loadList()
  } catch (e) {
    list.value[idx] = prev                                  // 回滚
    uni.showToast({ title: '操作失败', icon: 'none' })
  }
}

function handleDelete(t: TodoDto) {
  uni.showModal({
    title: '删除待办',
    content: `确定删除「${t.title}」吗？`,
    confirmColor: '#D04030',
    success: async (r) => {
      if (!r.confirm) return
      await removeTodoApi(t.todoId)
      await loadList()
      uni.showToast({ title: '已删除', icon: 'none' })
    }
  })
}

/* ===== 新增/编辑弹层 ===== */
const sheetVisible = ref<boolean>(false)
const saving = ref<boolean>(false)
const formError = ref<string>('')
const editingId = ref<number>(0)

const priorityOptions = [
  { label: '高', value: 1 },
  { label: '中', value: 2 },
  { label: '低', value: 3 }
]

const form = reactive({
  title: '',
  description: '',
  deadline: '',
  deadlineDate: '',
  priority: 2
})

function resetForm() {
  form.title = ''
  form.description = ''
  form.deadline = ''
  form.deadlineDate = ''
  form.priority = 2
  formError.value = ''
  editingId.value = 0
}

function openAdd() {
  resetForm()
  sheetVisible.value = true
}

function openEdit(t: TodoDto) {
  editingId.value = t.todoId
  form.title = t.title
  form.description = t.description || ''
  form.deadline = t.deadline || ''
  form.deadlineDate = (t.deadline || '').split(' ')[0]
  form.priority = t.priority
  formError.value = ''
  sheetVisible.value = true
}

function closeSheet() {
  if (saving.value) return
  sheetVisible.value = false
}

function onDeadlineChange(e: any) {
  form.deadlineDate = e.detail.value
  form.deadline = form.deadlineDate ? form.deadlineDate + ' 09:00' : ''
}

async function handleSave() {
  if (saving.value) return
  formError.value = ''
  if (!form.title.trim()) {
    formError.value = '标题不能为空'
    return
  }
  saving.value = true
  try {
    const payload = {
      title: form.title.trim(),
      description: form.description.trim(),
      deadline: form.deadline || undefined,
      priority: form.priority
    }
    if (editingId.value) await updateTodoApi(editingId.value, payload)
    else await addTodoApi(payload as any)
    sheetVisible.value = false
    await loadList()
    uni.showToast({ title: '已保存', icon: 'success' })
  } catch (e: any) {
    formError.value = (e && e.msg) ? e.msg : '保存失败，请稍后重试'
  } finally {
    saving.value = false
  }
}

function goBack() {
  const pages = getCurrentPages()
  if (pages.length > 1) uni.navigateBack()
  else uni.reLaunch({ url: '/pages/index/index' })
}

onLoad(() => { loadList() })
onShow(() => { loadList() })
</script>

<style lang="scss" scoped>
.todos-page {
  min-height: 100vh; box-sizing: border-box; padding: 0 32rpx 160rpx;
  @include eduPageGradientStrong;
}
.nav-bar {
  position: fixed; top: 0; left: 0; right: 0; z-index: 99; background: transparent;
  transition: background-color 0.3s ease, box-shadow 0.3s ease;
}
.nav-bar-opaque { background: #FFFFFF; box-shadow: 0 2rpx 12rpx rgba(0, 0, 0, 0.06); }
.nav-bar-inner { display: flex; align-items: center; padding-left: 16rpx; }
.nav-back { width: 72rpx; height: 72rpx; display: flex; align-items: center; justify-content: center; }
.back-icon { font-size: 44rpx; color: $edu-text-primary; }
.nav-title { font-size: 40rpx; font-weight: 700; color: $edu-text-primary; margin-left: 8rpx; }

.filter-tabs { display: flex; align-items: center; margin-top: 24rpx; }
.filter-pill {
  display: flex; align-items: center; justify-content: center;
  height: 72rpx; padding: 0 44rpx; border-radius: 36rpx; margin-right: 20rpx;
  @include eduSurfaceWash; box-shadow: 0 4rpx 12rpx rgba(0, 0, 0, 0.03);
}
.filter-pill-active { background: $edu-primary; .filter-pill-text { color: #FFFFFF; font-weight: 600; } }
.filter-pill-text { font-size: 28rpx; color: $edu-text-secondary; }

.priority-row { white-space: nowrap; margin-top: 20rpx; }
.priority-inner { display: inline-flex; align-items: center; }
.pri-chip {
  display: inline-flex; align-items: center; height: 56rpx; padding: 0 28rpx;
  border-radius: 28rpx; margin-right: 16rpx; background-color: $edu-surface;
  border: 2rpx solid $edu-divider;
}
.pri-chip-active { background-color: $edu-primary-container; border-color: $edu-primary; }
.pri-chip-text { font-size: 26rpx; color: $edu-text-secondary; }
.pri-chip-active .pri-chip-text { color: #0C2C6B; }

.todo-list { margin-top: 28rpx; }
.todo-item {
  display: flex; align-items: flex-start; padding: 28rpx; margin-bottom: 20rpx;
  border-radius: 24rpx; background-color: $edu-surface;
  box-shadow: 0 4rpx 16rpx rgba(0, 0, 0, 0.03);
}
.todo-done { opacity: 0.7; }
.check {
  width: 44rpx; height: 44rpx; border-radius: 50%; flex-shrink: 0; margin-right: 20rpx; margin-top: 4rpx;
  border: 3rpx solid $edu-outline; display: flex; align-items: center; justify-content: center;
}
.check-on { background-color: $edu-accent-teal; border-color: $edu-accent-teal; }
.check-icon { font-size: 28rpx; color: #FFFFFF; }
.todo-body { flex: 1; display: flex; flex-direction: column; }
.todo-top { display: flex; align-items: center; margin-bottom: 8rpx; }
.pri-tag { font-size: 22rpx; padding: 2rpx 12rpx; border-radius: 8rpx; margin-right: 12rpx; flex-shrink: 0; }
.pri-1 { background-color: #FDE7E3; color: $edu-accent-coral; }
.pri-2 { background-color: #FFF8E8; color: $edu-accent-yellow; }
.pri-3 { background-color: $edu-surface-variant; color: $edu-text-secondary; }
.todo-title { font-size: 30rpx; font-weight: 600; color: $edu-text-primary; line-height: 1.4; }
.title-done { text-decoration: line-through; color: $edu-text-hint; }
.todo-desc { font-size: 26rpx; color: $edu-text-secondary; line-height: 1.5; margin-top: 8rpx; }
.todo-foot { display: flex; align-items: center; margin-top: 12rpx; }
.deadline { font-size: 24rpx; color: $edu-accent-coral; margin-right: 24rpx; }
.done-time { font-size: 24rpx; color: $edu-text-hint; }
.todo-del { font-size: 34rpx; color: $edu-text-hint; padding: 8rpx 4rpx 8rpx 16rpx; }

.fab {
  position: fixed; right: 40rpx; bottom: calc(80rpx + env(safe-area-inset-bottom));
  width: 112rpx; height: 112rpx; border-radius: 50%;
  @include eduBrandGradient; box-shadow: 0 12rpx 28rpx rgba(54, 119, 239, 0.4);
  display: flex; align-items: center; justify-content: center; z-index: 90;
}
.fab-pressed { opacity: 0.9; }
.fab-icon { font-size: 56rpx; color: #FFFFFF; }

.sheet-mask {
  position: fixed; left: 0; top: 0; right: 0; bottom: 0; z-index: 200;
  background: rgba(0, 0, 0, 0.4); display: flex; align-items: flex-end;
}
.sheet-panel {
  width: 100%; box-sizing: border-box;
  padding: 40rpx 40rpx calc(40rpx + env(safe-area-inset-bottom));
  border-top-left-radius: 32rpx; border-top-right-radius: 32rpx;
  background-color: $edu-surface;
}
.sheet-title { display: block; font-size: 36rpx; font-weight: 700; color: $edu-text-primary; margin-bottom: 32rpx; }
.sheet-input {
  width: 100%; height: 96rpx; box-sizing: border-box; padding: 0 28rpx; margin-bottom: 20rpx;
  border-radius: 24rpx; border: 2rpx solid $edu-outline; font-size: 30rpx; color: $edu-text-primary;
  background-color: rgba(255, 255, 255, 0.6);
}
.sheet-textarea {
  width: 100%; min-height: 120rpx; box-sizing: border-box; padding: 20rpx 28rpx; margin-bottom: 20rpx;
  border-radius: 24rpx; border: 2rpx solid $edu-outline; font-size: 30rpx; color: $edu-text-primary;
  background-color: rgba(255, 255, 255, 0.6);
}
.sheet-ph { font-size: 28rpx; color: $edu-text-hint; }
.sheet-field {
  display: flex; align-items: center; height: 96rpx; padding: 0 28rpx; margin-bottom: 20rpx;
  border-radius: 24rpx; border: 2rpx solid $edu-outline; background-color: rgba(255, 255, 255, 0.6);
}
.sheet-field-label { font-size: 30rpx; color: $edu-text-secondary; flex: 1; }
.sheet-field-value { font-size: 30rpx; color: $edu-text-primary; }
.sheet-field-arrow { font-size: 36rpx; color: $edu-text-hint; margin-left: 12rpx; }
.sheet-sub { display: block; font-size: 28rpx; color: $edu-text-secondary; margin: 12rpx 0 16rpx; }
.pri-picker-row { display: flex; align-items: center; margin-bottom: 20rpx; }
.pri-pill {
  height: 72rpx; padding: 0 44rpx; border-radius: 36rpx; margin-right: 20rpx;
  display: flex; align-items: center; justify-content: center; background-color: $edu-surface-variant;
}
.pri-pill-active { background-color: $edu-primary; .pri-pill-text { color: #FFFFFF; font-weight: 600; } }
.pri-pill-text { font-size: 28rpx; color: $edu-text-secondary; }
.sheet-error { display: block; font-size: 26rpx; color: $edu-error-text; margin-bottom: 20rpx; }
.sheet-actions { display: flex; align-items: center; margin-top: 16rpx; }
.sheet-btn { flex: 1; height: 96rpx; border-radius: 48rpx; display: flex; align-items: center; justify-content: center; }
.sheet-btn-cancel { margin-right: 24rpx; background-color: $edu-surface-variant; }
.sheet-cancel-text { font-size: 32rpx; color: $edu-text-secondary; }
.sheet-btn-save { @include eduBrandGradient; box-shadow: 0 8rpx 24rpx rgba(54, 119, 239, 0.3); }
.sheet-btn-disabled { opacity: 0.6; box-shadow: none; }
.sheet-save-text { font-size: 32rpx; font-weight: 600; color: #FFFFFF; }
</style>
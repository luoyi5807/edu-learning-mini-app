<template>
  <view class="note-detail-page" :class="themeClass">
    <view class="nav-bar" :style="{ paddingTop: statusBarHeight + 'px' }">
      <view class="nav-bar-inner" :style="{ height: navContentHeight + 'px' }">
        <view class="nav-back" @tap="goBack">
          <text class="back-icon">←</text>
        </view>
        <text class="nav-title">笔记详情</text>
      </view>
    </view>
    <view class="nav-placeholder" :style="{ height: (statusBarHeight + navContentHeight) + 'px' }"></view>

    <block v-if="note">
      <view class="note-card" v-if="note">
        <text class="note-title">{{ note.title }}</text>
        <view class="note-meta">
          <text class="note-tag">{{ note.sourceType === 2 ? '视频笔记' : '文章笔记' }}</text>
          <text class="note-time">{{ note.createTime }}</text>
        </view>
        <block v-if="!editing">
          <text class="note-content">{{ note.content || note.summary || '(无正文)' }}</text>
        </block>
        <block v-else>
          <textarea class="edit-textarea" v-model="editContent" placeholder="编辑笔记内容…" :maxlength="500" auto-height />
          <view class="edit-actions">
            <text class="edit-btn edit-cancel" @tap="cancelEdit">取消</text>
            <text class="edit-btn edit-save" @tap="saveEdit">{{ savingEdit ? '保存中…' : '保存' }}</text>
          </view>
        </block>
        <view class="note-progress" v-if="note.sourceType === 2 && note.videoTimestamp">
          <text class="note-progress-text">📍 记录时播放进度 {{ note.videoTimestamp }}</text>
        </view>
      </view>

      <view class="source-card" v-if="!note.sourceDeleted" @tap="openSource">
        <view class="source-left">
          <text class="source-label">来自{{ note.sourceType === 2 ? '课程' : '文章' }}</text>
          <text class="source-title">{{ note.sourceTitle || '查看原文' }}</text>
        </view>
        <text class="source-arrow">›</text>
      </view>
      <view class="source-card source-card-dead" v-else>
        <view class="source-left">
          <text class="source-label">来源</text>
          <text class="source-title source-title-dead">该内容已被删除</text>
        </view>
      </view>

      <view class="op-row" v-if="!editing">
        <view class="op-btn op-edit" @tap="startEdit"><text class="op-edit-text">编辑</text></view>
        <view class="op-btn op-del" @tap="handleDelete"><text class="op-del-text">删除</text></view>
      </view>
    </block>

    <view class="loading-wrap" v-else>
      <text class="loading-text">{{ loading ? '加载中…' : '笔记不存在或已删除' }}</text>
    </view>
  </view>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { onLoad } from '@dcloudio/uni-app'
import { getNotesApi, deleteNoteApi, updateNoteApi, type NoteDto } from '@/api/notes'
import { useTheme } from '@/composables/useTheme'

const { themeClass } = useTheme()

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

const noteId = ref<number>(0)
const note = ref<NoteDto | null>(null)
const loading = ref<boolean>(true)
const editing = ref<boolean>(false)
const editContent = ref<string>('')
const savingEdit = ref<boolean>(false)

onLoad(async (query) => {
  noteId.value = Number((query && query.noteId) || 0)
  try {
    const list = await getNotesApi()
    note.value = list.find((n) => n.noteId === noteId.value) || null
  } catch (e) { /* 拉取失败走下方提示 */ } finally {
    loading.value = false
  }
})

function openSource() {
  const n = note.value
  if (!n) return
  if (n.sourceType === 2) {
    uni.navigateTo({ url: `/pages-sub/player/player?courseId=${n.sourceId}` })
  } else {
    uni.navigateTo({ url: `/pages-sub/article/detail?articleId=${n.sourceId}` })
  }
}

function handleDelete() {
  const n = note.value
  if (!n) return
  uni.showModal({
    title: '删除笔记',
    content: '删除后不可恢复，确定删除这条笔记吗？',
    confirmText: '删除',
    confirmColor: '#E53935',
    success: async (m) => {
      if (!m.confirm) return
      try {
        await deleteNoteApi(n.noteId)
        uni.showToast({ title: '已删除', icon: 'success' })
        setTimeout(goBack, 600)
      } catch (e) {
        uni.showToast({ title: '删除失败', icon: 'none' })
      }
    }
  })
}

function goBack() {
  const pages = getCurrentPages()
  if (pages.length > 1) uni.navigateBack()
  else uni.reLaunch({ url: '/pages/index/index' })
}

function startEdit() {
  if (!note.value) return
  editContent.value = note.value.content || note.value.summary || ''
  editing.value = true
}
function cancelEdit() { editing.value = false }
async function saveEdit() {
  const n = note.value
  const text = editContent.value.trim()
  if (!n || !text) { uni.showToast({ title: '内容不能为空', icon: 'none' }); return }
  if (savingEdit.value) return
  savingEdit.value = true
  try {
    await updateNoteApi(n.noteId, { sourceType: n.sourceType, sourceId: n.sourceId, title: n.title.slice(0, 20), content: text })
    note.value = { ...n, content: text, summary: text.slice(0, 60) }
    editing.value = false
    uni.showToast({ title: '已保存', icon: 'success' })
  } catch (e) {
    uni.showToast({ title: '保存失败', icon: 'none' })
  } finally {
    savingEdit.value = false
  }
}

</script>

<style lang="scss" scoped>
.note-detail-page { min-height: 100vh; box-sizing: border-box; padding: 0 32rpx 60rpx; @include eduPageGradientStrong; }

.nav-bar { position: fixed; top: 0; left: 0; right: 0; z-index: 99; background: transparent; }
.nav-bar-inner { display: flex; align-items: center; padding-left: 16rpx; }
.nav-back { width: 72rpx; height: 72rpx; display: flex; align-items: center; justify-content: center; }
.back-icon { font-size: 44rpx; color: $edu-text-primary; }
.nav-title { font-size: 40rpx; font-weight: 700; color: $edu-text-primary; margin-left: 8rpx; flex: 1; }
.nav-del { padding: 12rpx 24rpx; }
.nav-del-text { font-size: 28rpx; color: $edu-error-text; font-weight: 600; }

.edit-textarea { width: 100%; min-height: 320rpx; margin-top: 28rpx; padding: 24rpx; box-sizing: border-box; border-radius: 20rpx; background-color: $edu-surface-variant; font-size: 30rpx; color: $edu-text-primary; line-height: 1.7; }
.edit-actions { display: flex; align-items: center; justify-content: flex-end; margin-top: 24rpx; }
.edit-btn { font-size: 30rpx; padding: 16rpx 48rpx; border-radius: 44rpx; margin-left: 24rpx; }
.edit-cancel { color: $edu-text-secondary; background-color: $edu-surface-variant; }
.edit-save { color: #FFFFFF; font-weight: 600; @include eduBrandGradient; }

.note-card { margin-top: 24rpx; padding: 36rpx; border-radius: 28rpx; background-color: $edu-surface; box-shadow: 0 8rpx 24rpx rgba(0, 0, 0, 0.04); }
.note-title { display: block; font-size: 38rpx; font-weight: 800; color: $edu-text-primary; line-height: 1.4; }
.note-meta { display: flex; align-items: center; margin-top: 16rpx; }
.note-tag { font-size: 24rpx; color: $edu-primary; font-weight: 600; background-color: $edu-primary-container; padding: 6rpx 20rpx; border-radius: 20rpx; margin-right: 20rpx; }
.note-time { font-size: 24rpx; color: $edu-text-hint; }
.note-content { display: block; white-space: pre-line; font-size: 32rpx; color: $edu-text-secondary; line-height: 1.7; margin-top: 28rpx; }
.note-progress { margin-top: 24rpx; }
.note-progress-text { font-size: 26rpx; color: $edu-accent-teal; }

.source-card { display: flex; align-items: center; justify-content: space-between; margin-top: 24rpx; padding: 32rpx 36rpx; border-radius: 28rpx; @include eduSurfaceWash; }
.source-left { flex: 1; }
.source-label { display: block; font-size: 24rpx; color: $edu-text-hint; }
.source-title { display: block; font-size: 30rpx; font-weight: 600; color: $edu-text-primary; margin-top: 8rpx; line-height: 1.4; }
.source-title-dead { color: $edu-text-hint; }
.source-arrow { font-size: 48rpx; color: $edu-text-hint; margin-left: 16rpx; }
.source-card-dead { opacity: 0.6; }

.op-row { display: flex; align-items: center; margin-top: 32rpx; }
.op-btn { flex: 1; height: 88rpx; border-radius: 44rpx; display: flex; align-items: center; justify-content: center; }
.op-edit { border: 2rpx solid $edu-primary; background-color: transparent; margin-right: 24rpx; }
.op-edit-text { font-size: 30rpx; font-weight: 600; color: $edu-primary; }
.op-del { background-color: #FBE0DE; }
.op-del-text { font-size: 30rpx; font-weight: 600; color: $edu-error-text; }

.loading-wrap { display: flex; justify-content: center; padding: 160rpx 0; }
.loading-text { font-size: 28rpx; color: $edu-text-hint; }

</style>
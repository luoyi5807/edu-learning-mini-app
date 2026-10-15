<template>
  <view class="comments-sheet" v-if="visible">
    <view class="sheet-mask" @tap="emit('close')"></view>
    <view class="sheet-panel">
      <view class="sheet-handle"></view>
      <view class="sheet-header">
        <text class="sheet-title">评论</text>
        <text class="sheet-count">{{ total }}</text>
      </view>

      <scroll-view class="comment-scroll" scroll-y :show-scrollbar="false">
        <LoadingState v-if="state === 'loading'" inline text="加载评论…" />
        <EmptyState v-else-if="comments.length === 0" text="还没有评论，抢占沙发" />
        <view v-else class="comment-list">
          <view v-for="c in comments" :key="c.commentId" class="comment-item">
            <view class="c-avatar"><text class="c-avatar-char">{{ charOf(c.nickName) }}</text></view>
            <view class="c-body">
              <text class="c-name">{{ c.nickName }}</text>
              <text class="c-content">{{ c.content }}</text>
              <view class="c-foot">
                <text class="c-time">{{ c.createTime }}</text>
                <text class="c-reply-btn" @tap="startReply(c)">回复</text>
                <text class="c-like" :class="{ 'c-like-on': c.isLiked }" @tap="handleLike(c)">{{ c.isLiked ? '♥' : '♡' }} {{ c.likeCount }}</text>
              </view>

              <!-- 楼中楼：灰底框，预览 2 条 + 展开/收起 -->
              <view class="reply-list" v-if="visibleReplies(c).length">
                <view class="reply-item" v-for="r in visibleReplies(c)" :key="r.commentId">
                  <text class="reply-name">{{ r.nickName }}</text>
                  <text v-if="r.replyToUserName" class="reply-to"> 回复 {{ r.replyToUserName }}</text>
                  <text class="reply-colon">：</text>
                  <text class="reply-content">{{ r.content }}</text>
                  <text class="reply-btn" @tap="startReply(r, c)">回复</text>
                </view>
              </view>
              <text class="view-replies" v-if="(c.replyCount || 0) > PREVIEW_COUNT" @tap="toggleExpand(c)">
                {{ isExpanded(c) ? '收起 ⌃' : '展开 ' + c.replyCount + ' 条回复 ⌄' }}
              </text>
            </view>
          </view>
        </view>
      </scroll-view>

      <!-- 底部输入框（与社区一致） -->
      <view class="input-area">
        <view class="reply-banner" v-if="replyTarget">
          <text class="reply-banner-text">正在回复 @{{ replyTarget.nickName }}</text>
          <text class="reply-banner-close" @tap="cancelReply">×</text>
        </view>
        <view class="input-row">
          <input
              class="c-input"
              v-model="draft"
              :focus="inputFocus"
              :placeholder="placeholder"
              placeholder-class="c-ph"
              confirm-type="send"
              @confirm="handleSend"
          />
          <view class="c-send" :class="{ 'c-send-disabled': !draft.trim() || sending }" @tap="handleSend">
            <text class="c-send-text">{{ sending ? '…' : (replyTarget ? '回复' : '发送') }}</text>
          </view>
        </view>
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { ref, computed, watch } from 'vue'
import LoadingState from '@/components/LoadingState.vue'
import EmptyState from '@/components/EmptyState.vue'
import { getCommentsApi, getRepliesApi, addCommentApi, likeCommentApi } from '@/api/comment'
import type { CommentDto } from '@/types/article'

const props = defineProps<{
  visible: boolean
  targetType: number
  targetId: number
}>()
const emit = defineEmits(['close'])

const PREVIEW_COUNT = 2
const comments = ref<CommentDto[]>([])
const state = ref<'loading' | 'ready'>('loading')
const total = ref<number>(0)
const expanded = ref<Record<number, boolean>>({})

const draft = ref<string>('')
const sending = ref<boolean>(false)
const inputFocus = ref<boolean>(false)

interface ReplyTarget { rootId: number; parentId: number; userId: number; nickName: string }
const replyTarget = ref<ReplyTarget | null>(null)
const placeholder = computed<string>(() => (replyTarget.value ? '回复 @' + replyTarget.value.nickName : '说点什么...'))

function charOf(name: string): string { return (name || 'U').charAt(0) }

async function load() {
  if (!props.targetId) return
  state.value = 'loading'
  expanded.value = {}
  try {
    const res = await getCommentsApi(props.targetType, props.targetId)
    comments.value = (res as any).list || []
    total.value = comments.value.length
  } catch (e) {
    comments.value = []
  } finally {
    state.value = 'ready'
  }
}

watch(() => [props.visible, props.targetId], ([v]) => { if (v) load() })

function isExpanded(c: CommentDto): boolean { return !!expanded.value[c.commentId] }
function visibleReplies(c: CommentDto): CommentDto[] {
  const l = c.replies || []
  return isExpanded(c) ? l : l.slice(0, PREVIEW_COUNT)
}
async function toggleExpand(c: CommentDto) {
  if (!isExpanded(c) && (c.replies || []).length < (c.replyCount || 0)) {
    const res = await getRepliesApi(c.commentId)
    const list = (res as any).list || []
    const idx = comments.value.findIndex((x) => x.commentId === c.commentId)
    if (idx >= 0) comments.value[idx] = { ...comments.value[idx], replies: list }
  }
  expanded.value = { ...expanded.value, [c.commentId]: !isExpanded(c) }
}

async function handleLike(c: CommentDto) {
  const idx = comments.value.findIndex((x) => x.commentId === c.commentId)
  comments.value[idx] = { ...c, isLiked: !c.isLiked, likeCount: c.likeCount + (c.isLiked ? -1 : 1) }
  try { await likeCommentApi(c.commentId, c.isLiked) } catch (e) { comments.value[idx] = c }
}

function openInput() { inputFocus.value = false; setTimeout(() => { inputFocus.value = true }, 30) }
function startReply(target: CommentDto, root?: CommentDto) {
  const rootId = root ? root.commentId : target.commentId
  replyTarget.value = { rootId, parentId: target.commentId, userId: target.userId, nickName: target.nickName }
  openInput()
}
function cancelReply() { replyTarget.value = null }

async function refreshReplies(rootId: number) {
  const res = await getRepliesApi(rootId)
  const list = (res as any).list || []
  const idx = comments.value.findIndex((x) => x.commentId === rootId)
  if (idx >= 0) comments.value[idx] = { ...comments.value[idx], replies: list, replyCount: list.length }
}

async function handleSend() {
  const text = draft.value.trim()
  if (!text || sending.value) return
  sending.value = true
  const target = replyTarget.value
  try {
    await addCommentApi({
      targetType: props.targetType,
      targetId: props.targetId,
      rootId: target ? target.rootId : undefined,
      parentId: target ? target.parentId : undefined,
      replyToUserId: target ? target.userId : undefined,
      replyToUserName: target ? target.nickName : undefined,
      content: text
    })
    draft.value = ''
    replyTarget.value = null
    if (target) await refreshReplies(target.rootId)
    else await load()
    uni.showToast({ title: target ? '回复成功' : '评论成功', icon: 'none' })
  } catch (e) {
    uni.showToast({ title: '评论失败', icon: 'none' })
  } finally {
    sending.value = false
  }
}
</script>

<style lang="scss" scoped>
.comments-sheet { position: fixed; top: 0; left: 0; right: 0; bottom: 0; z-index: 300; }
.sheet-mask { position: absolute; top: 0; left: 0; right: 0; bottom: 0; background: rgba(0, 0, 0, 0.4); }
.sheet-panel {
  position: absolute; left: 0; right: 0; bottom: 0; height: 76vh;
  background-color: $edu-surface; border-radius: 32rpx 32rpx 0 0;
  display: flex; flex-direction: column;

}
.sheet-handle { width: 72rpx; height: 8rpx; border-radius: 4rpx; background: $edu-outline; margin: 16rpx auto 0; }
.sheet-header { display: flex; align-items: baseline; justify-content: space-between; padding: 20rpx 32rpx 8rpx; }
.sheet-title { font-size: 34rpx; font-weight: 700; color: $edu-text-primary; }
.sheet-count { font-size: 26rpx; color: $edu-text-hint; }

/* 顶部输入框 */
.input-area { padding: 16rpx 32rpx calc(16rpx + env(safe-area-inset-bottom)); border-top: 2rpx solid $edu-divider; }
.reply-banner { display: flex; align-items: center; justify-content: space-between; padding: 10rpx 20rpx; margin-bottom: 12rpx; border-radius: 16rpx; background-color: $edu-surface-variant; }
.reply-banner-text { font-size: 24rpx; color: $edu-text-secondary; }
.reply-banner-close { font-size: 36rpx; color: $edu-text-hint; padding: 0 12rpx; line-height: 1; }
.input-row { display: flex; align-items: center; }
.c-input { flex: 1; height: 80rpx; border-radius: 40rpx; background-color: $edu-surface-variant; padding: 0 28rpx; font-size: 28rpx; color: $edu-text-primary; }
.c-ph { color: $edu-text-hint; font-size: 28rpx; }
.c-send { margin-left: 20rpx; height: 80rpx; padding: 0 40rpx; border-radius: 40rpx; display: flex; align-items: center; justify-content: center; @include eduBrandGradient; }
.c-send-text { font-size: 28rpx; font-weight: 600; color: #FFFFFF; }
.c-send-disabled { background-color: $edu-surface-variant; .c-send-text { color: $edu-text-hint; } }

/* 评论列表 */
.comment-scroll { flex: 1; min-height: 0; padding: 0 32rpx; box-sizing: border-box; }
.comment-list { padding: 24rpx 0; }
.comment-item { display: flex; align-items: flex-start; margin-bottom: 32rpx; }
.c-avatar { width: 64rpx; height: 64rpx; border-radius: 50%; background-color: $edu-primary-container; display: flex; align-items: center; justify-content: center; flex-shrink: 0; }
.c-avatar-char { font-size: 30rpx; font-weight: 700; color: #0C2C6B; }
.c-body { flex: 1; margin-left: 16rpx; min-width: 0; }
.c-name { display: block; font-size: 28rpx; font-weight: 600; color: $edu-text-secondary; }
.c-content { display: block; font-size: 30rpx; color: $edu-text-primary; line-height: 1.5; margin-top: 8rpx; }
.c-foot { display: flex; align-items: center; margin-top: 12rpx; }
.c-time { font-size: 24rpx; color: $edu-text-hint; }
.c-reply-btn { font-size: 24rpx; color: $edu-text-secondary; margin-left: auto; padding: 4rpx 0; }
.c-like { font-size: 26rpx; color: $edu-text-secondary; margin-left: 28rpx; }
.c-like-on { color: #FF4D6A; }

.reply-list { margin-top: 16rpx; padding: 16rpx 20rpx; border-radius: 16rpx; background-color: $edu-surface-variant; }
.reply-item { display: flex; flex-wrap: wrap; align-items: baseline; margin-bottom: 12rpx; }
.reply-item:last-child { margin-bottom: 0; }
.reply-name { font-size: 26rpx; font-weight: 600; color: $edu-text-secondary; flex-shrink: 0; }
.reply-to { font-size: 26rpx; color: $edu-primary; flex-shrink: 0; }
.reply-colon { font-size: 26rpx; color: $edu-text-secondary; flex-shrink: 0; }
.reply-content { font-size: 26rpx; color: $edu-text-primary; line-height: 1.5; flex: 1; min-width: 0; }
.reply-btn { font-size: 24rpx; color: $edu-primary; padding: 4rpx 12rpx; margin-left: 16rpx; flex-shrink: 0; }
.view-replies { display: block; font-size: 26rpx; color: $edu-primary; margin-top: 12rpx; }
</style>
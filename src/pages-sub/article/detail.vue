<template>
  <view class="article-detail-page" :class="themeClass">
    <view class="nav-bar" :class="{ 'nav-bar-opaque': navBarOpaque }" :style="{ paddingTop: statusBarHeight + 'px' }">
      <view class="nav-bar-inner" :style="{ height: navContentHeight + 'px', paddingRight: capsuleGap + 'px' }">
        <view class="nav-back" @tap="goBack"><text class="back-icon">←</text></view>
        <text class="nav-title">文章详情</text>
        <view class="nav-ai-group">
          <view class="nav-ask" @tap="askAixing">
            <view class="nav-ask-avatar"><text class="nav-ask-avatar-emoji">✦</text></view>
            <text class="nav-ask-text">问阿星</text>
          </view>
        </view>
      </view>
    </view>
    <view class="nav-placeholder" :style="{ height: (statusBarHeight + navContentHeight) + 'px' }"></view>

    <LoadingState v-if="state === 'loading'" text="正在加载…" />
    <ErrorState v-else-if="state === 'error'" text="加载失败" @retry="loadDetail" />
    <block v-else-if="article">
      <scroll-view class="content-scroll" scroll-y :show-scrollbar="false" :scroll-into-view="scrollInto" scroll-with-animation>
        <text class="article-title">{{ article.title }}</text>

        <view class="author-row">
          <view class="author-left" @tap="goAuthor">
            <view class="author-avatar">
              <image v-if="article.authorAvatar" class="author-avatar-img" :src="article.authorAvatar" mode="aspectFill" />
              <text v-else class="author-char">{{ charOf(article.authorName) }}</text>
            </view>
            <view class="author-info">
              <text class="author-name">{{ article.authorName }}</text>
              <text class="publish-time">{{ article.publishTime }}</text>
            </view>
          </view>
          <view class="author-right">
            <text class="category-tag" v-if="article.categoryName">{{ article.categoryName }}</text>
            <view class="follow-btn" v-if="!isSelfAuthor" :class="{ 'follow-btn-done': isFollowed }" @tap="toggleFollowAuthor">
              <text class="follow-btn-text">{{ isFollowed ? '已关注' : '＋ 关注' }}</text>
            </view>
          </view>
        </view>

        <view class="tag-row" v-if="article.tags && article.tags.length">
          <text class="tag-chip" v-for="t in article.tags" :key="t.tagId" @tap="goTag(t)">#{{ t.tagName }}</text>
        </view>

        <view class="rich-content"><rich-text :nodes="article.content" /></view>

        <view class="prev-next">
          <text class="pn-item" v-if="article.prevArticle" @tap="goArticle(article.prevArticle!.articleId)">‹ {{ article.prevArticle.title }}</text>
          <text class="pn-item pn-right" v-if="article.nextArticle" @tap="goArticle(article.nextArticle!.articleId)">{{ article.nextArticle.title }} ›</text>
        </view>

        <AdBanner :adpid="AD_PID_BANNER" :unit-id="AD_BANNER_ARTICLE" scene="文章" />

        <view class="comment-section">
          <text class="comment-header">评论 {{ article.commentCount }}</text>
          <EmptyState v-if="comments.length === 0" text="还没有评论，抢占沙发" />
          <view v-for="c in comments" :key="c.commentId" :id="'comment-' + c.commentId" class="comment-item" :class="{ 'comment-hl': highlightComment === c.commentId }">
            <view class="author-avatar sm" @tap="goUser(c.userId)">
              <image v-if="c.avatar" class="author-avatar-img" :src="c.avatar" mode="aspectFill" />
              <text v-else class="author-char">{{ charOf(c.nickName) }}</text>
            </view>
            <view class="comment-body">
              <text class="comment-name" @tap="goUser(c.userId)">{{ c.nickName }}</text>
              <text class="comment-content">{{ c.content }}</text>
              <view class="comment-foot">
                <text class="comment-time">{{ c.createTime }}</text>
                <text class="comment-reply-btn" @tap="startReply(c)">回复</text>
                <text class="comment-like" @tap="handleLikeComment(c)">{{ c.isLiked ? '♥' : '♡' }} {{ c.likeCount }}</text>
              </view>

              <!-- 楼中楼回复：预览 2 条 + 展开/收起 -->
              <view class="reply-list" v-if="visibleReplies(c).length">
                <view class="reply-item" v-for="r in visibleReplies(c)" :key="r.commentId">
                  <view class="reply-main">
                    <text class="reply-name" @tap="goUser(r.userId)">{{ r.nickName }}</text>
                    <text v-if="r.replyToUserName" class="reply-to" @tap="goUser(r.replyToUserId || 0)"> 回复 {{ r.replyToUserName }}</text>
                    <text class="reply-colon">：</text>
                    <text class="reply-content">{{ r.content }}</text>
                  </view>
                  <view class="reply-actions">
                    <text class="reply-btn" @tap="startReply(r, c)">回复</text>
                  </view>
                </view>
              </view>
              <text class="view-replies" v-if="(c.replyCount || 0) > 2" @tap="toggleReplies(c)">{{ isReplyExpanded(c) ? '收起 ⌃' : '展开 ' + c.replyCount + ' 条回复 ⌄' }}</text>
            </view>
          </view>
        </view>
        <view class="bottom-space"></view>
      </scroll-view>

      <!-- 底部互动栏 -->
      <view class="action-bar">
        <view class="reply-banner" v-if="replyTarget">
          <text class="reply-banner-text">正在回复 @{{ replyTarget.nickName }}</text>
          <text class="reply-banner-close" @tap="cancelReply">×</text>
        </view>
        <view class="input-row">
          <input
              class="comment-input"
              v-model="draft"
              :focus="inputFocus"
              :placeholder="inputPlaceholder"
              placeholder-class="comment-ph"
              confirm-type="send"
              @confirm="handleSend"
          />
          <view class="send-btn" :class="{ 'send-btn-disabled': !draft.trim() || sending }" @tap="handleSend">
            <text class="send-text">{{ sending ? '…' : (replyTarget ? '回复' : '发送') }}</text>
          </view>
        </view>
        <view class="icon-row">
          <view class="icon-item" @tap="handleLike">
            <text class="icon-glyph" :class="{ 'icon-liked': article.isLiked }">{{ article.isLiked ? '❤' : '♡' }}</text>
            <text class="icon-num">{{ article.likeCount }}</text>
          </view>
          <view class="icon-item" @tap="openInput">
            <text class="icon-glyph">💬</text>
            <text class="icon-num">{{ article.commentCount }}</text>
          </view>
          <view class="icon-item" @tap="openNoteSheet">
            <text class="icon-glyph">📝</text>
            <text class="icon-num">笔记</text>
          </view>
          <view class="icon-item" @tap="handleFavorite">
            <text class="icon-glyph" :class="{ 'icon-faved': article.isFavorited }">{{ article.isFavorited ? '★' : '☆' }}</text>
            <text class="icon-num">收藏</text>
          </view>
        </view>
      </view>

      <!-- 记笔记弹层 -->
      <view class="note-mask" v-if="showNote" @tap="closeNoteSheet"></view>
      <view class="note-sheet" v-if="showNote">
        <text class="note-sheet-title">记笔记</text>
        <text class="note-sheet-sub">来源：{{ article.title }}</text>
        <textarea class="note-textarea" v-model="noteContent" placeholder="记录你的想法…" placeholder-class="comment-ph" :maxlength="500" auto-height />
        <view class="note-actions">
          <text class="note-btn note-cancel" @tap="closeNoteSheet">取消</text>
          <text class="note-btn note-save" @tap="saveNote">{{ noteSaving ? '保存中…' : '保存' }}</text>
        </view>
      </view>

      <!-- 问阿星：帖子内半屏问答弹层（图11/12）-->
      <AgentPostSheet :visible="askVisible" :title="article.title" @close="askVisible = false" />
    </block>
  </view>
</template>

<script setup lang="ts">
import { computed, ref } from 'vue'
import { onLoad, onUnload } from '@dcloudio/uni-app'
import LoadingState from '@/components/LoadingState.vue'
import ErrorState from '@/components/ErrorState.vue'
import EmptyState from '@/components/EmptyState.vue'
import AdBanner from '@/components/AdBanner.vue'
import { AD_BANNER_ARTICLE } from '@/config/env'
import { useAuthStore } from '@/store/auth'
import { getArticleDetailApi } from '@/api/article'
import { getCommentsApi, getRepliesApi, addCommentApi, likeCommentApi, locateCommentApi } from '@/api/comment'
import { toggleLikeApi, toggleFavoriteApi, reportShareApi } from '@/api/interaction'
import { addNoteApi } from '@/api/notes'
import { followUserApi, unfollowUserApi, getFollowStatusApi } from '@/api/user'
import { reportWatchApi } from '@/api/points'
import { reportHistoryApi } from '@/api/interaction'
import { CONTENT_MIN_SECONDS } from '@/composables/pointsRule'
import { useTheme } from '@/composables/useTheme'
import AgentPostSheet from '@/components/AgentPostSheet.vue'
import type { ArticleDetailDto, ArticleTag, CommentDto } from '@/types/article'

const auth = useAuthStore()
const { themeClass } = useTheme()

const statusBarHeight = ref<number>(0)
const navContentHeight = ref<number>(44)
const capsuleGap = ref<number>(0)
const sysInfo = uni.getSystemInfoSync()
statusBarHeight.value = sysInfo.statusBarHeight || 0
// #ifdef MP-WEIXIN
const menuButton = uni.getMenuButtonBoundingClientRect()
if (menuButton) {
  navContentHeight.value = (menuButton.top - statusBarHeight.value) * 2 + menuButton.height
  capsuleGap.value = Math.max(0, sysInfo.windowWidth - menuButton.left) + 8
}
// #endif
const navBarOpaque = ref<boolean>(false)

const articleId = ref<number>(0)
const article = ref<ArticleDetailDto | null>(null)
const comments = ref<CommentDto[]>([])
const state = ref<'loading' | 'error' | 'ready'>('loading')

/* ===== 通知精准跳转：进页后定位到具体评论（仅执行一次） ===== */
const locateComment = ref<number>(0)
const highlightComment = ref<number>(0)
const scrollInto = ref<string>('')
let locatedDone = false

const draft = ref<string>('')
const sending = ref<boolean>(false)
const inputFocus = ref<boolean>(false)

interface ReplyTarget { rootId: number; parentId: number; userId: number; nickName: string }
const replyTarget = ref<ReplyTarget | null>(null)
const inputPlaceholder = computed<string>(() =>
    replyTarget.value ? '回复 @' + replyTarget.value.nickName : '说点什么...'
)

const showNote = ref<boolean>(false)
const noteContent = ref<string>('')
const noteSaving = ref<boolean>(false)

const askVisible = ref<boolean>(false)

/* 问阿星：打开帖子内问答弹层（不再跳助手页） */
function askAixing() {
  if (!article.value) return
  askVisible.value = true
}

/* ===== 关注作者（复用 /api/v1/follow add/cancel/status，本人不显示）===== */
const isFollowed = ref<boolean>(false)
const isSelfAuthor = computed<boolean>(() => {
  const myId = auth.state.user?.userId
  return !!article.value && Number(article.value.authorId) === Number(myId)
})
async function loadFollowState() {
  if (!article.value || isSelfAuthor.value) { isFollowed.value = false; return }
  try {
    const ids = await getFollowStatusApi([article.value.authorId])
    isFollowed.value = ids.indexOf(article.value.authorId) >= 0
  } catch (e) { isFollowed.value = false }
}
async function toggleFollowAuthor() {
  if (!article.value || isSelfAuthor.value) return
  const target = article.value.authorId
  try {
    const res = isFollowed.value ? await unfollowUserApi(target) : await followUserApi(target)
    isFollowed.value = !!res.active
    uni.showToast({ title: isFollowed.value ? '已关注' : '已取消关注', icon: 'none' })
  } catch (e) { uni.showToast({ title: '操作失败', icon: 'none' }) }
}

/* ===== 阅读计时：停留满 30 秒上报一次，服务端按天去重 ===== */
let readTimer: ReturnType<typeof setTimeout> | null = null
function stopReadTimer() { if (readTimer) { clearTimeout(readTimer); readTimer = null } }
function startReadTimer() {
  stopReadTimer()
  if (!articleId.value) return
  readTimer = setTimeout(async () => {
    try { await reportWatchApi('post', articleId.value, CONTENT_MIN_SECONDS) } catch (e) { /* 静默，不打扰用户 */ }
  }, CONTENT_MIN_SECONDS * 1000)
}

async function loadDetail() {
  state.value = 'loading'
  try {
    article.value = await getArticleDetailApi(articleId.value)
    state.value = 'ready'
    loadFollowState()
    loadComments()
    startReadTimer()
    reportHistoryApi({ targetType: 'post', targetId: articleId.value }).catch(() => {})
    if (locateComment.value) handleLocateComment()
  } catch (e) {
    state.value = 'error'
  }
}

async function loadComments(page = 1) {
  const res = await getCommentsApi(1, articleId.value, undefined, 20, page)
  comments.value = (res as any).list || []
  if (article.value) article.value = { ...article.value, commentCount: comments.value.length }
}

/** GET /comment/locate：拿目标评论所在页码/所属一级评论，翻页加载后滚动高亮 */
async function handleLocateComment() {
  const id = locateComment.value
  if (!id || locatedDone) return
  locatedDone = true
  try {
    const loc = await locateCommentApi(id)
    if (loc.deleted) { uni.showToast({ title: '该评论已被删除', icon: 'none' }); return }
    if (loc.targetType !== 1 || loc.targetId !== articleId.value) return
    await loadComments(loc.pageNum)
    if (loc.rootId !== id) expandedReplies.value = { ...expandedReplies.value, [loc.rootId]: true }
    highlightComment.value = id
    setTimeout(() => { scrollInto.value = 'comment-' + loc.rootId }, 150)
  } catch (e) { /* 定位失败：保持普通详情页 */ }
}

async function handleViewReplies(c: CommentDto) {
  const res = await getRepliesApi(c.commentId)
  const list = (res as any).list || []
  const idx = comments.value.findIndex((x) => x.commentId === c.commentId)
  if (idx >= 0) comments.value[idx] = { ...comments.value[idx], replies: list }
}

/** 回复成功后只刷新对应根评论的楼中楼，避免其它评论展开状态被重置 */
async function refreshCommentReplies(rootId: number) {
  const res = await getRepliesApi(rootId)
  const list = (res as any).list || []
  const idx = comments.value.findIndex((x) => x.commentId === rootId)
  if (idx >= 0) comments.value[idx] = { ...comments.value[idx], replies: list, replyCount: list.length }
}

async function handleLike() {
  if (!article.value) return
  const before = article.value
  article.value = { ...before, isLiked: !before.isLiked, likeCount: before.likeCount + (before.isLiked ? -1 : 1) }
  try { await toggleLikeApi(1, before.articleId, before.isLiked) }
  catch (e) { article.value = before; uni.showToast({ title: '操作失败', icon: 'none' }) }
}

async function handleFavorite() {
  if (!article.value) return
  const before = article.value
  article.value = { ...before, isFavorited: !before.isFavorited }
  try {
    await toggleFavoriteApi(1, before.articleId, before.isFavorited)
    uni.showToast({ title: article.value.isFavorited ? '已收藏' : '已取消收藏', icon: 'none' })
  } catch (e) { article.value = before }
}

async function handleLikeComment(c: CommentDto) {
  const idx = comments.value.findIndex((x) => x.commentId === c.commentId)
  comments.value[idx] = { ...c, isLiked: !c.isLiked, likeCount: c.likeCount + (c.isLiked ? -1 : 1) }
  try { await likeCommentApi(c.commentId, c.isLiked) } catch (e) { comments.value[idx] = c }
}

function openInput() { inputFocus.value = false; setTimeout(() => { inputFocus.value = true }, 30) }

/** 点击"回复"：root 缺省时表示回复根评论本身 */
function startReply(target: CommentDto, root?: CommentDto) {
  const rootId = root ? root.commentId : target.commentId
  replyTarget.value = {
    rootId,
    parentId: target.commentId,
    userId: target.userId,
    nickName: target.nickName
  }
  openInput()
}
function cancelReply() { replyTarget.value = null }

async function handleSend() {
  const text = draft.value.trim()
  if (!text || sending.value || !article.value) return
  sending.value = true
  const target = replyTarget.value
  try {
    await addCommentApi({
      targetType: 1,
      targetId: article.value.articleId,
      rootId: target ? target.rootId : undefined,
      parentId: target ? target.parentId : undefined,
      replyToUserId: target ? target.userId : undefined,
      replyToUserName: target ? target.nickName : undefined,
      content: text
    })
    draft.value = ''
    replyTarget.value = null
    if (target) {
      await refreshCommentReplies(target.rootId)
    } else {
      await loadComments()
    }
    uni.showToast({ title: target ? '回复成功' : '评论成功', icon: 'none' })
  } catch (e) {
    uni.showToast({ title: '评论失败', icon: 'none' })
  } finally {
    sending.value = false
  }
}

function openNoteSheet() { showNote.value = true }
function closeNoteSheet() { showNote.value = false }
async function saveNote() {
  const text = noteContent.value.trim()
  if (!text) { uni.showToast({ title: '请输入内容', icon: 'none' }); return }
  if (!article.value || noteSaving.value) return
  noteSaving.value = true
  try {
    await addNoteApi({ sourceType: 1, sourceId: article.value.articleId, sourceTitle: article.value.title, title: '《' + article.value.title + '》笔记', content: text })
    noteContent.value = ''
    showNote.value = false
    uni.showToast({ title: '已保存到笔记本', icon: 'success' })
  } catch (e) {
    uni.showToast({ title: '保存失败', icon: 'none' })
  } finally {
    noteSaving.value = false
  }
}

function handleMore() {
  uni.showActionSheet({
    itemList: ['分享', '举报'],
    success: (r) => {
      if (r.tapIndex === 0) { reportShareApi(1, articleId.value, 4); uni.showToast({ title: '已复制链接', icon: 'none' }) }
      else if (r.tapIndex === 1) { uni.showModal({ title: '举报', content: '确认举报该文章违规内容？', confirmColor: '#D04030', success: (m) => { if (m.confirm) uni.showToast({ title: '举报已提交', icon: 'none' }) } }) }
    }
  })
}

function goAuthor() { if (article.value) goUser(article.value.authorId) }
function goTag(t: ArticleTag) { uni.navigateTo({ url: `/pages-sub/article/tag?tagId=${t.tagId}&tagName=${encodeURIComponent(t.tagName)}` }) }
function goArticle(id: number) { articleId.value = id; loadDetail() }

/** 统一跳转用户主页：userId=0 视为自己（mock 中"我"发的评论 userId 为 0） */
function goUser(userId: number) {
  const myId = auth.state.user?.userId
  const target = userId || myId
  if (!target) { uni.showToast({ title: '请先登录', icon: 'none' }); return }
  uni.navigateTo({ url: `/pages-sub/mine/blog-home?userId=${target}` })
}

function goBack() {
  const pages = getCurrentPages()
  if (pages.length > 1) uni.navigateBack()
  else uni.reLaunch({ url: '/pages/index/index' })
}

onLoad((query) => {
  articleId.value = Number((query && query.articleId) || 0)
  locateComment.value = Number((query && (query as any).locateComment) || 0)
  loadDetail()
})

onUnload(stopReadTimer)
</script>

<style lang="scss" scoped>
.article-detail-page {
  height: 100vh; display: flex; flex-direction: column; box-sizing: border-box;
  @include eduPageGradientStrong;
}
.nav-bar {
  position: fixed; top: 0; left: 0; right: 0; z-index: 99; background: transparent;
  transition: background-color 0.3s ease, box-shadow 0.3s ease;
}
.nav-bar-opaque { background: var(--edu-surface); box-shadow: 0 2rpx 12rpx rgba(0, 0, 0, 0.06); }
.nav-bar-inner { display: flex; align-items: center; padding-left: 16rpx; }
.nav-back { width: 72rpx; height: 72rpx; display: flex; align-items: center; justify-content: center; }
.back-icon { font-size: 44rpx; color: $edu-text-primary; }
.nav-title { flex: 1; font-size: 40rpx; font-weight: 700; color: $edu-text-primary; margin-left: 8rpx; }
.more-icon { font-size: 44rpx; color: $edu-text-primary; }
.nav-ai-group { display: flex; align-items: center; }
.nav-ask { display: flex; align-items: center; margin-right: 24rpx; }
.nav-ask-avatar { width: 48rpx; height: 48rpx; border-radius: 50%; @include eduBrandGradient; display: flex; align-items: center; justify-content: center; margin-right: 8rpx; }
.nav-ask-avatar-emoji { font-size: 26rpx; color: #FFFFFF; }
.nav-ask-text { font-size: 30rpx; font-weight: 600; color: $edu-primary; }

.content-scroll { flex: 1; min-height: 0; padding: 0 32rpx; box-sizing: border-box; }
.article-title { display: block; font-size: 48rpx; font-weight: 800; color: $edu-text-primary; line-height: 1.35; margin-top: 24rpx; }
.author-row { display: flex; align-items: center; justify-content: space-between; margin-top: 28rpx; }
.author-left { display: flex; align-items: center; }
.author-avatar { width: 72rpx; height: 72rpx; border-radius: 50%; background-color: $edu-primary-container; display: flex; align-items: center; justify-content: center; overflow: hidden; }
.author-avatar.sm { width: 64rpx; height: 64rpx; }
.author-avatar-img { width: 100%; height: 100%; border-radius: 50%; }
.author-char { font-size: 30rpx; color: #0C2C6B; font-weight: 700; }
.author-info { display: flex; flex-direction: column; margin-left: 16rpx; }
.author-name { font-size: 30rpx; font-weight: 600; color: $edu-text-primary; }
.publish-time { font-size: 24rpx; color: $edu-text-hint; margin-top: 6rpx; }
.category-tag { font-size: 26rpx; color: $edu-primary; background-color: $edu-primary-container; padding: 8rpx 20rpx; border-radius: 12rpx; }
.author-right { display: flex; align-items: center; }
.follow-btn { margin-left: 16rpx; height: 56rpx; padding: 0 28rpx; border-radius: 28rpx; background-color: $edu-primary; display: flex; align-items: center; justify-content: center; }
.follow-btn-text { font-size: 26rpx; color: #FFFFFF; }
.follow-btn-done { background-color: $edu-surface-variant; }
.follow-btn-done .follow-btn-text { color: $edu-text-secondary; }

.tag-row { display: flex; flex-wrap: wrap; margin-top: 24rpx; }
.tag-chip { font-size: 26rpx; color: $edu-primary; background-color: rgba(54, 119, 239, 0.08); padding: 8rpx 20rpx; border-radius: 12rpx; margin: 0 16rpx 16rpx 0; }

.rich-content { margin-top: 24rpx; font-size: 32rpx; line-height: 1.7; color: $edu-text-primary; }
.prev-next { display: flex; flex-direction: column; margin-top: 40rpx; }
.pn-item { font-size: 28rpx; color: $edu-primary; padding: 12rpx 0; }
.pn-right { text-align: right; }

.comment-section { margin-top: 48rpx; padding-top: 32rpx; border-top: 16rpx solid $edu-surface-variant; }
.comment-header { display: block; font-size: 34rpx; font-weight: 700; color: $edu-text-primary; margin-bottom: 24rpx; }
.comment-item { display: flex; align-items: flex-start; margin-bottom: 32rpx; }
.comment-body { flex: 1; margin-left: 16rpx; }
.comment-name { display: block; font-size: 28rpx; font-weight: 600; color: $edu-text-secondary; }
.comment-content { display: block; font-size: 30rpx; color: $edu-text-primary; line-height: 1.5; margin-top: 8rpx; }
.comment-foot { display: flex; align-items: center; margin-top: 12rpx; }
.comment-time { font-size: 24rpx; color: $edu-text-hint; }
.comment-reply-btn { font-size: 24rpx; color: $edu-text-secondary; margin-left: 28rpx; padding: 4rpx 0; }
.comment-like { font-size: 26rpx; color: $edu-text-secondary; margin-left: auto; }

.reply-list { margin-top: 16rpx; padding: 16rpx 20rpx; border-radius: 16rpx; background-color: $edu-surface-variant; }
.reply-item { display: flex; flex-direction: column; margin-bottom: 16rpx; }
.reply-item:last-child { margin-bottom: 0; }
.reply-main { font-size: 26rpx; line-height: 1.5; word-break: break-all; }
.reply-name { font-weight: 600; color: $edu-text-secondary; }
.reply-to { color: $edu-primary; }
.reply-colon { color: $edu-text-secondary; }
.reply-content { color: $edu-text-primary; }
.reply-actions { display: flex; justify-content: flex-end; margin-top: 6rpx; }
.reply-btn { font-size: 24rpx; color: $edu-primary; padding: 4rpx 16rpx; }
.view-replies { display: block; font-size: 26rpx; color: $edu-primary; margin-top: 12rpx; }

/* 通知定位高亮 */
.comment-hl { background-color: rgba(54, 119, 239, 0.08); border-radius: 16rpx; }

.bottom-space { height: 360rpx; }

.action-bar {
  position: fixed; left: 0; right: 0; bottom: 0; z-index: 100;
  background-color: $edu-surface; border-top: 2rpx solid $edu-divider;
  padding: 16rpx 32rpx calc(16rpx + env(safe-area-inset-bottom));
}
.reply-banner {
  display: flex; align-items: center; justify-content: space-between;
  padding: 12rpx 20rpx; margin-bottom: 12rpx;
  border-radius: 16rpx; background-color: $edu-surface-variant;
}
.reply-banner-text { font-size: 24rpx; color: $edu-text-secondary; }
.reply-banner-close { font-size: 36rpx; color: $edu-text-hint; padding: 0 12rpx; line-height: 1; }
.input-row { display: flex; align-items: center; }
.comment-input { flex: 1; height: 80rpx; border-radius: 40rpx; background-color: $edu-surface-variant; padding: 0 28rpx; font-size: 28rpx; color: $edu-text-primary; }
.comment-ph { color: $edu-text-hint; font-size: 28rpx; }
.send-btn { width: 128rpx; height: 80rpx; border-radius: 40rpx; margin-left: 20rpx; display: flex; align-items: center; justify-content: center; @include eduBrandGradient; }
.send-btn-disabled { background-color: $edu-surface-variant; .send-text { color: $edu-text-hint; } }
.send-text { font-size: 28rpx; color: #FFFFFF; font-weight: 600; }
.icon-row { display: flex; align-items: center; justify-content: space-around; margin-top: 16rpx; }
.icon-item { display: flex; flex-direction: column; align-items: center; }
.icon-glyph { font-size: 40rpx; color: $edu-text-secondary; }
.icon-liked { color: #FF4D6A; }
.icon-faved { color: $edu-accent-yellow; }
.icon-num { font-size: 22rpx; color: $edu-text-hint; margin-top: 4rpx; }

.note-mask { position: fixed; top: 0; left: 0; right: 0; bottom: 0; z-index: 200; background: rgba(0, 0, 0, 0.4); }
.note-sheet {
  position: fixed; left: 0; right: 0; bottom: 0; z-index: 201;
  background-color: $edu-surface; border-radius: 32rpx 32rpx 0 0;
  padding: 40rpx 32rpx calc(40rpx + env(safe-area-inset-bottom));
}
.note-sheet-title { display: block; font-size: 34rpx; font-weight: 700; color: $edu-text-primary; }
.note-sheet-sub { display: block; font-size: 24rpx; color: $edu-text-hint; margin-top: 8rpx; }
.note-textarea { width: 100%; min-height: 220rpx; margin-top: 24rpx; padding: 24rpx; box-sizing: border-box; border-radius: 20rpx; background-color: $edu-surface-variant; font-size: 30rpx; color: $edu-text-primary; line-height: 1.6; }
.note-actions { display: flex; align-items: center; justify-content: flex-end; margin-top: 24rpx; }
.note-btn { font-size: 30rpx; padding: 16rpx 48rpx; border-radius: 44rpx; margin-left: 24rpx; }
.note-cancel { color: $edu-text-secondary; background-color: $edu-surface-variant; }
.note-save { color: #FFFFFF; font-weight: 600; @include eduBrandGradient; }
</style>
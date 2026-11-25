<template>
  <view class="publish-page" :class="themeClass">
    <view class="nav-bar" :style="{ paddingTop: statusBarHeight + 'px' }">
      <view class="nav-bar-inner" :style="{ height: navContentHeight + 'px' }">
        <view class="nav-back" @tap="goBack"><text class="back-icon">←</text></view>
        <text class="nav-title">{{ isEdit ? '编辑文章' : '发布文章' }}</text>
      </view>
    </view>
    <view class="nav-placeholder" :style="{ height: (statusBarHeight + navContentHeight) + 'px' }"></view>

    <scroll-view class="form-scroll" scroll-y :show-scrollbar="false">
      <!-- 标题 -->
      <text class="section-label">标题</text>
      <view class="field-card">
        <input class="field-input" v-model="form.title" placeholder="请输入标题" placeholder-class="ph" :maxlength="50" />
      </view>

      <!-- 摘要（选填） -->
      <text class="section-label">摘要（选填）</text>
      <view class="field-card">
        <textarea class="field-textarea-summary" v-model="form.summary" placeholder="一句话概括本文内容" placeholder-class="ph" :maxlength="120" auto-height />
      </view>

      <!-- 分类 -->
      <text class="section-label">分类</text>
      <scroll-view class="chip-scroll" scroll-x :show-scrollbar="false">
        <view class="chip-row">
          <view
              v-for="c in categories"
              :key="c.categoryId"
              class="choice-chip"
              :class="{ 'choice-chip-active': form.categoryId === c.categoryId }"
              @tap="selectCategory(c)"
          >
            <text class="choice-chip-text" :class="{ 'choice-chip-text-active': form.categoryId === c.categoryId }">{{ c.categoryName }}</text>
          </view>
        </view>
      </scroll-view>

      <!-- 标签（对齐安卓：单行横滑） -->
      <text class="section-label">标签（最多选 {{ maxTags }} 个）</text>
      <scroll-view class="chip-scroll" scroll-x :show-scrollbar="false">
        <view class="chip-row">
          <view
              v-for="t in tagPool"
              :key="t.tagId"
              class="choice-chip"
              :class="{ 'choice-chip-active': isTagSelected(t) }"
              @tap="toggleTag(t)"
          >
            <text class="choice-chip-text" :class="{ 'choice-chip-text-active': isTagSelected(t) }">#{{ t.tagName }}</text>
          </view>
        </view>
      </scroll-view>

      <!-- 正文 -->
      <text class="section-label">正文</text>
      <view class="field-card">
        <view class="content-toolbar">
          <view class="toolbar-btn" :class="{ 'toolbar-btn-disabled': inserting }" @tap="insertImage">
            <text class="toolbar-btn-text">{{ inserting ? '上传中…' : '🖼 插入图片' }}</text>
          </view>
          <text class="toolbar-hint">图片上传后插入正文，暂不支持视频</text>
        </view>
        <view class="content-head">
          <text class="content-icon">✏️</text>
          <textarea class="field-textarea-content" v-model="form.content" placeholder="在这里写正文，空行表示分段" placeholder-class="ph" :maxlength="5000" auto-height />
        </view>
      </view>

      <view class="bottom-space"></view>
    </scroll-view>

    <view class="submit-bar">
      <view class="submit-btn submit-publish" :class="{ 'submit-disabled': submitting || !canPublish }" @tap="handlePublish">
        <text class="submit-publish-text">{{ submitting ? '提交中…' : '发布' }}</text>
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { ref, reactive, computed } from 'vue'
import { onLoad } from '@dcloudio/uni-app'
import { publishArticleApi, updateArticleApi, getEditableArticleApi, getArticleTagsApi } from '@/api/article'
import { getArticleCategoryTreeApi, type CategoryNode } from '@/api/category'
import { uploadAvatarApi } from '@/api/user'
import { useTheme } from '@/composables/useTheme'
import type { ArticleTag } from '@/types/article'

const { themeClass } = useTheme()

const statusBarHeight = ref<number>(0)
const navContentHeight = ref<number>(44)
const sysInfo = uni.getSystemInfoSync()
statusBarHeight.value = sysInfo.statusBarHeight || 0
// #ifdef MP-WEIXIN
const menuButton = uni.getMenuButtonBoundingClientRect()
if (menuButton) { navContentHeight.value = (menuButton.top - statusBarHeight.value) * 2 + menuButton.height }
// #endif

const isEdit = ref<boolean>(false)
const editId = ref<number>(0)
const submitting = ref<boolean>(false)
const maxTags = 5

const categories = ref<CategoryNode[]>([])
const tagPool = ref<ArticleTag[]>([])
const inserting = ref<boolean>(false)

const form = reactive({
  title: '',
  summary: '',
  content: '',
  coverUrl: '',
  categoryId: 0,
  categoryName: '',
  selectedTags: [] as ArticleTag[],
  tagIds: [] as number[]
})

const canPublish = computed<boolean>(() => !!form.title.trim() && !!form.content.trim() && form.categoryId > 0)

function selectCategory(c: CategoryNode) {
  form.categoryId = c.categoryId
  form.categoryName = c.categoryName
}

function isTagSelected(t: ArticleTag): boolean {
  return form.tagIds.indexOf(t.tagId) >= 0
}
function toggleTag(t: ArticleTag) {
  const i = form.tagIds.indexOf(t.tagId)
  if (i >= 0) {
    form.tagIds.splice(i, 1)
    form.selectedTags = form.selectedTags.filter((x) => x.tagId !== t.tagId)
  } else {
    if (form.tagIds.length >= maxTags) { uni.showToast({ title: `最多选 ${maxTags} 个标签`, icon: 'none' }); return }
    form.tagIds.push(t.tagId)
    form.selectedTags.push(t)
  }
}

/** 正文插图：复用 POST /api/v1/upload（multipart file，图片≤5MB），成功后以 Markdown 图片语法追加到正文，详情页 rich-text 可渲染 */
function insertImage() {
  if (inserting.value) return
  uni.chooseImage({
    count: 3, sizeType: ['compressed'], sourceType: ['album'],
    success: async (res: any) => {
      inserting.value = true
      try {
        for (const p of res.tempFilePaths as string[]) {
          const url = await uploadAvatarApi(p)
          if (url) {
            const sep = (!form.content || form.content.endsWith('\n')) ? '' : '\n\n'
            form.content += sep + '![图片](' + url + ')\n'
          }
        }
        uni.showToast({ title: '已插入图片', icon: 'success' })
      } catch (e: any) {
        uni.showToast({ title: (e && e.msg) || '图片上传失败', icon: 'none' })
      } finally {
        inserting.value = false
      }
    }
  })
}

async function handlePublish() {
  if (submitting.value) return
  if (!form.title.trim()) { uni.showToast({ title: '请填写标题', icon: 'none' }); return }
  if (!form.content.trim()) { uni.showToast({ title: '请填写正文', icon: 'none' }); return }
  if (!form.categoryId) { uni.showToast({ title: '请选择分类', icon: 'none' }); return }
  submitting.value = true
  try {
    const summary = form.summary.trim() || form.content.trim().slice(0, 60)
    const params = {
      title: form.title.trim(),
      summary,
      content: form.content,
      coverUrl: form.coverUrl,
      categoryId: form.categoryId,
      tagIds: form.tagIds
    }
    if (isEdit.value && editId.value) {
      await updateArticleApi(editId.value, params)
      uni.showToast({ title: '已保存', icon: 'success' })
    } else {
      await publishArticleApi(params)
      uni.showToast({ title: '已提交审核', icon: 'success' })
    }
    setTimeout(goBack, 700)
  } catch (e: any) {
    uni.showToast({ title: (e && e.msg) || '保存失败', icon: 'none' })
  } finally {
    submitting.value = false
  }
}

function goBack() {
  const pages = getCurrentPages()
  if (pages.length > 1) uni.navigateBack()
  else uni.reLaunch({ url: '/pages/index/index' })
}

onLoad(async (query) => {
  const [cats, tags] = await Promise.all([getArticleCategoryTreeApi(), getArticleTagsApi()])
  categories.value = cats || []
  tagPool.value = (tags || []).slice(0, 10)
  if (query && query.articleId) {
    isEdit.value = true
    editId.value = Number(query.articleId)
    const a = await getEditableArticleApi(editId.value)
    if (a) {
      form.title = a.title
      form.summary = a.summary || ''
      form.categoryName = a.categoryName || ''
    }
  } else if (query) {
    // 阿星「发到论坛」预填
    if (query.title) form.title = decodeURIComponent(String(query.title))
    if (query.content) form.content = decodeURIComponent(String(query.content))
  }
})
</script>

<style lang="scss" scoped>
.publish-page {
  height: 100vh; display: flex; flex-direction: column; box-sizing: border-box;
  @include eduPageGradientStrong;
}
.nav-bar { position: fixed; top: 0; left: 0; right: 0; z-index: 99; background: var(--edu-surface); }
.nav-bar-inner { display: flex; align-items: center; padding-left: 16rpx; padding-right: 24rpx; }
.nav-back { width: 72rpx; height: 72rpx; display: flex; align-items: center; justify-content: center; }
.back-icon { font-size: 44rpx; color: $edu-text-primary; }
.nav-title { font-size: 40rpx; font-weight: 700; color: $edu-text-primary; margin-left: 8rpx; flex: 1; }

.form-scroll { flex: 1; min-height: 0; padding: 8rpx 32rpx; box-sizing: border-box; }

.section-label { display: block; font-size: 32rpx; font-weight: 700; color: $edu-text-primary; margin: 28rpx 0 16rpx; }

.field-card { border-radius: 24rpx; background-color: var(--edu-surface); padding: 24rpx 28rpx; box-sizing: border-box; }
.field-input { width: 100%; height: 64rpx; font-size: 32rpx; color: $edu-text-primary; }
.field-textarea-summary { width: 100%; min-height: 72rpx; font-size: 30rpx; line-height: 1.6; color: $edu-text-primary; }
.ph { color: $edu-text-hint; font-size: 28rpx; }

.chip-scroll { width: 100%; white-space: nowrap; }
.chip-row { display: flex; flex-wrap: wrap; }
.choice-chip {
  padding: 16rpx 32rpx; border-radius: 999rpx; background-color: var(--edu-surface);
  border: 2rpx solid transparent; margin: 0 16rpx 16rpx 0; flex-shrink: 0;
}
.choice-chip-active { background-color: $edu-primary-container; border-color: $edu-primary; }
.choice-chip-text { font-size: 28rpx; color: $edu-text-secondary; }
.choice-chip-text-active { color: $edu-primary; font-weight: 600; }

/* 正文工具栏 */
.content-toolbar { display: flex; align-items: center; margin-bottom: 20rpx; }
.toolbar-btn { height: 64rpx; padding: 0 28rpx; border-radius: 999rpx; background-color: $edu-primary-container; display: flex; align-items: center; }
.toolbar-btn-text { font-size: 26rpx; font-weight: 600; color: $edu-primary; }
.toolbar-btn-disabled { opacity: 0.5; }
.toolbar-hint { font-size: 22rpx; color: $edu-text-hint; margin-left: 20rpx; }

.content-head { display: flex; align-items: flex-start; }
.content-icon { font-size: 30rpx; margin-right: 12rpx; margin-top: 8rpx; }
.field-textarea-content { flex: 1; min-height: 320rpx; font-size: 30rpx; line-height: 1.6; color: $edu-text-primary; }

.bottom-space { height: 200rpx; }

.submit-bar {
  position: fixed; left: 0; right: 0; bottom: 0; z-index: 100; display: flex; align-items: center;
  padding: 20rpx 32rpx calc(20rpx + env(safe-area-inset-bottom)); background-color: $edu-surface;
  border-top: 2rpx solid $edu-divider;
}
.submit-btn { flex: 1; height: 92rpx; border-radius: 46rpx; display: flex; align-items: center; justify-content: center; }
.submit-publish { @include eduBrandGradient; box-shadow: 0 8rpx 24rpx rgba(54, 119, 239, 0.3); }
.submit-publish-text { font-size: 30rpx; color: #FFFFFF; font-weight: 600; }
.submit-disabled { opacity: 0.4; }
</style>
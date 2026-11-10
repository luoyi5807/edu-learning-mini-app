<template>
  <view class="publish-page">
    <view class="nav-bar" :style="{ paddingTop: statusBarHeight + 'px' }">
      <view class="nav-bar-inner" :style="{ height: navContentHeight + 'px' }">
        <view class="nav-back" @tap="goBack"><text class="back-icon">←</text></view>
        <text class="nav-title">{{ isEdit ? '编辑文章' : '发布文章' }}</text>
        <view class="nav-draft" @tap="handleSave(0)"><text class="nav-draft-text">存草稿</text></view>
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

      <!-- 封面（选填） -->
      <text class="section-label">封面（选填）</text>
      <view class="cover-row">
        <view class="cover-preview" @tap="chooseCover">
          <image v-if="form.coverUrl" class="cover-preview-img" :src="form.coverUrl" mode="aspectFill" />
        </view>
        <view class="cover-actions">
          <view class="cover-pick-btn" @tap="chooseCover"><text class="cover-pick-text">从相册选择</text></view>
          <input class="cover-link-input" v-model="coverLinkDraft" placeholder="或粘贴图片直链" placeholder-class="ph" @blur="applyCoverLink" />
        </view>
      </view>
      <text class="cover-hint">上传走 POST /api/v1/files/upload（scene=article_cover），本地已自动压到长边 1600px / 质量 85</text>

      <!-- 标签 -->
      <text class="section-label">标签（最多选 {{ maxTags }} 个）</text>
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
      <view class="tag-input-row">
        <input class="tag-input" v-model="tagDraft" placeholder="自定义标签，回车添加" placeholder-class="ph" confirm-type="done" @confirm="addTag" />
        <text class="tag-add" @tap="addTag">添加</text>
      </view>
      <view class="chip-row" v-if="customTags.length">
        <view class="tag-chip" v-for="(t, i) in customTags" :key="t" @tap="removeCustomTag(i)">
          <text class="tag-chip-text">#{{ t }}</text>
          <text class="tag-chip-x">×</text>
        </view>
      </view>

      <!-- 正文 -->
      <text class="section-label">正文</text>
      <view class="field-card">
        <view class="content-head">
          <text class="content-icon">✏️</text>
          <textarea class="field-textarea-content" v-model="form.content" placeholder="在这里写正文，空行表示分段" placeholder-class="ph" :maxlength="5000" auto-height />
        </view>
      </view>

      <view class="bottom-space"></view>
    </scroll-view>

    <view class="submit-bar">
      <view class="submit-btn submit-draft" @tap="handleSave(0)"><text class="submit-draft-text">保存草稿</text></view>
      <view class="submit-btn submit-publish" :class="{ 'submit-disabled': submitting || !canPublish }" @tap="handleSave(1)">
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
import type { ArticleTag } from '@/types/article'

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
const tagDraft = ref<string>('')
const coverLinkDraft = ref<string>('')
const customTags = ref<string[]>([])

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
    if (form.tagIds.length + customTags.value.length >= maxTags) { uni.showToast({ title: `最多选 ${maxTags} 个标签`, icon: 'none' }); return }
    form.tagIds.push(t.tagId)
    form.selectedTags.push(t)
  }
}

function addTag() {
  const t = tagDraft.value.trim().replace(/^#/, '')
  if (!t) return
  if (form.tagIds.length + customTags.value.length >= maxTags) { uni.showToast({ title: `最多选 ${maxTags} 个标签`, icon: 'none' }); return }
  const hit = tagPool.value.find((x) => x.tagName === t)
  if (hit) {
    if (!isTagSelected(hit)) toggleTag(hit)
  } else if (customTags.value.indexOf(t) < 0) {
    customTags.value.push(t)
  }
  tagDraft.value = ''
}
function removeCustomTag(i: number) { customTags.value.splice(i, 1) }

function chooseCover() {
  uni.chooseImage({
    count: 1, sizeType: ['compressed'], sourceType: ['album'],
    success: (res: any) => { form.coverUrl = res.tempFilePaths[0] }
  })
}
function applyCoverLink() {
  const link = coverLinkDraft.value.trim()
  if (link) form.coverUrl = link
}

async function handleSave(publish: number) {
  if (submitting.value) return
  if (!form.title.trim()) { uni.showToast({ title: '请填写标题', icon: 'none' }); return }
  if (publish === 1) {
    if (!form.content.trim()) { uni.showToast({ title: '请填写正文', icon: 'none' }); return }
    if (!form.categoryId) { uni.showToast({ title: '请选择分类', icon: 'none' }); return }
  }
  submitting.value = true
  try {
    const summary = form.summary.trim() || form.content.trim().slice(0, 60)
    const params = {
      title: form.title.trim(),
      summary,
      content: form.content,
      coverUrl: form.coverUrl,
      categoryId: form.categoryId,
      tagIds: form.tagIds,
      publish
    }
    if (isEdit.value && editId.value) {
      await updateArticleApi(editId.value, params)
      uni.showToast({ title: '已保存', icon: 'success' })
    } else {
      await publishArticleApi(params)
      uni.showToast({ title: publish === 1 ? '已提交审核' : '已存草稿', icon: 'success' })
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
      form.coverUrl = a.coverUrl || ''
      form.categoryName = a.categoryName || ''
    }
  }
})
</script>

<style lang="scss" scoped>
.publish-page {
  height: 100vh; display: flex; flex-direction: column; box-sizing: border-box;
  @include eduPageGradientStrong;
}
.nav-bar { position: fixed; top: 0; left: 0; right: 0; z-index: 99; background: rgba(255, 255, 255, 0.9); }
.nav-bar-inner { display: flex; align-items: center; padding-left: 16rpx; padding-right: 24rpx; }
.nav-back { width: 72rpx; height: 72rpx; display: flex; align-items: center; justify-content: center; }
.back-icon { font-size: 44rpx; color: $edu-text-primary; }
.nav-title { font-size: 40rpx; font-weight: 700; color: $edu-text-primary; margin-left: 8rpx; flex: 1; }
.nav-draft { padding: 8rpx 16rpx; }
.nav-draft-text { font-size: 30rpx; color: $edu-text-secondary; }

.form-scroll { flex: 1; min-height: 0; padding: 8rpx 32rpx; box-sizing: border-box; }

.section-label { display: block; font-size: 32rpx; font-weight: 700; color: $edu-text-primary; margin: 28rpx 0 16rpx; }

.field-card { border-radius: 24rpx; background-color: rgba(255, 255, 255, 0.6); padding: 24rpx 28rpx; box-sizing: border-box; }
.field-input { width: 100%; height: 64rpx; font-size: 32rpx; color: $edu-text-primary; }
.field-textarea-summary { width: 100%; min-height: 72rpx; font-size: 30rpx; line-height: 1.6; color: $edu-text-primary; }
.ph { color: $edu-text-hint; font-size: 28rpx; }

.chip-scroll { width: 100%; white-space: nowrap; }
.chip-row { display: flex; flex-wrap: wrap; }
.choice-chip {
  padding: 16rpx 32rpx; border-radius: 999rpx; background-color: rgba(255, 255, 255, 0.75);
  border: 2rpx solid transparent; margin: 0 16rpx 16rpx 0; flex-shrink: 0;
}
.choice-chip-active { background-color: $edu-primary-container; border-color: $edu-primary; }
.choice-chip-text { font-size: 28rpx; color: $edu-text-secondary; }
.choice-chip-text-active { color: $edu-primary; font-weight: 600; }

.cover-row { display: flex; align-items: flex-start; }
.cover-preview {
  width: 180rpx; height: 180rpx; border-radius: 20rpx; background-color: rgba(255, 255, 255, 0.75);
  overflow: hidden; margin-right: 24rpx; flex-shrink: 0;
}
.cover-preview-img { width: 100%; height: 100%; }
.cover-actions { flex: 1; display: flex; flex-direction: column; }
.cover-pick-btn {
  height: 84rpx; border-radius: 999rpx; background-color: rgba(255, 255, 255, 0.75);
  display: flex; align-items: center; justify-content: center;
}
.cover-pick-text { font-size: 30rpx; color: $edu-text-primary; }
.cover-link-input {
  margin-top: 16rpx; height: 72rpx; border-radius: 20rpx; background-color: rgba(255, 255, 255, 0.6);
  padding: 0 24rpx; font-size: 28rpx; color: $edu-text-primary; box-sizing: border-box;
}
.cover-hint { display: block; font-size: 24rpx; color: $edu-text-hint; line-height: 1.6; margin-top: 16rpx; }

.tag-input-row { display: flex; align-items: center; margin-top: 4rpx; }
.tag-input { flex: 1; height: 80rpx; border-radius: 24rpx; background-color: rgba(255, 255, 255, 0.6); padding: 0 24rpx; font-size: 28rpx; color: $edu-text-primary; box-sizing: border-box; }
.tag-add { font-size: 28rpx; color: $edu-primary; padding: 0 24rpx; font-weight: 600; }
.tag-chip { display: flex; align-items: center; background-color: $edu-primary-container; border-radius: 999rpx; padding: 16rpx 24rpx; margin: 0 16rpx 16rpx 0; }
.tag-chip-text { font-size: 26rpx; color: #0C2C6B; }
.tag-chip-x { font-size: 28rpx; color: #0C2C6B; margin-left: 8rpx; }

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
.submit-draft { margin-right: 24rpx; background-color: $edu-surface-variant; }
.submit-draft-text { font-size: 30rpx; color: $edu-text-secondary; font-weight: 600; }
.submit-publish { @include eduBrandGradient; box-shadow: 0 8rpx 24rpx rgba(54, 119, 239, 0.3); }
.submit-publish-text { font-size: 30rpx; color: #FFFFFF; font-weight: 600; }
.submit-disabled { opacity: 0.4; }
</style>
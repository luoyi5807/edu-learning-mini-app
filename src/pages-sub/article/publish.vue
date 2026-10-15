<template>
  <view class="publish-page">
    <view class="nav-bar" :style="{ paddingTop: statusBarHeight + 'px' }">
      <view class="nav-bar-inner" :style="{ height: navContentHeight + 'px' }">
        <view class="nav-back" @tap="goBack"><text class="back-icon">←</text></view>
        <text class="nav-title">{{ isEdit ? '编辑文章' : '发布文章' }}</text>
      </view>
    </view>
    <view class="nav-placeholder" :style="{ height: (statusBarHeight + navContentHeight) + 'px' }"></view>

    <scroll-view class="form-scroll" scroll-y :show-scrollbar="false">
      <input class="title-input" v-model="form.title" placeholder="请输入标题" placeholder-class="ph" :maxlength="50" />

      <view class="cover-picker" @tap="chooseCover">
        <image v-if="form.coverUrl" class="cover-img" :src="form.coverUrl" mode="aspectFill" />
        <view v-else class="cover-empty"><text class="cover-plus">＋</text><text class="cover-tip">添加封面</text></view>
      </view>

      <textarea class="content-input" v-model="form.content" placeholder="正文内容，支持较长文本…" placeholder-class="ph" :maxlength="5000" auto-height />

      <picker mode="selector" :range="categoryNames" @change="onCategoryChange">
        <view class="field-row">
          <text class="field-label">分类</text>
          <text class="field-value">{{ form.categoryName || '请选择分类' }}</text>
          <text class="field-arrow">›</text>
        </view>
      </picker>

      <view class="tag-field">
        <text class="field-label">标签（3-5 个）</text>
        <view class="tag-input-row">
          <input class="tag-input" v-model="tagDraft" placeholder="输入标签回车添加" placeholder-class="ph" confirm-type="done" @confirm="addTag" />
          <text class="tag-add" @tap="addTag">添加</text>
        </view>
        <view class="tag-chips">
          <view class="tag-chip" v-for="(t, i) in form.tags" :key="t" @tap="removeTag(i)">
            <text class="tag-chip-text">#{{ t }}</text>
            <text class="tag-chip-x">×</text>
          </view>
        </view>
      </view>
      <view class="bottom-space"></view>
    </scroll-view>

    <view class="submit-bar">
      <view class="submit-btn submit-draft" @tap="handleSave(0)"><text class="submit-draft-text">保存草稿</text></view>
      <view class="submit-btn submit-publish" :class="{ 'submit-disabled': submitting }" @tap="handleSave(1)">
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
const tagDraft = ref<string>('')

const categories = ref<CategoryNode[]>([])
const categoryNames = computed<string[]>(() => categories.value.map((c) => c.categoryName))

const form = reactive({
  title: '',
  content: '',
  coverUrl: '',
  categoryId: 0,
  categoryName: '',
  tags: [] as string[]
})

function onCategoryChange(e: any) {
  const c = categories.value[Number(e.detail.value)]
  if (c) { form.categoryId = c.categoryId; form.categoryName = c.categoryName }
}
function chooseCover() {
  uni.chooseImage({
    count: 1, sizeType: ['compressed'], sourceType: ['album', 'camera'],
    success: (res: any) => { form.coverUrl = res.tempFilePaths[0] }
  })
}
function addTag() {
  const t = tagDraft.value.trim().replace(/^#/, '')
  if (!t) return
  if (form.tags.length >= 5) { uni.showToast({ title: '最多 5 个标签', icon: 'none' }); return }
  if (form.tags.indexOf(t) < 0) form.tags.push(t)
  tagDraft.value = ''
}
function removeTag(i: number) { form.tags.splice(i, 1) }

async function handleSave(publish: number) {
  if (submitting.value) return
  if (!form.title.trim()) { uni.showToast({ title: '请填写标题', icon: 'none' }); return }
  if (!form.content.trim()) { uni.showToast({ title: '请填写正文', icon: 'none' }); return }
  if (!form.categoryId) { uni.showToast({ title: '请选择分类', icon: 'none' }); return }
  submitting.value = true
  try {
    const params = {
      title: form.title.trim(),
      summary: form.content.trim().slice(0, 60),
      content: form.content,
      coverUrl: form.coverUrl,
      categoryId: form.categoryId,
      tagIds: [],
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
  const res = await getArticleCategoryTreeApi()
  categories.value = res || []
  if (query && query.articleId) {
    isEdit.value = true
    editId.value = Number(query.articleId)
    const a = await getEditableArticleApi(editId.value)
    if (a) { form.title = a.title; form.content = a.summary || ''; form.categoryName = a.categoryName || '' }
  }
})
</script>

<style lang="scss" scoped>
.publish-page {
  height: 100vh; display: flex; flex-direction: column; box-sizing: border-box;
  @include eduPageGradientStrong;
}
.nav-bar { position: fixed; top: 0; left: 0; right: 0; z-index: 99; background: rgba(255, 255, 255, 0.9); }
.nav-bar-inner { display: flex; align-items: center; padding-left: 16rpx; }
.nav-back { width: 72rpx; height: 72rpx; display: flex; align-items: center; justify-content: center; }
.back-icon { font-size: 44rpx; color: $edu-text-primary; }
.nav-title { font-size: 40rpx; font-weight: 700; color: $edu-text-primary; margin-left: 8rpx; }

.form-scroll { flex: 1; min-height: 0; padding: 24rpx 32rpx; box-sizing: border-box; }
.title-input { width: 100%; height: 96rpx; font-size: 40rpx; font-weight: 700; color: $edu-text-primary; }
.cover-picker { margin-top: 20rpx; }
.cover-img { width: 100%; height: 300rpx; border-radius: 24rpx; }
.cover-empty { width: 100%; height: 220rpx; border-radius: 24rpx; border: 2rpx dashed $edu-outline; background-color: rgba(255, 255, 255, 0.5); display: flex; flex-direction: column; align-items: center; justify-content: center; }
.cover-plus { font-size: 56rpx; color: $edu-text-hint; }
.cover-tip { font-size: 26rpx; color: $edu-text-hint; margin-top: 8rpx; }
.content-input { width: 100%; min-height: 400rpx; margin-top: 24rpx; font-size: 30rpx; line-height: 1.6; color: $edu-text-primary; }
.ph { color: $edu-text-hint; font-size: 28rpx; }

.field-row { display: flex; align-items: center; height: 96rpx; margin-top: 24rpx; padding: 0 28rpx; border-radius: 24rpx; background-color: $edu-surface; }
.field-label { font-size: 30rpx; color: $edu-text-secondary; }
.field-value { flex: 1; text-align: right; font-size: 30rpx; color: $edu-text-primary; margin-right: 12rpx; }
.field-arrow { font-size: 36rpx; color: $edu-text-hint; }

.tag-field { margin-top: 24rpx; }
.tag-input-row { display: flex; align-items: center; margin-top: 16rpx; }
.tag-input { flex: 1; height: 80rpx; border-radius: 24rpx; background-color: $edu-surface; padding: 0 24rpx; font-size: 28rpx; color: $edu-text-primary; }
.tag-add { font-size: 28rpx; color: $edu-primary; padding: 0 24rpx; font-weight: 600; }
.tag-chips { display: flex; flex-wrap: wrap; margin-top: 16rpx; }
.tag-chip { display: flex; align-items: center; background-color: $edu-primary-container; border-radius: 12rpx; padding: 8rpx 16rpx; margin: 0 16rpx 16rpx 0; }
.tag-chip-text { font-size: 26rpx; color: #0C2C6B; }
.tag-chip-x { font-size: 28rpx; color: #0C2C6B; margin-left: 8rpx; }
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
.submit-disabled { opacity: 0.6; }
</style>
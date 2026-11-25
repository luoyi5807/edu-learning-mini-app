<template>
  <view class="sql-card">
    <text class="sql-answer">{{ data.answer }}</text>
    <text class="sql-meta" v-if="data.rowCount != null && !data.error">共 {{ data.rowCount }} 条结果</text>
    <text class="sql-meta sql-meta-err" v-if="data.error">查询未能执行</text>
    <view class="sql-table" v-if="columns.length">
      <scroll-view scroll-x class="sql-scroll">
        <view class="sql-grid">
          <view class="sql-tr sql-thead">
            <text class="sql-th" v-for="c in columns" :key="c">{{ c }}</text>
          </view>
          <view class="sql-tr" v-for="(row, ri) in previewRows" :key="ri">
            <text class="sql-td" v-for="c in columns" :key="c">{{ cell(row[c]) }}</text>
          </view>
        </view>
      </scroll-view>
      <text class="sql-more" v-if="moreHint">仅展示前 {{ previewRows.length }} 条</text>
    </view>
    <view class="sql-toggle" v-if="data.sql" @tap="showSql = !showSql">
      <text class="sql-toggle-text">{{ showSql ? '收起 SQL ▲' : '查看 SQL ▼' }}</text>
    </view>
    <text class="sql-code" v-if="showSql && data.sql">{{ data.sql }}</text>
  </view>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import type { AgentSqlPayload } from '@/types/agent'
const props = defineProps<{ data: AgentSqlPayload }>()
const showSql = ref<boolean>(false)
const columns = computed<string[]>(() => {
  const rows = props.data && props.data.rows
  if (rows && rows.length) return Object.keys(rows[0] || {})
  return []
})
const previewRows = computed<any[]>(() => ((props.data && props.data.rows) || []).slice(0, 10))
const moreHint = computed<boolean>(() => {
  const rc = props.data && props.data.rowCount
  return rc != null && rc > previewRows.value.length
})
function cell(v: any): string { return v == null ? '-' : String(v) }
</script>

<style lang="scss" scoped>
.sql-card { max-width: 92%; padding: 28rpx; border-radius: 8rpx 28rpx 28rpx 28rpx; background-color: $edu-surface; box-shadow: 0 6rpx 18rpx rgba(0, 0, 0, 0.04); }
.sql-answer { display: block; font-size: 30rpx; color: $edu-text-primary; line-height: 1.6; }
.sql-meta { display: block; font-size: 24rpx; color: $edu-text-hint; margin-top: 12rpx; }
.sql-meta-err { color: #E53935; }
.sql-table { margin-top: 20rpx; border-radius: 16rpx; overflow: hidden; border: 2rpx solid $edu-divider; }
.sql-scroll { width: 100%; white-space: nowrap; }
.sql-grid { display: inline-block; min-width: 100%; }
.sql-tr { display: flex; }
.sql-thead { background-color: rgba(54, 119, 239, 0.10); }
.sql-th { flex: 0 0 auto; min-width: 180rpx; padding: 16rpx 20rpx; font-size: 24rpx; font-weight: 700; color: $edu-primary; }
.sql-td { flex: 0 0 auto; min-width: 180rpx; padding: 16rpx 20rpx; font-size: 26rpx; color: $edu-text-secondary; border-top: 2rpx solid $edu-divider; }
.sql-more { display: block; font-size: 22rpx; color: $edu-text-hint; padding: 8rpx 20rpx; }
.sql-toggle { margin-top: 16rpx; }
.sql-toggle-text { font-size: 24rpx; color: $edu-primary; }
.sql-code { display: block; margin-top: 12rpx; padding: 20rpx; border-radius: 16rpx; background-color: $edu-surface-variant; font-size: 24rpx; color: $edu-text-secondary; line-height: 1.5; white-space: pre-wrap; word-break: break-all; }
</style>
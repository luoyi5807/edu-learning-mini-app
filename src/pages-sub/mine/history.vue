<template>
  <MineTargetList :class="themeClass" title="观看历史" :items="list" :show-progress="true" time-label="最近观看：" />
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { onLoad } from '@dcloudio/uni-app'
import MineTargetList from '@/components/MineTargetList.vue'
import type { UserTargetItem } from '@/types/user'
import { getHistoryListApi } from '@/api/interaction'
import { useTheme } from '@/composables/useTheme'

const { themeClass } = useTheme()

const list = ref<UserTargetItem[]>([])

onLoad(async () => {
  try {
    list.value = await getHistoryListApi()
  } catch (e) {
    // 拉取失败保持空列表，组件展示空态
  }
})
</script>
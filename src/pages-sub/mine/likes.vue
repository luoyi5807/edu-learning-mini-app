<template>
  <MineTargetList title="我的点赞" :items="list" time-label="点赞于：" />
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { onLoad } from '@dcloudio/uni-app'
import MineTargetList from '@/components/MineTargetList.vue'
import type { UserTargetItem } from '@/types/user'
import { getMyLikesApi } from '@/api/interaction'

const list = ref<UserTargetItem[]>([])

onLoad(async () => {
  try {
    list.value = await getMyLikesApi()
  } catch (e) {
    // 拉取失败保持空列表
  }
})
</script>
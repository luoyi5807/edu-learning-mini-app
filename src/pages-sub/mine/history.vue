<template>
  <MineTargetList title="观看历史" :items="list" :show-progress="true" time-label="最近观看：" />
</template>

<script setup lang="ts">
import { ref } from 'vue'
import MineTargetList from '@/components/MineTargetList.vue'
import type { UserTargetItem } from '@/types/user'

/* Mock，接口接入换成 GET user/view-history?targetType= */
const list = ref<UserTargetItem[]>([
  { targetType: 2, targetId: 1, title: 'Machine Learning 从入门到实战', cover: '', collectTime: '2026-09-12 20:15:00', progressSeconds: 720, duration: 2400 },
  { targetType: 1, targetId: 101, title: 'Kotlin 协程取消机制完全指南', cover: '', collectTime: '2026-09-11 14:30:00' },
  { targetType: 2, targetId: 5, title: 'Python 编程基础入门', cover: '', collectTime: '2026-09-10 09:00:00', progressSeconds: 180, duration: 1800 },
  { targetType: 1, targetId: 103, title: '后端接口设计中的 10 个常见错误', cover: '', collectTime: '2026-09-09 21:00:00' }
])
</script>
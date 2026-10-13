<template>
  <MineTargetList title="我的点赞" :items="list" time-label="点赞于：" />
</template>

<script setup lang="ts">
import { ref } from 'vue'
import MineTargetList from '@/components/MineTargetList.vue'
import type { UserTargetItem } from '@/types/user'

/* Mock，接口接入换成 GET user/likes?targetType= */
const list = ref<UserTargetItem[]>([
  { targetType: 1, targetId: 102, title: 'Java 高并发编程', cover: '', collectTime: '2026-09-11 10:20:00' },
  { targetType: 2, targetId: 3, title: 'UI 设计从零基础到精通', cover: '', collectTime: '2026-09-10 16:40:00' },
  { targetType: 1, targetId: 101, title: 'Kotlin 协程取消机制完全指南', cover: '', collectTime: '2026-09-08 11:05:00' },
  { targetType: 2, targetId: 1, title: 'Machine Learning 从入门到实战', cover: '', collectTime: '2026-09-07 18:00:00' }
])
</script>
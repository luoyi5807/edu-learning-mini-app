export interface UserTargetItem {
    targetType: number        // 1 帖子  2 课程  3 短视频
    targetId: number
    videoId?: number          // 观看历史（课程）：上次观看的小节ID，跳播放页续播定位用
    title: string
    cover: string
    collectTime: string       // 收藏/点赞/观看时间（后端已格式化，前端不解析）
    progressSeconds?: number  // 观看历史：续播进度（秒）
    duration?: number         // 观看历史：总时长（秒）
}
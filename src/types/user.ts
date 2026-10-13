export interface UserTargetItem {
    targetType: number        // 1 文章  2 视频课程
    targetId: number
    title: string
    cover: string
    collectTime: string       // 收藏/点赞/观看时间（后端已格式化，前端不解析）
    progressSeconds?: number  // 观看历史：续播进度（秒）
    duration?: number         // 观看历史：总时长（秒）
}
export interface Course {
    courseId: number
    title: string
    coverUrl: string
    instructorName: string
    instructorId?: number
    instructorAvatar?: string
    studentCount: number
    categoryId: number
    categoryName: string
    videoType: number      // 1 短视频  2 长视频课程
    isFree: number
    duration?: number        // 时长（秒）
    viewCount?: number       // 播放量
    likeCount?: number       // 点赞数
    favoriteCount?: number   // 收藏数
    commentCount?: number    // 评论数
    averageScore?: number    // 平均评分
    ratingCount?: number     // 评分人数
    description?: string     // 简介
    totalLessons?: number    // 总小节数（长视频）
    videoFileId?: string     // 云厂商 VOD 文件ID（短视频）
    playUrl?: string         // 短视频直链（后端 videoUrl 拼 BASE_URL，列表即可播）
    transcodeStatus?: number // 转码状态：0处理中 1成功 2失败
    isLiked?: boolean
    isFavorited?: boolean
}

export interface CourseCategory {
    categoryId: number
    categoryName: string
}

/** 视频小节（course_lesson / LessonDto） */
export interface LessonDto {
    lessonId: number
    courseId: number
    chapterId: number
    title: string
    duration: number          // 秒
    isFree: number            // 0 付费  1 免费试看
    transcodeStatus: number   // 1 成功才可播
    videoFileId?: string
    progressSeconds?: number  // 已观看进度（秒），续播用
    isFinished?: boolean
}

/** 章节（course_chapter / ChapterDto） */
export interface ChapterDto {
    chapterId: number
    courseId: number
    title: string
    lessonCount?: number
    lessons: LessonDto[]
}

/** 课程详情（CourseDetailDto：含 chapters→lessons 树） */
export interface CourseDetailDto extends Course {
    chapters: ChapterDto[]
    isJoined?: boolean
    /** 最近点赞用户预览（展示头像 + 等 N 人赞过） */
    recentLikers?: { userId: number; nickName: string; avatar?: string }[]
}

/** 播放凭证（GET courses/{id}/play-info） */
export interface PlayInfoDto {
    playUrl: string        // 限时签名播放地址
    expireTime: string
    watermarkText: string
    duration: number
}

/** 课程评分（GET courses/{id}/ratings） */
export interface CourseRatingDto {
    ratingId: number
    userId: number
    nickName: string
    avatar?: string
    score: number          // 0.5 - 5.0
    createTime: string
}

export interface ArticleDto {
    articleId: number
    title: string
    summary?: string
    coverUrl?: string
    authorId: number
    authorName: string
    authorAvatar?: string
    categoryName?: string
    viewCount: number
    likeCount: number
    commentCount: number
    publishTime: string
    status?: number
    categoryId?: number   // 列表按分类筛选（mock 用）
    essence?: number      // 1 精华（mock 用）
}

export interface ArticleTag {
    tagId: number
    tagName: string
    useCount?: number
}

export interface ArticleDetailDto {
    articleId: number
    title: string
    summary?: string
    content: string            // 富文本 HTML
    coverUrl?: string
    authorId: number
    authorName: string
    authorAvatar?: string
    categoryId?: number
    categoryName?: string
    tags: ArticleTag[]
    viewCount: number
    likeCount: number
    commentCount: number
    favoriteCount: number
    publishTime: string
    status?: number
    isLiked: boolean
    isFavorited: boolean
    prevArticle?: { articleId: number; title: string } | null
    nextArticle?: { articleId: number; title: string } | null
}

export interface CommentDto {
    commentId: number
    userId: number
    nickName: string
    avatar?: string
    content: string
    createTime: string
    likeCount: number
    isLiked: boolean
    replyCount: number
    parentId?: number
    replyToUserId?: number
    replyToUserName?: string
    replies?: CommentDto[]   // 楼中楼：预览/展开的回复
}

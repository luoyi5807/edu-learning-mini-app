export interface Course {
    courseId: number
    title: string
    coverUrl: string
    instructorName: string
    studentCount: number
    categoryId: number
    categoryName: string
    videoType: number
    isFree: number
}

export interface CourseCategory {
    categoryId: number
    categoryName: string
}
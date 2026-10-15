import { get, post, put, patch, del, v1 } from '@/utils/request'
import { API_READY } from '@/config/apiStatus'

/**
 * 待办 DTO —— 契约 6.9：
 * GET todos?status&priority / POST todos / PUT todos/{id} / PATCH todos/{id}/status / DELETE todos/{id}
 */
export interface TodoDto {
    todoId: number
    title: string
    description?: string
    status: number        // 0 未完成  1 已完成
    priority: number      // 1 高  2 中  3 低
    deadline?: string
    remindTime?: string
    relateType?: number
    relateId?: number
    createTime?: string
    finishTime?: string
}

export interface TodoAddParams {
    title: string
    description?: string
    deadline?: string
    remindTime?: string
    priority: number
    relateType?: number
    relateId?: number
}

export const TODO_PRIORITY_TEXT: Record<number, string> = { 1: '高', 2: '中', 3: '低' }

let seq = 100
const mockTodos: TodoDto[] = [
    { todoId: 1, title: '看完《Kotlin 协程》第 8 节', description: '结构化并发部分做好笔记', status: 0, priority: 1, deadline: '2026-10-15 20:00', createTime: '2026-10-13 09:00' },
    { todoId: 2, title: '整理后端接口设计笔记', status: 0, priority: 2, deadline: '2026-10-16 18:00', createTime: '2026-10-12 21:30' },
    { todoId: 3, title: '发布 uni-app 分包优化文章', status: 0, priority: 3, createTime: '2026-10-11 15:00' },
    { todoId: 4, title: '完成每日签到', status: 1, priority: 2, finishTime: '2026-10-13 08:10', createTime: '2026-10-13 08:00' }
]

function mockSort(list: TodoDto[]): TodoDto[] {
    return list.slice().sort((a, b) => {
        if (a.status !== b.status) return a.status - b.status
        if (a.priority !== b.priority) return a.priority - b.priority
        return String(a.deadline || '9999').localeCompare(String(b.deadline || '9999'))
    })
}

export function getTodosApi(status?: number, priority?: number): Promise<TodoDto[]> {
    if (!API_READY.todos) {
        let list = mockTodos.slice()
        if (status !== undefined && status !== null) list = list.filter((t) => t.status === status)
        if (priority) list = list.filter((t) => t.priority === priority)
        return Promise.resolve(mockSort(list))
    }
    return get(v1('/todos'), { status, priority })
}

export function addTodoApi(params: TodoAddParams): Promise<void> {
    if (!API_READY.todos) {
        mockTodos.push({ todoId: ++seq, status: 0, createTime: '刚刚', ...params })
        return Promise.resolve()
    }
    return post(v1('/todos'), params)
}

export function updateTodoApi(todoId: number, params: Partial<TodoAddParams>): Promise<void> {
    if (!API_READY.todos) {
        const t = mockTodos.find((x) => x.todoId === todoId)
        if (t) Object.assign(t, params)
        return Promise.resolve()
    }
    return put(v1('/todos/' + todoId), params)
}

export function setTodoStatusApi(todoId: number, status: number): Promise<void> {
    if (!API_READY.todos) {
        const t = mockTodos.find((x) => x.todoId === todoId)
        if (t) { t.status = status; t.finishTime = status === 1 ? '刚刚' : undefined }
        return Promise.resolve()
    }
    return patch(v1('/todos/' + todoId + '/status'), { status })
}

export function removeTodoApi(todoId: number): Promise<void> {
    const idx = mockTodos.findIndex((t) => t.todoId === todoId)
    if (idx >= 0) mockTodos.splice(idx, 1)
    if (!API_READY.todos) return Promise.resolve()
    return del(v1('/todos/' + todoId))
}
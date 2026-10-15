import { get, post, put, del, v1 } from '@/utils/request'
import { API_READY } from '@/config/apiStatus'

export interface NoteDto {
    noteId: number
    title: string
    summary?: string
    content?: string
    sourceType: number        // 1 文章  2 视频
    sourceId: number
    sourceTitle?: string
    videoTimestamp?: string
    createTime: string
}

let seq = 5000
const mockNotes: NoteDto[] = [
    { noteId: 1, title: '协程取消的三个关键点', summary: '1) 取消是协作式的\n2) 挂起点才会检查取消状态\n3) CancellationException 需捕获处理', content: '', sourceType: 1, sourceId: 101, sourceTitle: 'Kotlin 协程取消机制完全指南', createTime: '2026-09-17 21:30' },
    { noteId: 2, title: 'JMM 与可见性', summary: 'volatile 保证可见性与有序性，不保证原子性。synchronized 三者都保证。', content: '', sourceType: 2, sourceId: 1, videoTimestamp: '22:00', createTime: '2026-09-16 20:15' },
    { noteId: 3, title: '组合优于继承的实例', summary: '用策略模式替换掉三层继承，测试用例从 12 个减到 4 个。', content: '', sourceType: 2, sourceId: 5, videoTimestamp: '8:00', createTime: '2026-09-15 19:00' },
    { noteId: 4, title: '接口设计笔记', summary: '分页统一用 pageNum/pageSize；写操作一律带幂等 Token。', content: '', sourceType: 1, sourceId: 103, createTime: '2026-09-13 11:20' }
]

/** GET notes?sourceType&keyword */
export function getNotesApi(sourceType?: number, keyword?: string): Promise<NoteDto[]> {
    if (!API_READY.notes) {
        let l = mockNotes.slice()
        if (sourceType) l = l.filter((n) => n.sourceType === sourceType)
        const kw = (keyword || '').trim()
        if (kw) l = l.filter((n) => n.title.indexOf(kw) >= 0 || (n.summary || '').indexOf(kw) >= 0)
        return Promise.resolve(l)
    }
    return get(v1('/notes'), { sourceType, keyword })
}

/** GET notes/by-source 按来源查笔记（不分页） */
export function getNotesBySourceApi(sourceType: number, sourceId: number): Promise<NoteDto[]> {
    if (!API_READY.notes) return Promise.resolve(mockNotes.filter((n) => n.sourceType === sourceType && n.sourceId === sourceId))
    return get(v1('/notes/by-source'), { sourceType, sourceId })
}

export interface AddNoteParams { sourceType: number; sourceId: number; title?: string; content: string; sourceTitle?: string; videoTimestamp?: string }

/** POST notes */
export function addNoteApi(params: AddNoteParams): Promise<{ noteId: number }> {
    if (!API_READY.notes) {
        const noteId = ++seq
        const content = params.content.trim()
        mockNotes.unshift({
            noteId,
            title: params.title || (content.slice(0, 12) || '未命名笔记'),
            summary: content.slice(0, 60),
            content,
            sourceType: params.sourceType,
            sourceId: params.sourceId,
            sourceTitle: params.sourceTitle,
            videoTimestamp: params.videoTimestamp,
            createTime: '刚刚'
        })
        return Promise.resolve({ noteId })
    }
    return post(v1('/notes'), params)
}

export function updateNoteApi(noteId: number, params: Partial<AddNoteParams>): Promise<void> {
    if (!API_READY.notes) {
        const n = mockNotes.find((x) => x.noteId === noteId)
        if (n && params.content !== undefined) { n.content = params.content; n.summary = params.content.slice(0, 60) }
        return Promise.resolve()
    }
    return put(v1('/notes/' + noteId), params)
}

export function deleteNoteApi(noteId: number): Promise<void> {
    const i = mockNotes.findIndex((x) => x.noteId === noteId)
    if (i >= 0) mockNotes.splice(i, 1)
    if (!API_READY.notes) return Promise.resolve()
    return del(v1('/notes/' + noteId))
}
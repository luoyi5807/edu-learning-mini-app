// src/api/notes.ts
import { get, post, v1 } from '@/utils/request'
import { API_READY } from '@/config/apiStatus'

export interface NoteDto {
    noteId: number
    title: string
    summary?: string
    content?: string
    sourceType: number        // 1 文章(post)  2 视频(video)
    sourceId: number
    sourceTitle?: string
    videoTimestamp?: string   // 展示用 mm:ss
    sourceDeleted?: boolean   // 来源已删除
    createTime: string
}

/** 后端 learning_note 行 */
export interface BackendNote {
    noteId: number
    userId: number
    targetType: string        // 'post' | 'video'
    targetId: number
    noteTitle: string
    noteContent: string
    progress?: number | null  // 秒
    createTime: string
    updateTime?: string
    sourceTitle?: string | null
    courseId?: number | null
    sourceDeleted?: boolean | null
}

/* ===== 前端视图模型 ⇄ 后端字段 映射 ===== */
function toSourceType(targetType: string): number { return targetType === 'video' ? 2 : 1 }
function toTargetType(sourceType: number): string { return sourceType === 2 ? 'video' : 'post' }
function formatHms(sec: number): string {
    const s = Math.max(0, Math.floor(sec || 0))
    const m = Math.floor(s / 60), ss = s % 60
    return `${m < 10 ? '0' + m : m}:${ss < 10 ? '0' + ss : ss}`
}
function parseHms(text?: string): number | undefined {
    if (!text) return undefined
    const parts = String(text).split(':').map((x) => Number(x))
    if (parts.some((n) => isNaN(n))) return undefined
    return parts.length === 3 ? parts[0] * 3600 + parts[1] * 60 + parts[2] : parts[0] * 60 + (parts[1] || 0)
}

function normalizeNote(n: BackendNote): NoteDto {
    return {
        noteId: n.noteId,
        title: n.noteTitle || (n.noteContent || '').slice(0, 12) || '未命名笔记',
        summary: (n.noteContent || '').slice(0, 60),
        content: n.noteContent || '',
        sourceType: toSourceType(n.targetType),
        sourceId: n.targetId,
        sourceTitle: n.sourceTitle || undefined,
        videoTimestamp: (n.progress != null && n.targetType === 'video') ? formatHms(n.progress) : undefined,
        sourceDeleted: !!n.sourceDeleted,
        createTime: n.createTime || ''
    }
}

/* ===== mock 兜底 ===== */
let seq = 5000
const mockNotes: NoteDto[] = [
    { noteId: 1, title: '协程取消的三个关键点', summary: '1) 取消是协作式的\n2) 挂起点才会检查取消状态', content: '', sourceType: 1, sourceId: 101, sourceTitle: 'Kotlin 协程取消机制完全指南', createTime: '2026-09-17 21:30' },
    { noteId: 2, title: 'JMM 与可见性', summary: 'volatile 保证可见性与有序性，不保证原子性。', content: '', sourceType: 2, sourceId: 1, videoTimestamp: '22:00', createTime: '2026-09-16 20:15' }
]

/** GET /api/v1/note/list —— 我的笔记列表（分页） */
export async function getNotesApi(sourceType?: number, keyword?: string): Promise<NoteDto[]> {
    if (!API_READY.notes) {
        let l = mockNotes.slice()
        if (sourceType) l = l.filter((n) => n.sourceType === sourceType)
        const kw = (keyword || '').trim()
        if (kw) l = l.filter((n) => n.title.indexOf(kw) >= 0 || (n.summary || '').indexOf(kw) >= 0)
        return l
    }
    const query: Record<string, any> = { pageNum: 1, pageSize: 100 }
    if (sourceType) query.targetType = toTargetType(sourceType)
    if (keyword && keyword.trim()) query.keyword = keyword.trim()
    const body: any = await get(v1('/note/list'), query)
    const rows: BackendNote[] = (body && Array.isArray(body.rows)) ? body.rows : []
    return rows.map(normalizeNote)
}

/** 按来源查笔记（详情页/播放器回填用） */
export async function getNotesBySourceApi(sourceType: number, sourceId: number): Promise<NoteDto[]> {
    if (!API_READY.notes) return mockNotes.filter((n) => n.sourceType === sourceType && n.sourceId === sourceId)
    const body: any = await get(v1('/note/list'), { targetType: toTargetType(sourceType), targetId: sourceId, pageNum: 1, pageSize: 100 })
    const rows: BackendNote[] = (body && Array.isArray(body.rows)) ? body.rows : []
    return rows.map(normalizeNote)
}

export interface AddNoteParams {
    sourceType: number; sourceId: number; title?: string; content: string
    sourceTitle?: string; videoTimestamp?: string
}

/** POST /api/v1/note/add（JSON 出口） */
export function addNoteApi(params: AddNoteParams): Promise<{ noteId: number }> {
    if (!API_READY.notes) {
        const noteId = ++seq
        const content = params.content.trim()
        mockNotes.unshift({
            noteId, title: params.title || (content.slice(0, 12) || '未命名笔记'),
            summary: content.slice(0, 60), content, sourceType: params.sourceType,
            sourceId: params.sourceId, sourceTitle: params.sourceTitle,
            videoTimestamp: params.videoTimestamp, createTime: '刚刚'
        })
        return Promise.resolve({ noteId })
    }
    const body: Record<string, string> = {
        targetType: toTargetType(params.sourceType),
        targetId: String(params.sourceId),
        noteTitle: params.title || (params.content.trim().slice(0, 12) || '未命名笔记'),
        noteContent: params.content
    }
    const progress = parseHms(params.videoTimestamp)
    if (progress != null) body.progress = String(progress)
    return post(v1('/note/add'), body)
}

/** POST /api/v1/note/edit（只改标题与正文） */
export function updateNoteApi(noteId: number, params: Partial<AddNoteParams>): Promise<void> {
    if (!API_READY.notes) {
        const n = mockNotes.find((x) => x.noteId === noteId)
        if (n && params.content !== undefined) { n.content = params.content; n.summary = params.content.slice(0, 60) }
        return Promise.resolve()
    }
    return post(v1('/note/edit'), { noteId: String(noteId), noteTitle: params.title || n2t(noteId), noteContent: params.content || '' })
}

/** POST /api/v1/note/remove */
export function deleteNoteApi(noteId: number): Promise<void> {
    const i = mockNotes.findIndex((x) => x.noteId === noteId)
    if (i >= 0) mockNotes.splice(i, 1)
    if (!API_READY.notes) return Promise.resolve()
    return post(v1('/note/remove'), { noteId: String(noteId) })
}

// edit 时若调用方没传标题，用占位（后端要求非空≤20）
function n2t(_id: number): string { return '笔记' }
import axios from "axios"
import type { TreeNode, Registro, HistoryEntry, FileItem, Project, CodeSnippet, MermaidDiagram } from "../types"

const API_BASE_URL = "http://localhost:3004/api"

const api = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    "Content-Type": "application/json",
  },
})

// Interceptor para logging
api.interceptors.request.use((config) => {
  console.log(`🚀 API Request: ${config.method?.toUpperCase()} ${config.url}`, config.data)
  return config
})

api.interceptors.response.use(
  (response) => {
    console.log(`✅ API Response: ${response.config.url}`, response.data)
    return response
  },
  (error) => {
    console.error(`❌ API Error: ${error.config?.url}`, error.response?.data || error.message)
    return Promise.reject(error)
  },
)

// Projects API
export const projectsApi = {
  getProjects: () => api.get<Project[]>("/projects"),
  createProject: (projectData: { nombre: string; descripcion: string; ruta_base?: string }) =>
    api.post("/projects", projectData),
  updateProject: (projectId: number, projectData: Partial<Project>) => api.put(`/projects/${projectId}`, projectData),
  deleteProject: (projectId: number) => api.delete(`/projects/${projectId}`),
  exportProject: (projectId: number) => api.get(`/projects/${projectId}/export`),
}

// Nodes API
export const nodesApi = {
  getTree: (projectId: number) => api.get<TreeNode[]>(`/nodes/${projectId}`),
  saveTree: (projectId: number, treeData: TreeNode[]) => api.post(`/nodes/${projectId}`, treeData),
  createNode: (projectId: number, nodeData: Partial<TreeNode>) => api.post(`/nodes/${projectId}/create`, nodeData),
  getNodeHistory: (projectId: number, nodeId: string) =>
    api.get<HistoryEntry[]>(`/nodes/${projectId}/${nodeId}/history`),
  updateNodeField: (
    projectId: number,
    nodeId: string,
    data: {
      campo: string
      anterior: string
      nuevo: string
      usuario: string
    },
  ) => api.post(`/nodes/${projectId}/${nodeId}/update`, data),
}

// Snippets API
export const snippetsApi = {
  getSnippets: (nodeId: string, projectId: number) =>
    api.get<CodeSnippet[]>(`/snippets?nodo_id=${nodeId}&proyecto_id=${projectId}`),
  saveSnippet: (snippet: Partial<CodeSnippet>) => api.post("/snippets", snippet),
  deleteSnippet: (snippetId: number) => api.delete(`/snippets/${snippetId}`),
}

// Diagramas API - Actualizado con nombres en español
export const diagramasApi = {
  getDiagramas: (nodeId: string, projectId: number) =>
    api.get<MermaidDiagram[]>(`/diagramas?nodo_id=${nodeId}&proyecto_id=${projectId}`),
  saveDiagrama: (diagrama: Partial<MermaidDiagram>) => api.post("/diagramas", diagrama),
  deleteDiagrama: (diagramaId: number) => api.delete(`/diagramas/${diagramaId}`),
  validarCodigo: (codigo: string) => api.post("/diagramas/validar", { codigo_mermaid: codigo }),
}

// Files API
export const filesApi = {
  readFile: (path: string) =>
    api.get<{ content: string; path: string }>(`/files/read?path=${encodeURIComponent(path)}`),
  exploreDirectory: (path?: string) =>
    api.get<{ items: FileItem[]; current_path: string }>(
      `/files/explore${path ? `?path=${encodeURIComponent(path)}` : ""}`,
    ),
  openFile: (path: string) => api.post("/files/open", { path }),
}

// Registros API - Actualizado con nombres en español
export const registrosApi = {
  getRegistros: (nodeId: string) => api.get<Registro[]>(`/registros?nodo_id=${nodeId}`),
  saveRegistro: (registro: Registro) => api.post("/registros", registro),
  deleteRegistro: (registroId: number) => api.delete(`/registros/${registroId}`),
  reordenarRegistros: (nodeId: string) => api.post("/registros/reordenar", { nodo_id: nodeId }),
}

// User API
export const userApi = {
  getCurrentUser: () => api.get<{ usuario: string }>("/user"),
}

// Debug API
export const debugApi = {
  getInfo: () => api.get("/debug"),
}

export default api

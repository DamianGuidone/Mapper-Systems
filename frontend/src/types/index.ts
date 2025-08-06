export interface TreeNode {
  id: string
  text: string
  icon: string
  type: "default" | "leaf"
  parent: string
  data: NodeData
  state: {
    loaded: boolean
    opened: boolean
    selected: boolean
    disabled: boolean
    hidden?: boolean
  }
}

export interface NodeData {
  descripcion: string
  tipo_nodo: "carpeta" | "bd" | "js" | "cs" | "html" | "reporte"
  archivo?: string
  ultima_modificacion?: string
  ultima_revision?: string
  historial_file?: string
}

export interface Project {
  id: number
  nombre: string
  descripcion: string
  ruta_base: string
  fecha_creacion: string
  fecha_modificacion: string
  configuracion: Record<string, any>
  stats: {
    total_nodos: number
    total_registros: number
    total_snippets: number
    total_diagramas: number
  }
}

export interface Registro {
  id?: number
  archivo: string
  ubicacion?: string
  funcion?: string
  descripcion?: string
  orden: number
  nodo_id?: string
  proyecto_id?: number
}

export interface CodeSnippet {
  id?: number
  nodo_id: string
  proyecto_id: number
  titulo: string
  descripcion?: string
  lenguaje: string
  codigo: string
  archivo_ruta?: string
  orden: number
  fecha_creacion?: string
  fecha_modificacion?: string
}

export interface MermaidDiagram {
  id?: number
  nodo_id: string
  proyecto_id: number
  titulo: string
  descripcion?: string
  tipo_diagrama: MermaidDiagramType
  codigo_mermaid: string
  archivo_ruta?: string
  orden: number
  fecha_creacion?: string
  fecha_actualizacion?: string
}

export type MermaidDiagramType =
  | "flowchart"
  | "sequence"
  | "classDiagram"     
  | "stateDiagram"    
  | "erDiagram"        
  | "journey"          
  | "requirementDiagram"
  | "gantt"
  | "pie"
  | "gitgraph"
  | "mindmap"
  | "timeline"
  | "quadrant"
  | "c4"
  | "xychart"
  | "block"
  | "packet"
  | "kanban"
  | "architecture"
  | "radar";

export interface HistoryEntry {
  fecha: string
  campo: string
  anterior: string
  nuevo: string
  usuario: string
}

export interface FileItem {
  name: string
  path: string
  is_directory: boolean
  type: string
}

export type SupportedLanguage =
  | "javascript"
  | "typescript"
  | "python"
  | "java"
  | "csharp"
  | "html"
  | "css"
  | "sql"
  | "json"
  | "xml"
  | "php"
  | "ruby"
  | "go"
  | "rust"
  | "cpp"
  | "c"
  | "bash"
  | "yaml"
  | "markdown"

// Contexto de la aplicación
export interface AppContextType {
  currentProject: Project | null
  currentUser: string
  projects: Project[]
  selectedNode: TreeNode | null
  treeData: TreeNode[]
  darkMode: boolean
  setCurrentProject: (project: Project | null) => void
  setSelectedNode: (node: TreeNode | null) => void
  setTreeData: (data: TreeNode[]) => void
  refreshProjects: () => Promise<void>
  refreshTree: () => Promise<void>
  showNotification: (message: string, type: "success" | "warning" |"error") => void
  toggleDarkMode: () => void
}

"use client"

import type React from "react"
import { createContext, useContext, useState, useEffect, type ReactNode } from "react"
import type { AppContextType, Project, TreeNode } from "../types"
import { userApi, projectsApi, nodesApi } from "../services/api"

const AppContext = createContext<AppContextType | undefined>(undefined)

export const useAppContext = () => {
  const context = useContext(AppContext)
  if (context === undefined) {
    throw new Error("useAppContext must be used within an AppProvider")
  }
  return context
}

interface AppProviderProps {
  children: ReactNode
  onNotification?: (message: string, type: "success" | "error" | "warning") => void
}

export const AppProvider: React.FC<AppProviderProps> = ({ children, onNotification }) => {
  const [currentProject, setCurrentProject] = useState<Project | null>(null)
  const [currentUser, setCurrentUser] = useState("Anónimo")
  const [projects, setProjects] = useState<Project[]>([])
  const [selectedNode, setSelectedNode] = useState<TreeNode | null>(null)
  const [treeData, setTreeData] = useState<TreeNode[]>([])
  const [darkMode, setDarkMode] = useState<boolean>(true) // Estado para modo oscuro

  // Función para alternar modo oscuro
  const toggleDarkMode = () => {
    setDarkMode(prevMode => !prevMode)
  }

  // Inicialización
  useEffect(() => {
    initializeApp()
  }, [])

  // Cargar árbol cuando cambie el proyecto
  useEffect(() => {
    if (currentProject) {
      refreshTree()
    } else {
      setTreeData([])
      setSelectedNode(null)
    }
  }, [currentProject])

  const initializeApp = async () => {
    try {
      // Cargar usuario
      const userResponse = await userApi.getCurrentUser()
      setCurrentUser(userResponse.data.usuario)

      // Cargar proyectos
      await refreshProjects()
      
      // Recuperar preferencia de modo oscuro de localStorage si existe
      const savedDarkMode = localStorage.getItem("darkMode")
      if (savedDarkMode !== null) {
        setDarkMode(savedDarkMode === "true")
      }
    } catch (error) {
      console.error("Error initializing app:", error)
      showNotification("Error al inicializar la aplicación", "error")
    }
  }

  // Guardar preferencia de modo oscuro en localStorage
  useEffect(() => {
    localStorage.setItem("darkMode", darkMode.toString())
  }, [darkMode])

  const refreshProjects = async () => {
    try {
      const response = await projectsApi.getProjects()
      setProjects(response.data)

      // Si no hay proyecto actual pero hay proyectos, seleccionar el primero
      if (!currentProject && response.data.length > 0) {
        setCurrentProject(response.data[0])
      }
      // Si el proyecto actual ya no existe, limpiar
      else if (currentProject && !response.data.find((p) => p.id === currentProject.id)) {
        setCurrentProject(response.data.length > 0 ? response.data[0] : null)
      }
    } catch (error) {
      console.error("Error refreshing projects:", error)
      showNotification("Error al cargar proyectos", "error")
    }
  }

  const refreshTree = async () => {
    if (!currentProject) return

    try {
      const response = await nodesApi.getTree(currentProject.id)
      setTreeData(response.data)
    } catch (error) {
      console.error("Error refreshing tree:", error)
      showNotification("Error al cargar el árbol", "error")
    }
  }

  const showNotification = (message: string, type: "success" | "warning" | "error") => {
    if (onNotification) {
      onNotification(message, type)
    }
  }

  const handleSetCurrentProject = (project: Project | null) => {
    setCurrentProject(project)
    setSelectedNode(null) // Limpiar nodo seleccionado al cambiar proyecto
  }

  const value: AppContextType = {
    currentProject,
    currentUser,
    projects,
    selectedNode,
    treeData,
    darkMode, // Agregar al contexto
    setCurrentProject: handleSetCurrentProject,
    setSelectedNode,
    setTreeData,
    refreshProjects,
    refreshTree,
    showNotification,
    toggleDarkMode, // Agregar función al contexto
  }

  return <AppContext.Provider value={value}>{children}</AppContext.Provider>
}
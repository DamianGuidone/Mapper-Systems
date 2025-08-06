"use client"
import { useState } from "react"
import {
  ThemeProvider,
  CssBaseline,
  Container,
  Grid,
  Typography,
  Box,
  Snackbar,
  Alert,
  Tabs,
  Tab,
  IconButton,
  Tooltip,
  AppBar,
  Toolbar,
} from "@mui/material"
import { WbSunny, DarkMode } from "@mui/icons-material"
import { Settings, Add, Folder } from "@mui/icons-material"
import { TreeView } from "./components/TreeView"
import { NodeDetails } from "./components/NodeDetails"
import { NodeForm } from "./components/NodeForm"
import { TablaRegistros } from "./components/TablaRegistros"
import { SqlPreview } from "./components/SqlPreview"
import { CodeSnippets } from "./components/CodeSnippets"
import { DiagramasMermaid } from "./components/DiagramasMermaid"
import { ProjectManager } from "./components/ProjectManager"
import { MermaidLoader } from "./components/MermaidLoader"
import { AppProvider, useAppContext } from "./contexts/AppContext"
import { darkTheme } from "./theme/theme"
import { lightTheme } from "./theme/lightTheme"

function AppContent() {
  const {
    currentProject,
    currentUser,
    selectedNode,
    projects,
    darkMode,
    toggleDarkMode,
    setCurrentProject,
    refreshProjects,
  } = useAppContext()

  const [projectManagerOpen, setProjectManagerOpen] = useState(false)
  const [activeTab, setActiveTab] = useState(0)
  const [notification, setNotification] = useState<{ message: string; type: "success" | "error" } | null>(null)

  const handleProjectSelect = (project: any) => {
    setCurrentProject(project)
    setActiveTab(0)
  }

  const showNotification = (message: string, type: "success" | "error") => {
    setNotification({ message, type })
  }

  // Determinar qué mostrar según el tipo de nodo
  const showTablaRegistros = selectedNode && ["js", "cs", "html", "reporte"].includes(selectedNode.data.tipo_nodo)
  const showSqlPreview = selectedNode && selectedNode.data.tipo_nodo === "bd"
  const showCodeSnippets = selectedNode && selectedNode.data.tipo_nodo !== "carpeta"
  const showNodeDetails = selectedNode && selectedNode.data.tipo_nodo !== "carpeta"
  const showDiagramasMermaid = selectedNode // Disponible para TODOS los nodos

  const getTabContent = () => {
    switch (activeTab) {
      case 0: // Detalles
        return (
          <Box sx={{ display: "flex", flexDirection: "column", gap: 2 }}>
            {showNodeDetails && <NodeDetails />}
            {showSqlPreview && <SqlPreview />}
            {/* Para carpetas, mostrar mensaje informativo */}
            {selectedNode && selectedNode.data.tipo_nodo === "carpeta" && (
              <Alert severity="info" sx={{ mb: 2 }}>
                <Typography variant="body2">
                  📁 <strong>Nodo Contenedor: {selectedNode.text}</strong>
                  <br />
                  Los nodos contenedor organizan la estructura del proyecto.
                  <br />
                  Usa las pestañas "Diagramas" para documentar la arquitectura de esta sección.
                </Typography>
              </Alert>
            )}
          </Box>
        )
      case 1: // Registros
        return showTablaRegistros ? (
          <TablaRegistros expanded />
        ) : (
          <Alert severity="info">Los registros están disponibles para nodos JS, C#, HTML y Reporte.</Alert>
        )
      case 2: // Snippets
        return showCodeSnippets ? (
          <CodeSnippets />
        ) : (
          <Alert severity="info">Los snippets están disponibles para todos los nodos excepto carpetas.</Alert>
        )
      case 3: // Diagramas
        return showDiagramasMermaid ? (
          <MermaidLoader>
            <DiagramasMermaid
              nodeId={selectedNode.id || "default-node"}
              projectId={currentProject?.id || 1}
            />
          </MermaidLoader>
        ) : (
          <Alert severity="info">Los diagramas están disponibles para todos los nodos.</Alert>
        )
      default:
        return null
    }
  }

  return (
    <ThemeProvider theme={darkMode ? darkTheme : lightTheme}>
      <CssBaseline />
      {/* App Bar */}
      <AppBar position="static" elevation={1}>
        <Toolbar>
          <Typography variant="h6" component="div" sx={{ flexGrow: 1 }}>
            📚 Mapper-Systems - {currentProject ? currentProject.nombre : "Sin proyecto"}
          </Typography>
          <Typography variant="body2" sx={{ mr: 2 }}>
            Usuario: {currentUser}
          </Typography>
          {/* Botón para alternar modo oscuro */}
          <Tooltip title={darkMode ? "Modo claro" : "Modo oscuro"}>
            <IconButton color="inherit" onClick={toggleDarkMode} sx={{ mr: 1 }}>
              {darkMode ? <WbSunny /> : <DarkMode />}
            </IconButton>
          </Tooltip>
          <Tooltip title="Gestor de Proyectos">
            <IconButton color="inherit" onClick={() => setProjectManagerOpen(true)}>
              <Settings />
            </IconButton>
          </Tooltip>
        </Toolbar>
      </AppBar>

      <Container maxWidth="xl" sx={{ py: 3 }}>
        {!currentProject ? (
          <Box sx={{ textAlign: "center", py: 8 }}>
            <Folder sx={{ fontSize: 80, color: "text.secondary", mb: 2 }} />
            <Typography variant="h4" gutterBottom>
              ¡Bienvenido a Mapper-Systems!
            </Typography>
            <Typography variant="body1" color="text.secondary" sx={{ mb: 4 }}>
              Para comenzar, crea o selecciona un proyecto de documentación.
            </Typography>
            <Box sx={{ display: "flex", gap: 2, justifyContent: "center" }}>
              <IconButton
                size="large"
                color="primary"
                onClick={() => setProjectManagerOpen(true)}
                sx={{ border: 1, borderColor: "primary.main" }}
              >
                <Add />
              </IconButton>
              <Typography variant="body2" sx={{ alignSelf: "center" }}>
                Crear nuevo proyecto
              </Typography>
            </Box>
          </Box>
        ) : (
          <Grid container spacing={3}>
            {/* Columna izquierda - Árbol y Formulario */}
            <Grid item xs={12} md={4}>
              <Box sx={{ display: "flex", flexDirection: "column", gap: 2 }}>
                <TreeView />
                <NodeForm />
              </Box>
            </Grid>
            {/* Columna derecha - Contenido con tabs */}
            <Grid item xs={12} md={8}>
              {selectedNode ? (
                <Box>
                  <Tabs
                    value={activeTab}
                    onChange={(_, newValue) => setActiveTab(newValue)}
                    sx={{ borderBottom: 1, borderColor: "divider", mb: 2 }}
                  >
                    <Tab label="📋 Detalles" />
                    <Tab label="📝 Registros" disabled={!showTablaRegistros} />
                    <Tab label="💾 Snippets" disabled={!showCodeSnippets} />
                    <Tab label="📊 Diagramas" />
                  </Tabs>
                  {getTabContent()}
                </Box>
              ) : (
                <Box sx={{ p: 4, textAlign: "center", color: "text.secondary" }}>
                  <Typography variant="h6" gutterBottom>
                    Selecciona un nodo para comenzar
                  </Typography>
                  <Typography variant="body2">
                    • <strong>Carpetas:</strong> Organizan la estructura + Diagramas de arquitectura
                  </Typography>
                  <Typography variant="body2">
                    • <strong>BD:</strong> Archivos SQL con previsualización + Diagramas ER
                  </Typography>
                  <Typography variant="body2">
                    • <strong>JS/CS/HTML/Reporte:</strong> Registros + Snippets + Diagramas de flujo
                  </Typography>
                </Box>
              )}
            </Grid>
          </Grid>
        )}

        {/* Project Manager */}
        <ProjectManager
          open={projectManagerOpen}
          onClose={() => setProjectManagerOpen(false)}
          onProjectSelect={handleProjectSelect}
          projects={projects}
          onProjectsUpdate={refreshProjects}
        />

        {/* Notificaciones */}
        <Snackbar
          open={!!notification}
          autoHideDuration={4000}
          onClose={() => setNotification(null)}
          anchorOrigin={{ vertical: "bottom", horizontal: "right" }}
        >
          <Alert onClose={() => setNotification(null)} severity={notification?.type || "info"} sx={{ width: "100%" }}>
            {notification?.message}
          </Alert>
        </Snackbar>
      </Container>
    </ThemeProvider>
  )
}

function App() {
  const [notification, setNotification] = useState<{ message: string; type: "success" | "error" | "warning" } | null>(null)

  const handleNotification = (message: string, type: "success" | "error" | "warning" )  => {
    setNotification({ message, type })
  }

  return (
    <AppProvider onNotification={handleNotification}>
      <AppContent />
    </AppProvider>
  )
}

export default App

"use client"
import type React from "react"
import { useState, useEffect, useCallback } from "react"
import {
  Box,
  Card,
  CardContent,
  CardActions,
  Typography,
  Button,
  Grid,
  IconButton,
  Menu,
  MenuItem,
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  Chip,
  Alert,
  Fab,
  Zoom,
} from "@mui/material"
import {
  Add as AddIcon,
  Edit as EditIcon,
  Delete as DeleteIcon,
  MoreVert as MoreVertIcon,
  Visibility as VisibilityIcon,
  ContentCopy as ContentCopyIcon,
} from "@mui/icons-material"
import { MermaidEditor } from "./MermaidEditor"
import MermaidRenderer from "./MermaidRenderer"
import { useAppContext } from "../contexts/AppContext"
import type { MermaidDiagram, MermaidDiagramType } from "../types"

interface DiagramasMermaidProps {
  nodeId: string
  projectId: number
}

// Mapeo de tipos de diagrama a colores y etiquetas
const DIAGRAM_TYPE_INFO: Record<MermaidDiagramType, { label: string; color: string; emoji: string }> = {
  flowchart: { label: "Flowchart", color: "#2196f3", emoji: "🔄" },
  sequence: { label: "Sequence", color: "#4caf50", emoji: "📋" },
  classDiagram: { label: "Class", color: "#ff9800", emoji: "🏗️" },
  stateDiagram: { label: "State", color: "#9c27b0", emoji: "🔀" },
  erDiagram: { label: "ER Diagram", color: "#f44336", emoji: "🗃️" },
  journey: { label: "User Journey", color: "#00bcd4", emoji: "🚶" },
  gantt: { label: "Gantt", color: "#795548", emoji: "📅" },
  pie: { label: "Pie Chart", color: "#607d8b", emoji: "🥧" },
  gitgraph: { label: "Git Graph", color: "#3f51b5", emoji: "🌳" },
  mindmap: { label: "Mind Map", color: "#e91e63", emoji: "🧠" },
  timeline: { label: "Timeline", color: "#009688", emoji: "⏰" },
  quadrant: { label: "Quadrant", color: "#673ab7", emoji: "📊" },
  requirementDiagram: { label: "Requirement", color: "#ff5722", emoji: "📝" },
  c4: { label: "C4 Diagram", color: "#9e9e9e", emoji: "🏢" },
  xychart: { label: "XY Chart", color: "#1976d2", emoji: "📈" },
  block: { label: "Block", color: "#388e3c", emoji: "🧱" },
  packet: { label: "Packet", color: "#7b1fa2", emoji: "📦" },
  kanban: { label: "Kanban", color: "#f57c00", emoji: "📋" },
  architecture: { label: "Architecture", color: "#5d4037", emoji: "🏗️" },
  radar: { label: "Radar", color: "#d32f2f", emoji: "🎯" },
}

export const DiagramasMermaid: React.FC<DiagramasMermaidProps> = ({ nodeId, projectId }) => {
  const { darkMode, showNotification } = useAppContext()
  const [diagramas, setDiagramas] = useState<MermaidDiagram[]>([])
  const [loading, setLoading] = useState(true)
  const [editorOpen, setEditorOpen] = useState(false)
  const [selectedDiagram, setSelectedDiagram] = useState<MermaidDiagram | null>(null)
  const [deleteDialogOpen, setDeleteDialogOpen] = useState(false)
  const [diagramToDelete, setDiagramToDelete] = useState<MermaidDiagram | null>(null)
  const [anchorEl, setAnchorEl] = useState<null | HTMLElement>(null)
  const [menuDiagram, setMenuDiagram] = useState<MermaidDiagram | null>(null)
  const [viewDialogOpen, setViewDialogOpen] = useState(false)
  const [viewDiagram, setViewDiagram] = useState<MermaidDiagram | null>(null)

  // Cargar diagramas
  const loadDiagramas = useCallback(async () => {
    try {
      setLoading(true)
      // Simular carga de datos - aquí iría la llamada real a la API
      const mockDiagramas: MermaidDiagram[] = [
        {
          id: 1,
          titulo: "Flujo de Autenticación",
          descripcion: "Diagrama de flujo del proceso de autenticación de usuarios",
          tipo_diagrama: "flowchart",
          codigo_mermaid: `flowchart TD
    A[Usuario] --> B{¿Credenciales válidas?}
    B -->|Sí| C[Acceso concedido]
    B -->|No| D[Acceso denegado]`,
          nodo_id: nodeId,
          proyecto_id: projectId,
          orden: 1,
          fecha_creacion: new Date().toISOString(),
          fecha_actualizacion: new Date().toISOString(),
        },
        {
          id: 2,
          titulo: "Arquitectura del Sistema",
          descripcion: "Diagrama de la arquitectura general del sistema",
          tipo_diagrama: "block",
          codigo_mermaid: `block-beta
    columns 3
    Frontend["🖥️ Frontend"] space Backend["⚙️ Backend"]
    Database[("🗄️ Database")]
    
    Frontend --> Backend
    Backend --> Database`,
          nodo_id: nodeId,
          proyecto_id: projectId,
          orden: 2,
          fecha_creacion: new Date().toISOString(),
          fecha_actualizacion: new Date().toISOString(),
        },
      ]
      setDiagramas(mockDiagramas)
    } catch (error) {
      console.error("Error loading diagrams:", error)
      showNotification("Error al cargar los diagramas", "error")
    } finally {
      setLoading(false)
    }
  }, [nodeId, projectId, showNotification])

  useEffect(() => {
    loadDiagramas()
  }, [loadDiagramas])

  // Abrir editor para crear nuevo diagrama
  const handleCreateDiagram = () => {
    setSelectedDiagram(null)
    setEditorOpen(true)
  }

  // Abrir editor para editar diagrama existente
  const handleEditDiagram = (diagram: MermaidDiagram) => {
    setSelectedDiagram(diagram)
    setEditorOpen(true)
    handleCloseMenu()
  }

  // Guardar diagrama
  const handleSaveDiagram = async (diagramData: Partial<MermaidDiagram>) => {
    try {
      if (selectedDiagram) {
        // Actualizar diagrama existente
        const updatedDiagram = { ...selectedDiagram, ...diagramData }
        setDiagramas((prev) => prev.map((d) => (d.id === selectedDiagram.id ? updatedDiagram : d)))
        showNotification("Diagrama actualizado exitosamente", "success")
      } else {
        // Crear nuevo diagrama
        const newDiagram: MermaidDiagram = {
          id: Date.now(), // En producción sería generado por el backend
          ...diagramData,
          nodo_id: nodeId,
          proyecto_id: projectId,
          orden: diagramas.length + 1,
          fecha_creacion: new Date().toISOString(),
          fecha_actualizacion: new Date().toISOString(),
        } as MermaidDiagram
        setDiagramas((prev) => [...prev, newDiagram])
        showNotification("Diagrama creado exitosamente", "success")
      }
    } catch (error) {
      console.error("Error saving diagram:", error)
      showNotification("Error al guardar el diagrama", "error")
      throw error
    }
  }

  // Eliminar diagrama
  const handleDeleteDiagram = async () => {
    if (!diagramToDelete) return

    try {
      setDiagramas((prev) => prev.filter((d) => d.id !== diagramToDelete.id))
      showNotification("Diagrama eliminado exitosamente", "success")
      setDeleteDialogOpen(false)
      setDiagramToDelete(null)
    } catch (error) {
      console.error("Error deleting diagram:", error)
      showNotification("Error al eliminar el diagrama", "error")
    }
  }

  // Abrir menú de opciones
  const handleOpenMenu = (event: React.MouseEvent<HTMLElement>, diagram: MermaidDiagram) => {
    setAnchorEl(event.currentTarget)
    setMenuDiagram(diagram)
  }

  // Cerrar menú de opciones
  const handleCloseMenu = () => {
    setAnchorEl(null)
    setMenuDiagram(null)
  }

  // Ver diagrama en pantalla completa
  const handleViewDiagram = (diagram: MermaidDiagram) => {
    setViewDiagram(diagram)
    setViewDialogOpen(true)
    handleCloseMenu()
  }

  // Copiar código del diagrama
  const handleCopyCode = async (diagram: MermaidDiagram) => {
    try {
      await navigator.clipboard.writeText(diagram.codigo_mermaid)
      showNotification("Código copiado al portapapeles", "success")
      handleCloseMenu()
    } catch (error) {
      console.error("Error copying code:", error)
      showNotification("Error al copiar el código", "error")
    }
  }

  // Duplicar diagrama
  const handleDuplicateDiagram = (diagram: MermaidDiagram) => {
    const duplicatedDiagram: MermaidDiagram = {
      ...diagram,
      id: Date.now(),
      titulo: `${diagram.titulo} (Copia)`,
      fecha_creacion: new Date().toISOString(),
      fecha_actualizacion: new Date().toISOString(),
    }
    setDiagramas((prev) => [...prev, duplicatedDiagram])
    showNotification("Diagrama duplicado exitosamente", "success")
    handleCloseMenu()
  }

  if (loading) {
    return (
      <Box display="flex" justifyContent="center" alignItems="center" minHeight="200px">
        <Typography>Cargando diagramas...</Typography>
      </Box>
    )
  }

  return (
    <Box>
      {/* Header */}
      <Box display="flex" justifyContent="space-between" alignItems="center" mb={3}>
        <Typography variant="h5" component="h2">
          Diagramas Mermaid
        </Typography>
        <Button variant="contained" startIcon={<AddIcon />} onClick={handleCreateDiagram}>
          Nuevo Diagrama
        </Button>
      </Box>

      {/* Lista de diagramas */}
      {diagramas.length === 0 ? (
        <Alert severity="info" sx={{ mb: 2 }}>
          <Typography variant="body1">
            No hay diagramas creados aún. Haz clic en "Nuevo Diagrama" para crear tu primer diagrama Mermaid.
          </Typography>
        </Alert>
      ) : (
        <Grid container spacing={3}>
          {diagramas.map((diagram) => {
            const typeInfo = DIAGRAM_TYPE_INFO[diagram.tipo_diagrama]
            return (
              <Grid item xs={12} sm={6} md={4} key={diagram.id}>
                <Card
                  sx={{
                    height: "100%",
                    display: "flex",
                    flexDirection: "column",
                    transition: "all 0.2s",
                    "&:hover": {
                      transform: "translateY(-2px)",
                      boxShadow: 4,
                    },
                  }}
                >
                  <CardContent sx={{ flex: 1 }}>
                    <Box display="flex" justifyContent="space-between" alignItems="flex-start" mb={2}>
                      <Typography variant="h6" component="h3" noWrap sx={{ flex: 1, mr: 1 }}>
                        {diagram.titulo}
                      </Typography>
                      <IconButton size="small" onClick={(e) => handleOpenMenu(e, diagram)}>
                        <MoreVertIcon />
                      </IconButton>
                    </Box>

                    <Box mb={2}>
                      <Chip
                        label={`${typeInfo.emoji} ${typeInfo.label}`}
                        size="small"
                        sx={{
                          backgroundColor: typeInfo.color,
                          color: "white",
                        }}
                      />
                    </Box>

                    {diagram.descripcion && (
                      <Typography variant="body2" color="text.secondary" sx={{ mb: 2 }}>
                        {diagram.descripcion}
                      </Typography>
                    )}

                    {/* Preview del diagrama */}
                    <Box
                      sx={{
                        height: 150,
                        border: "1px solid",
                        borderColor: "divider",
                        borderRadius: 1,
                        overflow: "hidden",
                        backgroundColor: darkMode ? "#1e1e1e" : "#fafafa",
                      }}
                    >
                      <MermaidRenderer
                        code={diagram.codigo_mermaid}
                        darkMode={darkMode}
                        onError={() => {
                          // Silenciar errores en preview
                        }}
                        shouldRender={true}
                      />
                    </Box>
                  </CardContent>

                  <CardActions>
                    <Button size="small" startIcon={<VisibilityIcon />} onClick={() => handleViewDiagram(diagram)}>
                      Ver
                    </Button>
                    <Button size="small" startIcon={<EditIcon />} onClick={() => handleEditDiagram(diagram)}>
                      Editar
                    </Button>
                  </CardActions>
                </Card>
              </Grid>
            )
          })}
        </Grid>
      )}

      {/* FAB para crear nuevo diagrama */}
      <Zoom in={diagramas.length > 0}>
        <Fab
          color="primary"
          aria-label="add"
          sx={{
            position: "fixed",
            bottom: 16,
            right: 16,
          }}
          onClick={handleCreateDiagram}
        >
          <AddIcon />
        </Fab>
      </Zoom>

      {/* Editor de diagramas */}
      <MermaidEditor
        open={editorOpen}
        onClose={() => setEditorOpen(false)}
        onSave={handleSaveDiagram}
        initialDiagram={selectedDiagram}
        nodeId={nodeId}
        projectId={projectId}
      />

      {/* Menú de opciones */}
      <Menu anchorEl={anchorEl} open={Boolean(anchorEl)} onClose={handleCloseMenu}>
        <MenuItem onClick={() => menuDiagram && handleViewDiagram(menuDiagram)}>
          <VisibilityIcon sx={{ mr: 1 }} />
          Ver
        </MenuItem>
        <MenuItem onClick={() => menuDiagram && handleEditDiagram(menuDiagram)}>
          <EditIcon sx={{ mr: 1 }} />
          Editar
        </MenuItem>
        <MenuItem onClick={() => menuDiagram && handleCopyCode(menuDiagram)}>
          <ContentCopyIcon sx={{ mr: 1 }} />
          Copiar código
        </MenuItem>
        <MenuItem onClick={() => menuDiagram && handleDuplicateDiagram(menuDiagram)}>
          <ContentCopyIcon sx={{ mr: 1 }} />
          Duplicar
        </MenuItem>
        <MenuItem
          onClick={() => {
            if (menuDiagram) {
              setDiagramToDelete(menuDiagram)
              setDeleteDialogOpen(true)
              handleCloseMenu()
            }
          }}
          sx={{ color: "error.main" }}
        >
          <DeleteIcon sx={{ mr: 1 }} />
          Eliminar
        </MenuItem>
      </Menu>

      {/* Dialog para ver diagrama */}
      <Dialog
        open={viewDialogOpen}
        onClose={() => setViewDialogOpen(false)}
        maxWidth="lg"
        fullWidth
        PaperProps={{
          sx: { height: "80vh" },
        }}
      >
        <DialogTitle>
          <Box display="flex" justifyContent="space-between" alignItems="center">
            <Typography variant="h6">{viewDiagram?.titulo}</Typography>
            {viewDiagram && (
              <Chip
                label={`${DIAGRAM_TYPE_INFO[viewDiagram.tipo_diagrama].emoji} ${
                  DIAGRAM_TYPE_INFO[viewDiagram.tipo_diagrama].label
                }`}
                size="small"
                sx={{
                  backgroundColor: DIAGRAM_TYPE_INFO[viewDiagram.tipo_diagrama].color,
                  color: "white",
                }}
              />
            )}
          </Box>
        </DialogTitle>
        <DialogContent sx={{ p: 0 }}>
          {viewDiagram && (
            <Box sx={{ height: "100%", p: 2 }}>
              <MermaidRenderer code={viewDiagram.codigo_mermaid} darkMode={darkMode} shouldRender={true} />
            </Box>
          )}
        </DialogContent>
        <DialogActions>
          <Button onClick={() => setViewDialogOpen(false)}>Cerrar</Button>
          {viewDiagram && (
            <Button
              variant="contained"
              startIcon={<EditIcon />}
              onClick={() => {
                setViewDialogOpen(false)
                handleEditDiagram(viewDiagram)
              }}
            >
              Editar
            </Button>
          )}
        </DialogActions>
      </Dialog>

      {/* Dialog de confirmación para eliminar */}
      <Dialog open={deleteDialogOpen} onClose={() => setDeleteDialogOpen(false)}>
        <DialogTitle>Confirmar eliminación</DialogTitle>
        <DialogContent>
          <Typography>
            ¿Estás seguro de que deseas eliminar el diagrama "{diagramToDelete?.titulo}"? Esta acción no se puede
            deshacer.
          </Typography>
        </DialogContent>
        <DialogActions>
          <Button onClick={() => setDeleteDialogOpen(false)}>Cancelar</Button>
          <Button onClick={handleDeleteDiagram} color="error" variant="contained">
            Eliminar
          </Button>
        </DialogActions>
      </Dialog>
    </Box>
  )
}

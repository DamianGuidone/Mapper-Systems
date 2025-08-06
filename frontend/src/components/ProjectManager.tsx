"use client"

import type React from "react"
import { useState, useEffect } from "react"
import {
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  Button,
  TextField,
  Box,
  Typography,
  Card,
  CardContent,
  CardActions,
  Grid,
  Chip,
  IconButton,
  Tooltip,
  Alert,
} from "@mui/material"
import { Add, Edit, Delete, Download, Folder, Code, Description } from "@mui/icons-material"
import type { Project } from "../types"
import { projectsApi } from "../services/api"

interface ProjectManagerProps {
  open: boolean
  onClose: () => void
  onProjectSelect: (project: Project) => void
  projects: Project[]
  onProjectsUpdate: () => void
}

export const ProjectManager: React.FC<ProjectManagerProps> = ({
  open,
  onClose,
  onProjectSelect,
  projects,
  onProjectsUpdate,
}) => {
  const [formOpen, setFormOpen] = useState(false)
  const [selectedProject, setSelectedProject] = useState<Project | null>(null)
  const [formData, setFormData] = useState({
    nombre: "",
    descripcion: "",
  })
  const [nameConflict, setNameConflict] = useState({
    exists: false,
    projectId: 0,
    active: false,
    name: ""
  })

  // Resetear conflictos al abrir/cerrar el formulario
  useEffect(() => {
    if (formOpen) {
      setNameConflict({ exists: false, projectId: 0, active: false, name: "" })
    }
  }, [formOpen])

  const checkProjectName = async (name: string) => {
    try {
      const response = await fetch('/api/projects/check-name', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ nombre: name })
      })
      return await response.json()
    } catch (error) {
      console.error("Error checking project name:", error)
      return { available: true }
    }
  }

  const handleCreateProject = async () => {
    try {
      // Verificar si el nombre está disponible
      const checkResult = await checkProjectName(formData.nombre)
      
      if (!checkResult.available) {
        setNameConflict({
          exists: true,
          projectId: checkResult.project_id,
          active: checkResult.active,
          name: formData.nombre
        })
        return
      }
      
      // Si el nombre está disponible, crear proyecto
      await projectsApi.createProject(formData)
      onProjectsUpdate()
      setFormOpen(false)
      resetForm()
    } catch (error) {
      console.error("Error creating project:", error)
    }
  }

  const handleReactivateProject = async () => {
    if (!nameConflict.projectId) return
    
    try {
      const response = await fetch(`/api/projects/${nameConflict.projectId}/reactivate`, {
        method: 'PUT'
      })
      const result = await response.json()
      
      if (result.success) {
        onProjectsUpdate()
        setFormOpen(false)
        resetForm()
        
        // Seleccionar el proyecto reactivado
        const reactivatedProject = projects.find(p => p.id === nameConflict.projectId)
        if (reactivatedProject) {
          setTimeout(() => onProjectSelect(reactivatedProject), 300)
        }
      }
    } catch (error) {
      console.error("Error reactivating project:", error)
    }
  }

  const handleEditProject = (project: Project) => {
    setSelectedProject(project)
    setFormData({
      nombre: project.nombre,
      descripcion: project.descripcion,
    })
    setFormOpen(true)
  }

  const handleUpdateProject = async () => {
    if (!selectedProject) return

    try {
      // Si el nombre cambió, verificar disponibilidad
      if (selectedProject.nombre !== formData.nombre) {
        const checkResult = await checkProjectName(formData.nombre)
        
        if (!checkResult.available) {
          setNameConflict({
            exists: true,
            projectId: checkResult.project_id,
            active: checkResult.active,
            name: formData.nombre
          })
          return
        }
      }
      
      await projectsApi.updateProject(selectedProject.id, formData)
      onProjectsUpdate()
      setFormOpen(false)
      resetForm()
    } catch (error) {
      console.error("Error updating project:", error)
    }
  }

  const handleDeleteProject = async (project: Project) => {
    if (!confirm(`¿Eliminar el proyecto "${project.nombre}"?`)) return

    try {
      await projectsApi.deleteProject(project.id)
      onProjectsUpdate()
    } catch (error) {
      console.error("Error deleting project:", error)
    }
  }

  const handleExportProject = async (project: Project) => {
    try {
      const response = await projectsApi.exportProject(project.id)
      const blob = new Blob([JSON.stringify(response.data, null, 2)], { type: "application/json" })
      const url = URL.createObjectURL(blob)
      const a = document.createElement("a")
      a.href = url
      a.download = `${project.nombre}_export.json`
      a.click()
      URL.revokeObjectURL(url)
    } catch (error) {
      console.error("Error exporting project:", error)
    }
  }

  const resetForm = () => {
    setFormData({ nombre: "", descripcion: "" })
    setSelectedProject(null)
    setNameConflict({ exists: false, projectId: 0, active: false, name: "" })
  }

  const formatDate = (dateString: string) => {
    return new Date(dateString).toLocaleDateString("es-ES", {
      year: "numeric",
      month: "short",
      day: "numeric",
      hour: "2-digit",
      minute: "2-digit",
    })
  }

  return (
    <>
      <Dialog open={open} onClose={onClose} maxWidth="lg" fullWidth>
        <DialogTitle>
          <Box sx={{ display: "flex", justifyContent: "between", alignItems: "center" }}>
            <Typography variant="h6">🗂️ Gestor de Proyectos</Typography>
            <Button
              variant="contained"
              startIcon={<Add />}
              onClick={() => {
                resetForm()
                setFormOpen(true)
              }}
            >
              Nuevo Proyecto
            </Button>
          </Box>
        </DialogTitle>
        <DialogContent>
          {projects.length === 0 ? (
            <Alert severity="info" sx={{ mt: 2 }}>
              <Typography variant="body2">
                <strong>¡Bienvenido!</strong>
                <br />
                No tienes proyectos creados. Crea tu primer proyecto para comenzar a documentar tu código.
              </Typography>
            </Alert>
          ) : (
            <Grid container spacing={3} sx={{ mt: 1 }}>
              {projects.map((project) => (
                <Grid item xs={12} md={6} lg={4} key={project.id}>
                  <Card
                    sx={{
                      height: "100%",
                      display: "flex",
                      flexDirection: "column",
                      cursor: "pointer",
                      transition: "all 0.2s ease",
                      "&:hover": {
                        transform: "translateY(-2px)",
                        boxShadow: 4,
                      },
                    }}
                    onClick={() => {
                      onProjectSelect(project)
                      onClose()
                    }}
                  >
                    <CardContent sx={{ flexGrow: 1 }}>
                      <Box sx={{ display: "flex", alignItems: "center", mb: 2 }}>
                        <Folder color="primary" sx={{ mr: 1 }} />
                        <Typography variant="h6" noWrap>
                          {project.nombre}
                        </Typography>
                      </Box>

                      <Typography variant="body2" color="text.secondary" sx={{ mb: 2, minHeight: 40 }}>
                        {project.descripcion || "Sin descripción"}
                      </Typography>

                      <Box sx={{ display: "flex", gap: 1, mb: 2, flexWrap: "wrap" }}>
                        <Chip
                          icon={<Folder />}
                          label={`${project.stats.total_nodos} nodos`}
                          size="small"
                          color="primary"
                          variant="outlined"
                        />
                        <Chip
                          icon={<Description />}
                          label={`${project.stats.total_registros} registros`}
                          size="small"
                          color="secondary"
                          variant="outlined"
                        />
                        <Chip
                          icon={<Code />}
                          label={`${project.stats.total_snippets} snippets`}
                          size="small"
                          color="success"
                          variant="outlined"
                        />
                      </Box>

                      <Typography variant="caption" color="text.secondary">
                        Modificado: {formatDate(project.fecha_modificacion)}
                      </Typography>
                    </CardContent>

                    <CardActions sx={{ justifyContent: "space-between", pt: 0 }}>
                      <Box>
                        <Tooltip title="Editar proyecto">
                          <IconButton
                            size="small"
                            onClick={(e) => {
                              e.stopPropagation()
                              handleEditProject(project)
                            }}
                          >
                            <Edit />
                          </IconButton>
                        </Tooltip>
                        <Tooltip title="Exportar proyecto">
                          <IconButton
                            size="small"
                            onClick={(e) => {
                              e.stopPropagation()
                              handleExportProject(project)
                            }}
                          >
                            <Download />
                          </IconButton>
                        </Tooltip>
                        <Tooltip title="Eliminar proyecto">
                          <IconButton
                            size="small"
                            color="error"
                            onClick={(e) => {
                              e.stopPropagation()
                              handleDeleteProject(project)
                            }}
                          >
                            <Delete />
                          </IconButton>
                        </Tooltip>
                      </Box>
                      <Typography variant="caption" color="primary">
                        ID: {project.id}
                      </Typography>
                    </CardActions>
                  </Card>
                </Grid>
              ))}
            </Grid>
          )}
        </DialogContent>
        <DialogActions>
          <Button onClick={onClose}>Cerrar</Button>
        </DialogActions>
      </Dialog>

      {/* Dialog para crear/editar proyecto */}
      <Dialog open={formOpen} onClose={() => setFormOpen(false)} maxWidth="sm" fullWidth>
        <DialogTitle>{selectedProject ? "Editar Proyecto" : "Nuevo Proyecto"}</DialogTitle>
        <DialogContent>
          <Box sx={{ display: "flex", flexDirection: "column", gap: 2, pt: 1 }}>
            {nameConflict.exists && (
              <Alert severity="warning" sx={{ mb: 2 }}>
                {nameConflict.active ? (
                  <Typography>
                    <strong>¡Proyecto existente!</strong> Ya hay un proyecto activo con el nombre "{nameConflict.name}".
                  </Typography>
                ) : (
                  <Typography>
                    <strong>¡Proyecto archivado!</strong> Hay un proyecto archivado con el nombre "{nameConflict.name}".
                  </Typography>
                )}
              </Alert>
            )}
            
            <TextField
              fullWidth
              label="Nombre del Proyecto"
              value={formData.nombre}
              onChange={(e) => setFormData({ ...formData, nombre: e.target.value })}
              required
              placeholder="Ej: Sistema de Usuarios, E-commerce, etc."
              error={nameConflict.exists}
              helperText={nameConflict.exists ? "Nombre no disponible" : ""}
            />
            <TextField
              fullWidth
              label="Descripción"
              value={formData.descripcion}
              onChange={(e) => setFormData({ ...formData, descripcion: e.target.value })}
              multiline
              rows={3}
              placeholder="Describe el propósito y alcance del proyecto..."
            />
          </Box>
        </DialogContent>
        <DialogActions>
          {nameConflict.exists && (
            <Button 
              color="secondary" 
              onClick={() => {
                if (nameConflict.active) {
                  // Abrir proyecto existente
                  const existingProject = projects.find(p => p.id === nameConflict.projectId)
                  if (existingProject) {
                    onProjectSelect(existingProject)
                    setFormOpen(false)
                    resetForm()
                    onClose()
                  }
                } else {
                  // Reactivar proyecto archivado
                  handleReactivateProject()
                }
              }}
            >
              {nameConflict.active ? "Abrir Proyecto Existente" : "Reactivar Proyecto Archivado"}
            </Button>
          )}
          
          <Button onClick={() => setFormOpen(false)}>Cancelar</Button>
          <Button
            onClick={selectedProject ? handleUpdateProject : handleCreateProject}
            variant="contained"
            disabled={!formData.nombre.trim()}
          >
            {selectedProject ? "Actualizar" : "Crear"}
          </Button>
        </DialogActions>
      </Dialog>
    </>
  )
}
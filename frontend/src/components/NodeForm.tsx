"use client"

import type React from "react"
import { useState } from "react"
import {
  Card,
  CardContent,
  Typography,
  TextField,
  Button,
  Box,
  FormControl,
  InputLabel,
  Select,
  MenuItem,
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  IconButton,
  Alert,
} from "@mui/material"
import { Add, FolderOpen, Info } from "@mui/icons-material"
import type { TreeNode, NodeData } from "../types"
import { FileExplorer } from "./FileExplorer"
import { useAppContext } from "../contexts/AppContext"
import { nodesApi } from "../services/api"

export const NodeForm: React.FC = () => {
  const { currentProject, selectedNode, treeData, setTreeData, refreshTree, showNotification } = useAppContext()

  const [open, setOpen] = useState(false)
  const [fileExplorerOpen, setFileExplorerOpen] = useState(false)
  const [formData, setFormData] = useState({
    text: "",
    tipo_nodo: "carpeta" as NodeData["tipo_nodo"],
    descripcion: "",
    archivo: "",
  })

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()

    if (!currentProject) {
      showNotification("No hay proyecto seleccionado", "error")
      return
    }

    const nodeId = "node_" + Math.random().toString(36).substr(2, 9)
    const isContainer = formData.tipo_nodo === "carpeta"

    const nodeData: Partial<TreeNode> = {
      id: nodeId,
      text: formData.text,
      type: isContainer ? "default" : "leaf",
      parent: selectedNode?.id || "#", // Si no hay nodo seleccionado, crear en la raíz
      data: {
        descripcion: formData.descripcion,
        tipo_nodo: formData.tipo_nodo,
        archivo: formData.tipo_nodo === "bd" ? formData.archivo : undefined,
        historial_file: `history/${nodeId}.json`,
      },
      state: {
        loaded: true,
        opened: false,
        selected: false,
        disabled: false,
      },
      icon: getNodeIcon(formData.tipo_nodo),
    }

    try {
      await nodesApi.createNode(currentProject.id, nodeData)
      const newNode = nodeData as TreeNode
      const updatedTreeData = [...treeData, newNode]
      setTreeData(updatedTreeData)
      await nodesApi.saveTree(currentProject.id, updatedTreeData)
      await refreshTree()
      showNotification(`Nodo "${nodeData.text}" creado exitosamente`, "success")

      // Reset form
      setFormData({
        text: "",
        tipo_nodo: "carpeta",
        descripcion: "",
        archivo: "",
      })
      setOpen(false)
    } catch (error) {
      console.error("Error creating node:", error)
      showNotification("Error al crear el nodo", "error")
    }
  }

  const getNodeIcon = (tipo: NodeData["tipo_nodo"]) => {
    const icons = {
      carpeta: "fas fa-folder",
      bd: "fas fa-database",
      js: "fab fa-js",
      cs: "fab fa-microsoft",
      html: "fab fa-html5",
      reporte: "far fa-chart-bar",
    }
    return icons[tipo]
  }

  const handleFileSelect = (filePath: string) => {
    setFormData({ ...formData, archivo: filePath })
    setFileExplorerOpen(false)
  }

  const getContextMessage = () => {
    if (selectedNode) {
      return `Crear nodo hijo de: ${selectedNode.text}`
    }
    return "Crear nodo raíz (múltiples nodos raíz permitidos)"
  }

  const getNodeTypeDescription = (tipo: NodeData["tipo_nodo"]) => {
    const descriptions = {
      carpeta: "Contenedor para organizar otros nodos. Permite drag & drop.",
      bd: "Nodo para archivos SQL con previsualización con formato.",
      js: "Nodo JavaScript con tabla de registros detallada.",
      cs: "Nodo C# con tabla de registros detallada.",
      html: "Nodo HTML con tabla de registros detallada.",
      reporte: "Nodo de reporte con tabla de registros detallada.",
    }
    return descriptions[tipo]
  }

  if (!currentProject) {
    return (
      <Card>
        <CardContent>
          <Alert severity="warning">Selecciona un proyecto para crear nodos</Alert>
        </CardContent>
      </Card>
    )
  }

  return (
    <>
      <Card>
        <CardContent>
          <Box sx={{ display: "flex", justifyContent: "between", alignItems: "center", mb: 2 }}>
            <Typography variant="h6">Agregar Nuevo Nodo</Typography>
            <Button variant="contained" startIcon={<Add />} onClick={() => setOpen(true)}>
              Nuevo Nodo
            </Button>
          </Box>

          <Alert severity="info" sx={{ mb: 2 }}>
            <Typography variant="body2">
              <strong>{getContextMessage()}</strong>
            </Typography>
            <Typography variant="caption" display="block" sx={{ mt: 0.5 }}>
              💡 Proyecto actual: <strong>{currentProject.nombre}</strong>
            </Typography>
          </Alert>

          {selectedNode && (
            <Box sx={{ p: 2, backgroundColor: "rgba(144, 202, 249, 0.1)", borderRadius: 1 }}>
              <Typography variant="body2" color="primary">
                📁 Nodo padre seleccionado: <strong>{selectedNode.text}</strong>
              </Typography>
              <Typography variant="caption" color="text.secondary">
                Tipo: {selectedNode.data.tipo_nodo} | ID: {selectedNode.id}
              </Typography>
            </Box>
          )}
        </CardContent>
      </Card>

      <Dialog open={open} onClose={() => setOpen(false)} maxWidth="sm" fullWidth>
        <form onSubmit={handleSubmit}>
          <DialogTitle>Crear Nuevo Nodo</DialogTitle>
          <DialogContent>
            <Box sx={{ display: "flex", flexDirection: "column", gap: 2, pt: 1 }}>
              <FormControl fullWidth>
                <InputLabel>Tipo de Nodo</InputLabel>
                <Select
                  value={formData.tipo_nodo}
                  onChange={(e) => setFormData({ ...formData, tipo_nodo: e.target.value as NodeData["tipo_nodo"] })}
                  label="Tipo de Nodo"
                >
                  <MenuItem value="carpeta">📁 Contenedor</MenuItem>
                  <MenuItem value="bd">🗄️ BD (Base de Datos)</MenuItem>
                  <MenuItem value="js">🟨 JavaScript</MenuItem>
                  <MenuItem value="cs">🟩 C#</MenuItem>
                  <MenuItem value="html">🟦 HTML</MenuItem>
                  <MenuItem value="reporte">📊 Reporte</MenuItem>
                </Select>
              </FormControl>

              <Alert severity="info" icon={<Info />}>
                <Typography variant="body2">{getNodeTypeDescription(formData.tipo_nodo)}</Typography>
              </Alert>

              <TextField
                fullWidth
                label="Nombre del Nodo"
                value={formData.text}
                onChange={(e) => setFormData({ ...formData, text: e.target.value })}
                required
                placeholder="Ej: Sistema de Usuarios, Login Module, etc."
              />

              <TextField
                fullWidth
                label="Descripción"
                value={formData.descripcion}
                onChange={(e) => setFormData({ ...formData, descripcion: e.target.value })}
                multiline
                rows={2}
                placeholder="Describe el propósito y contenido de este nodo..."
              />

              {formData.tipo_nodo === "bd" && (
                <Box>
                  <TextField
                    fullWidth
                    label="Ruta del Archivo SQL"
                    value={formData.archivo}
                    onChange={(e) => setFormData({ ...formData, archivo: e.target.value })}
                    placeholder="Ej: scripts/usuarios/sp_login.sql"
                    InputProps={{
                      endAdornment: (
                        <IconButton onClick={() => setFileExplorerOpen(true)}>
                          <FolderOpen />
                        </IconButton>
                      ),
                    }}
                    helperText="Archivo SQL que se mostrará con formato de sintaxis"
                  />
                </Box>
              )}
            </Box>
          </DialogContent>
          <DialogActions>
            <Button onClick={() => setOpen(false)}>Cancelar</Button>
            <Button type="submit" variant="contained" disabled={!formData.text.trim()}>
              Crear Nodo
            </Button>
          </DialogActions>
        </form>
      </Dialog>

      <FileExplorer
        open={fileExplorerOpen}
        onClose={() => setFileExplorerOpen(false)}
        onFileSelect={handleFileSelect}
      />
    </>
  )
}

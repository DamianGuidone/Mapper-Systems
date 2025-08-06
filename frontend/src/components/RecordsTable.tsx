"use client"

import type React from "react"
import { useState, useEffect } from "react"
import {
  Card,
  CardContent,
  Typography,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  Button,
  Box,
  TextField,
  IconButton,
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  Paper,
  Chip,
  Tooltip,
  Alert,
} from "@mui/material"
import { Add, Edit, Delete, FileCopy, Search, DragIndicator, Code, Launch } from "@mui/icons-material"
import type { Registro } from "../types"
import { recordsApi, filesApi } from "../services/api"
import { useAppContext } from "../contexts/AppContext"

interface RecordsTableProps {
  expanded?: boolean
}

export const RecordsTable: React.FC<RecordsTableProps> = ({ expanded = false }) => {
  const { selectedNode, currentProject, currentUser, showNotification } = useAppContext()

  const [records, setRecords] = useState<Registro[]>([])
  const [loading, setLoading] = useState(false)
  const [searchTerm, setSearchTerm] = useState("")
  const [selectedRecord, setSelectedRecord] = useState<Registro | null>(null)
  const [formOpen, setFormOpen] = useState(false)
  const [previewOpen, setPreviewOpen] = useState(false)
  const [previewContent, setPreviewContent] = useState("")
  const [formData, setFormData] = useState<Partial<Registro>>({
    archivo: "",
    ubicacion: "",
    funcion: "",
    descripcion: "",
    orden: 1,
  })

  useEffect(() => {
    if (selectedNode && currentProject && ["js", "cs", "html", "reporte"].includes(selectedNode.data.tipo_nodo)) {
      loadRecords()
    } else {
      setRecords([])
    }
  }, [selectedNode, currentProject])

  const loadRecords = async () => {
    if (!selectedNode) return

    setLoading(true)
    try {
      const response = await recordsApi.getRecords(selectedNode.id)
      setRecords(response.data)
    } catch (error) {
      console.error("Error loading records:", error)
      showNotification("Error al cargar registros", "error")
    } finally {
      setLoading(false)
    }
  }

  const handleSaveRecord = async () => {
    if (!selectedNode || !currentProject) return

    try {
      const recordToSave: Registro = {
        ...formData,
        nodo_id: selectedNode.id,
        proyecto_id: currentProject.id,
        archivo: formData.archivo || "",
        orden: formData.orden || records.length + 1,
      } as Registro

      await recordsApi.saveRecord(recordToSave)
      await loadRecords()
      setFormOpen(false)
      resetForm()
      showNotification("Registro guardado exitosamente", "success")
    } catch (error) {
      console.error("Error saving record:", error)
      showNotification("Error al guardar registro", "error")
    }
  }

  const handleDeleteRecord = async (recordId: number) => {
    if (!confirm("¿Eliminar este registro?")) return

    try {
      await recordsApi.deleteRecord(recordId)
      await loadRecords()
      showNotification("Registro eliminado", "success")
    } catch (error) {
      console.error("Error deleting record:", error)
      showNotification("Error al eliminar registro", "error")
    }
  }

  const handleEditRecord = (record: Registro) => {
    setSelectedRecord(record)
    setFormData(record)
    setFormOpen(true)
  }

  const handleDuplicateRecord = (record: Registro) => {
    setSelectedRecord(null)
    setFormData({
      ...record,
      id: undefined,
      orden: (record.orden || 0) + 1,
    })
    setFormOpen(true)
  }

  const handlePreviewFile = async (filePath: string) => {
    if (!filePath) return

    try {
      const response = await filesApi.readFile(filePath)
      setPreviewContent(response.data.content)
      setPreviewOpen(true)
    } catch (error) {
      console.error("Error loading file preview:", error)
      setPreviewContent("Error al cargar el archivo")
      setPreviewOpen(true)
    }
  }

  const handleOpenFile = async (filePath: string) => {
    if (!filePath) return

    try {
      await filesApi.openFile(filePath)
    } catch (error) {
      console.error("Error opening file:", error)
      showNotification("Error al abrir archivo", "error")
    }
  }

  const resetForm = () => {
    setFormData({
      archivo: "",
      ubicacion: "",
      funcion: "",
      descripcion: "",
      orden: records.length + 1,
    })
    setSelectedRecord(null)
  }

  const filteredRecords = records.filter((record) =>
    Object.values(record).some((value) => value?.toString().toLowerCase().includes(searchTerm.toLowerCase())),
  )

  if (!selectedNode || !currentProject || !["js", "cs", "html", "reporte"].includes(selectedNode.data.tipo_nodo)) {
    return null
  }

  const getNodeTypeInfo = () => {
    const types = {
      js: { name: "JavaScript", color: "warning", icon: "🟨" },
      cs: { name: "C#", color: "success", icon: "🟩" },
      html: { name: "HTML", color: "primary", icon: "🟦" },
      reporte: { name: "Reporte", color: "secondary", icon: "📊" },
    }
    return types[selectedNode.data.tipo_nodo as keyof typeof types] || types.js
  }

  const nodeInfo = getNodeTypeInfo()

  return (
    <>
      <Card>
        <CardContent>
          <Box sx={{ display: "flex", justifyContent: "between", alignItems: "center", mb: 2 }}>
            <Typography variant="h6">
              {nodeInfo.icon} Registros {nodeInfo.name} - {selectedNode.text}
            </Typography>
            <Box sx={{ display: "flex", gap: 1 }}>
              <TextField
                size="small"
                placeholder="Buscar en registros..."
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                InputProps={{
                  startAdornment: <Search />,
                }}
                sx={{ width: expanded ? 250 : 180 }}
              />
              <Button
                variant="contained"
                startIcon={<Add />}
                onClick={() => {
                  resetForm()
                  setFormOpen(true)
                }}
              >
                Nuevo Registro
              </Button>
            </Box>
          </Box>

          {records.length === 0 && !loading && (
            <Alert severity="info" sx={{ mb: 2 }}>
              <Typography variant="body2">
                <strong>¡Agrega valor a este nodo!</strong>
                <br />
                Los registros te permiten documentar archivos, funciones, ubicaciones y descripciones específicas.
                <br />
                Esto convierte un simple nodo en una herramienta de documentación poderosa.
              </Typography>
            </Alert>
          )}

          <TableContainer component={Paper} sx={{ maxHeight: expanded ? 600 : 400 }}>
            <Table stickyHeader size={expanded ? "medium" : "small"}>
              <TableHead>
                <TableRow>
                  <TableCell width="5%">
                    <DragIndicator fontSize="small" />
                  </TableCell>
                  <TableCell width="25%">Archivo</TableCell>
                  <TableCell width="20%">Ubicación</TableCell>
                  <TableCell width="20%">Función</TableCell>
                  <TableCell width="25%">Descripción</TableCell>
                  <TableCell width="5%" align="center">
                    Acciones
                  </TableCell>
                </TableRow>
              </TableHead>
              <TableBody>
                {filteredRecords.map((record, index) => (
                  <TableRow key={record.id} hover>
                    <TableCell>
                      <Chip label={record.orden || index + 1} size="small" color={nodeInfo.color as any} />
                    </TableCell>
                    <TableCell>
                      <Box sx={{ display: "flex", alignItems: "center", gap: 1 }}>
                        <Typography variant="body2" sx={{ fontFamily: "monospace" }}>
                          {record.archivo || "-"}
                        </Typography>
                        {record.archivo && (
                          <Box>
                            <Tooltip title="Ver código">
                              <IconButton size="small" onClick={() => handlePreviewFile(record.archivo)}>
                                <Code fontSize="small" />
                              </IconButton>
                            </Tooltip>
                            <Tooltip title="Abrir archivo">
                              <IconButton size="small" onClick={() => handleOpenFile(record.archivo)}>
                                <Launch fontSize="small" />
                              </IconButton>
                            </Tooltip>
                          </Box>
                        )}
                      </Box>
                    </TableCell>
                    <TableCell>
                      <Typography variant="body2">{record.ubicacion || "-"}</Typography>
                    </TableCell>
                    <TableCell>
                      <Typography variant="body2" sx={{ fontFamily: "monospace", color: "primary.main" }}>
                        {record.funcion || "-"}
                      </Typography>
                    </TableCell>
                    <TableCell sx={{ maxWidth: expanded ? 300 : 150 }}>
                      <Typography variant="body2" noWrap={!expanded}>
                        {record.descripcion || "-"}
                      </Typography>
                    </TableCell>
                    <TableCell align="center">
                      <Box sx={{ display: "flex", gap: 0.5 }}>
                        <Tooltip title="Editar">
                          <IconButton size="small" onClick={() => handleEditRecord(record)}>
                            <Edit fontSize="small" />
                          </IconButton>
                        </Tooltip>
                        <Tooltip title="Duplicar">
                          <IconButton size="small" onClick={() => handleDuplicateRecord(record)}>
                            <FileCopy fontSize="small" />
                          </IconButton>
                        </Tooltip>
                        <Tooltip title="Eliminar">
                          <IconButton
                            size="small"
                            onClick={() => record.id && handleDeleteRecord(record.id)}
                            color="error"
                          >
                            <Delete fontSize="small" />
                          </IconButton>
                        </Tooltip>
                      </Box>
                    </TableCell>
                  </TableRow>
                ))}
                {filteredRecords.length === 0 && (
                  <TableRow>
                    <TableCell colSpan={6} align="center">
                      <Typography color="text.secondary">
                        {loading ? "Cargando registros..." : "No hay registros que coincidan con la búsqueda"}
                      </Typography>
                    </TableCell>
                  </TableRow>
                )}
              </TableBody>
            </Table>
          </TableContainer>

          <Box sx={{ mt: 2, display: "flex", justifyContent: "between", alignItems: "center" }}>
            <Typography variant="caption" color="text.secondary">
              Total: {filteredRecords.length} registro{filteredRecords.length !== 1 ? "s" : ""}
            </Typography>
            {records.length > 0 && (
              <Button size="small" onClick={() => recordsApi.reindexOrder(selectedNode.id)}>
                Reordenar
              </Button>
            )}
          </Box>
        </CardContent>
      </Card>

      {/* Dialog para crear/editar registro */}
      <Dialog open={formOpen} onClose={() => setFormOpen(false)} maxWidth="md" fullWidth>
        <DialogTitle>
          {selectedRecord ? "Editar Registro" : "Nuevo Registro"} - {nodeInfo.name}
        </DialogTitle>
        <DialogContent>
          <Box sx={{ display: "flex", flexDirection: "column", gap: 2, pt: 1 }}>
            <TextField
              fullWidth
              label="Archivo (ruta relativa)"
              value={formData.archivo || ""}
              onChange={(e) => setFormData({ ...formData, archivo: e.target.value })}
              placeholder="ej: src/components/Header.js"
              helperText="Ruta del archivo desde la raíz del proyecto"
            />
            <TextField
              fullWidth
              label="Ubicación (contexto)"
              value={formData.ubicacion || ""}
              onChange={(e) => setFormData({ ...formData, ubicacion: e.target.value })}
              placeholder="ej: Línea 45, Método init()"
              helperText="Ubicación específica dentro del archivo"
            />
            <TextField
              fullWidth
              label="Función/Método"
              value={formData.funcion || ""}
              onChange={(e) => setFormData({ ...formData, funcion: e.target.value })}
              placeholder="ej: calculateTotal(), renderHeader()"
              helperText="Nombre de la función o método relevante"
            />
            <TextField
              fullWidth
              label="Descripción"
              value={formData.descripcion || ""}
              onChange={(e) => setFormData({ ...formData, descripcion: e.target.value })}
              multiline
              rows={3}
              placeholder="Describe qué hace este código, su propósito, parámetros importantes, etc."
              helperText="Documentación detallada para futura referencia"
            />
            <TextField
              fullWidth
              label="Orden"
              type="number"
              value={formData.orden || 1}
              onChange={(e) => setFormData({ ...formData, orden: Number.parseInt(e.target.value) || 1 })}
              helperText="Orden de aparición en la lista"
            />
          </Box>
        </DialogContent>
        <DialogActions>
          <Button onClick={() => setFormOpen(false)}>Cancelar</Button>
          <Button onClick={handleSaveRecord} variant="contained">
            {selectedRecord ? "Actualizar" : "Crear"}
          </Button>
        </DialogActions>
      </Dialog>

      {/* Dialog para preview de archivos */}
      <Dialog open={previewOpen} onClose={() => setPreviewOpen(false)} maxWidth="lg" fullWidth>
        <DialogTitle>Previsualización de Código</DialogTitle>
        <DialogContent>
          <Paper
            sx={{
              p: 2,
              backgroundColor: "#2a2a2a",
              color: "#f5f5f5",
              maxHeight: 500,
              overflow: "auto",
            }}
          >
            <Box
              component="pre"
              sx={{
                fontFamily: "monospace",
                fontSize: "0.875rem",
                whiteSpace: "pre-wrap",
                wordBreak: "break-word",
                margin: 0,
              }}
            >
              {previewContent}
            </Box>
          </Paper>
        </DialogContent>
        <DialogActions>
          <Button onClick={() => setPreviewOpen(false)}>Cerrar</Button>
        </DialogActions>
      </Dialog>
    </>
  )
}

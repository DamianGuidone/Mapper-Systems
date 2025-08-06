"use client"
import type React from "react"
import { useState, useEffect, useCallback, useMemo } from "react"
import mermaid from "mermaid"

// Asegurar que Mermaid esté disponible en el cliente
if (typeof window !== "undefined") {
  mermaid.initialize({
    startOnLoad: false,
    securityLevel: "loose",
  })
}
import {
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  Button,
  Box,
  TextField,
  Select,
  MenuItem,
  FormControl,
  InputLabel,
  Paper,
  Typography,
  IconButton,
  Tooltip,
  Alert,
  Tabs,
  Tab,
  Chip,
  Snackbar,
  Collapse,
} from "@mui/material"
import {
  Save as SaveIcon,
  ContentCopy as ContentCopyIcon,
  CheckCircle as CheckCircleIcon,
  Fullscreen as FullscreenIcon,
  FullscreenExit as FullscreenExitIcon,
  Refresh as RefreshIcon,
  Download as DownloadIcon,
  Warning as WarningIcon,
  Palette as PaletteIcon,
  Info as InfoIcon,
  Error as ErrorIcon,
} from "@mui/icons-material"
import type { MermaidDiagram, MermaidDiagramType } from "../types"
import MermaidRenderer from "./MermaidRenderer"
import { MermaidVersionCheck } from "./MermaidVersionCheck"
import { useAppContext } from "../contexts/AppContext"
import { MonacoMermaidEditor } from "./MonacoMermaidEditor"
import { MERMAID_TEMPLATES } from "./MermaidTemplates"
import { ResizablePanels } from "./ResizablePanels"
import { DiagramPreviewTools } from "./DiagramPreviewTools"


interface MermaidEditorProps {
  open: boolean
  onClose: () => void
  onSave: (diagram: Partial<MermaidDiagram>) => Promise<void>
  initialDiagram?: MermaidDiagram | null
  nodeId: string
  projectId: number
}

export const MermaidEditor: React.FC<MermaidEditorProps> = ({
  open,
  onClose,
  onSave,
  initialDiagram,
  nodeId,
  projectId,
}) => {
  const { darkMode, showNotification } = useAppContext()
  const [formData, setFormData] = useState<Partial<MermaidDiagram>>({
    titulo: "",
    descripcion: "",
    tipo_diagrama: "flowchart",
    codigo_mermaid: "",
    orden: 1,
  })
  const [activeTab, setActiveTab] = useState(0)
  const [isFullscreen, setIsFullscreen] = useState(false)
  const [validation, setValidation] = useState<{
    valido: boolean
    errores: string
    sugerencias: string
  } | null>(null)
  const [renderKey, setRenderKey] = useState(0)
  const [isRendering, setIsRendering] = useState(false)
  const [isSaving, setIsSaving] = useState(false)
  const [showCopySuccess, setShowCopySuccess] = useState(false)

  // Estados para mostrar/ocultar secciones
  const [showVersionCheck, setShowVersionCheck] = useState(false)
  const [showValidation, setShowValidation] = useState(false)

  // Tipos de diagrama funcionales (removidos los problemáticos)
  const DIAGRAM_TYPES = useMemo(
    () => [
      { value: "flowchart", label: "🔄 Flowchart", color: "#2196f3", version: "v8.0+" },
      { value: "sequence", label: "📋 Sequence", color: "#4caf50", version: "v8.0+" },
      { value: "classDiagram", label: "🏗️ Class Diagram", color: "#ff9800", version: "v9.0+" },
      { value: "stateDiagram", label: "🔀 State Diagram", color: "#9c27b0", version: "v9.0+" },
      { value: "erDiagram", label: "🗃️ ER Diagram", color: "#f44336", version: "v9.0+" },
      { value: "journey", label: "🚶 User Journey", color: "#00bcd4", version: "v10.0+" },
      { value: "gantt", label: "📅 Gantt", color: "#795548", version: "v8.0+" },
      { value: "pie", label: "🥧 Pie Chart", color: "#607d8b", version: "v8.0+" },
      { value: "gitgraph", label: "🌳 Git Graph", color: "#3f51b5", version: "v10.0+" },
      { value: "mindmap", label: "🧠 Mind Map", color: "#e91e63", version: "v10.0+" },
      { value: "timeline", label: "⏰ Timeline", color: "#009688", version: "v10.0+" },
      { value: "quadrant", label: "📊 Quadrant Chart", color: "#673ab7", version: "v11.0+" },
      { value: "requirement", label: "📝 Requirement", color: "#ff5722", version: "v11.0+" },
      { value: "c4", label: "🏢 C4 Diagram", color: "#9e9e9e", version: "v11.0+" },
      { value: "xychart", label: "📈 XY Chart", color: "#1976d2", version: "v11.0+" },
      { value: "block", label: "🧱 Block Diagram", color: "#388e3c", version: "v11.0+" },
      { value: "packet", label: "📦 Packet", color: "#7b1fa2", version: "v11.0+" },
      { value: "kanban", label: "📋 Kanban", color: "#f57c00", version: "v11.0+" },
      { value: "architecture", label: "🏗️ Architecture", color: "#5d4037", version: "v11.1+" },
      { value: "radar", label: "🎯 Radar Chart", color: "#d32f2f", version: "v11.6+" },
    ],
    [],
  )

  // Inicializar formulario cuando se abre el diálogo
  useEffect(() => {
    if (open) {
      if (initialDiagram) {
        setFormData(initialDiagram)
        setTimeout(() => {
          setRenderKey((prev) => prev + 1)
        }, 100)
      } else {
        const newFormData = {
          titulo: "",
          descripcion: "",
          tipo_diagrama: "flowchart" as MermaidDiagramType,
          codigo_mermaid: MERMAID_TEMPLATES.flowchart.code,
          orden: 1,
        }
        setFormData(newFormData)
        setTimeout(() => {
          setRenderKey((prev) => prev + 1)
        }, 100)
      }
      setValidation(null)
      setIsRendering(false)
      setShowVersionCheck(false)
      setShowValidation(false)
    }
  }, [open, initialDiagram])

  // Manejar cambio de tipo de diagrama
  const handleTypeChange = useCallback(
    (newType: MermaidDiagramType) => {
      const newFormData = {
        ...formData,
        tipo_diagrama: newType,
        codigo_mermaid: MERMAID_TEMPLATES[newType].code,
      }
      setFormData(newFormData)
      setTimeout(() => {
        setRenderKey((prev) => prev + 1)
      }, 100)
      setValidation(null)
    },
    [formData],
  )

  // Manejar cambio de código
  const handleCodeChange = useCallback((newCode: string) => {
    setFormData((prev) => ({
      ...prev,
      codigo_mermaid: newCode,
    }))
    setValidation(null)
  }, [])

  // Validar código Mermaid
  const validateCode = useCallback(async () => {
    if (!formData.codigo_mermaid?.trim()) {
      setValidation({
        valido: false,
        errores: "El código no puede estar vacío",
        sugerencias: "Escribe código Mermaid válido",
      })
      setShowValidation(true)
      return
    }

    try {
      if (typeof window === "undefined") {
        setValidation({
          valido: false,
          errores: "Validación no disponible en servidor",
          sugerencias: "La validación se ejecuta en el cliente",
        })
        setShowValidation(true)
        return
      }

      const mermaidLib = mermaid || (await import("mermaid")).default
      await mermaidLib.parse(formData.codigo_mermaid)
      setValidation({
        valido: true,
        errores: "",
        sugerencias: "",
      })
      setShowValidation(true)
      showNotification("Código Mermaid válido", "success")
    } catch (error) {
      const errorMessage = error instanceof Error ? error.message : "Error desconocido"
      setValidation({
        valido: false,
        errores: errorMessage,
        sugerencias: "Revisa la sintaxis del código Mermaid",
      })
      setShowValidation(true)
    }
  }, [formData.codigo_mermaid, showNotification])

  // Forzar re-render del diagrama
  const forceRender = useCallback(() => {
    setRenderKey((prev) => prev + 1)
    setValidation(null)
  }, [])

  // Guardar diagrama
  const handleSave = useCallback(async () => {
    if (!formData.titulo?.trim()) {
      showNotification("El título es requerido", "error")
      return
    }


    if (!formData.codigo_mermaid?.trim()) {
      showNotification("El código Mermaid es requerido", "error")
      return
    }

    setIsSaving(true)
    try {
      const diagramToSave: Partial<MermaidDiagram> = {
        ...formData,
        nodo_id: nodeId,
        proyecto_id: projectId,
      }
      await onSave(diagramToSave)
      onClose()
      showNotification("Diagrama guardado exitosamente", "success")
    } catch (error) {
      console.error("Error saving diagram:", error)
      showNotification("Error al guardar el diagrama", "error")
    } finally {
      setIsSaving(false)
    }
  }, [formData, nodeId, projectId, onSave, onClose, showNotification])

  // Copiar código al portapapeles
  const copyToClipboard = useCallback(async () => {
    try {
      await navigator.clipboard.writeText(formData.codigo_mermaid || "")
      setShowCopySuccess(true)
    } catch (error) {
      console.error("Error copying to clipboard:", error)
      showNotification("Error al copiar", "error")
    }
  }, [formData.codigo_mermaid, showNotification])

  // Exportar como PNG
  const handleExportPng = useCallback(async () => {
    if (!formData.codigo_mermaid) {
      showNotification("No hay código Mermaid para exportar.", "warning")
      return
    }

    try {
      const tempContainer = document.createElement("div")
      tempContainer.style.position = "absolute"
      tempContainer.style.left = "-9999px"
      tempContainer.style.top = "-9999px"
      document.body.appendChild(tempContainer)

      mermaid.initialize({
        theme: darkMode ? "dark" : "default",
        securityLevel: "loose",
        flowchart: { curve: "basis" },
      })

      const { svg } = await mermaid.render("export-diagram-id", formData.codigo_mermaid)

      const img = new Image()
      img.crossOrigin = "anonymous"

      const svgBlob = new Blob([svg], { type: "image/svg+xml;charset=utf-8" })
      const url = URL.createObjectURL(svgBlob)

      img.onload = () => {
        const canvas = document.createElement("canvas")
        const ctx = canvas.getContext("2d")

        if (!ctx) {
          URL.revokeObjectURL(url)
          document.body.removeChild(tempContainer)
          return
        }

        const scale = 2
        canvas.width = img.width * scale
        canvas.height = img.height * scale
        ctx.scale(scale, scale)

        ctx.fillStyle = darkMode ? "#1e1e1e" : "#ffffff"
        ctx.fillRect(0, 0, img.width, img.height)

        ctx.drawImage(img, 0, 0)

        const pngUrl = canvas.toDataURL("image/png", 1.0)
        const downloadLink = document.createElement("a")
        downloadLink.href = pngUrl
        downloadLink.download = `${formData.titulo || "diagrama-mermaid"}.png`
        document.body.appendChild(downloadLink)
        downloadLink.click()

        document.body.removeChild(downloadLink)
        document.body.removeChild(tempContainer)
        URL.revokeObjectURL(url)

        showNotification("Diagrama exportado como PNG", "success")
      }

      img.onerror = () => {
        document.body.removeChild(tempContainer)
        URL.revokeObjectURL(url)
        showNotification("Error al procesar el diagrama para exportar", "error")
      }

      img.src = url
    } catch (error) {
      console.error("Error durante la exportación a PNG:", error)
      showNotification("Error al exportar diagrama", "error")
    }
  }, [formData.codigo_mermaid, formData.titulo, darkMode, showNotification])

  // Exportar como SVG
  const handleExportSvg = useCallback(async () => {
    if (!formData.codigo_mermaid) {
      showNotification("No hay código Mermaid para exportar.", "warning")
      return
    }

    try {
      mermaid.initialize({
        theme: darkMode ? "dark" : "default",
        securityLevel: "loose",
        flowchart: { curve: "basis" },
      })

      const { svg } = await mermaid.render("export-diagram-id", formData.codigo_mermaid)

      const svgBlob = new Blob([svg], { type: "image/svg+xml;charset=utf-8" })
      const url = URL.createObjectURL(svgBlob)

      const downloadLink = document.createElement("a")
      downloadLink.href = url
      downloadLink.download = `${formData.titulo || "diagrama-mermaid"}.svg`
      document.body.appendChild(downloadLink)
      downloadLink.click()

      document.body.removeChild(downloadLink)
      URL.revokeObjectURL(url)

      showNotification("Diagrama exportado como SVG", "success")
    } catch (error) {
      console.error("Error durante la exportación a SVG:", error)
      showNotification("Error al exportar diagrama", "error")
    }
  }, [formData.codigo_mermaid, formData.titulo, darkMode, showNotification])

  // Callback cuando el diagrama se renderiza
  const handleRendered = useCallback(() => {
    setIsRendering(false)
    console.log("Diagrama renderizado exitosamente")
  }, [])

  // Callback cuando hay error en el render
  const handleRenderError = useCallback((error: string) => {
    console.error("Error en renderizado:", error)
    setValidation({
      valido: false,
      errores: error,
      sugerencias: "Revisa la sintaxis del código Mermaid",
    })
    setIsRendering(false)
  }, [])

  const currentType = DIAGRAM_TYPES.find((t) => t.value === formData.tipo_diagrama) || DIAGRAM_TYPES[0]
  const template = MERMAID_TEMPLATES[formData.tipo_diagrama as MermaidDiagramType]

  // Antes de renderizar, establecer isRendering en true
  // Eliminar este useEffect:
  // useEffect(() => {
  //   if (formData.codigo_mermaid?.trim()) {
  //     setIsRendering(true)
  //   }
  // }, [formData.codigo_mermaid])

  return (
    <>
      <Dialog
        open={open}
        onClose={onClose}
        maxWidth={isFullscreen ? false : "xl"}
        fullWidth
        fullScreen={isFullscreen}
        PaperProps={{
          sx: {
            height: isFullscreen ? "100vh" : "90vh",
            maxHeight: isFullscreen ? "100vh" : "90vh",
          },
        }}
      >
        <DialogTitle sx={{ pb: 1 }}>
          <Box
            sx={{
              display: "flex",
              justifyContent: "space-between",
              alignItems: "center",
            }}
          >
            <Box sx={{ display: "flex", alignItems: "center", gap: 2 }}>
              <Typography variant="h6">{initialDiagram ? "Editar" : "Crear"} Diagrama Mermaid</Typography>

              {/* Botón para mostrar/ocultar versión de Mermaid */}
              <Tooltip title={showVersionCheck ? "Ocultar información de versión" : "Mostrar información de versión"}>
                <span>
                  <IconButton
                    size="small"
                    onClick={() => setShowVersionCheck(!showVersionCheck)}
                    color={showVersionCheck ? "primary" : "default"}
                  >
                    <InfoIcon />
                  </IconButton>
                </span>
              </Tooltip>

              {/* Botón para mostrar/ocultar validación */}
              <Tooltip title={showValidation ? "Ocultar validación" : "Mostrar validación"}>
                <span>
                  <IconButton
                    size="small"
                    onClick={() => setShowValidation(!showValidation)}
                    color={validation?.valido ? "success" : validation ? "error" : "default"}
                  >
                    {validation?.valido ? <CheckCircleIcon /> : validation ? <ErrorIcon /> : <WarningIcon />}
                  </IconButton>
                </span>
              </Tooltip>
            </Box>

            <Tooltip title={isFullscreen ? "Salir pantalla completa" : "Pantalla completa"}>
              <span>
                <IconButton onClick={() => setIsFullscreen(!isFullscreen)}>
                  {isFullscreen ? <FullscreenExitIcon /> : <FullscreenIcon />}
                </IconButton>
              </span>
            </Tooltip>
          </Box>
        </DialogTitle>

        <DialogContent sx={{ p: 0, display: "flex", flexDirection: "column", height: "100%" }}>
          {/* Verificador de versión colapsable */}
          <Collapse in={showVersionCheck}>
            <Box sx={{ px: 2, pt: 1 }}>
              <MermaidVersionCheck />
            </Box>
          </Collapse>

          {/* Cabecera compacta con controles */}
          <Paper
            elevation={1}
            sx={{
              p: 2,
              m: 2,
              mb: 1,
              borderRadius: 2,
              backgroundColor: (theme) => (theme.palette.mode === "dark" ? "rgba(255,255,255,0.05)" : "#f8f9fa"),
            }}
          >
            {/* Primera línea: Título, Tipo, Descripción y Botones */}
            <Box sx={{ display: "flex", gap: 2, alignItems: "center", flexWrap: "wrap", mb: 1 }}>
              {/* Título más compacto */}
              <TextField
                label="Título"
                value={formData.titulo || ""}
                onChange={(e) => setFormData((prev) => ({ ...prev, titulo: e.target.value }))}
                required
                size="small"
                error={!formData.titulo?.trim()}
                sx={{ minWidth: 180, maxWidth: 250 }}
              />

              {/* Tipo de diagrama */}
              <FormControl size="small" sx={{ minWidth: 160 }}>
                <InputLabel>Tipo</InputLabel>
                <Select
                  value={formData.tipo_diagrama || "flowchart"}
                  onChange={(e) => handleTypeChange(e.target.value as MermaidDiagramType)}
                  label="Tipo"
                >
                  {DIAGRAM_TYPES.map((type) => (
                    <MenuItem key={type.value} value={type.value}>
                      {type.label}
                    </MenuItem>
                  ))}
                </Select>
              </FormControl>

              {/* Descripción */}
              <TextField
                label="Descripción"
                value={formData.descripcion || ""}
                onChange={(e) => setFormData((prev) => ({ ...prev, descripcion: e.target.value }))}
                size="small"
                sx={{ minWidth: 200, flex: 1 }}
              />

              {/* Botones de acción */}
              <Box sx={{ display: "flex", gap: 1 }}>
                <Tooltip title="Validar código">
                  <span>
                    <IconButton
                      size="small"
                      onClick={validateCode}
                      disabled={!formData.codigo_mermaid?.trim()}
                      color={validation?.valido ? "success" : "default"}
                    >
                      <CheckCircleIcon />
                    </IconButton>
                  </span>
                </Tooltip>

                <Tooltip title="Actualizar diagrama">
                  <span>
                    <IconButton size="small" onClick={forceRender} disabled={!formData.codigo_mermaid?.trim()}>
                      <RefreshIcon />
                    </IconButton>
                  </span>
                </Tooltip>

                <Tooltip title="Copiar código">
                  <span>
                    <IconButton size="small" onClick={copyToClipboard} disabled={!formData.codigo_mermaid?.trim()}>
                      <ContentCopyIcon />
                    </IconButton>
                  </span>
                </Tooltip>

                <Tooltip title="Exportar PNG">
                  <span>
                    <IconButton
                      size="small"
                      onClick={handleExportPng}
                      disabled={!formData.codigo_mermaid?.trim() || isRendering}
                    >
                      <DownloadIcon />
                    </IconButton>
                  </span>
                </Tooltip>

                <Tooltip title="Exportar SVG">
                  <span>
                    <IconButton
                      size="small"
                      onClick={handleExportSvg}
                      disabled={!formData.codigo_mermaid?.trim() || isRendering}
                    >
                      <PaletteIcon />
                    </IconButton>
                  </span>
                </Tooltip>
              </Box>
            </Box>

            {/* Segunda línea: Información del tipo */}
            <Box sx={{ display: "flex", alignItems: "center", gap: 1 }}>
              <Chip
                label={currentType.label}
                sx={{ backgroundColor: currentType.color, color: "white" }}
                size="small"
              />
              <Typography variant="caption" color="text.secondary">
                {template?.description}
              </Typography>
              <Chip label={currentType.version} size="small" variant="outlined" />
            </Box>

            {/* Validación colapsable */}
            <Collapse in={showValidation && !!validation}>
              {validation && (
                <Alert
                  severity={validation.valido ? "success" : "error"}
                  sx={{ mt: 2 }}
                  icon={validation.valido ? <CheckCircleIcon /> : <WarningIcon />}
                >
                  {validation.valido ? (
                    "✅ Código válido"
                  ) : (
                    <Box>
                      <Typography variant="body2" fontWeight="bold">
                        Error: {validation.errores}
                      </Typography>
                      {validation.sugerencias && (
                        <Typography variant="body2" sx={{ mt: 0.5 }}>
                          💡 {validation.sugerencias}
                        </Typography>
                      )}
                    </Box>
                  )}
                </Alert>
              )}
            </Collapse>
          </Paper>

          {/* Tabs para diferentes vistas */}
          <Box sx={{ borderBottom: 1, borderColor: "divider", mx: 2 }}>
            <Tabs value={activeTab} onChange={(_, newValue) => setActiveTab(newValue)}>
              <Tab label="📝 Editor" />
              <Tab label="📚 Plantillas" />
              <Tab label="❓ Ayuda" />
            </Tabs>
          </Box>

          {/* Contenido principal */}
          <Box sx={{ flex: 1, overflow: "hidden", p: 2 }}>
            {activeTab === 0 && (
              <ResizablePanels
                leftPanel={
                  <Paper sx={{ height: "100%", display: "flex", flexDirection: "column" }}>
                    <Box
                      sx={{
                        p: 1,
                        backgroundColor: (theme) =>
                          theme.palette.mode === "dark" ? "rgba(255,255,255,0.1)" : "#f0f0f0",
                        borderRadius: "4px 4px 0 0",
                        display: "flex",
                        justifyContent: "space-between",
                        alignItems: "center",
                      }}
                    >
                      <Typography variant="subtitle2">💻 Editor de Código</Typography>
                      <Typography variant="caption">
                        {formData.codigo_mermaid?.split("\n").length || 0} líneas
                      </Typography>
                    </Box>
                    <Box sx={{ flex: 1, border: "1px solid", borderColor: "divider" }}>
                      <MonacoMermaidEditor
                        value={formData.codigo_mermaid || ""}
                        onChange={handleCodeChange}
                        darkMode={darkMode}
                        onSave={handleSave}
                        onRender={forceRender}
                        diagramType={formData.tipo_diagrama as MermaidDiagramType}
                      />
                    </Box>
                  </Paper>
                }
                rightPanel={
                  <Paper sx={{ height: "100%", display: "flex", flexDirection: "column" }}>
                    <Box
                      sx={{
                        p: 1,
                        backgroundColor: (theme) =>
                          theme.palette.mode === "dark" ? "rgba(255,255,255,0.1)" : "#f0f0f0",
                        borderRadius: "4px 4px 0 0",
                        display: "flex",
                        justifyContent: "space-between",
                        alignItems: "center",
                      }}
                    >
                      <Typography variant="subtitle2">👁️ Previsualización</Typography>
                      <Typography
                        variant="caption"
                        sx={{
                          color: isRendering ? "#f57c00" : "#4caf50",
                          fontWeight: "medium",
                        }}
                      >
                        {isRendering ? "Renderizando..." : "Listo ✓"}
                      </Typography>
                    </Box>
                    <Box sx={{ flex: 1, overflow: "hidden" }}>
                      <DiagramPreviewTools onRefresh={forceRender}>
                        <MermaidRenderer
                          key={renderKey}
                          code={formData.codigo_mermaid || ""}
                          darkMode={darkMode}
                          onRendered={handleRendered}
                          onError={handleRenderError}
                          shouldRender={true} 
                        />
                      </DiagramPreviewTools>
                    </Box>
                  </Paper>
                }
                initialLeftWidth={50}
                minLeftWidth={30}
                maxLeftWidth={70}
              />
            )}

            {/* Tab de Plantillas */}
            {activeTab === 1 && (
              <Box sx={{ flex: 1, overflowY: "auto", maxHeight: "calc(100vh - 300px)" }}>
                <Typography variant="h6" gutterBottom sx={{ mb: 2 }}>
                  📚 Plantillas de Diagramas Mermaid
                </Typography>

                <Alert severity="info" sx={{ mb: 2 }}>
                  <Typography variant="body2">
                    Selecciona una plantilla para comenzar rápidamente. Todas las plantillas están optimizadas y
                    probadas.
                  </Typography>
                </Alert>

                <Box
                  sx={{
                    display: "grid",
                    gridTemplateColumns: "repeat(auto-fill, minmax(300px, 1fr))",
                    gap: 2,
                    paddingBottom: 2,
                  }}
                >
                  {DIAGRAM_TYPES.map((type) => (
                    <Paper
                      key={type.value}
                      sx={{
                        p: 2,
                        cursor: "pointer",
                        transition: "all 0.2s",
                        "&:hover": {
                          transform: "translateY(-2px)",
                          boxShadow: 4,
                        },
                        border: formData.tipo_diagrama === type.value ? 2 : 1,
                        borderColor: formData.tipo_diagrama === type.value ? type.color : "divider",
                      }}
                      onClick={() => handleTypeChange(type.value as MermaidDiagramType)}
                    >
                      <Box sx={{ display: "flex", alignItems: "center", mb: 1, justifyContent: "space-between" }}>
                        <Chip
                          label={type.label}
                          size="small"
                          sx={{
                            backgroundColor: type.color,
                            color: "white",
                          }}
                        />
                        <Chip label={type.version} size="small" variant="outlined" />
                      </Box>

                      <Typography variant="body2" sx={{ color: "text.secondary", mb: 1 }}>
                        {MERMAID_TEMPLATES[type.value as MermaidDiagramType]?.description}
                      </Typography>

                      <Paper
                        sx={{
                          p: 1,
                          backgroundColor: darkMode ? "#1e1e1e" : "#f5f5f5",
                          color: darkMode ? "#f5f5f5" : "#333",
                          maxHeight: 120,
                          overflow: "auto",
                          mt: 1,
                        }}
                      >
                        <Typography
                          variant="body2"
                          component="pre"
                          sx={{
                            fontFamily: "monospace",
                            fontSize: "0.7rem",
                            whiteSpace: "pre-wrap",
                            margin: 0,
                          }}
                        >
                          {MERMAID_TEMPLATES[type.value as MermaidDiagramType]?.code.substring(0, 200)}
                          {MERMAID_TEMPLATES[type.value as MermaidDiagramType]?.code.length > 200 && "..."}
                        </Typography>
                      </Paper>
                    </Paper>
                  ))}
                </Box>
              </Box>
            )}

            {/* Tab de Ayuda */}
            {activeTab === 2 && (
              <Box sx={{ flex: 1, overflowY: "auto" }}>
                <Typography variant="h6" gutterBottom>
                  ❓ Guía de Uso del Editor
                </Typography>

                <Box sx={{ display: "flex", flexDirection: "column", gap: 3 }}>
                  <Paper sx={{ p: 2 }}>
                    <Typography variant="h6" gutterBottom>
                      ⚡ Atajos de Teclado
                    </Typography>
                    <Box sx={{ display: "flex", flexDirection: "column", gap: 1 }}>
                      <Typography variant="body2">
                        • <strong>Ctrl/Cmd + S</strong>: Guardar diagrama
                      </Typography>
                      <Typography variant="body2">
                        • <strong>Ctrl/Cmd + Enter</strong>: Renderizar diagrama
                      </Typography>
                      <Typography variant="body2">
                        • <strong>Ctrl/Cmd + Space</strong>: Mostrar autocompletado
                      </Typography>
                      <Typography variant="body2">
                        • <strong>Ctrl/Cmd + Rueda</strong>: Zoom en previsualización
                      </Typography>
                    </Box>
                  </Paper>

                  <Paper sx={{ p: 2 }}>
                    <Typography variant="h6" gutterBottom>
                      🎯 Herramientas de Previsualización
                    </Typography>
                    <Box sx={{ display: "flex", flexDirection: "column", gap: 1 }}>
                      <Typography variant="body2">• 🖐️ Herramienta de paneo para mover el diagrama</Typography>
                      <Typography variant="body2">• 🔍 Zoom in/out para acercar o alejar</Typography>
                      <Typography variant="body2">• 🎯 Centrar y resetear zoom</Typography>
                      <Typography variant="body2">• 📺 Pantalla completa para mejor visualización</Typography>
                      <Typography variant="body2">• 🔄 Actualizar para re-renderizar</Typography>
                    </Box>
                  </Paper>

                  <Paper sx={{ p: 2 }}>
                    <Typography variant="h6" gutterBottom>
                      📏 Paneles Redimensionables
                    </Typography>
                    <Typography variant="body2">
                      Arrastra la línea divisoria entre el editor y la previsualización para ajustar el tamaño según tus
                      necesidades. Puedes dar más espacio al código o al diagrama según lo que estés trabajando.
                    </Typography>
                  </Paper>

                  <Paper sx={{ p: 2 }}>
                    <Typography variant="h6" gutterBottom>
                      🎨 Mejores Prácticas
                    </Typography>
                    <Box sx={{ display: "flex", flexDirection: "column", gap: 1 }}>
                      <Typography variant="body2">• Usa títulos descriptivos para tus diagramas</Typography>
                      <Typography variant="body2">• Agrega descripciones para contexto adicional</Typography>
                      <Typography variant="body2">• Valida tu código antes de guardar</Typography>
                      <Typography variant="body2">• Usa el autocompletado para sintaxis correcta</Typography>
                      <Typography variant="body2">• Exporta en PNG para documentos o SVG para web</Typography>
                    </Box>
                  </Paper>
                </Box>
              </Box>
            )}
          </Box>
        </DialogContent>

        <DialogActions sx={{ p: 2, borderTop: 1, borderColor: "divider" }}>
          <Button onClick={onClose} disabled={isSaving}>
            Cancelar
          </Button>
          <Button
            onClick={handleSave}
            variant="contained"
            disabled={!formData.titulo?.trim() || !formData.codigo_mermaid?.trim() || isSaving}
            startIcon={<SaveIcon />}
          >
            {isSaving ? "Guardando..." : initialDiagram ? "Actualizar" : "Guardar"} Diagrama
          </Button>
        </DialogActions>
      </Dialog>

      {/* Snackbar para confirmación de copia */}
      <Snackbar
        open={showCopySuccess}
        autoHideDuration={2000}
        onClose={() => setShowCopySuccess(false)}
        message="Código copiado al portapapeles"
      />
    </>
  )
}

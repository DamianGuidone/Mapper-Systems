"use client"

import type React from "react"
import { useState, useEffect } from "react"
import {
  Card,
  CardContent,
  Typography,
  Button,
  Box,
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  TextField,
  Select,
  MenuItem,
  FormControl,
  InputLabel,
  IconButton,
  Tooltip,
  List,
  ListItem,
  ListItemText,
  ListItemSecondaryAction,
  Chip,
  Paper,
  Alert,
} from "@mui/material"
import { Add, Edit, Delete, Code, ContentCopy, Save } from "@mui/icons-material"
import type { CodeSnippet, SupportedLanguage } from "../types"
import { snippetsApi } from "../services/api"
import { useAppContext } from "../contexts/AppContext"

const SUPPORTED_LANGUAGES: { value: SupportedLanguage; label: string; color: string }[] = [
  { value: "javascript", label: "JavaScript", color: "#f7df1e" },
  { value: "typescript", label: "TypeScript", color: "#3178c6" },
  { value: "python", label: "Python", color: "#3776ab" },
  { value: "java", label: "Java", color: "#ed8b00" },
  { value: "csharp", label: "C#", color: "#239120" },
  { value: "html", label: "HTML", color: "#e34f26" },
  { value: "css", label: "CSS", color: "#1572b6" },
  { value: "sql", label: "SQL", color: "#336791" },
  { value: "json", label: "JSON", color: "#000000" },
  { value: "xml", label: "XML", color: "#ff6600" },
  { value: "php", label: "PHP", color: "#777bb4" },
  { value: "ruby", label: "Ruby", color: "#cc342d" },
  { value: "go", label: "Go", color: "#00add8" },
  { value: "rust", label: "Rust", color: "#000000" },
  { value: "cpp", label: "C++", color: "#00599c" },
  { value: "bash", label: "Bash", color: "#4eaa25" },
  { value: "yaml", label: "YAML", color: "#cb171e" },
  { value: "markdown", label: "Markdown", color: "#083fa1" },
]

export const CodeSnippets: React.FC = () => {
  const { selectedNode, currentProject, showNotification } = useAppContext()

  const [snippets, setSnippets] = useState<CodeSnippet[]>([])
  const [loading, setLoading] = useState(false)
  const [formOpen, setFormOpen] = useState(false)
  const [previewOpen, setPreviewOpen] = useState(false)
  const [selectedSnippet, setSelectedSnippet] = useState<CodeSnippet | null>(null)
  const [previewSnippet, setPreviewSnippet] = useState<CodeSnippet | null>(null)
  const [formData, setFormData] = useState<Partial<CodeSnippet>>({
    titulo: "",
    descripcion: "",
    lenguaje: "javascript",
    codigo: "",
    orden: 1,
  })

  useEffect(() => {
    if (selectedNode && currentProject) {
      loadSnippets()
    } else {
      setSnippets([])
    }
  }, [selectedNode, currentProject])

  const loadSnippets = async () => {
    if (!selectedNode || !currentProject) return

    setLoading(true)
    try {
      const response = await snippetsApi.getSnippets(selectedNode.id, currentProject.id)
      setSnippets(response.data)
    } catch (error) {
      console.error("Error loading snippets:", error)
      showNotification("Error al cargar snippets", "error")
    } finally {
      setLoading(false)
    }
  }

  const handleSaveSnippet = async () => {
    if (!selectedNode || !currentProject) return

    try {
      const snippetToSave: Partial<CodeSnippet> = {
        ...formData,
        nodo_id: selectedNode.id,
        proyecto_id: currentProject.id,
        orden: formData.orden || snippets.length + 1,
      }

      await snippetsApi.saveSnippet(snippetToSave)
      await loadSnippets()
      setFormOpen(false)
      resetForm()
      showNotification("Snippet guardado exitosamente", "success")
    } catch (error) {
      console.error("Error saving snippet:", error)
      showNotification("Error al guardar snippet", "error")
    }
  }

  const handleDeleteSnippet = async (snippetId: number) => {
    if (!confirm("¿Eliminar este snippet de código?")) return

    try {
      await snippetsApi.deleteSnippet(snippetId)
      await loadSnippets()
      showNotification("Snippet eliminado", "success")
    } catch (error) {
      console.error("Error deleting snippet:", error)
      showNotification("Error al eliminar snippet", "error")
    }
  }

  const handleEditSnippet = (snippet: CodeSnippet) => {
    setSelectedSnippet(snippet)
    setFormData(snippet)
    setFormOpen(true)
  }

  const handlePreviewSnippet = (snippet: CodeSnippet) => {
    setPreviewSnippet(snippet)
    setPreviewOpen(true)
  }

  const copyToClipboard = async (code: string) => {
    try {
      await navigator.clipboard.writeText(code)
      showNotification("Código copiado al portapapeles", "success")
    } catch (error) {
      console.error("Error copying to clipboard:", error)
      showNotification("Error al copiar", "error")
    }
  }

  const resetForm = () => {
    setFormData({
      titulo: "",
      descripcion: "",
      lenguaje: "javascript",
      codigo: "",
      orden: snippets.length + 1,
    })
    setSelectedSnippet(null)
  }

  const getLanguageInfo = (language: string) => {
    return SUPPORTED_LANGUAGES.find((lang) => lang.value === language) || SUPPORTED_LANGUAGES[0]
  }

  const formatCode = (code: string, language: string) => {
    // Aquí podrías integrar un syntax highlighter como Prism.js o highlight.js
    return code
  }

  if (!selectedNode || !currentProject) {
    return null
  }

  return (
    <>
      <Card>
        <CardContent>
          <Box sx={{ display: "flex", justifyContent: "between", alignItems: "center", mb: 2 }}>
            <Typography variant="h6">💾 Snippets de Código - {selectedNode.text}</Typography>
            <Button
              variant="contained"
              startIcon={<Add />}
              onClick={() => {
                resetForm()
                setFormOpen(true)
              }}
            >
              Nuevo Snippet
            </Button>
          </Box>

          {snippets.length === 0 && !loading && (
            <Alert severity="info" sx={{ mb: 2 }}>
              <Typography variant="body2">
                <strong>¡Guarda fragmentos de código importantes!</strong>
                <br />
                Los snippets te permiten almacenar y organizar trozos de código relevantes para este nodo.
                <br />
                Se guardan tanto en la base de datos como en archivos para respaldo.
              </Typography>
            </Alert>
          )}

          <List>
            {snippets.map((snippet) => {
              const langInfo = getLanguageInfo(snippet.lenguaje)
              return (
                <ListItem key={snippet.id} divider>
                  <ListItemText
                    primary={
                      <Box sx={{ display: "flex", alignItems: "center", gap: 1 }}>
                        <Typography variant="subtitle1">{snippet.titulo}</Typography>
                        <Chip
                          label={langInfo.label}
                          size="small"
                          sx={{ backgroundColor: langInfo.color, color: "white" }}
                        />
                      </Box>
                    }
                    secondary={
                      <Box>
                        <Typography variant="body2" color="text.secondary">
                          {snippet.descripcion || "Sin descripción"}
                        </Typography>
                        <Typography variant="caption" color="text.secondary">
                          {snippet.codigo.split("\n").length} líneas • Creado:{" "}
                          {snippet.fecha_creacion && new Date(snippet.fecha_creacion).toLocaleDateString()}
                        </Typography>
                      </Box>
                    }
                  />
                  <ListItemSecondaryAction>
                    <Tooltip title="Ver código">
                      <IconButton size="small" onClick={() => handlePreviewSnippet(snippet)}>
                        <Code />
                      </IconButton>
                    </Tooltip>
                    <Tooltip title="Copiar código">
                      <IconButton size="small" onClick={() => copyToClipboard(snippet.codigo)}>
                        <ContentCopy />
                      </IconButton>
                    </Tooltip>
                    <Tooltip title="Editar">
                      <IconButton size="small" onClick={() => handleEditSnippet(snippet)}>
                        <Edit />
                      </IconButton>
                    </Tooltip>
                    <Tooltip title="Eliminar">
                      <IconButton
                        size="small"
                        color="error"
                        onClick={() => snippet.id && handleDeleteSnippet(snippet.id)}
                      >
                        <Delete />
                      </IconButton>
                    </Tooltip>
                  </ListItemSecondaryAction>
                </ListItem>
              )
            })}
            {loading && (
              <ListItem>
                <ListItemText primary="Cargando snippets..." />
              </ListItem>
            )}
          </List>
        </CardContent>
      </Card>

      {/* Dialog para crear/editar snippet */}
      <Dialog open={formOpen} onClose={() => setFormOpen(false)} maxWidth="lg" fullWidth>
        <DialogTitle>{selectedSnippet ? "Editar Snippet" : "Nuevo Snippet de Código"}</DialogTitle>
        <DialogContent>
          <Box sx={{ display: "flex", flexDirection: "column", gap: 2, pt: 1 }}>
            <Box sx={{ display: "flex", gap: 2 }}>
              <TextField
                fullWidth
                label="Título del Snippet"
                value={formData.titulo || ""}
                onChange={(e) => setFormData({ ...formData, titulo: e.target.value })}
                required
                placeholder="Ej: Función de validación, Query de usuarios, etc."
              />
              <FormControl sx={{ minWidth: 200 }}>
                <InputLabel>Lenguaje</InputLabel>
                <Select
                  value={formData.lenguaje || "javascript"}
                  onChange={(e) => setFormData({ ...formData, lenguaje: e.target.value as SupportedLanguage })}
                  label="Lenguaje"
                >
                  {SUPPORTED_LANGUAGES.map((lang) => (
                    <MenuItem key={lang.value} value={lang.value}>
                      <Box sx={{ display: "flex", alignItems: "center", gap: 1 }}>
                        <Box
                          sx={{
                            width: 12,
                            height: 12,
                            borderRadius: "50%",
                            backgroundColor: lang.color,
                          }}
                        />
                        {lang.label}
                      </Box>
                    </MenuItem>
                  ))}
                </Select>
              </FormControl>
            </Box>

            <TextField
              fullWidth
              label="Descripción"
              value={formData.descripcion || ""}
              onChange={(e) => setFormData({ ...formData, descripcion: e.target.value })}
              multiline
              rows={2}
              placeholder="Describe qué hace este código, cuándo usarlo, etc."
            />

            <TextField
              fullWidth
              label="Código"
              value={formData.codigo || ""}
              onChange={(e) => setFormData({ ...formData, codigo: e.target.value })}
              multiline
              rows={12}
              required
              placeholder="Pega aquí tu código..."
              sx={{
                "& .MuiInputBase-input": {
                  fontFamily: "'Fira Code', 'Consolas', 'Monaco', monospace",
                  fontSize: "0.875rem",
                },
              }}
            />

            <TextField
              label="Orden"
              type="number"
              value={formData.orden || 1}
              onChange={(e) => setFormData({ ...formData, orden: Number.parseInt(e.target.value) || 1 })}
              sx={{ width: 120 }}
            />
          </Box>
        </DialogContent>
        <DialogActions>
          <Button onClick={() => setFormOpen(false)}>Cancelar</Button>
          <Button onClick={handleSaveSnippet} variant="contained" disabled={!formData.titulo || !formData.codigo}>
            <Save sx={{ mr: 1 }} />
            {selectedSnippet ? "Actualizar" : "Guardar"}
          </Button>
        </DialogActions>
      </Dialog>

      {/* Dialog para preview de código */}
      <Dialog open={previewOpen} onClose={() => setPreviewOpen(false)} maxWidth="lg" fullWidth>
        <DialogTitle>
          <Box sx={{ display: "flex", justifyContent: "between", alignItems: "center" }}>
            <Typography variant="h6">{previewSnippet?.titulo}</Typography>
            <Box sx={{ display: "flex", gap: 1 }}>
              {previewSnippet && (
                <Chip
                  label={getLanguageInfo(previewSnippet.lenguaje).label}
                  sx={{ backgroundColor: getLanguageInfo(previewSnippet.lenguaje).color, color: "white" }}
                />
              )}
              <Button
                startIcon={<ContentCopy />}
                onClick={() => previewSnippet && copyToClipboard(previewSnippet.codigo)}
              >
                Copiar
              </Button>
            </Box>
          </Box>
        </DialogTitle>
        <DialogContent>
          {previewSnippet && (
            <Box>
              {previewSnippet.descripcion && (
                <Typography variant="body2" color="text.secondary" sx={{ mb: 2 }}>
                  {previewSnippet.descripcion}
                </Typography>
              )}
              <Paper
                sx={{
                  p: 2,
                  backgroundColor: "#1e1e1e",
                  color: "#f5f5f5",
                  overflow: "auto",
                  maxHeight: 500,
                }}
              >
                <Box
                  component="pre"
                  sx={{
                    fontFamily: "'Fira Code', 'Consolas', 'Monaco', monospace",
                    fontSize: "0.875rem",
                    whiteSpace: "pre-wrap",
                    wordBreak: "break-word",
                    margin: 0,
                    lineHeight: 1.5,
                  }}
                >
                  {formatCode(previewSnippet.codigo, previewSnippet.lenguaje)}
                </Box>
              </Paper>
            </Box>
          )}
        </DialogContent>
        <DialogActions>
          <Button onClick={() => setPreviewOpen(false)}>Cerrar</Button>
        </DialogActions>
      </Dialog>
    </>
  )
}

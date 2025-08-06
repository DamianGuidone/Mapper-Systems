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
  List,
  ListItem,
  ListItemText,
  Chip,
  IconButton,
  Collapse,
  Select,
  MenuItem,
  FormControl,
  InputLabel,
} from "@mui/material"
import { Visibility, VisibilityOff, Today, FolderOpen } from "@mui/icons-material"
import { nodesApi } from "../services/api"
import { useAppContext } from "../contexts/AppContext"
import { useApi } from "../hooks/useApi"

export const NodeDetails: React.FC = () => {
  const { selectedNode, currentProject, currentUser, showNotification } = useAppContext()

  const [showHistory, setShowHistory] = useState(false)
  const [historyFilter, setHistoryFilter] = useState("")
  const [dateFrom, setDateFrom] = useState("")
  const [dateTo, setDateTo] = useState("")

  const { data: history, refetch: refetchHistory } = useApi(
    () =>
      selectedNode && currentProject
        ? nodesApi.getNodeHistory(currentProject.id, selectedNode.id)
        : Promise.reject("No node or project selected"),
    [selectedNode?.id, currentProject?.id],
  )

  const handleFieldUpdate = async (field: string, oldValue: string, newValue: string) => {
    if (!selectedNode || !currentProject || oldValue === newValue) return

    try {
      await nodesApi.updateNodeField(currentProject.id, selectedNode.id, {
        campo: field,
        anterior: oldValue,
        nuevo: newValue,
        usuario: currentUser,
      })
      refetchHistory()
      showNotification("Campo actualizado exitosamente", "success")
    } catch (error) {
      console.error("Error updating field:", error)
      showNotification("Error al actualizar campo", "error")
    }
  }

  const setToday = (field: string) => {
    const today = new Date().toISOString().split("T")[0]
    if (selectedNode) {
      const oldValue = selectedNode.data[field as keyof typeof selectedNode.data] || ""
      handleFieldUpdate(field, oldValue, today)
    }
  }

  const filteredHistory =
    history?.filter((entry) => {
      if (historyFilter && entry.campo !== historyFilter) return false
      if (dateFrom && new Date(entry.fecha) < new Date(dateFrom)) return false
      if (dateTo && new Date(entry.fecha) > new Date(dateTo)) return false
      return true
    }) || []

  if (!selectedNode || !currentProject) {
    return (
      <Card>
        <CardContent>
          <Typography variant="h6" color="text.secondary">
            Selecciona un nodo para ver sus detalles
          </Typography>
        </CardContent>
      </Card>
    )
  }

  return (
    <Card>
      <CardContent>
        <Typography variant="h6" gutterBottom>
          Detalles del Nodo
        </Typography>

        <Box sx={{ mb: 2 }}>
          <TextField
            fullWidth
            label="Título"
            value={selectedNode.text}
            onBlur={(e) => handleFieldUpdate("text", selectedNode.text, e.target.value)}
            variant="outlined"
            size="small"
          />
        </Box>

        <Box sx={{ mb: 2 }}>
          <TextField
            fullWidth
            label="Descripción"
            value={selectedNode.data.descripcion || ""}
            onBlur={(e) => handleFieldUpdate("descripcion", selectedNode.data.descripcion || "", e.target.value)}
            variant="outlined"
            size="small"
            multiline
            rows={2}
          />
        </Box>

        <Box sx={{ display: "flex", gap: 2, mb: 2 }}>
          <Box sx={{ flex: 1 }}>
            <TextField
              fullWidth
              label="Última modificación"
              type="date"
              value={selectedNode.data.ultima_modificacion || ""}
              onChange={(e) =>
                handleFieldUpdate("ultima_modificacion", selectedNode.data.ultima_modificacion || "", e.target.value)
              }
              InputLabelProps={{ shrink: true }}
              size="small"
            />
            <Button size="small" onClick={() => setToday("ultima_modificacion")} sx={{ mt: 0.5 }}>
              <Today fontSize="small" sx={{ mr: 0.5 }} />
              Hoy
            </Button>
          </Box>
          <Box sx={{ flex: 1 }}>
            <TextField
              fullWidth
              label="Última revisión"
              type="date"
              value={selectedNode.data.ultima_revision || ""}
              onChange={(e) =>
                handleFieldUpdate("ultima_revision", selectedNode.data.ultima_revision || "", e.target.value)
              }
              InputLabelProps={{ shrink: true }}
              size="small"
            />
            <Button size="small" onClick={() => setToday("ultima_revision")} sx={{ mt: 0.5 }}>
              <Today fontSize="small" sx={{ mr: 0.5 }} />
              Hoy
            </Button>
          </Box>
        </Box>

        {selectedNode.data.tipo_nodo === "bd" && (
          <Box sx={{ mb: 2 }}>
            <TextField
              fullWidth
              label="Archivo"
              value={selectedNode.data.archivo || ""}
              InputProps={{
                readOnly: true,
                endAdornment: (
                  <IconButton size="small">
                    <FolderOpen />
                  </IconButton>
                ),
              }}
              size="small"
            />
          </Box>
        )}

        {/* Historial */}
        <Box sx={{ mt: 3 }}>
          <Box sx={{ display: "flex", justifyContent: "between", alignItems: "center", mb: 1 }}>
            <Typography variant="h6">Historial de Cambios</Typography>
            <IconButton onClick={() => setShowHistory(!showHistory)}>
              {showHistory ? <VisibilityOff /> : <Visibility />}
            </IconButton>
          </Box>

          <Collapse in={showHistory}>
            <Box sx={{ mb: 2, display: "flex", gap: 2, flexWrap: "wrap" }}>
              <FormControl size="small" sx={{ minWidth: 120 }}>
                <InputLabel>Campo</InputLabel>
                <Select value={historyFilter} onChange={(e) => setHistoryFilter(e.target.value)} label="Campo">
                  <MenuItem value="">Todos</MenuItem>
                  <MenuItem value="text">Título</MenuItem>
                  <MenuItem value="descripcion">Descripción</MenuItem>
                  <MenuItem value="ultima_modificacion">Última Modificación</MenuItem>
                  <MenuItem value="ultima_revision">Última Revisión</MenuItem>
                </Select>
              </FormControl>
              <TextField
                label="Desde"
                type="date"
                value={dateFrom}
                onChange={(e) => setDateFrom(e.target.value)}
                InputLabelProps={{ shrink: true }}
                size="small"
              />
              <TextField
                label="Hasta"
                type="date"
                value={dateTo}
                onChange={(e) => setDateTo(e.target.value)}
                InputLabelProps={{ shrink: true }}
                size="small"
              />
              <Button
                size="small"
                onClick={() => {
                  setHistoryFilter("")
                  setDateFrom("")
                  setDateTo("")
                }}
              >
                Reset
              </Button>
            </Box>

            <List dense>
              {filteredHistory.map((entry, index) => (
                <ListItem key={index} divider>
                  <ListItemText
                    primary={
                      <Box sx={{ display: "flex", alignItems: "center", gap: 1 }}>
                        <Chip label={entry.campo} size="small" />
                        <Typography variant="body2">{new Date(entry.fecha).toLocaleString()}</Typography>
                      </Box>
                    }
                    secondary={
                      <Box>
                        <Typography variant="body2" component="span" sx={{ textDecoration: "line-through" }}>
                          {entry.anterior}
                        </Typography>
                        {" → "}
                        <Typography variant="body2" component="span" color="success.main">
                          {entry.nuevo}
                        </Typography>
                        <Typography variant="caption" display="block">
                          por {entry.usuario}
                        </Typography>
                      </Box>
                    }
                  />
                </ListItem>
              ))}
            </List>
          </Collapse>
        </Box>
      </CardContent>
    </Card>
  )
}

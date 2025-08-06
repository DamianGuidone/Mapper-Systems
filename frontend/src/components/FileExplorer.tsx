"use client"

import type React from "react"
import { useState } from "react"
import {
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  Button,
  Box,
  List,
  ListItem,
  ListItemIcon,
  ListItemText,
  ListItemButton,
  Typography,
  Breadcrumbs,
  Link,
  Paper,
} from "@mui/material"
import { Folder, InsertDriveFile, Storage, Code, Html, NavigateNext } from "@mui/icons-material"
import type { FileItem } from "../types"
import { filesApi } from "../services/api"
import { useApi } from "../hooks/useApi"

interface FileExplorerProps {
  open: boolean
  onClose: () => void
  onFileSelect: (filePath: string) => void
}

export const FileExplorer: React.FC<FileExplorerProps> = ({ open, onClose, onFileSelect }) => {
  const [currentPath, setCurrentPath] = useState("")
  const [selectedFile, setSelectedFile] = useState<string | null>(null)
  const [fileContent, setFileContent] = useState("")

  const { data: explorerData, loading, refetch } = useApi(() => filesApi.exploreDirectory(currentPath), [currentPath])

  const getFileIcon = (item: FileItem) => {
    if (item.is_directory) return <Folder color="primary" />

    switch (item.type) {
      case "database":
        return <Storage color="error" />
      case "javascript":
        return <Code color="warning" />
      case "html":
        return <Html color="info" />
      default:
        return <InsertDriveFile />
    }
  }

  const handleItemClick = async (item: FileItem) => {
    if (item.is_directory) {
      setCurrentPath(item.path)
    } else {
      setSelectedFile(item.path)
      try {
        const response = await filesApi.readFile(item.path)
        setFileContent(response.data.content)
      } catch (error) {
        setFileContent("Error al cargar el archivo")
      }
    }
  }

  const handleBreadcrumbClick = (path: string) => {
    setCurrentPath(path)
  }

  const handleConfirm = () => {
    if (selectedFile) {
      onFileSelect(selectedFile)
      onClose()
    }
  }

  const pathParts = currentPath.split("/").filter(Boolean)

  return (
    <Dialog open={open} onClose={onClose} maxWidth="lg" fullWidth>
      <DialogTitle>Explorador de Archivos</DialogTitle>
      <DialogContent>
        <Box sx={{ display: "flex", height: 500 }}>
          {/* Panel izquierdo - Explorador */}
          <Box sx={{ width: "40%", borderRight: 1, borderColor: "divider", pr: 2 }}>
            <Breadcrumbs separator={<NavigateNext fontSize="small" />} sx={{ mb: 2 }}>
              <Link component="button" variant="body2" onClick={() => handleBreadcrumbClick("")}>
                Archive
              </Link>
              {pathParts.map((part, index) => {
                const path = pathParts.slice(0, index + 1).join("/")
                return (
                  <Link key={path} component="button" variant="body2" onClick={() => handleBreadcrumbClick(path)}>
                    {part}
                  </Link>
                )
              })}
            </Breadcrumbs>

            <List dense>
              {loading ? (
                <ListItem>
                  <ListItemText primary="Cargando..." />
                </ListItem>
              ) : (
                explorerData?.items.map((item) => (
                  <ListItem key={item.path} disablePadding>
                    <ListItemButton onClick={() => handleItemClick(item)} selected={selectedFile === item.path}>
                      <ListItemIcon>{getFileIcon(item)}</ListItemIcon>
                      <ListItemText primary={item.name} />
                    </ListItemButton>
                  </ListItem>
                ))
              )}
            </List>
          </Box>

          {/* Panel derecho - Preview */}
          <Box sx={{ width: "60%", pl: 2 }}>
            <Typography variant="h6" gutterBottom>
              Previsualización
            </Typography>
            <Paper
              sx={{
                p: 2,
                height: "calc(100% - 40px)",
                overflow: "auto",
                backgroundColor: "#2a2a2a",
                color: "#f5f5f5",
              }}
            >
              {selectedFile ? (
                <Box
                  component="pre"
                  sx={{
                    fontFamily: "monospace",
                    fontSize: "0.875rem",
                    whiteSpace: "pre-wrap",
                    wordBreak: "break-word",
                  }}
                >
                  {fileContent}
                </Box>
              ) : (
                <Typography color="text.secondary">Selecciona un archivo para ver su contenido</Typography>
              )}
            </Paper>
          </Box>
        </Box>
      </DialogContent>
      <DialogActions>
        <Button onClick={onClose}>Cancelar</Button>
        <Button onClick={handleConfirm} variant="contained" disabled={!selectedFile}>
          Seleccionar
        </Button>
      </DialogActions>
    </Dialog>
  )
}

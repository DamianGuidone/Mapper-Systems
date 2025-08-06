"use client"

import type React from "react"
import { useState, useEffect } from "react"
import { Card, CardContent, Typography, Box, Paper, IconButton, Tooltip } from "@mui/material"
import { Storage, Visibility, Launch, ContentCopy } from "@mui/icons-material"
import { filesApi } from "../services/api"
import { useAppContext } from "../contexts/AppContext"

export const SqlPreview: React.FC = () => {
  const { selectedNode, showNotification } = useAppContext()

  const [fileContent, setFileContent] = useState("")
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    if (selectedNode?.data.tipo_nodo === "bd" && selectedNode.data.archivo) {
      loadFileContent()
    } else {
      setFileContent("")
      setError(null)
    }
  }, [selectedNode])

  const loadFileContent = async () => {
    if (!selectedNode?.data.archivo) return

    setLoading(true)
    setError(null)
    try {
      const response = await filesApi.readFile(selectedNode.data.archivo)
      setFileContent(response.data.content)
    } catch (err: any) {
      setError(err.response?.data?.error || "Error al cargar el archivo")
      setFileContent("")
      showNotification("Error al cargar archivo SQL", "error")
    } finally {
      setLoading(false)
    }
  }

  const openFileInSSMS = async () => {
    if (!selectedNode?.data.archivo) return

    try {
      await filesApi.openFile(selectedNode.data.archivo)
      showNotification("Archivo abierto en SSMS", "success")
    } catch (error) {
      console.error("Error opening file:", error)
      showNotification("Error al abrir archivo", "error")
    }
  }

  const copyToClipboard = async () => {
    try {
      await navigator.clipboard.writeText(fileContent)
      showNotification("SQL copiado al portapapeles", "success")
    } catch (error) {
      console.error("Error copying to clipboard:", error)
      showNotification("Error al copiar", "error")
    }
  }

  const formatSqlContent = (content: string) => {
    if (!content) return content

    // Palabras clave SQL para resaltar
    const sqlKeywords = [
      "SELECT",
      "FROM",
      "WHERE",
      "JOIN",
      "INNER JOIN",
      "LEFT JOIN",
      "RIGHT JOIN",
      "FULL JOIN",
      "INSERT",
      "UPDATE",
      "DELETE",
      "CREATE",
      "ALTER",
      "DROP",
      "TABLE",
      "INDEX",
      "VIEW",
      "PROCEDURE",
      "FUNCTION",
      "TRIGGER",
      "DATABASE",
      "SCHEMA",
      "PRIMARY KEY",
      "FOREIGN KEY",
      "NOT NULL",
      "UNIQUE",
      "DEFAULT",
      "CHECK",
      "CONSTRAINT",
      "REFERENCES",
      "AND",
      "OR",
      "NOT",
      "IN",
      "EXISTS",
      "BETWEEN",
      "LIKE",
      "IS NULL",
      "IS NOT NULL",
      "ORDER BY",
      "GROUP BY",
      "HAVING",
      "DISTINCT",
      "TOP",
      "LIMIT",
      "OFFSET",
      "UNION",
      "UNION ALL",
      "INTERSECT",
      "EXCEPT",
      "CASE",
      "WHEN",
      "THEN",
      "ELSE",
      "END",
      "IF",
      "WHILE",
      "FOR",
      "BEGIN",
      "END",
      "TRY",
      "CATCH",
      "THROW",
      "RETURN",
      "DECLARE",
      "SET",
      "EXEC",
      "EXECUTE",
      "PRINT",
      "RAISERROR",
    ]

    let formattedContent = content

    // Resaltar palabras clave SQL
    sqlKeywords.forEach((keyword) => {
      const regex = new RegExp(`\\b${keyword}\\b`, "gi")
      formattedContent = formattedContent.replace(regex, `<span class="sql-keyword">${keyword.toUpperCase()}</span>`)
    })

    // Resaltar comentarios
    formattedContent = formattedContent.replace(/--.*$/gm, '<span class="sql-comment">$&</span>')

    // Resaltar comentarios de bloque
    formattedContent = formattedContent.replace(/\/\*[\s\S]*?\*\//g, '<span class="sql-comment">$&</span>')

    // Resaltar strings
    formattedContent = formattedContent.replace(/'([^']*)'/g, "<span class=\"sql-string\">'$1'</span>")

    // Resaltar números
    formattedContent = formattedContent.replace(/\b\d+(\.\d+)?\b/g, '<span class="sql-number">$&</span>')

    return formattedContent
  }

  if (!selectedNode || selectedNode.data.tipo_nodo !== "bd") {
    return null
  }

  return (
    <Card>
      <CardContent>
        <Box sx={{ display: "flex", justifyContent: "between", alignItems: "center", mb: 2 }}>
          <Typography variant="h6">📄 Previsualización SQL</Typography>
          <Box sx={{ display: "flex", gap: 1 }}>
            <Tooltip title="Recargar contenido">
              <IconButton onClick={loadFileContent} disabled={loading}>
                <Visibility />
              </IconButton>
            </Tooltip>
            <Tooltip title="Copiar SQL">
              <IconButton onClick={copyToClipboard} disabled={!fileContent}>
                <ContentCopy />
              </IconButton>
            </Tooltip>
            <Tooltip title="Abrir en SSMS">
              <IconButton onClick={openFileInSSMS}>
                <Launch />
              </IconButton>
            </Tooltip>
          </Box>
        </Box>

        {selectedNode.data.archivo ? (
          <Paper
            sx={{
              p: 2,
              backgroundColor: "#1e1e1e",
              color: "#f5f5f5",
              maxHeight: 500,
              overflow: "auto",
              border: "1px solid #333",
              borderRadius: 2,
            }}
          >
            {loading ? (
              <Typography>Cargando SQL...</Typography>
            ) : error ? (
              <Typography color="error">{error}</Typography>
            ) : fileContent ? (
              <>
                <style>{`
                  .sql-keyword {
                    color: #569cd6;
                    font-weight: bold;
                  }
                  .sql-comment {
                    color: #6a9955;
                    font-style: italic;
                  }
                  .sql-string {
                    color: #ce9178;
                  }
                  .sql-number {
                    color: #b5cea8;
                  }
                `}</style>
                <Box
                  component="pre"
                  sx={{
                    fontFamily: "'Fira Code', 'Consolas', 'Monaco', monospace",
                    fontSize: "0.875rem",
                    whiteSpace: "pre-wrap",
                    wordBreak: "break-word",
                    margin: 0,
                    lineHeight: 1.5,
                    "& .sql-keyword": {
                      color: "#569cd6",
                      fontWeight: "bold",
                    },
                    "& .sql-comment": {
                      color: "#6a9955",
                      fontStyle: "italic",
                    },
                    "& .sql-string": {
                      color: "#ce9178",
                    },
                    "& .sql-number": {
                      color: "#b5cea8",
                    },
                  }}
                  dangerouslySetInnerHTML={{ __html: formatSqlContent(fileContent) }}
                />
              </>
            ) : (
              <Typography color="text.secondary">El archivo está vacío</Typography>
            )}
          </Paper>
        ) : (
          <Paper sx={{ p: 3, textAlign: "center" }}>
            <Storage sx={{ fontSize: 48, color: "text.secondary", mb: 2 }} />
            <Typography color="text.secondary">No hay archivo asociado a este nodo</Typography>
            <Typography variant="body2" color="text.secondary" sx={{ mt: 1 }}>
              Edita el nodo para asignar un archivo SQL
            </Typography>
          </Paper>
        )}

        {selectedNode.data.archivo && (
          <Box sx={{ mt: 2, p: 1, backgroundColor: "#2a2a2a", borderRadius: 1 }}>
            <Typography variant="caption" sx={{ fontFamily: "monospace", color: "text.secondary" }}>
              📁 {selectedNode.data.archivo}
            </Typography>
          </Box>
        )}
      </CardContent>
    </Card>
  )
}

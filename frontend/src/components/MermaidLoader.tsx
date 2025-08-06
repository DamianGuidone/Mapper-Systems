"use client"
import { useEffect, useState } from "react"
import type React from "react"

import { Box, CircularProgress, Typography } from "@mui/material"

interface MermaidLoaderProps {
  children: React.ReactNode
}

export const MermaidLoader: React.FC<MermaidLoaderProps> = ({ children }) => {
  const [mermaidLoaded, setMermaidLoaded] = useState(false)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    const loadMermaid = async () => {
      try {
        // Verificar si ya está cargado
        if (typeof window !== "undefined" && (window as any).mermaid) {
          setMermaidLoaded(true)
          return
        }

        // Importar Mermaid dinámicamente
        const mermaid = (await import("mermaid")).default

        // Hacer Mermaid disponible globalmente (opcional)
        if (typeof window !== "undefined") {
          ;(window as any).mermaid = mermaid
        }

        setMermaidLoaded(true)
      } catch (err) {
        console.error("Error loading Mermaid:", err)
        setError("Error al cargar Mermaid")
      }
    }

    loadMermaid()
  }, [])

  if (error) {
    return (
      <Box display="flex" justifyContent="center" alignItems="center" minHeight="200px">
        <Typography color="error">{error}</Typography>
      </Box>
    )
  }

  if (!mermaidLoaded) {
    return (
      <Box display="flex" justifyContent="center" alignItems="center" minHeight="200px">
        <CircularProgress size={24} />
        <Typography sx={{ ml: 2 }}>Cargando Mermaid...</Typography>
      </Box>
    )
  }

  return <>{children}</>
}

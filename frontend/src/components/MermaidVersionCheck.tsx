"use client"
import type React from "react"
import { useEffect, useState } from "react"
import { Alert, Box, Chip, Typography } from "@mui/material"
import { Info, CheckCircle, Warning } from "@mui/icons-material"

export const MermaidVersionCheck: React.FC = () => {
  const [mermaidInfo, setMermaidInfo] = useState<{
    version: string
    isLoaded: boolean
    features: string[]
  }>({
    version: "Unknown",
    isLoaded: false,
    features: [],
  })

  useEffect(() => {
    const checkMermaidVersion = async () => {
      try {
        // Verificar si estamos en el cliente
        if (typeof window === "undefined") {
          setMermaidInfo({
            version: "Server Side",
            isLoaded: false,
            features: [],
          })
          return
        }

        // Importar mermaid dinámicamente
        const mermaid = (await import("mermaid")).default

        if (mermaid) {
          let version = "Unknown"
          const features: string[] = []

          // Verificar características básicas
          if ("parse" in mermaid) features.push("Parser")
          if ("render" in mermaid) features.push("Renderer")
          mermaid.initialize({
            startOnLoad: false,
            theme: "default",
            securityLevel: "loose",
          })
          features.push("Configuración")

          // Intentar detectar versión a través de características
          try {
            await mermaid.parse("mindmap\n  root")
            features.push("Mindmap")
          } catch (e) {
            // No soporta mindmap
          }

          try {
            await mermaid.parse("timeline\n  title Test")
            features.push("Timeline")
          } catch (e) {
            // No soporta timeline
          }

          try {
            await mermaid.parse("quadrantChart\n  title Test")
            features.push("Quadrant")
          } catch (e) {
            // No soporta quadrant
          }

          try {
            await mermaid.parse("xychart-beta\n  line [1,2,3]")
            features.push("XY Chart")
          } catch (e) {
            // No soporta xychart
          }

          try {
            await mermaid.parse("block-beta\n  A B")
            features.push("Block")
          } catch (e) {
            // No soporta block
          }

          try {
            await mermaid.parse("packet\n  0-7: Test")
            features.push("Packet")
          } catch (e) {
            // No soporta packet
          }

          try {
            await mermaid.parse("architecture-beta\n  service test(server)[Test]")
            features.push("Architecture")
          } catch (e) {
            // No soporta architecture
          }

          try {
            await mermaid.parse("radar-beta\n  axis A\n  curve c{1}")
            features.push("Radar")
          } catch (e) {
            // No soporta radar
          }

          // Estimar versión basada en características
          if (features.includes("Radar") || features.includes("Architecture")) {
            version = "v10.9+"
          } else if (features.includes("Block") || features.includes("XY Chart")) {
            version = "v10.6+"
          } else if (features.includes("Quadrant")) {
            version = "v10.3+"
          } else if (features.includes("Timeline") || features.includes("Mindmap")) {
            version = "v10.0+"
          } else {
            version = "v9.0+"
          }

          setMermaidInfo({
            version,
            isLoaded: true,
            features,
          })
        } else {
          setMermaidInfo({
            version: "Not loaded",
            isLoaded: false,
            features: [],
          })
        }
      } catch (error) {
        console.error("Error checking Mermaid version:", error)
        setMermaidInfo({
          version: "Error loading",
          isLoaded: false,
          features: [],
        })
      }
    }

    // Verificar después de un pequeño delay para asegurar que mermaid esté cargado
    const timer = setTimeout(checkMermaidVersion, 1000)
    return () => clearTimeout(timer)
  }, [])

  const getSeverity = () => {
    if (!mermaidInfo.isLoaded) return "error"
    if (mermaidInfo.features.length >= 8) return "success"
    if (mermaidInfo.features.length >= 5) return "info"
    return "warning"
  }

  const getIcon = () => {
    const severity = getSeverity()
    switch (severity) {
      case "success":
        return <CheckCircle />
      case "error":
        return <Warning />
      case "warning":
        return <Warning />
      default:
        return <Info />
    }
  }

  const getRecommendation = () => {
    const featureCount = mermaidInfo.features.length
    if (featureCount >= 10) {
      return "¡Excelente! Tienes acceso a todas las características modernas de Mermaid."
    } else if (featureCount >= 7) {
      return "Buena versión de Mermaid con soporte para la mayoría de diagramas modernos."
    } else if (featureCount >= 4) {
      return "Versión básica de Mermaid. Considera actualizar para acceder a más tipos de diagramas."
    } else {
      return "Versión antigua de Mermaid. Se recomienda actualizar para mejor compatibilidad."
    }
  }

  return (
    <Alert severity={getSeverity()} icon={getIcon()} sx={{ mb: 2 }}>
      <Box>
        <Typography variant="body2" fontWeight="bold">
          Mermaid {mermaidInfo.version} - {mermaidInfo.isLoaded ? "Cargado" : "No disponible"}
        </Typography>

        <Typography variant="body2" sx={{ mt: 1 }}>
          {getRecommendation()}
        </Typography>

        {mermaidInfo.features.length > 0 && (
          <Box sx={{ mt: 1, display: "flex", flexWrap: "wrap", gap: 0.5 }}>
            <Typography variant="caption" sx={{ mr: 1 }}>
              Características disponibles:
            </Typography>
            {mermaidInfo.features.map((feature) => (
              <Chip
                key={feature}
                label={feature}
                size="small"
                variant="outlined"
                sx={{ fontSize: "0.7rem", height: "20px" }}
              />
            ))}
          </Box>
        )}
      </Box>
    </Alert>
  )
}

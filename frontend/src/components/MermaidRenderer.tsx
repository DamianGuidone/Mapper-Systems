// MermaidRenderer.tsx
"use client"
import React, { useEffect, useRef, useState, useCallback } from "react"
import { Box, CircularProgress, Typography } from "@mui/material"

interface MermaidRendererProps {
 code: string
 darkMode?: boolean
 onRendered?: () => void
 onError?: (error: string) => void
 shouldRender: boolean // Prop para controlar el renderizado
}

const MermaidRenderer: React.FC<MermaidRendererProps> = ({ code, darkMode = false, onRendered, onError, shouldRender }) => {
 const containerRef = useRef<HTMLDivElement>(null)
 const [error, setError] = useState<string | null>(null)
 const [loading, setLoading] = useState<boolean>(false)
 const [mermaidLib, setMermaidLib] = useState<any>(null) // Renombrado para evitar conflicto con import

 // Cargar Mermaid dinámicamente y configurar una vez
 useEffect(() => {
  const loadMermaid = async () => {
   try {
    const mermaidInstance = (await import("mermaid")).default
    mermaidInstance.initialize({
     startOnLoad: false,
     theme: darkMode? "dark" : "default",
     securityLevel: "loose",
     fontFamily: "Roboto, sans-serif",
     // Configuración useMaxWidth para todos los tipos de diagrama
     flowchart: { curve: "basis", useMaxWidth: true },
     sequence: { useMaxWidth: true },
     class: { useMaxWidth: true },
     state: { useMaxWidth: true },
     er: { useMaxWidth: true },
     journey: { useMaxWidth: true },
     gantt: { useMaxWidth: true },
     pie: { useMaxWidth: true },
     gitGraph: { useMaxWidth: true },
     mindmap: { useMaxWidth: true },
     timeline: { useMaxWidth: true },
     quadrantChart: { useMaxWidth: true },
     c4: { useMaxWidth: true },
     xyChart: { useMaxWidth: true },
     block: { useMaxWidth: true },
     packet: { useMaxWidth: true },
     kanban: { useMaxWidth: true },
     architecture: { useMaxWidth: true },
     radar: { useMaxWidth: true }
    })
    setMermaidLib(mermaidInstance)
   } catch (err) {
    console.error("Error loading Mermaid:", err)
    setError("Error al cargar la librería Mermaid.")
    onError?.("Error al cargar la librería Mermaid.")
   }
  }
  loadMermaid()
 }, [darkMode, onError]) // Dependencia darkMode para re-inicializar si el tema cambia

 // Función de renderizado principal
 const renderDiagram = useCallback(async () => {
  if (!mermaidLib ||!containerRef.current ||!code.trim()) {
   return
  }

  setLoading(true)
  setError(null)

  try {
   containerRef.current.innerHTML = "" // Limpiar contenedor antes de renderizar

   // Generar ID único para cada renderizado
   const id = `mermaid-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`

   console.log("MermaidRenderer: Intentando renderizar diagrama con código:", code.substring(0, 100) + "...")

   const { svg, bindFunctions } = await mermaidLib.render(id, code)

   if (containerRef.current) {
    containerRef.current.innerHTML = svg
    if (bindFunctions) {
     bindFunctions(containerRef.current)
    }
    setLoading(false)
    onRendered?.()
    console.log("MermaidRenderer: Diagrama renderizado exitosamente.")
   }
  } catch (err) {
   console.error("MermaidRenderer: Error de renderizado:", err)
   const errorMessage = err instanceof Error? err.message : "Error desconocido al renderizar."
   setError("Error al renderizar el diagrama.")
   setLoading(false)
   onError?.(errorMessage)

   // Mostrar error en el contenedor
   if (containerRef.current) {
    containerRef.current.innerHTML = `
     <div style="
      padding: 16px;
      color: #d32f2f;
      background-color: #ffebee;
      border-radius: 4px;
      border: 1px solid #ffcdd2;
      font-family: 'Roboto', sans-serif;
      text-align: center;
     ">
      <strong>Error de sintaxis Mermaid:</strong><br/><br/>
      <code style="
       font-size: 0.875rem;
       background: rgba(0,0,0,0.1);
       padding: 4px 8px;
       border-radius: 2px;
       display: block;
       margin-top: 8px;
       word-break: break-word;
      ">
       ${errorMessage}
      </code>
     </div>
    `
   }
  }
 }, [mermaidLib, containerRef, code, setLoading, setError])

 // Este useEffect se encarga de disparar el renderizado cuando shouldRender es true
 useEffect(() => {
  if (shouldRender && mermaidLib && code.trim()) {
   renderDiagram()
  } else if (!code.trim()) {
   // Si el código está vacío, limpiar y resetear estados
   setLoading(false)
   setError(null)
   if (containerRef.current) {
    containerRef.current.innerHTML = ""
   }
  }
  // La función de limpieza se encarga de limpiar el contenedor
  return () => {
   if (containerRef.current) {
    containerRef.current.innerHTML = ""
   }
  }
 },) // Dependencias correctas

 // Si no hay código, mostrar mensaje
 if (!code.trim()) {
  return (
   <Box display="flex" justifyContent="center" alignItems="center" height="100%" sx={{ minHeight: 200 }}>
    <Typography color="textSecondary" textAlign="center">
     Escribe tu código Mermaid en el editor para ver la previsualización
    </Typography>
   </Box>
  )
 }

 if (loading) {
  return (
   <Box display="flex" justifyContent="center" alignItems="center" height="100%" sx={{ minHeight: 200 }}>
    <CircularProgress size={24} />
    <Typography sx={{ ml: 2 }}>Renderizando diagrama...</Typography>
   </Box>
  )
 }

 if (error) {
  return (
   <Box
    display="flex"
    flexDirection="column"
    gap={2}
    p={2}
    height="100%"
    sx={{ minHeight: 200 }}
    alignItems="center"
    justifyContent="center"
   >
    <Typography color="error" fontWeight="bold" textAlign="center">
     {error}
    </Typography>
    {/* El botón de reintentar ahora lo maneja el padre */}
   </Box>
  )
 }

 return (
  <Box
   ref={containerRef}
   sx={{
    p: 2,
    overflow: "auto",
    display: "flex",
    justifyContent: "center",
    alignItems: "center",
    height: "100%",
    minHeight: 200,
    "& svg": {
     maxWidth: "100%",
     height: "auto",
     display: "block",
    },
    // Mejorar la legibilidad en modo oscuro
    "&.node rect, &.node circle, &.node ellipse, &.node polygon, &.node path": {
     filter: darkMode? "brightness(1.1)" : "none",
    },
    "&.edgeLabel": {
     backgroundColor: darkMode? "rgba(0,0,0,0.8)" : "rgba(255,255,255,0.8)",
    },
   }}
  />
 )
}

export default React.memo(MermaidRenderer)
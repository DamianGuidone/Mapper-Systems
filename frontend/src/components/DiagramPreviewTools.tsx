"use client"
import type React from "react"
import { useState, useRef, useCallback } from "react"
import { Box, Tooltip, Fab, Zoom } from "@mui/material"
import {
  PanTool as PanToolIcon,
  ZoomIn as ZoomInIcon,
  ZoomOut as ZoomOutIcon,
  Fullscreen as FullscreenIcon,
  CenterFocusStrong as CenterFocusIcon,
  Refresh as RefreshIcon,
} from "@mui/icons-material"

interface DiagramPreviewToolsProps {
  children: React.ReactNode
  onRefresh?: () => void
}

export const DiagramPreviewTools: React.FC<DiagramPreviewToolsProps> = ({ children, onRefresh }) => {
  const [isPanning, setIsPanning] = useState(false)
  const [zoom, setZoom] = useState(1)
  const [pan, setPan] = useState({ x: 0, y: 0 })
  const [isDragging, setIsDragging] = useState(false)
  const [lastMousePos, setLastMousePos] = useState({ x: 0, y: 0 })
  const containerRef = useRef<HTMLDivElement>(null)
  const contentRef = useRef<HTMLDivElement>(null)

  const handlePanToggle = useCallback(() => {
    setIsPanning(!isPanning)
  }, [isPanning])

  const handleZoomIn = useCallback(() => {
    setZoom((prev) => Math.min(prev * 1.2, 3))
  }, [])

  const handleZoomOut = useCallback(() => {
    setZoom((prev) => Math.max(prev / 1.2, 0.1))
  }, [])

  const handleCenter = useCallback(() => {
    setZoom(1)
    setPan({ x: 0, y: 0 })
  }, [])

  const handleFullscreen = useCallback(() => {
    if (containerRef.current) {
      if (document.fullscreenElement) {
        document.exitFullscreen()
      } else {
        containerRef.current.requestFullscreen()
      }
    }
  }, [])

  const handleMouseDown = useCallback(
    (e: React.MouseEvent) => {
      if (isPanning) {
        setIsDragging(true)
        setLastMousePos({ x: e.clientX, y: e.clientY })
        e.preventDefault()
      }
    },
    [isPanning],
  )

  const handleMouseMove = useCallback(
    (e: React.MouseEvent) => {
      if (isDragging && isPanning) {
        const deltaX = e.clientX - lastMousePos.x
        const deltaY = e.clientY - lastMousePos.y
        setPan((prev) => ({
          x: prev.x + deltaX,
          y: prev.y + deltaY,
        }))
        setLastMousePos({ x: e.clientX, y: e.clientY })
      }
    },
    [isDragging, isPanning, lastMousePos],
  )

  const handleMouseUp = useCallback(() => {
    setIsDragging(false)
  }, [])

  const handleWheel = useCallback((e: React.WheelEvent) => {
    if (e.ctrlKey || e.metaKey) {
      e.preventDefault()
      const delta = e.deltaY > 0 ? 0.9 : 1.1
      setZoom((prev) => Math.min(Math.max(prev * delta, 0.1), 3))
    }
  }, [])

  return (
    <Box
      ref={containerRef}
      sx={{
        position: "relative",
        width: "100%",
        height: "100%",
        overflow: "hidden",
        cursor: isPanning ? (isDragging ? "grabbing" : "grab") : "default",
      }}
      onMouseDown={handleMouseDown}
      onMouseMove={handleMouseMove}
      onMouseUp={handleMouseUp}
      onMouseLeave={handleMouseUp}
      onWheel={handleWheel}
    >
      {/* Contenido del diagrama */}
      <Box
        ref={contentRef}
        sx={{
          width: "100%",
          height: "100%",
          transform: `translate(${pan.x}px, ${pan.y}px) scale(${zoom})`,
          transformOrigin: "center center",
          transition: isDragging ? "none" : "transform 0.1s ease-out",
        }}
      >
        {children}
      </Box>

      {/* Herramientas flotantes */}
      <Box
        sx={{
          position: "absolute",
          top: 16,
          right: 16,
          display: "flex",
          flexDirection: "column",
          gap: 1,
          zIndex: 1000,
        }}
      >
        <Zoom in={true}>
          <Tooltip title={isPanning ? "Desactivar paneo" : "Activar paneo"} placement="left">
            <Fab size="small" color={isPanning ? "primary" : "default"} onClick={handlePanToggle} sx={{ boxShadow: 2 }}>
              <PanToolIcon />
            </Fab>
          </Tooltip>
        </Zoom>

        <Zoom in={true} style={{ transitionDelay: "50ms" }}>
          <Tooltip title="Acercar" placement="left">
            <Fab size="small" onClick={handleZoomIn} sx={{ boxShadow: 2 }}>
              <ZoomInIcon />
            </Fab>
          </Tooltip>
        </Zoom>

        <Zoom in={true} style={{ transitionDelay: "100ms" }}>
          <Tooltip title="Alejar" placement="left">
            <Fab size="small" onClick={handleZoomOut} sx={{ boxShadow: 2 }}>
              <ZoomOutIcon />
            </Fab>
          </Tooltip>
        </Zoom>

        <Zoom in={true} style={{ transitionDelay: "150ms" }}>
          <Tooltip title="Centrar y resetear zoom" placement="left">
            <Fab size="small" onClick={handleCenter} sx={{ boxShadow: 2 }}>
              <CenterFocusIcon />
            </Fab>
          </Tooltip>
        </Zoom>

        <Zoom in={true} style={{ transitionDelay: "200ms" }}>
          <Tooltip title="Pantalla completa" placement="left">
            <Fab size="small" onClick={handleFullscreen} sx={{ boxShadow: 2 }}>
              <FullscreenIcon />
            </Fab>
          </Tooltip>
        </Zoom>

        {onRefresh && (
          <Zoom in={true} style={{ transitionDelay: "250ms" }}>
            <Tooltip title="Actualizar diagrama" placement="left">
              <Fab size="small" onClick={onRefresh} sx={{ boxShadow: 2 }}>
                <RefreshIcon />
              </Fab>
            </Tooltip>
          </Zoom>
        )}
      </Box>

      {/* Indicador de zoom */}
      <Box
        sx={{
          position: "absolute",
          bottom: 16,
          right: 16,
          backgroundColor: "rgba(0, 0, 0, 0.7)",
          color: "white",
          px: 1,
          py: 0.5,
          borderRadius: 1,
          fontSize: "0.75rem",
          zIndex: 1000,
        }}
      >
        {Math.round(zoom * 100)}%
      </Box>
    </Box>
  )
}

"use client"
import React, { useState, useRef, useCallback } from "react"
import { Box } from "@mui/material"

interface ResizablePanelsProps {
  leftPanel: React.ReactNode
  rightPanel: React.ReactNode
  initialLeftWidth?: number
  minLeftWidth?: number
  maxLeftWidth?: number
}

export const ResizablePanels: React.FC<ResizablePanelsProps> = ({
  leftPanel,
  rightPanel,
  initialLeftWidth = 50,
  minLeftWidth = 20,
  maxLeftWidth = 80,
}) => {
  const [leftWidth, setLeftWidth] = useState(initialLeftWidth)
  const [isDragging, setIsDragging] = useState(false)
  const containerRef = useRef<HTMLDivElement>(null)

  const handleMouseDown = useCallback((e: React.MouseEvent) => {
    e.preventDefault()
    setIsDragging(true)
  }, [])

  const handleMouseMove = useCallback(
    (e: MouseEvent) => {
      if (!isDragging || !containerRef.current) return

      const containerRect = containerRef.current.getBoundingClientRect()
      const newLeftWidth = ((e.clientX - containerRect.left) / containerRect.width) * 100

      const clampedWidth = Math.min(Math.max(newLeftWidth, minLeftWidth), maxLeftWidth)
      setLeftWidth(clampedWidth)
    },
    [isDragging, minLeftWidth, maxLeftWidth],
  )

  const handleMouseUp = useCallback(() => {
    setIsDragging(false)
  }, [])

  React.useEffect(() => {
    if (isDragging) {
      document.addEventListener("mousemove", handleMouseMove)
      document.addEventListener("mouseup", handleMouseUp)
      document.body.style.cursor = "col-resize"
      document.body.style.userSelect = "none"

      return () => {
        document.removeEventListener("mousemove", handleMouseMove)
        document.removeEventListener("mouseup", handleMouseUp)
        document.body.style.cursor = ""
        document.body.style.userSelect = ""
      }
    }
  }, [isDragging, handleMouseMove, handleMouseUp])

  return (
    <Box
      ref={containerRef}
      sx={{
        display: "flex",
        height: "100%",
        width: "100%",
        overflow: "hidden",
      }}
    >
      {/* Panel izquierdo */}
      <Box
        sx={{
          width: `${leftWidth}%`,
          height: "100%",
          overflow: "hidden",
          display: "flex",
          flexDirection: "column",
        }}
      >
        {leftPanel}
      </Box>

      {/* Divisor redimensionable */}
      <Box
        onMouseDown={handleMouseDown}
        sx={{
          width: "4px",
          height: "100%",
          backgroundColor: "divider",
          cursor: "col-resize",
          position: "relative",
          "&:hover": {
            backgroundColor: "primary.main",
          },
          "&::before": {
            content: '""',
            position: "absolute",
            left: "-2px",
            right: "-2px",
            top: 0,
            bottom: 0,
            zIndex: 1,
          },
        }}
      />

      {/* Panel derecho */}
      <Box
        sx={{
          width: `${100 - leftWidth}%`,
          height: "100%",
          overflow: "hidden",
          display: "flex",
          flexDirection: "column",
        }}
      >
        {rightPanel}
      </Box>
    </Box>
  )
}

"use client"

import React, { useState, useEffect } from "react";
import {
  Box,
  Card,
  CardContent,
  Typography,
  FormGroup,
  FormControlLabel,
  Checkbox,
  Button,
  CircularProgress,
  Alert,
  Chip,
  IconButton,
  Menu,
  MenuItem,
} from "@mui/material";
import { TreeView as MuiTreeView } from "@mui/x-tree-view/TreeView";
import { TreeItem } from "@mui/x-tree-view/TreeItem";
import {
  ExpandMore,
  ChevronRight,
  Folder,
  Storage,
  Code,
  Html,
  Assessment,
  Refresh,
  Save,
  MoreVert,
  ArrowUpward,
  ArrowDownward,
  SubdirectoryArrowLeft,
  SubdirectoryArrowRight,
} from "@mui/icons-material";
import type { TreeNode } from "../types";
import { nodesApi } from "../services/api";
import { useAppContext } from "../contexts/AppContext";

const nodeTypeIcons = {
  carpeta: <Folder />,
  bd: <Storage color="error" />,
  js: <Code color="warning" />,
  cs: <Code color="success" />,
  html: <Html color="primary" />,
  reporte: <Assessment color="secondary" />,
};

const nodeTypeColors = {
  carpeta: "#90caf9",
  bd: "#f44336",
  js: "#ff9800",
  cs: "#4caf50",
  html: "#2196f3",
  reporte: "#9c27b0",
};

export const TreeView: React.FC = () => {
  const { currentProject, selectedNode, setSelectedNode, treeData, setTreeData, refreshTree, showNotification } =
    useAppContext();

  const [activeFilters, setActiveFilters] = useState<Set<string>>(new Set());
  const [filteredNodes, setFilteredNodes] = useState<TreeNode[]>([]);
  const [loading, setLoading] = useState(false);
  const [contextMenu, setContextMenu] = useState<{
    node: TreeNode | null;
    mouseX: number;
    mouseY: number;
  } | null>(null);

  useEffect(() => {
    if (treeData) {
      applyFilters(treeData);
    }
  }, [treeData, activeFilters]);

  const applyFilters = (nodes: TreeNode[]) => {
    if (activeFilters.size === 0) {
      setFilteredNodes(nodes);
      return;
    }

    const filtered = nodes.filter((node) => {
      const isContainer = node.type === "default";
      if (isContainer) return true; // Siempre mostrar contenedores

      const nodeType = node.data?.tipo_nodo?.toLowerCase() || "";
      return activeFilters.has(nodeType);
    });

    setFilteredNodes(filtered);
  };

  const handleFilterChange = (filterType: string, checked: boolean) => {
    const newFilters = new Set(activeFilters);
    if (checked) {
      newFilters.add(filterType);
    } else {
      newFilters.delete(filterType);
    }
    setActiveFilters(newFilters);
  };

  const resetFilters = () => {
    setActiveFilters(new Set());
  };

  const saveTree = async () => {
    if (!currentProject || !treeData) {
      showNotification("No hay proyecto o datos para guardar", "error");
      return;
    }

    try {
      setLoading(true);
      await nodesApi.saveTree(currentProject.id, treeData);
      showNotification("Árbol guardado exitosamente", "success");
    } catch (error) {
      console.error("Error al guardar árbol:", error);
      showNotification("Error al guardar árbol", "error");
    } finally {
      setLoading(false);
    }
  };

  const handleRefresh = async () => {
    try {
      setLoading(true);
      await refreshTree();
      showNotification("Árbol actualizado", "success");
    } catch (error) {
      showNotification("Error al actualizar árbol", "error");
    } finally {
      setLoading(false);
    }
  };

  // Menú contextual
  const handleContextMenu = (event: React.MouseEvent, node: TreeNode) => {
    event.preventDefault();
    setContextMenu(
      contextMenu === null
        ? { node, mouseX: event.clientX - 2, mouseY: event.clientY - 4 }
        : null
    );
  };

  const handleCloseContextMenu = () => {
    setContextMenu(null);
  };

  // Función para mover un nodo arriba
  const moveNodeUp = (node: TreeNode) => {
    if (!treeData) return;

    // Encontrar el índice del nodo en su grupo de hermanos
    const siblings = treeData.filter(n => n.parent === node.parent);
    const currentIndex = siblings.findIndex(n => n.id === node.id);

    if (currentIndex <= 0) return; // Ya es el primero

    // Intercambiar con el hermano anterior
    const prevNode = siblings[currentIndex - 1];
    const newTreeData = [...treeData];
    const nodeIndex = newTreeData.findIndex(n => n.id === node.id);
    const prevNodeIndex = newTreeData.findIndex(n => n.id === prevNode.id);

    // Intercambiar los nodos en el array
    [newTreeData[nodeIndex], newTreeData[prevNodeIndex]] = [newTreeData[prevNodeIndex], newTreeData[nodeIndex]];

    setTreeData(newTreeData);
    showNotification(`Nodo "${node.text}" movido arriba`, "success");
    handleCloseContextMenu();
  };

  // Función para mover un nodo abajo
  const moveNodeDown = (node: TreeNode) => {
    if (!treeData) return;

    const siblings = treeData.filter(n => n.parent === node.parent);
    const currentIndex = siblings.findIndex(n => n.id === node.id);

    if (currentIndex >= siblings.length - 1) return; // Ya es el último

    // Intercambiar con el hermano siguiente
    const nextNode = siblings[currentIndex + 1];
    const newTreeData = [...treeData];
    const nodeIndex = newTreeData.findIndex(n => n.id === node.id);
    const nextNodeIndex = newTreeData.findIndex(n => n.id === nextNode.id);

    [newTreeData[nodeIndex], newTreeData[nextNodeIndex]] = [newTreeData[nextNodeIndex], newTreeData[nodeIndex]];

    setTreeData(newTreeData);
    showNotification(`Nodo "${node.text}" movido abajo`, "success");
    handleCloseContextMenu();
  };

  // Función para subir de nivel (mover al abuelo)
  const moveNodeToParentLevel = (node: TreeNode) => {
    if (!treeData || node.parent === "#") return; // Ya es raíz

    // Encontrar el padre
    const parent = treeData.find(n => n.id === node.parent);
    if (!parent) return;

    // Nuevo padre será el padre del padre
    const newParent = parent.parent;

    const newTreeData = treeData.map(n => {
      if (n.id === node.id) {
        return { ...n, parent: newParent };
      }
      return n;
    });

    setTreeData(newTreeData);
    showNotification(`Nodo "${node.text}" subido de nivel`, "success");
    handleCloseContextMenu();
  };

  // Función para bajar de nivel (hacerlo hijo del nodo anterior)
  const moveNodeToChildLevel = (node: TreeNode) => {
    if (!treeData) return;

    // Encontrar hermanos
    const siblings = treeData.filter(n => n.parent === node.parent);
    const currentIndex = siblings.findIndex(n => n.id === node.id);

    if (currentIndex === 0) return; // No hay hermano anterior

    const prevNode = siblings[currentIndex - 1];

    // Verificar que el hermano anterior es una carpeta
    if (prevNode.data?.tipo_nodo !== "carpeta") {
      showNotification("Solo puedes mover nodos dentro de carpetas", "error");
      return;
    }

    const newTreeData = treeData.map(n => {
      if (n.id === node.id) {
        return { ...n, parent: prevNode.id };
      }
      return n;
    });

    setTreeData(newTreeData);
    showNotification(`Nodo "${node.text}" movido dentro de "${prevNode.text}"`, "success");
    handleCloseContextMenu();
  };

  const renderTreeItems = (nodes: TreeNode[]) => {
    const rootNodes = nodes.filter((node) => node.parent === "#");
    if (rootNodes.length === 0) {
      return null;
    }
    return rootNodes.map((node) => renderTreeItem(node, nodes));
  };

  const renderTreeItem = (node: TreeNode, allNodes: TreeNode[]): React.ReactNode => {
    const children = allNodes.filter((n) => n.parent === node.id);
    const nodeType = node.data?.tipo_nodo || "carpeta";
    const icon = nodeTypeIcons[nodeType as keyof typeof nodeTypeIcons] || <Folder />;
    const isContainer = nodeType === "carpeta";

    return (
      <TreeItem
        key={node.id}
        nodeId={node.id}
        label={
          <Box
            sx={{
              display: "flex",
              alignItems: "center",
              py: 0.5,
              px: 1,
            }}
            onContextMenu={(e) => handleContextMenu(e, node)}
          >
            {icon}
            <Typography
              variant="body2"
              sx={{
                ml: 1,
                color: nodeTypeColors[nodeType as keyof typeof nodeTypeColors] || "#90caf9",
                fontWeight: isContainer ? "bold" : "normal",
              }}
            >
              {node.text}
            </Typography>
            {isContainer && children.length > 0 && (
              <Chip
                label={children.length}
                size="small"
                sx={{ ml: 1, height: 20, fontSize: "0.7rem" }}
                color="primary"
                variant="outlined"
              />
            )}
            <IconButton 
              size="small" 
              sx={{ ml: 'auto' }} 
              onClick={(e) => {
                e.stopPropagation();
                handleContextMenu(e, node);
              }}
            >
              <MoreVert fontSize="small" />
            </IconButton>
          </Box>
        }
      >
        {children.map((child) => renderTreeItem(child, allNodes))}
      </TreeItem>
    );
  };

  const handleNodeSelect = (event: React.SyntheticEvent, nodeId: string) => {
    const selectedNodeData = treeData?.find((node) => node.id === nodeId) || null;
    setSelectedNode(selectedNodeData);
  };

  if (!currentProject) {
    return (
      <Card>
        <CardContent>
          <Alert severity="warning">Selecciona un proyecto para ver el árbol</Alert>
        </CardContent>
      </Card>
    );
  }

  return (
    <Card>
      <CardContent>
        <Typography variant="h6" gutterBottom>
          Filtrar por tipo:
        </Typography>

        <FormGroup row sx={{ mb: 2 }}>
          <FormControlLabel
            control={
              <Checkbox
                checked={activeFilters.has("bd")}
                onChange={(e) => handleFilterChange("bd", e.target.checked)}
              />
            }
            label={<Typography color="error">BD</Typography>}
          />
          <FormControlLabel
            control={
              <Checkbox
                checked={activeFilters.has("js")}
                onChange={(e) => handleFilterChange("js", e.target.checked)}
              />
            }
            label={<Typography color="warning.main">JS</Typography>}
          />
          <FormControlLabel
            control={
              <Checkbox
                checked={activeFilters.has("cs")}
                onChange={(e) => handleFilterChange("cs", e.target.checked)}
              />
            }
            label={<Typography color="success.main">C#</Typography>}
          />
          <FormControlLabel
            control={
              <Checkbox
                checked={activeFilters.has("html")}
                onChange={(e) => handleFilterChange("html", e.target.checked)}
              />
            }
            label={<Typography color="primary">HTML</Typography>}
          />
          <FormControlLabel
            control={
              <Checkbox
                checked={activeFilters.has("reporte")}
                onChange={(e) => handleFilterChange("reporte", e.target.checked)}
              />
            }
            label={<Typography color="secondary">Reporte</Typography>}
          />
        </FormGroup>

        <Box sx={{ mb: 2, display: "flex", gap: 1 }}>
          <Button size="small" onClick={resetFilters}>
            Resetear
          </Button>
          <Button size="small" startIcon={<Refresh />} onClick={handleRefresh} disabled={loading}>
            Recargar
          </Button>
          <Button size="small" startIcon={<Save />} onClick={saveTree} color="success" disabled={loading}>
            Guardar
          </Button>
        </Box>

        <Typography variant="h6" gutterBottom>
          Mapeo
        </Typography>

        {loading && (
          <Box sx={{ display: "flex", justifyContent: "center", p: 2 }}>
            <CircularProgress size={24} />
          </Box>
        )}

        {!treeData || treeData.length === 0 ? (
          <Alert severity="info" sx={{ mt: 2 }}>
            No hay nodos en el árbol. Crea tu primer nodo usando el formulario de abajo.
            <br />
            <strong>Tip:</strong> Puedes crear múltiples nodos raíz para diferentes proyectos o áreas.
          </Alert>
        ) : (
          <Box sx={{ minHeight: 200 }}>
            <MuiTreeView
              defaultCollapseIcon={<ExpandMore />}
              defaultExpandIcon={<ChevronRight />}
              selected={selectedNode?.id || ""}
              onNodeSelect={handleNodeSelect}
              sx={{
                flexGrow: 1,
                maxWidth: 400,
                overflowY: "auto",
                "& .MuiTreeItem-content": {
                  padding: "2px 4px",
                  borderRadius: 1,
                  "&:hover": {
                    backgroundColor: "rgba(144, 202, 249, 0.08)",
                  },
                  "&.Mui-selected": {
                    backgroundColor: "rgba(144, 202, 249, 0.12)",
                    "&:hover": {
                      backgroundColor: "rgba(144, 202, 249, 0.16)",
                    },
                  },
                },
              }}
            >
              {renderTreeItems(filteredNodes)}
            </MuiTreeView>
          </Box>
        )}

        {/* Menú contextual */}
        <Menu
          open={contextMenu !== null}
          onClose={handleCloseContextMenu}
          anchorReference="anchorPosition"
          anchorPosition={
            contextMenu !== null
              ? { top: contextMenu.mouseY, left: contextMenu.mouseX }
              : undefined
          }
        >
          <MenuItem onClick={() => contextMenu?.node && moveNodeUp(contextMenu.node)}>
            <ArrowUpward fontSize="small" sx={{ mr: 1 }} /> Mover arriba
          </MenuItem>
          <MenuItem onClick={() => contextMenu?.node && moveNodeDown(contextMenu.node)}>
            <ArrowDownward fontSize="small" sx={{ mr: 1 }} /> Mover abajo
          </MenuItem>
          <MenuItem onClick={() => contextMenu?.node && moveNodeToParentLevel(contextMenu.node)}>
            <SubdirectoryArrowLeft fontSize="small" sx={{ mr: 1 }} /> Subir de nivel
          </MenuItem>
          <MenuItem onClick={() => contextMenu?.node && moveNodeToChildLevel(contextMenu.node)}>
            <SubdirectoryArrowRight fontSize="small" sx={{ mr: 1 }} /> Bajar de nivel
          </MenuItem>
        </Menu>
      </CardContent>
    </Card>
  );
};
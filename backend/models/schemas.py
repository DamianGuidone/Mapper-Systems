from dataclasses import dataclass
from typing import Optional, List, Dict, Any
from datetime import datetime

@dataclass
class NodeData:
    descripcion: str
    tipo_nodo: str
    archivo: Optional[str] = None
    ultima_modificacion: Optional[str] = None
    ultima_revision: Optional[str] = None
    historial_file: Optional[str] = None

@dataclass
class TreeNode:
    id: str
    text: str
    icon: str
    type: str
    parent: str
    data: NodeData
    state: Dict[str, Any]

@dataclass
class Registro:  # Cambiado de Record a Registro
    id: Optional[int]
    archivo: str
    ubicacion: Optional[str]
    funcion: Optional[str]
    descripcion: Optional[str]
    orden: int
    nodo_id: str
    proyecto_id: Optional[int]

@dataclass
class HistoryEntry:
    fecha: str
    campo: str
    anterior: str
    nuevo: str
    usuario: str

@dataclass
class CodeSnippet:
    id: Optional[int]
    nodo_id: str
    proyecto_id: int
    titulo: str
    descripcion: Optional[str]
    lenguaje: str
    codigo: str
    archivo_ruta: Optional[str]
    orden: int
    fecha_creacion: Optional[str]
    fecha_modificacion: Optional[str]

@dataclass
class DiagramaMermaid:  # Nuevo modelo en español
    id: Optional[int]
    nodo_id: str
    proyecto_id: int
    titulo: str
    descripcion: Optional[str]
    tipo_diagrama: str
    codigo_mermaid: str
    archivo_ruta: Optional[str]
    orden: int
    fecha_creacion: Optional[str]
    fecha_modificacion: Optional[str]

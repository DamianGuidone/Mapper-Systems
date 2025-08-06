import os
import json
import urllib.parse
import re
from datetime import datetime
from models.database import get_db_connection

def clean_sql_path(path: str) -> str:
    """Limpia la ruta y convierte / → \ """
    if not path:
        return "Archive"
    
    # Decodificar URL encoding (%20 → espacio, etc.)
    decoded_path = urllib.parse.unquote(path)
    # Solo permitimos caracteres válidos en rutas
    cleaned = re.sub(r'[<>|?*\"]', '', decoded_path)
    cleaned = cleaned.replace('/', '\\').strip()
    return cleaned

def add_node_history_entry(node_id: str, project_id: int, campo: str, anterior: str, nuevo: str, usuario: str = "Sistema"):
    """Agrega una entrada al historial de un nodo en la base de datos"""
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        
        cursor.execute("""
            INSERT INTO historial_nodos 
            (nodo_id, proyecto_id, fecha, campo, anterior, nuevo, usuario)
            VALUES (?, ?, ?, ?, ?, ?, ?)
        """, (node_id, project_id, datetime.now().isoformat(), campo, anterior, nuevo, usuario))
        
        conn.commit()
        conn.close()
    except Exception as e:
        print(f"Error adding node history entry: {str(e)}")

def create_project_structure(project_name: str, project_id: int):
    """Crea la estructura de directorios para un proyecto"""
    base_path = f"projects/{project_name}"
    
    directories = [
        base_path,
        f"{base_path}/snippets",
        f"{base_path}/exports",
        f"{base_path}/docs",
        f"{base_path}/assets"
    ]
    
    for directory in directories:
        os.makedirs(directory, exist_ok=True)
    
    # Crear archivo README del proyecto
    readme_content = f"""# {project_name}

Proyecto de documentación creado el {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}

## Estructura
- `/snippets` - Fragmentos de código guardados
- `/exports` - Exportaciones del proyecto
- `/docs` - Documentación adicional
- `/assets` - Recursos y archivos adjuntos

## ID del Proyecto: {project_id}
"""
    
    with open(f"{base_path}/README.md", 'w', encoding='utf-8') as f:
        f.write(readme_content)
    
    print(f"✅ Estructura de proyecto creada: {base_path}")

#!/usr/bin/env python3
"""
Script para crear backups de la base de datos
Exporta toda la información a JSON para respaldo
"""

import os
import sys
import json
import sqlite3
from datetime import datetime

# Agregar el directorio padre al path
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from models.database import get_db_connection

def backup_database():
    """Crea un backup completo de la base de datos en formato JSON"""
    print("💾 Creando backup de la base de datos...")
    
    conn = get_db_connection()
    cursor = conn.cursor()
    
    backup_data = {
        "backup_date": datetime.now().isoformat(),
        "version": "1.0",
        "projects": [],
        "nodes": [],
        "records": [],
        "snippets": [],
        "diagrams": []
    }
    
    # Backup de proyectos
    cursor.execute("SELECT * FROM proyectos WHERE activo = 1")
    projects = cursor.fetchall()
    for project in projects:
        backup_data["projects"].append(dict(project))
    
    # Backup de nodos
    cursor.execute("SELECT * FROM arbol_nodos ORDER BY proyecto_id, orden")
    nodes = cursor.fetchall()
    for node in nodes:
        node_dict = dict(node)
        node_dict["data"] = json.loads(node_dict["data"])  # Parsear JSON
        backup_data["nodes"].append(node_dict)
    
    # Backup de registros
    cursor.execute("SELECT * FROM registros ORDER BY proyecto_id, nodo_id, orden")
    records = cursor.fetchall()
    for record in records:
        backup_data["records"].append(dict(record))
    
    # Backup de snippets
    cursor.execute("SELECT * FROM code_snippets ORDER BY proyecto_id, nodo_id, orden")
    snippets = cursor.fetchall()
    for snippet in snippets:
        backup_data["snippets"].append(dict(snippet))
    
    # Backup de diagramas
    cursor.execute("SELECT * FROM mermaid_diagrams ORDER BY proyecto_id, nodo_id, orden")
    diagrams = cursor.fetchall()
    for diagram in diagrams:
        backup_data["diagrams"].append(dict(diagram))
    
    conn.close()
    
    # Crear archivo de backup
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    backup_filename = f"backup_database_{timestamp}.json"
    backup_path = os.path.join("backups", backup_filename)
    
    # Crear directorio de backups
    os.makedirs("backups", exist_ok=True)
    
    # Guardar backup
    with open(backup_path, 'w', encoding='utf-8') as f:
        json.dump(backup_data, f, indent=2, ensure_ascii=False)
    
    print(f"✅ Backup creado: {backup_path}")
    print(f"   📊 {len(backup_data['projects'])} proyectos")
    print(f"   🌳 {len(backup_data['nodes'])} nodos")
    print(f"   📝 {len(backup_data['records'])} registros")
    print(f"   💾 {len(backup_data['snippets'])} snippets")
    print(f"   📊 {len(backup_data['diagrams'])} diagramas")
    
    return backup_path

if __name__ == "__main__":
    backup_database()

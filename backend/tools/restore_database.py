#!/usr/bin/env python3
"""
Script para restaurar la base de datos desde un backup JSON
"""

import os
import sys
import json
import sqlite3
from datetime import datetime

# Agregar el directorio padre al path
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from models.database import get_db_connection, init_db

def restore_database(backup_file):
    """Restaura la base de datos desde un archivo de backup"""
    if not os.path.exists(backup_file):
        print(f"❌ Archivo de backup no encontrado: {backup_file}")
        return False
    
    print(f"🔄 Restaurando base de datos desde: {backup_file}")
    
    # Leer backup
    with open(backup_file, 'r', encoding='utf-8') as f:
        backup_data = json.load(f)
    
    # Reinicializar base de datos
    init_db()
    
    conn = get_db_connection()
    cursor = conn.cursor()
    
    try:
        # Restaurar proyectos
        for project in backup_data.get("projects", []):
            cursor.execute("""
                INSERT OR REPLACE INTO proyectos 
                (id, nombre, descripcion, ruta_base, fecha_creacion, fecha_modificacion, activo, configuracion)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?)
            """, (
                project["id"], project["nombre"], project["descripcion"], project["ruta_base"],
                project["fecha_creacion"], project["fecha_modificacion"], 
                project.get("activo", 1), project.get("configuracion", "{}")
            ))
        
        # Restaurar nodos
        for node in backup_data.get("nodes", []):
            cursor.execute("""
                INSERT OR REPLACE INTO arbol_nodos 
                (id, proyecto_id, text, type, parent, data, orden, fecha_creacion, fecha_modificacion)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
            """, (
                node["id"], node["proyecto_id"], node["text"], node["type"],
                node["parent"], json.dumps(node["data"]), node["orden"],
                node["fecha_creacion"], node.get("fecha_modificacion")
            ))
        
        # Restaurar registros
        for record in backup_data.get("records", []):
            cursor.execute("""
                INSERT OR REPLACE INTO registros 
                (id, nodo_id, proyecto_id, archivo, ubicacion, funcion, descripcion, orden, fecha_creacion, fecha_modificacion)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            """, (
                record.get("id"), record["nodo_id"], record["proyecto_id"], record["archivo"],
                record.get("ubicacion"), record.get("funcion"), record.get("descripcion"),
                record["orden"], record["fecha_creacion"], record.get("fecha_modificacion")
            ))
        
        # Restaurar snippets
        for snippet in backup_data.get("snippets", []):
            cursor.execute("""
                INSERT OR REPLACE INTO code_snippets 
                (id, nodo_id, proyecto_id, titulo, descripcion, lenguaje, codigo, archivo_ruta, orden, fecha_creacion, fecha_modificacion)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            """, (
                snippet.get("id"), snippet["nodo_id"], snippet["proyecto_id"], snippet["titulo"],
                snippet.get("descripcion"), snippet["lenguaje"], snippet["codigo"],
                snippet.get("archivo_ruta"), snippet["orden"], snippet["fecha_creacion"],
                snippet.get("fecha_modificacion")
            ))
        
        # Restaurar diagramas
        for diagram in backup_data.get("diagrams", []):
            cursor.execute("""
                INSERT OR REPLACE INTO mermaid_diagrams 
                (id, nodo_id, proyecto_id, titulo, descripcion, tipo_diagrama, codigo_mermaid, archivo_ruta, orden, fecha_creacion, fecha_modificacion)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            """, (
                diagram.get("id"), diagram["nodo_id"], diagram["proyecto_id"], diagram["titulo"],
                diagram.get("descripcion"), diagram["tipo_diagrama"], diagram["codigo_mermaid"],
                diagram.get("archivo_ruta"), diagram["orden"], diagram["fecha_creacion"],
                diagram.get("fecha_modificacion")
            ))
        
        conn.commit()
        
        print("✅ Restauración completada exitosamente!")
        print(f"   📊 {len(backup_data.get('projects', []))} proyectos")
        print(f"   🌳 {len(backup_data.get('nodes', []))} nodos")
        print(f"   📝 {len(backup_data.get('records', []))} registros")
        print(f"   💾 {len(backup_data.get('snippets', []))} snippets")
        print(f"   📊 {len(backup_data.get('diagrams', []))} diagramas")
        
        return True
        
    except Exception as e:
        print(f"❌ Error durante la restauración: {e}")
        conn.rollback()
        return False
    finally:
        conn.close()

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Uso: python restore_database.py <archivo_backup.json>")
        print("\nBackups disponibles:")
        if os.path.exists("backups"):
            backups = [f for f in os.listdir("backups") if f.endswith('.json')]
            for backup in sorted(backups, reverse=True):
                print(f"  - backups/{backup}")
        else:
            print("  No hay backups disponibles")
        sys.exit(1)
    
    backup_file = sys.argv[1]
    restore_database(backup_file)

#!/usr/bin/env python3
"""
Script para migrar datos desde data.json a la base de datos SQLite
Convierte el formato JSON legacy al nuevo sistema de BD
"""

import os
import sys
import json
import sqlite3
from datetime import datetime

# Agregar el directorio padre al path
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from models.database import get_db_connection, init_db

def migrate_from_json():
    """Migra datos desde data.json a la base de datos"""
    json_path = "data.json"
    
    if not os.path.exists(json_path):
        print(f"❌ No se encontró {json_path}")
        return False
    
    print("📦 Iniciando migración desde JSON...")
    
    # Leer datos JSON
    with open(json_path, 'r', encoding='utf-8') as f:
        json_data = json.load(f)
    
    print(f"   📄 Datos JSON cargados: {len(json_data)} nodos")
    
    # Inicializar BD si no existe
    init_db()
    
    conn = get_db_connection()
    cursor = conn.cursor()
    
    # Crear proyecto por defecto para migración
    now = datetime.now().isoformat()
    cursor.execute("""
        INSERT OR IGNORE INTO proyectos (id, nombre, descripcion, ruta_base, fecha_creacion, fecha_modificacion)
        VALUES (1, 'Proyecto Migrado', 'Datos migrados desde data.json', 'projects/migrado', ?, ?)
    """, (now, now))
    
    project_id = 1
    migrated_nodes = 0
    
    # Migrar nodos
    for node in json_data:
        try:
            cursor.execute("""
                INSERT OR REPLACE INTO arbol_nodos 
                (id, proyecto_id, text, type, parent, data, orden, fecha_creacion, fecha_modificacion)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
            """, (
                node["id"], project_id, node["text"], node["type"], 
                node["parent"], json.dumps(node["data"]), 
                migrated_nodes, now, now
            ))
            migrated_nodes += 1
        except Exception as e:
            print(f"   ⚠️  Error migrando nodo {node.get('id', 'unknown')}: {e}")
    
    conn.commit()
    conn.close()
    
    print(f"   ✅ Migrados {migrated_nodes} nodos al proyecto ID {project_id}")
    
    # Crear backup del JSON
    backup_path = f"data_backup_{datetime.now().strftime('%Y%m%d_%H%M%S')}.json"
    os.rename(json_path, backup_path)
    print(f"   📦 JSON respaldado como: {backup_path}")
    
    print("✅ Migración completada exitosamente!")
    return True

if __name__ == "__main__":
    migrate_from_json()

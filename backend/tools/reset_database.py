#!/usr/bin/env python3
"""
Script para resetear completamente la base de datos
Elimina la BD existente y la recrea con estructura limpia
"""

import os
import sys
import sqlite3
from datetime import datetime

# Agregar el directorio padre al path para importar módulos
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from models.database import init_db, DB_PATH

def reset_database():
    """Elimina y recrea la base de datos completamente"""
    print("🗑️  Reseteando base de datos...")
    
    # Eliminar base de datos existente
    if os.path.exists(DB_PATH):
        os.remove(DB_PATH)
        print(f"   ✅ Base de datos eliminada: {DB_PATH}")
    
    # Crear directorio si no existe
    os.makedirs(os.path.dirname(DB_PATH), exist_ok=True)
    
    # Recrear base de datos
    init_db()
    print("   ✅ Base de datos recreada con estructura actualizada")
    
    # Verificar tablas creadas
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()
    cursor.execute("SELECT name FROM sqlite_master WHERE type='table';")
    tables = cursor.fetchall()
    conn.close()
    
    print(f"   📊 Tablas creadas: {len(tables)}")
    for table in tables:
        print(f"      - {table[0]}")
    
    print("✅ Reset completado exitosamente!")

if __name__ == "__main__":
    confirm = input("⚠️  ¿Estás seguro de que quieres resetear la base de datos? (y/N): ")
    if confirm.lower() in ['y', 'yes', 'sí', 's']:
        reset_database()
    else:
        print("❌ Operación cancelada")

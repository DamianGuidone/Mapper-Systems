#!/usr/bin/env python3
"""
Script para verificar el estado del sistema
Diagnóstica problemas comunes y muestra estadísticas
"""

import os
import sys
import sqlite3
from datetime import datetime

# Agregar el directorio padre al path
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from models.database import get_db_connection, DB_PATH

def check_system():
    """Verifica el estado completo del sistema"""
    print("🔍 Verificando estado del sistema...")
    print("=" * 50)
    
    # Verificar archivos y directorios
    print("📁 ARCHIVOS Y DIRECTORIOS:")
    checks = [
        ("Base de datos", DB_PATH),
        ("Directorio projects", "projects"),
        ("Directorio Archive", "Archive"),
        ("Directorio backups", "backups"),
        ("App Flask", "backend/app.py"),
        ("Frontend", "frontend/src/App.tsx")
    ]
    
    for name, path in checks:
        status = "✅" if os.path.exists(path) else "❌"
        print(f"   {status} {name}: {path}")
    
    print()
    
    # Verificar base de datos
    if os.path.exists(DB_PATH):
        print("🗄️ BASE DE DATOS:")
        try:
            conn = get_db_connection()
            cursor = conn.cursor()
            
            # Verificar tablas
            cursor.execute("SELECT name FROM sqlite_master WHERE type='table';")
            tables = cursor.fetchall()
            print(f"   📊 Tablas: {len(tables)}")
            
            expected_tables = [
                "proyectos", "arbol_nodos", "registros", 
                "code_snippets", "mermaid_diagrams", 
                "historial_registro", "historial_nodos"
            ]
            
            existing_tables = [table[0] for table in tables]
            for table in expected_tables:
                status = "✅" if table in existing_tables else "❌"
                print(f"      {status} {table}")
            
            # Estadísticas
            print("\n   📈 ESTADÍSTICAS:")
            
            cursor.execute("SELECT COUNT(*) FROM proyectos WHERE activo = 1")
            projects_count = cursor.fetchone()[0]
            print(f"      📁 Proyectos activos: {projects_count}")
            
            if projects_count > 0:
                cursor.execute("SELECT COUNT(*) FROM arbol_nodos")
                nodes_count = cursor.fetchone()[0]
                print(f"      🌳 Nodos totales: {nodes_count}")
                
                cursor.execute("SELECT COUNT(*) FROM registros")
                records_count = cursor.fetchone()[0]
                print(f"      📝 Registros: {records_count}")
                
                cursor.execute("SELECT COUNT(*) FROM code_snippets")
                snippets_count = cursor.fetchone()[0]
                print(f"      💾 Snippets: {snippets_count}")
                
                cursor.execute("SELECT COUNT(*) FROM mermaid_diagrams")
                diagrams_count = cursor.fetchone()[0]
                print(f"      📊 Diagramas: {diagrams_count}")
                
                # Proyectos más activos
                print("\n   🏆 PROYECTOS MÁS ACTIVOS:")
                cursor.execute("""
                    SELECT p.nombre, COUNT(n.id) as nodos
                    FROM proyectos p
                    LEFT JOIN arbol_nodos n ON p.id = n.proyecto_id
                    WHERE p.activo = 1
                    GROUP BY p.id, p.nombre
                    ORDER BY nodos DESC
                    LIMIT 3
                """)
                top_projects = cursor.fetchall()
                
                for i, (name, node_count) in enumerate(top_projects, 1):
                    print(f"      {i}. {name}: {node_count} nodos")
            
            conn.close()
            
        except Exception as e:
            print(f"   ❌ Error accediendo a la BD: {e}")
    
    print()
    
    # Verificar archivos JSON legacy
    print("📄 ARCHIVOS LEGACY:")
    json_files = ["data.json"]
    for json_file in json_files:
        if os.path.exists(json_file):
            print(f"   ⚠️  {json_file} encontrado (considera migrar)")
        else:
            print(f"   ✅ {json_file} no existe (migración completa)")
    
    print()
    
    # Recomendaciones
    print("💡 RECOMENDACIONES:")
    
    if not os.path.exists(DB_PATH):
        print("   🔧 Ejecutar: python tools/reset_database.py")
    
    if os.path.exists(DB_PATH):
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT COUNT(*) FROM proyectos WHERE activo = 1")
        if cursor.fetchone()[0] == 0:
            print("   🌱 Ejecutar: python tools/seed_sample_data.py")
        conn.close()
    
    if os.path.exists("data.json"):
        print("   📦 Ejecutar: python tools/migrate_from_json.py")
    
    if not os.path.exists("backups"):
        print("   💾 Crear backup: python tools/backup_database.py")
    
    print("\n✅ Verificación completada!")

if __name__ == "__main__":
    check_system()

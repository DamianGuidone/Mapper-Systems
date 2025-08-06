import sqlite3
import os

DB_PATH = "db/sp.db"

def get_db_connection():
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    return conn

def init_db():
    """Inicializa la base de datos con las tablas necesarias"""
    conn = get_db_connection()
    cursor = conn.cursor()
    
    # Tabla de proyectos
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS proyectos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre TEXT NOT NULL UNIQUE,
            descripcion TEXT,
            ruta_base TEXT,
            fecha_creacion TEXT NOT NULL,
            fecha_modificacion TEXT,
            activo BOOLEAN DEFAULT 1,
            configuracion TEXT DEFAULT '{}'
        )
    """)
    
    # Tabla para guardar estructura del árbol por proyecto
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS arbol_nodos (
            id TEXT PRIMARY KEY,
            proyecto_id INTEGER NOT NULL,
            text TEXT NOT NULL,
            type TEXT NOT NULL,
            parent TEXT NOT NULL,
            data TEXT NOT NULL,
            orden INTEGER DEFAULT 0,
            fecha_creacion TEXT NOT NULL,
            fecha_modificacion TEXT,
            FOREIGN KEY(proyecto_id) REFERENCES proyectos(id) ON DELETE CASCADE
        )
    """)
    
    # Tabla principal: registros por nodo
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS registros (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nodo_id TEXT NOT NULL,
            proyecto_id INTEGER NOT NULL,
            archivo TEXT NOT NULL,
            ubicacion TEXT,
            funcion TEXT,
            descripcion TEXT,
            orden INTEGER DEFAULT 0,
            fecha_creacion TEXT NOT NULL,
            fecha_modificacion TEXT,
            FOREIGN KEY(nodo_id) REFERENCES arbol_nodos(id) ON DELETE CASCADE,
            FOREIGN KEY(proyecto_id) REFERENCES proyectos(id) ON DELETE CASCADE
        )
    """)
    
    # Tabla de snippets de código
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS code_snippets (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nodo_id TEXT NOT NULL,
            proyecto_id INTEGER NOT NULL,
            titulo TEXT NOT NULL,
            descripcion TEXT,
            lenguaje TEXT NOT NULL,
            codigo TEXT NOT NULL,
            archivo_ruta TEXT,
            orden INTEGER DEFAULT 0,
            fecha_creacion TEXT NOT NULL,
            fecha_modificacion TEXT,
            FOREIGN KEY(nodo_id) REFERENCES arbol_nodos(id) ON DELETE CASCADE,
            FOREIGN KEY(proyecto_id) REFERENCES proyectos(id) ON DELETE CASCADE
        )
    """)
    
    # Tabla de diagramas Mermaid
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS mermaid_diagrams (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nodo_id TEXT NOT NULL,
            proyecto_id INTEGER NOT NULL,
            titulo TEXT NOT NULL,
            descripcion TEXT,
            tipo_diagrama TEXT NOT NULL,
            codigo_mermaid TEXT NOT NULL,
            archivo_ruta TEXT,
            orden INTEGER DEFAULT 0,
            fecha_creacion TEXT NOT NULL,
            fecha_modificacion TEXT,
            FOREIGN KEY(nodo_id) REFERENCES arbol_nodos(id) ON DELETE CASCADE,
            FOREIGN KEY(proyecto_id) REFERENCES proyectos(id) ON DELETE CASCADE
        )
    """)
    
    # Tabla de historial_registro
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS historial_registro (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            registro_id INTEGER NOT NULL,
            proyecto_id INTEGER NOT NULL,
            fecha TEXT NOT NULL,
            campo TEXT NOT NULL,
            anterior TEXT,
            nuevo TEXT,
            usuario VARCHAR(50),
            FOREIGN KEY(registro_id) REFERENCES registros(id) ON DELETE CASCADE,
            FOREIGN KEY(proyecto_id) REFERENCES proyectos(id) ON DELETE CASCADE
        )
    """)
    
    # Tabla de historial de nodos
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS historial_nodos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nodo_id TEXT NOT NULL,
            proyecto_id INTEGER NOT NULL,
            fecha TEXT NOT NULL,
            campo TEXT NOT NULL,
            anterior TEXT,
            nuevo TEXT,
            usuario VARCHAR(50),
            FOREIGN KEY(nodo_id) REFERENCES arbol_nodos(id) ON DELETE CASCADE,
            FOREIGN KEY(proyecto_id) REFERENCES proyectos(id) ON DELETE CASCADE
        )
    """)
    
    conn.commit()
    conn.close()
    print("✅ Base de datos inicializada correctamente")

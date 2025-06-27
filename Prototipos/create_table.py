import sqlite3

def init_db():
    conn = sqlite3.connect("db/sp.db")
    cursor = conn.cursor()

    # Tabla para guardar estructura del árbol
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS arbol_nodos (
            id TEXT PRIMARY KEY,
            text TEXT,
            type TEXT,
            parent TEXT,
            data TEXT
        )
    """)
    conn.commit()    
    
    # Tabla principal: registros
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS registros (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            archivo TEXT NOT NULL,
            ubicacion TEXT,
            funcion TEXT,
            descripcion TEXT,
            orden INTEGER DEFAULT 0,
            nodo_id TEXT NOT NULL
        )
    """)
    conn.commit()

    # Tabla de historial_registro
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS historial_registro (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            registro_id INTEGER NOT NULL,
            fecha TEXT NOT NULL,
            campo TEXT NOT NULL,
            anterior TEXT,
            nuevo TEXT,
            usuario VARCHAR(50),
            FOREIGN KEY(registro_id) REFERENCES registros(id)
        )
    """)

    conn.commit()
    conn.close()

if __name__ == "__main__":
    try:
        init_db()
        print("Base de datos inicializada correctamente.")
    except Exception as e:
        print(f"Ocurrió un error: {e}")
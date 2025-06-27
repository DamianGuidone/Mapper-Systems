import datetime
import json
import sqlite3
from flask import Flask, request, jsonify, send_from_directory
import os
import urllib.parse
import re

app = Flask(__name__)

ARCHIVE_DIR = "Archive"
HISTORY_DIR = "history"
DB_PATH = "db/sp.db"

def clean_sql_path(path: str) -> str:
    """ Limpia la ruta y convierte / → \ """
    if not path:
        return ""

    decoded_path = urllib.parse.unquote(path)
    cleaned = re.sub(r'[<>:"|?*]', '', decoded_path).strip()
    cleaned = cleaned.replace('/', '\\')
    return cleaned

@app.route('/api/read-sql', methods=['GET'])
def read_sql():
    path_encoded = request.args.get("path")
    if not path_encoded:
        return jsonify({"error": "Ruta no especificada"}), 400

    path = clean_sql_path(path_encoded)
    full_path = os.path.normpath(os.path.join(ARCHIVE_DIR, path))

    # Validar que el archivo esté dentro de Archive
    if not full_path.startswith(ARCHIVE_DIR):
        return jsonify({"error": "Acceso denegado"}), 403

    if not os.path.isfile(full_path):
        return jsonify({"error": "Archivo no encontrado"}), 404

    try:
        with open(full_path, 'r', encoding='utf-8') as f:
            content = f.read()
        return content, 200, {'Content-Type': 'text/plain; charset=utf-8'}
    except Exception as e:
        print(f"[ERROR] No se pudo leer {full_path}: {e}")
        return jsonify({"error": "No se pudo leer el archivo"}), 500

@app.route('/api/registros', methods=['GET'])
def get_registros():
    nodo_id = request.args.get("nodo_id")
    if not nodo_id:
        return jsonify({"error": "nodo_id no especificado"}), 400

    try:
        conn = sqlite3.connect(DB_PATH)
        cursor = conn.cursor()
        cursor.execute("SELECT id, archivo, ubicacion, funcion, descripcion, orden FROM registros WHERE nodo_id = ? ORDER BY orden ASC", (nodo_id,))
        rows = cursor.fetchall()
        conn.close()

        registros = [
            {
                "id": r[0],
                "archivo": r[1],
                "ubicacion": r[2],
                "funcion": r[3],
                "descripcion": r[4],
                "orden": r[5],
                "nodo_id": nodo_id
            } for r in rows
        ]

        return jsonify(registros)

    except Exception as e:
        print(f"[ERROR] Al obtener registros: {e}")
        return jsonify({"error": "Error al cargar registros"}), 500

# Sirve archivos estáticos desde /history/
@app.route('/history/<path:filename>')
def serve_history(filename):
    return send_from_directory(HISTORY_DIR, filename)

@app.route('/api/registro', methods=['POST'])
def save_registro():
    entry = request.get_json()
    if not entry:
        return jsonify({"error": "Datos inválidos"}), 400

    try:
        conn = sqlite3.connect(DB_PATH)
        cursor = conn.cursor()

        # Si hay ID → es una actualización
        if 'id' in entry and entry['id']:
            cursor.execute(
                "UPDATE registros SET archivo = ?, ubicacion = ?, funcion = ?, descripcion = ?, orden = ? WHERE id = ?",
                (entry["archivo"], entry["ubicacion"], entry["funcion"], entry["descripcion"], entry["orden"], entry["id"])
            )
            conn.commit()

            # Registrar cambios individuales en historial_registro
            original = dict(cursor.execute("SELECT * FROM registros WHERE id = ?", (entry["id"],)).fetchone())

            for field in ["archivo", "ubicacion", "funcion", "descripcion", "orden"]:
                if original[field] != entry[field]:
                    cursor.execute("""
                        INSERT INTO historial_registro (registro_id, fecha, campo, anterior, nuevo, usuario)
                        VALUES (?, ?, ?, ?, ?, ?)
                    """, (
                        entry["id"],
                        datetime.datetime.now().isoformat(),
                        field,
                        str(original[field]),
                        str(entry[field]),
                        entry.get("usuario", "Anónimo")
                    ))
        else:
            # Nuevo registro
            cursor.execute("""
                INSERT INTO registros (archivo, ubicacion, funcion, descripcion, orden, nodo_id)
                VALUES (?, ?, ?, ?, ?, ?)
            """, (
                entry["archivo"],
                entry["ubicacion"],
                entry["funcion"],
                entry["descripcion"],
                entry["orden"],
                entry["nodo_id"]
            ))
            conn.commit()

            registro_id = cursor.lastrowid

            cursor.execute("""
                INSERT INTO historial_registro (registro_id, fecha, campo, anterior, nuevo, usuario)
                VALUES (?, ?, ?, ?, ?, ?)
            """, (
                registro_id,
                datetime.datetime.now().isoformat(),
                "nuevo_registro",
                "",
                f"Archivo: {entry['archivo']}, Función: {entry['funcion']}",
                entry.get("usuario", "Anónimo")
            ))

        conn.commit()
        conn.close()

        return jsonify({"success": True})

    except Exception as e:
        print(f"[ERROR] Al guardar registro: {e}")
        return jsonify({"error": "No se pudo guardar el registro", "details": str(e)}), 500

@app.route('/api/user', methods=['GET'])
def get_user():
    import getpass
    user = getpass.getuser()
    return jsonify({"usuario": user})

@app.route('/api/nodos', methods=['GET'])
def get_nodos():
    try:
        # Simplemente devolver una estructura básica para empezar
        nodos = [
            {
                "id": "node_abc123",
                "text": "Nodo BD",
                "type": "bd",
                "data": {
                    "descripcion": "Ejemplo de nodo BD",
                    "archivo": "clientes\\alta_cliente.sql",
                    "historial_file": "history\\node_abc123.json"
                }
            },
            {
                "id": "node_xyz789",
                "text": "Nodo JS",
                "type": "js",
                "data": {
                    "descripcion": "Funciones JavaScript",
                    "archivo": "login.js"
                }
            }
        ]
        return jsonify(nodos)

    except Exception as e:
        print(f"[ERROR] Al obtener nodos: {e}")
        return jsonify({"error": "No se pudieron cargar los nodos"}), 500

@app.route('/api/save-tree', methods=['POST'])
def save_tree():
    try:
        tree_data = request.get_json()
        if not tree_data or not isinstance(tree_data, list):
            return jsonify({"error": "Datos inválidos", "details": "Se esperaba un array de nodos"}), 400

        conn = sqlite3.connect(DB_PATH)
        cursor = conn.cursor()

        # Limpiar tabla temporalmente
        cursor.execute("DELETE FROM arbol_nodos")
        conn.commit()

        # Crear tabla si no existe (opcional)
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS arbol_nodos (
                id TEXT PRIMARY KEY,
                text TEXT,
                type TEXT,
                parent TEXT,
                data TEXT
            )
        """)

        # Insertar nodos recursivamente
        def insert_node(node, parent_id="#"):
            node_id = node.get("id", "")
            text = node.get("text", "")
            node_type = node.get("type", "default")
            node_data = json.dumps(node.get("data", {}))

            cursor.execute("""
                INSERT INTO arbol_nodos (id, text, type, parent, data)
                VALUES (?, ?, ?, ?, ?)
            """, (node_id, text, node_type, parent_id, node_data))

            children = node.get("children", [])
            for child in children:
                insert_node(child, parent_id=node_id)

        for node in tree_data:
            insert_node(node)

        conn.commit()
        conn.close()

        return jsonify({"success": True, "total_nodes": len(tree_data)}), 200

    except Exception as e:
        print(f"[ERROR] Al guardar árbol: {e}")
        return jsonify({"error": "No se pudo guardar el árbol", "details": str(e)}), 500

@app.route('/api/nodos', methods=['GET'])
def get_tree():
    try:
        conn = sqlite3.connect(DB_PATH)
        cursor = conn.cursor()
        cursor.execute("SELECT id, text, type, parent, data FROM arbol_nodos ORDER BY parent ASC")
        rows = cursor.fetchall()
        conn.close()

        nodes = []
        node_map = {}

        # Primero mapear todos los nodos
        for r in rows:
            node = {
                "id": r[0],
                "text": r[1],
                "type": r[2],
                "parent": r[3],
                "data": json.loads(r[4]) if r[4] else {}
            }
            node_map[node["id"]] = node

        # Luego reconstruir la estructura anidada
        for r in rows:
            node = node_map[r[0]]
            parent = r[3]

            if parent == "#":
                nodes.append(node)
            else:
                if parent not in node_map:
                    continue  # Saltar nodos huérfanos

                parent_node = node_map[parent]
                if "children" not in parent_node:
                    parent_node["children"] = []
                parent_node["children"].append(node)

        return jsonify(nodes)

    except Exception as e:
        print(f"[ERROR] Al cargar árbol: {e}")
        return jsonify({"error": "No se pudo cargar el árbol"}), 500

@app.route('/api/historial_registro', methods=['POST'])
def add_historial_registro():
    data = request.get_json()
    if not data:
        return jsonify({"error": "Datos inválidos"}), 400

    registro_id = data.get("registro_id")
    campo = data.get("campo")
    anterior = data.get("anterior")
    nuevo = data.get("nuevo")
    usuario = data.get("usuario", "Anónimo")

    if not all([registro_id, campo]):
        return jsonify({"error": "Faltan campos obligatorios (registro_id, campo)"}), 400

    try:
        conn = sqlite3.connect(DB_PATH)
        cursor = conn.cursor()

        cursor.execute("""
            INSERT INTO historial_registro (registro_id, fecha, campo, anterior, nuevo, usuario)
            VALUES (?, ?, ?, ?, ?, ?)
        """, (
            registro_id,
            datetime.datetime.now().isoformat(),
            campo,
            str(anterior),
            str(nuevo),
            usuario
        ))

        conn.commit()
        conn.close()

        return jsonify({"success": True}), 200

    except Exception as e:
        print(f"[ERROR] Al guardar historial_registro: {e}")
        return jsonify({"error": "No se pudo guardar el historial", "details": str(e)}), 500

@app.route('/api/historial_registro/<int:registro_id>', methods=['GET'])
def get_historial_registro(registro_id):
    try:
        conn = sqlite3.connect(DB_PATH)
        cursor = conn.cursor()
        cursor.execute("""
            SELECT * FROM historial_registro
            WHERE registro_id = ?
            ORDER BY fecha DESC
        """, (registro_id,))
        rows = cursor.fetchall()
        conn.close()

        history = [
            {
                "id": r[0],
                "registro_id": r[1],
                "fecha": r[2],
                "campo": r[3],
                "anterior": r[4],
                "nuevo": r[5],
                "usuario": r[6]
            } for r in rows
        ]

        return jsonify(history)

    except Exception as e:
        print(f"[ERROR] Al cargar historial_registro: {e}")
        return jsonify({"error": "No se pudo cargar el historial_registro"}), 500

@app.route('/api/open-sql', methods=['GET'])
def open_sql_file():
    path_encoded = request.args.get("path")
    if not path_encoded:
        return jsonify({"error": "Ruta no especificada"}), 400

    try:
        decoded_path = urllib.parse.unquote(path_encoded)
        cleaned_path = re.sub(r'[<>:"|?*]', '', decoded_path).strip()
        cleaned_path = cleaned_path.replace('/', '\\')

        full_path = os.path.normpath(os.path.join(ARCHIVE_DIR, cleaned_path))

        if not full_path.startswith(ARCHIVE_DIR):
            return jsonify({"error": "Acceso denegado", "path": full_path}), 403

        if not os.path.isfile(full_path):
            return jsonify({"error": "Archivo no encontrado", "path": full_path}), 404

        # Solo funciona en Windows
        if os.name != 'nt':
            return jsonify({"error": "Solo disponible en Windows"}), 501

        # Abrir con SSMS
        try:
            os.startfile(full_path)
            return jsonify({
                "success": True,
                "message": f"Abriendo {full_path}",
                "path": full_path
            })
        except Exception as e:
            print(f"[ERROR] No se pudo abrir '{full_path}': {e}")
            return jsonify({
                "error": "No se pudo abrir el archivo",
                "details": str(e)
            }), 500

    except Exception as e:
        print(f"[ERROR] Al procesar ruta: {e}")
        return jsonify({"error": "Error al procesar la ruta"}), 500

@app.route('/api/reindex-orden', methods=['POST'])
def reindex_orden():
    data = request.get_json()
    nodo_id = data.get("nodo_id")
    
    if not nodo_id:
        return jsonify({"error": "nodo_id no especificado"}), 400

    try:
        conn = sqlite3.connect(DB_PATH)
        cursor = conn.cursor()

        # Obtener todos los registros del nodo, ordenados por campo 'orden'
        cursor.execute("SELECT id FROM registros WHERE nodo_id = ? ORDER BY orden ASC", (nodo_id,))
        rows = cursor.fetchall()

        # Reindexar órdenes: asignar 1, 2, 3... según posición
        for idx, (registro_id,) in enumerate(rows):
            cursor.execute("UPDATE registros SET orden = ? WHERE id = ?", (idx + 1, registro_id))

        conn.commit()
        conn.close()

        return jsonify({
            "success": True,
            "message": "Órdenes reindexados correctamente",
            "total_registros": len(rows),
            "nodo_id": nodo_id
        })

    except Exception as e:
        print(f"[ERROR] Al reindexar órdenes: {e}")
        return jsonify({"error": "No se pudieron reindexar los órdenes", "details": str(e)}), 500


if __name__ == "__main__":
    os.makedirs("db", exist_ok=True)
    os.makedirs("history", exist_ok=True)
    os.makedirs("Archive", exist_ok=True)

    app.run(port=5004, debug=True)
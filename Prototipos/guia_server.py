import http.server
import socketserver
import json
import sqlite3
import urllib.parse
import os
import re
import datetime

PORT = 8000
DB_PATH = "db/sp.db"
HISTORY_DIR = "history"

os.makedirs("db", exist_ok=True)

class ApiRequestHandler(http.server.BaseHTTPRequestHandler):
    def get_tree_data(self):
        conn = sqlite3.connect(DB_PATH)
        cursor = conn.cursor()
        cursor.execute("SELECT id, text, tipo_nodo FROM nodos ORDER BY id ASC")
        rows = cursor.fetchall()

        tree = []
        for row in rows:
            node_id, text, tipo_nodo = row
            cursor.execute("SELECT campo, valor FROM metadatos WHERE nodo_id = ?", (node_id,))
            metadata = {campo: valor for campo, valor in cursor.fetchall()}

            tree.append({
                "id": node_id,
                "text": text,
                "type": "default" if tipo_nodo == "carpeta" else "leaf",
                "data": metadata
            })

        return tree

    def clean_sql_path(self, path: str) -> str:
        """Limpia la ruta y convierte / → \ """
        if not path:
            return ""

        decoded_path = urllib.parse.unquote(path)
        cleaned = re.sub(r'[<>:"|?*]', '', decoded_path).strip()
        cleaned = cleaned.replace('/', '\\')
        return cleaned

    def do_GET(self):
        parsed_path = urllib.parse.urlparse(self.path)

        if parsed_path.path == "/api/nodos":
            tree_data = self.get_tree_data()
            self.send_json_response(tree_data)

        elif parsed_path.path.startswith("/api/archivo"):
            params = urllib.parse.parse_qs(parsed_path.query)
            encoded_path = params.get("path", [""])[0]

            if not encoded_path:
                self.send_json_response({"error": "Ruta no especificada"}, 400)
                return

            cleaned_path = self.clean_sql_path(encoded_path)
            full_path = os.path.normpath(os.path.join("Archive", cleaned_path))

            if not os.path.exists(full_path):
                self.send_json_response({"error": "Archivo no encontrado"}, 404)
                return

            try:
                with open(full_path, 'r', encoding='utf-8') as f:
                    content = f.read()
                self.send_response(200)
                self.send_header("Content-Type", "text/plain; charset=utf-8")
                self.end_headers()
                self.wfile.write(content.encode('utf-8'))
            except Exception as e:
                print(f"[ERROR] No se pudo leer el archivo {full_path}: {e}")
                self.send_json_response({"error": "Error al leer el archivo"}, 500)

        elif parsed_path.path.startswith("/api/registros"):
            params = urllib.parse.parse_qs(parsed_path.query)
            nodo_id = params.get("nodo_id", [""])[0]
            if not nodo_id:
                self.send_json_response({"error": "nodo_id no especificado"}, 400)
                return

            conn = sqlite3.connect(DB_PATH)
            cursor = conn.cursor()
            cursor.execute("SELECT * FROM registros WHERE nodo_id = ? ORDER BY orden ASC", (nodo_id,))
            rows = cursor.fetchall()

            registros = [{"id": r[0], "archivo": r[1], "ubicacion": r[2], "funcion": r[3], "descripcion": r[4], "orden": r[5]} for r in rows]
            self.send_json_response(registros)

        elif parsed_path.path.startswith("/api/historial"):
            params = urllib.parse.parse_qs(parsed_path.query)
            nodo_id = params.get("nodo_id", [""])[0]

            history_path = os.path.join(HISTORY_DIR, f"{nodo_id}.json")

            if not os.path.exists(history_path):
                self.send_json_response([], 200)
                return

            with open(history_path, 'r', encoding='utf-8') as f:
                history = json.load(f)

            self.send_json_response(history)

        elif parsed_path.path.startswith("/api/user"):
            import getpass
            user = getpass.getuser()
            self.send_json_response({"usuario": user})

        else:
            self.send_json_response({"error": "Ruta no encontrada"}, 404)

    def do_POST(self):
        parsed_path = urllib.parse.urlparse(self.path)

        if parsed_path.path == "/api/registros":
            content_length = int(self.headers['Content-Length'])
            post_data = self.rfile.read(content_length)
            entry = json.loads(post_data.decode())

            conn = sqlite3.connect(DB_PATH)
            cursor = conn.cursor()

            if 'id' in entry and entry['id']:
                cursor.execute(
                    "UPDATE registros SET archivo = ?, ubicacion = ?, funcion = ?, descripcion = ?, orden = ? WHERE id = ?",
                    (entry["archivo"], entry["ubicacion"], entry["funcion"], entry["descripcion"], entry["orden"], entry["id"])
                )
                conn.commit()

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
            self.send_json_response({"success": True})

        elif parsed_path.path == "/api/nodos":
            # Guardar árbol completo (opcional)
            content_length = int(self.headers['Content-Length'])
            post_data = self.rfile.read(content_length)
            tree_data = json.loads(post_data.decode())

            # Lógica para guardar árbol en BD
            self.send_json_response({"success": True})

        elif parsed_path.path.startswith("/api/historial"):
            content_length = int(self.headers['Content-Length'])
            post_data = self.rfile.read(content_length)
            history = json.loads(post_data.decode())

            nodeId = history.get("nodeId")
            if not nodeId:
                self.send_json_response({"error": "nodeId no especificado"}, 400)
                return

            history_path = os.path.join(HISTORY_DIR, f"{nodeId}.json")
            os.makedirs(os.path.dirname(history_path), exist_ok=True)

            with open(history_path, "w", encoding="utf-8") as f:
                json.dump(history["history"], f, indent=2)

            self.send_json_response({"success": True})

        elif parsed_path.path.startswith("/api/reindex-orden"):
            params = urllib.parse.parse_qs(parsed_path.query)
            nodo_id = params.get("nodo_id", [""])[0]

            if not nodo_id:
                self.send_json_response({"error": "nodo_id no especificado"}, 400)
                return

            conn = sqlite3.connect(DB_PATH)
            cursor = conn.cursor()

            cursor.execute("SELECT id FROM registros WHERE nodo_id = ? ORDER BY orden ASC", (nodo_id,))
            rows = cursor.fetchall()

            for idx, (registro_id,) in enumerate(rows):
                cursor.execute("UPDATE registros SET orden = ? WHERE id = ?", (idx + 1, registro_id))

            conn.commit()
            conn.close()
            self.send_json_response({"success": True, "message": "Órdenes reindexados"})
        
        elif parsed_path.path.startswith("/api/registros"):
            params = urllib.parse.parse_qs(parsed_path.query)
            registro_id = params.get("id", [""])[0]

            if not registro_id:
                self.send_json_response({"error": "id no especificado"}, 400)
                return

            conn = sqlite3.connect(DB_PATH)
            cursor = conn.cursor()
            cursor.execute("DELETE FROM registros WHERE id = ?", (registro_id,))
            cursor.execute("DELETE FROM historial_registro WHERE registro_id = ?", (registro_id,))
            conn.commit()
            conn.close()

            self.send_json_response({"success": True})

    def do_DELETE(self):
        parsed_path = urllib.parse.urlparse(self.path)

        if parsed_path.path.startswith("/api/registros"):
            params = urllib.parse.parse_qs(parsed_path.query)
            registro_id = params.get("id", [""])[0]

            conn = sqlite3.connect(DB_PATH)
            cursor = conn.cursor()
            cursor.execute("DELETE FROM registros WHERE id = ?", (registro_id,))
            cursor.execute("DELETE FROM historial_registro WHERE registro_id = ?", (registro_id,))
            conn.commit()
            conn.close()

            self.send_json_response({"success": True})

        elif parsed_path.path.startswith("/api/nodos"):
            # Eliminar nodo
            pass

        else:
            self.send_json_response({"error": "Ruta no soportada"}, 404)

    def send_json_response(self, data, status=200):
        self.send_response(status)
        self.send_header("Content-Type", "application/json")
        self.end_headers()
        self.wfile.write(json.dumps(data).encode())
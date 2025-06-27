import datetime
import http.server
import json
import socketserver
import os
import sqlite3
import urllib.parse
import subprocess
import re

PORT = 8000
SSMS_PATH = r"C:\Program Files (x86)\Microsoft SQL Server Management Studio 20\Common7\IDE\Ssms.exe"
HISTORY_DIR = "history" 
os.makedirs("Archive", exist_ok=True)

class MyHandler(http.server.SimpleHTTPRequestHandler):
    def build_tree(self, path):
        """Recursivamente construye una estructura HTML de <ul><li> para mostrar carpetas y archivos"""
        try:
            items = sorted(os.listdir(path))
        except Exception as e:
            print(f"[ERROR] No se pudo leer {path}: {e}")
            return ""

        tree_html = "<ul>"
        for item in items:
            item_path = os.path.join(path, item)
            relative_path = os.path.relpath(item_path, "Archive")  # Ruta relativa desde Archive/
            encoded_path = urllib.parse.quote(relative_path)       # Codifica espacios, acentos, etc.
            is_dir = os.path.isdir(item_path)

            if is_dir:
                tree_html += f'<li><i class="fas fa-folder me-2"></i>{item}'
                tree_html += self.build_tree(item_path)
                tree_html += "</li>"
            else:
                ext = os.path.splitext(item)[1].lower()
                icon = "fa-file"
                if ext == ".sql":
                    icon = "fa-database"
                elif ext in [".js", ".ts"]:
                    icon = "fa-code"
                elif ext == ".json":
                    icon = "fa-book"

                # El href pasa la ruta completa desde Archive/
                tree_html += f'''
                    <li class="list-group-item d-flex align-items-center">
                        <i class="fas {icon} me-2"></i>
                        <a href="/read-sql?path={encoded_path}" class="text-decoration-none">{item}</a>
                    </li>
                '''
        tree_html += "</ul>"
        return tree_html

    # Migrado
    def clean_sql_path(self, path: str) -> str:
        """Limpia la ruta y convierte / → \ """
        if not path:
            return "Archive"
        else:
            path = os.path.normpath(os.path.join("Archive", path))            

        # Decodificar URL encoding (%20 → espacio, etc.)
        decoded_path = urllib.parse.unquote(path)

        # Solo permitimos caracteres válidos en rutas
        cleaned = re.sub(r'[<>|?*\"]', '', decoded_path)  # Eliminar caracteres prohibidos en Windows
        cleaned = cleaned.replace('/', '\\').strip()
        return cleaned

    def do_GET(self):
        # Migrado
        if self.path.startswith("/read-sql"):
            params = urllib.parse.urlparse(self.path)
            query = urllib.parse.parse_qs(params.query)
            encoded_path = query.get("path", [""])[0]

            if encoded_path:
                path = self.clean_sql_path(encoded_path)  # Limpia y decodifica
                full_path = os.path.normpath(os.path.join(".", path))  # Une con Archive/

                if os.path.exists(full_path):
                    try:
                        with open(full_path, 'r', encoding='utf-8') as f:
                            content = f.read()
                        self.send_response(200)
                        self.send_header("Content-Type", "text/plain; charset=utf-8")
                        self.end_headers()
                        self.wfile.write(content.encode('utf-8'))
                    except Exception as e:
                        print(f"[ERROR] No se pudo leer el archivo {full_path}: {e}")
                        self.send_response(500)
                        self.send_header("Content-Type", "text/plain; charset=utf-8")
                        self.end_headers()
                        self.wfile.write(b"Server error")
                else:
                    print(f"[ERROR] Archivo no encontrado: {full_path}")
                    self.send_response(404)
                    self.send_header("Content-Type", "text/plain; charset=utf-8")
                    self.end_headers()
                    self.wfile.write(b"File not found")
            else:
                self.send_response(400)
                self.send_header("Content-Type", "text/plain; charset=utf-8")
                self.end_headers()
                self.wfile.write(b"Invalid path")

        elif self.path.startswith("/open-sql"):
            params = urllib.parse.urlparse(self.path)
            query = urllib.parse.parse_qs(params.query)
            encoded_path = query.get("path", [""])[0]

            if encoded_path:
                # Decodificar URL
                path = urllib.parse.unquote(encoded_path)

                # Limpiar la ruta
                cleaned_path = self.clean_sql_path(path)

                print(f"[DEBUG] Ruta original: {path}")
                print(f"[DEBUG] Ruta limpia: {cleaned_path}")

                # Comprobar si existe
                if os.path.exists(cleaned_path):
                    print("[OK] El archivo existe.")

                    # Abrir con programa por defecto
                    try:
                        os.startfile(cleaned_path)
                    except Exception as e:
                        print("No se pudo abrir con otro programa:", e)
                else:
                    print("[ERROR] El archivo NO existe o la ruta es inválida.")
            else:
                print("[ERROR] No se recibió ninguna ruta.")

            self.send_response(200)
            self.send_header("Content-Type", "text/plain; charset=utf-8")
            self.end_headers()
            self.wfile.write(b"Opening SQL file")

        # Migrado
        elif self.path.startswith("/history"):
            # Sirve archivos estáticos desde /history/
            history_path = os.path.join(os.getcwd(), self.path[1:])  # Remover la barra inicial
            if os.path.exists(history_path):
                self.send_response(200)
                self.send_header("Content-Type", "application/json")
                self.end_headers()
                with open(history_path, 'rb') as f:
                    self.wfile.write(f.read())
                return
            else:
                self.send_response(404)
                self.end_headers()
                self.wfile.write(b"File not found")
                return

        elif self.path == "/get-user":
            import getpass
            user = getpass.getuser()
            self.send_response(200)
            self.send_header("Content-Type", "application/json")
            self.end_headers()
            self.wfile.write(json.dumps({"usuario": user}).encode('utf-8'))
            return

        elif self.path.startswith("/get-js-cs"):
            params = urllib.parse.urlparse(self.path)
            query = urllib.parse.parse_qs(params.query)
            nodeId = query.get("nodeId", [""])[0]

            if not nodeId:
                self.send_response(400)
                self.wfile.write(b'{"error": "nodeId no especificado"}')
                return

            conn = sqlite3.connect('db/sp.db')
            cursor = conn.cursor()
            cursor.execute("SELECT * FROM funciones WHERE nodo_id = ?", (nodeId,))
            rows = cursor.fetchall()

            data = [{"id": r[0], "archivo": r[1], "ubicacion": r[2], "funcion": r[3], "descripcion": r[4]} for r in rows]
            self.send_response(200)
            self.send_header("Content-Type", "application/json")
            self.end_headers()
            self.wfile.write(json.dumps(data).encode())

        elif self.path.startswith("/archive"):
            relative_path = self.path[len("/archive"):].lstrip('/')
            safe_path = self.clean_sql_path(relative_path)

            full_path = os.path.normpath(os.path.join(".", safe_path))

            if not full_path.startswith("Archive") and not full_path.startswith(".\\Archive"):
                self.send_response(403)
                self.end_headers()
                self.wfile.write(b"Forbidden")
                return

            if not os.path.exists(full_path):
                self.send_response(404)
                self.end_headers()
                self.wfile.write(b"File not found")
                return

            if os.path.isdir(full_path):
                html = f"""
                <html>
                <head>
                    <title>Explorar Carpetas</title>
                    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css ">
                </head>
                <body>
                    <h5>Ruta: {safe_path or "Raíz"}</h5>
                    {self.build_tree(full_path)}
                </body>
                </html>
                """
                self.send_response(200)
                self.send_header("Content-Type", "text/html; charset=utf-8")
                self.end_headers()
                self.wfile.write(html.encode('utf-8'))
                return
            else:
                self.send_response(302)
                self.send_header("Location", f"/read-sql?path={urllib.parse.quote(safe_path)}")
                self.end_headers()
                return

        elif self.path.startswith("/get-registros"):
            params = urllib.parse.urlparse(self.path)
            nodeId = urllib.parse.parse_qs(params.query).get("nodo_id", [""])[0]

            if not nodeId:
                self.send_response(400)
                self.wfile.write(b'{"error": "nodeId no especificado"}')
                return

            db_path = os.path.join("db", "sp.db")
            if not os.path.exists(db_path):
                self.send_response(500)
                self.end_headers()
                self.wfile.write(b'{"error": "Base de datos no encontrada"}')
                return

            conn = sqlite3.connect(db_path)
            cursor = conn.cursor()
            cursor = conn.cursor()
            cursor.execute("SELECT * FROM registros WHERE nodo_id = ? ORDER BY orden ASC", (nodeId,))
            rows = cursor.fetchall()

            data = [{"id": r[0], "archivo": r[1], "ubicacion": r[2], "funcion": r[3], "descripcion": r[4], "orden": r[5]} for r in rows]
            
            self.send_response(200)
            self.send_header("Content-Type", "application/json")
            self.end_headers()
            self.wfile.write(json.dumps(data).encode())
            return

        else:
            # Para cualquier otra solicitud (index.html, css, js, etc.)
            super().do_GET()

    def do_POST(self):
        if self.path == "/save-tree":
            content_length = int(self.headers['Content-Length'])
            post_data = self.rfile.read(content_length)
            tree_data = json.loads(post_data.decode('utf-8'))

            # Guardar datos en data.json
            with open('data.json', 'w') as f:
                json.dump(tree_data, f, indent=4)

            self.send_response(200)
            self.send_header("Content-Type", "application/json")
            self.end_headers()
            self.wfile.write(json.dumps({"success": True}).encode('utf-8'))
            return
        
        elif self.path == "/save-history":
            content_length = int(self.headers['Content-Length'])
            post_data = self.rfile.read(content_length)
            data = json.loads(post_data.decode('utf-8'))

            nodeId = data.get('nodeId')
            history = data.get('history')

            if not nodeId or not history:
                self.send_response(400)
                self.send_header("Content-Type", "application/json")
                self.end_headers()
                self.wfile.write(json.dumps({"success": False, "message": "Datos inválidos"}).encode('utf-8'))
                return

            # Guardar historial en archivo .json
            history_path = os.path.join('history', f'{nodeId}.json')
            os.makedirs(os.path.dirname(history_path), exist_ok=True)

            with open(history_path, 'w') as f:
                json.dump(history, f, indent=4)

            self.send_response(200)
            self.send_header("Content-Type", "application/json")
            self.end_headers()
            self.wfile.write(json.dumps({"success": True}).encode('utf-8'))

        elif self.path == "/update-node-history":
            content_length = int(self.headers['Content-Length'])
            post_data = self.rfile.read(content_length)
            data = json.loads(post_data.decode('utf-8'))

            nodeId = data.get("nodeId")
            campo = data.get("campo")
            anterior = data.get("anterior")
            nuevo = data.get("nuevo")
            usuario = data.get("usuario", "Anónimo")

            # Ruta al historial del nodo
            history_path = os.path.join(HISTORY_DIR, f"{nodeId}.json")

            # Cargar o crear historial
            if os.path.exists(history_path):
                with open(history_path, "r", encoding="utf-8") as f:
                    history = json.load(f)
            else:
                history = []

            # Agregar nueva entrada al historial
            history.append({
                "fecha": datetime.datetime.now().isoformat(),
                "campo": campo,
                "anterior": anterior,
                "nuevo": nuevo,
                "usuario": usuario
            })

            # Guardar historial actualizado
            with open(history_path, "w", encoding="utf-8") as f:
                json.dump(history, f, indent=2)

            # Respuesta OK
            self.send_response(200)
            self.send_header("Content-Type", "application/json")
            self.end_headers()
            self.wfile.write(json.dumps({"success": True}).encode('utf-8'))
            return
        
        elif self.path == "/save-funcion":
            content_length = int(self.headers['Content-Length'])
            post_data = self.rfile.read(content_length)
            entry = json.loads(post_data.decode())

            conn = sqlite3.connect('db/sp.db')
            cursor = conn.cursor()

            cursor.execute(
                "INSERT INTO funciones (archivo, ubicacion, funcion, descripcion, nodo_id) VALUES (?, ?, ?, ?, ?)",
                (entry["archivo"], entry["ubicacion"], entry["funcion"], entry["descripcion"], entry["nodo_id"])
            )
            conn.commit()
            conn.close()

            self.send_response(200)
            self.send_header("Content-Type", "application/json")
            self.end_headers()
            self.wfile.write(json.dumps({"success": True}).encode())

        elif self.path.startswith("/delete-funcion"):
            params = urllib.parse.urlparse(self.path)
            funcId = urllib.parse.parse_qs(params.query).get("id", [""])[0]

            conn = sqlite3.connect('db/sp.db')
            cursor = conn.cursor()
            cursor.execute("DELETE FROM funciones WHERE id = ?", (funcId,))
            conn.commit()
            conn.close()

            self.send_response(200)
            self.end_headers()
            self.wfile.write(json.dumps({"success": True}).encode())

        elif self.path == "/save-registro":
            try:
                content_length = int(self.headers['Content-Length'])
                post_data = self.rfile.read(content_length)
                entry = json.loads(post_data.decode())

                db_path = os.path.join("db", "sp.db")
                if not os.path.exists(db_path):
                    print(f"[ERROR] Base de datos no encontrada: {db_path}")
                    self.send_response(500)
                    self.end_headers()
                    self.wfile.write(json.dumps({"success": False, "message": "No se encontró la base de datos"}).encode())
                    return

                if 'id' in entry and entry['id']:
                    # Actualizar registro existente
                    cursor.execute(
                        "UPDATE registros SET archivo = ?, ubicacion = ?, funcion = ?, descripcion = ?, orden = ? WHERE id = ?",
                        (entry["archivo"], entry["ubicacion"], entry["funcion"], entry["descripcion"], entry["orden"], entry["id"])
                    )
                    conn.commit()

                    # Registrar en historial los campos modificados
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
                                original[field],
                                entry[field],
                                entry.get("usuario", "Anónimo")
                            ))
                else:
                    # Insertar nuevo registro
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

                    registro_id = cursor.lastrowid

                    # Registrar creación del registro
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

                self.send_response(200)
                self.send_header("Content-Type", "application/json")
                self.end_headers()
                self.wfile.write(json.dumps({"success": True}).encode())
                
            except Exception as e:
                print("[ERROR] Al guardar registro:", str(e))
                self.send_response(500)
                self.send_header("Content-Type", "application/json")
                self.end_headers()
                self.wfile.write(json.dumps({"success": False, "message": str(e)}).encode())
            return

        elif self.path.startswith("/delete-registro"):
            params = urllib.parse.urlparse(self.path)
            funcId = urllib.parse.parse_qs(params.query).get("id", [""])[0]

            conn = sqlite3.connect('db/sp.db')
            cursor = conn.cursor()
            
            # Marcar como eliminado (opcional) o borrar directamente
            cursor.execute("DELETE FROM registros WHERE id = ?", (funcId,))
            cursor.execute("DELETE FROM historial_registro WHERE registro_id = ?", (funcId,))

            conn.commit()
            conn.close()

            self.send_response(200)
            self.end_headers()
            self.wfile.write(json.dumps({"success": True}).encode())
            return

        elif self.path.startswith("/reindex-orden"):
            params = urllib.parse.urlparse(self.path)
            query = urllib.parse.parse_qs(params.query)
            nodeId = query.get("nodeId", [""])[0]

            if not nodeId:
                self.send_response(400)
                self.end_headers()
                self.wfile.write(json.dumps({"success": False, "message": "nodeId no especificado"}).encode())
                return

            db_path = os.path.join("db", "sp.db")
            conn = sqlite3.connect(db_path)
            cursor = conn.cursor()

            # Obtener todos los registros del nodo y ordenarlos
            cursor.execute("SELECT id FROM registros WHERE nodo_id = ? ORDER BY orden ASC", (nodeId,))
            rows = cursor.fetchall()

            for idx, row in enumerate(rows):
                cursor.execute("UPDATE registros SET orden = ? WHERE id = ?", (idx + 1, row[0]))

            conn.commit()
            conn.close()

            self.send_response(200)
            self.send_header("Content-Type", "application/json")
            self.end_headers()
            self.wfile.write(json.dumps({"success": True, "message": "Orden reindexado"}).encode())
            return
        super().do_POST()


with socketserver.TCPServer(("", PORT), MyHandler) as httpd:
    print(f"Servidor corriendo en http://localhost:{PORT}")
    httpd.serve_forever()
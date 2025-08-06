from flask import Blueprint, request, jsonify
import os
from datetime import datetime
from models.database import get_db_connection

snippets_bp = Blueprint('snippets', __name__)

@snippets_bp.route('', methods=['GET'])
def get_snippets():
    """Obtiene snippets de un nodo específico"""
    try:
        nodo_id = request.args.get('nodo_id')
        proyecto_id = request.args.get('proyecto_id')
        
        if not nodo_id or not proyecto_id:
            return jsonify({"error": "nodo_id y proyecto_id son requeridos"}), 400
        
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("""
            SELECT * FROM code_snippets 
            WHERE nodo_id = ? AND proyecto_id = ? 
            ORDER BY orden ASC
        """, (nodo_id, proyecto_id))
        rows = cursor.fetchall()
        
        snippets = []
        for row in rows:
            snippets.append({
                "id": row["id"],
                "titulo": row["titulo"],
                "descripcion": row["descripcion"],
                "lenguaje": row["lenguaje"],
                "codigo": row["codigo"],
                "archivo_ruta": row["archivo_ruta"],
                "orden": row["orden"],
                "fecha_creacion": row["fecha_creacion"],
                "fecha_modificacion": row["fecha_modificacion"]
            })
        
        conn.close()
        return jsonify(snippets)
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@snippets_bp.route('', methods=['POST'])
def save_snippet():
    """Guarda o actualiza un snippet"""
    try:
        data = request.get_json()
        conn = get_db_connection()
        cursor = conn.cursor()
        
        now = datetime.now().isoformat()
        
        if data.get('id'):
            # Actualizar snippet existente
            cursor.execute("""
                UPDATE code_snippets 
                SET titulo = ?, descripcion = ?, lenguaje = ?, codigo = ?, 
                    orden = ?, fecha_modificacion = ?
                WHERE id = ?
            """, (
                data["titulo"], data["descripcion"], data["lenguaje"], 
                data["codigo"], data["orden"], now, data["id"]
            ))
        else:
            # Crear nuevo snippet
            cursor.execute("""
                INSERT INTO code_snippets 
                (nodo_id, proyecto_id, titulo, descripcion, lenguaje, codigo, orden, fecha_creacion, fecha_modificacion)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
            """, (
                data["nodo_id"], data["proyecto_id"], data["titulo"], data["descripcion"],
                data["lenguaje"], data["codigo"], data["orden"], now, now
            ))
            
            snippet_id = cursor.lastrowid
            
            # Crear archivo físico si es necesario
            if data.get("save_to_file", False):
                project_path = f"projects/{data['proyecto_id']}/snippets"
                os.makedirs(project_path, exist_ok=True)
                
                file_extension = get_file_extension(data["lenguaje"])
                filename = f"{data['nodo_id']}_{snippet_id}.{file_extension}"
                file_path = os.path.join(project_path, filename)
                
                with open(file_path, 'w', encoding='utf-8') as f:
                    f.write(data["codigo"])
                
                # Actualizar ruta del archivo
                cursor.execute("""
                    UPDATE code_snippets SET archivo_ruta = ? WHERE id = ?
                """, (file_path, snippet_id))
        
        conn.commit()
        conn.close()
        return jsonify({"success": True})
    except Exception as e:
        return jsonify({"success": False, "error": str(e)}), 500

@snippets_bp.route('<int:snippet_id>', methods=['DELETE'])
def delete_snippet(snippet_id):
    """Elimina un snippet"""
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        
        # Obtener info del snippet antes de eliminarlo
        cursor.execute("SELECT archivo_ruta FROM code_snippets WHERE id = ?", (snippet_id,))
        row = cursor.fetchone()
        
        if row and row["archivo_ruta"] and os.path.exists(row["archivo_ruta"]):
            os.remove(row["archivo_ruta"])
        
        cursor.execute("DELETE FROM code_snippets WHERE id = ?", (snippet_id,))
        conn.commit()
        conn.close()
        
        return jsonify({"success": True})
    except Exception as e:
        return jsonify({"success": False, "error": str(e)}), 500

def get_file_extension(language):
    """Obtiene la extensión de archivo según el lenguaje"""
    extensions = {
        "javascript": "js",
        "typescript": "ts",
        "python": "py",
        "java": "java",
        "csharp": "cs",
        "html": "html",
        "css": "css",
        "sql": "sql",
        "json": "json",
        "xml": "xml",
        "php": "php",
        "ruby": "rb",
        "go": "go",
        "rust": "rs",
        "cpp": "cpp",
        "c": "c"
    }
    return extensions.get(language.lower(), "txt")

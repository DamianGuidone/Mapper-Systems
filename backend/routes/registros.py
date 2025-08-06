from flask import Blueprint, request, jsonify
import datetime
from models.database import get_db_connection

registros_bp = Blueprint('registros', __name__)

@registros_bp.route('', methods=['GET'])
def obtener_registros():
    """Obtiene todos los registros de un nodo específico"""
    try:
        nodo_id = request.args.get('nodo_id')
        proyecto_id = request.args.get('proyecto_id')
        
        if not nodo_id:
            return jsonify({"error": "nodo_id no especificado"}), 400
        
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("""
            SELECT * FROM registros 
            WHERE nodo_id = ? 
            ORDER BY orden ASC
        """, (nodo_id,))
        rows = cursor.fetchall()
        
        registros = []
        for row in rows:
            registros.append({
                "id": row["id"],
                "archivo": row["archivo"],
                "ubicacion": row["ubicacion"],
                "funcion": row["funcion"],
                "descripcion": row["descripcion"],
                "orden": row["orden"],
                "nodo_id": row["nodo_id"],
                "proyecto_id": row["proyecto_id"]
            })
        
        conn.close()
        return jsonify(registros)
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@registros_bp.route('', methods=['POST'])
def guardar_registro():
    """Guarda o actualiza un registro"""
    try:
        data = request.get_json()
        conn = get_db_connection()
        cursor = conn.cursor()
        
        now = datetime.datetime.now().isoformat()
        
        if data.get('id'):
            # Actualizar registro existente
            cursor.execute("""
                UPDATE registros 
                SET archivo = ?, ubicacion = ?, funcion = ?, descripcion = ?, 
                    orden = ?, fecha_modificacion = ?
                WHERE id = ?
            """, (
                data["archivo"], data.get("ubicacion"), data.get("funcion"), 
                data.get("descripcion"), data["orden"], now, data["id"]
            ))
        else:
            # Crear nuevo registro
            cursor.execute("""
                INSERT INTO registros 
                (archivo, ubicacion, funcion, descripcion, orden, nodo_id, proyecto_id, fecha_creacion, fecha_modificacion)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
            """, (
                data["archivo"], data.get("ubicacion"), data.get("funcion"),
                data.get("descripcion"), data["orden"], data["nodo_id"], 
                data["proyecto_id"], now, now
            ))
        
        conn.commit()
        conn.close()
        return jsonify({"success": True, "message": "Registro guardado exitosamente"})
    except Exception as e:
        return jsonify({"success": False, "error": str(e)}), 500

@registros_bp.route('<int:registro_id>', methods=['DELETE'])
def eliminar_registro(registro_id):
    """Elimina un registro específico"""
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("DELETE FROM registros WHERE id = ?", (registro_id,))
        cursor.execute("DELETE FROM historial_registro WHERE registro_id = ?", (registro_id,))
        conn.commit()
        conn.close()
        return jsonify({"success": True, "message": "Registro eliminado"})
    except Exception as e:
        return jsonify({"success": False, "error": str(e)}), 500

@registros_bp.route('reordenar', methods=['POST'])
def reordenar_registros():
    """Reindexar el orden de los registros de un nodo"""
    try:
        data = request.get_json()
        nodo_id = data.get('nodo_id')
        
        if not nodo_id:
            return jsonify({"error": "nodo_id no especificado"}), 400
        
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT id FROM registros WHERE nodo_id = ? ORDER BY orden ASC", (nodo_id,))
        rows = cursor.fetchall()
        
        for idx, row in enumerate(rows):
            cursor.execute("UPDATE registros SET orden = ? WHERE id = ?", (idx + 1, row["id"]))
        
        conn.commit()
        conn.close()
        return jsonify({"success": True, "message": "Orden reindexado"})
    except Exception as e:
        return jsonify({"success": False, "error": str(e)}), 500

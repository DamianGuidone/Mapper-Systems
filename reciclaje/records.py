from flask import Blueprint, request, jsonify
import datetime
from models.database import get_db_connection

records_bp = Blueprint('records', __name__)

@records_bp.route('', methods=['GET'])
def get_records():
    """Obtiene todos los registros de un nodo específico"""
    try:
        nodo_id = request.args.get('nodo_id')
        if not nodo_id:
            return jsonify({"error": "nodo_id no especificado"}), 400
        
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM registros WHERE nodo_id = ? ORDER BY orden ASC", (nodo_id,))
        rows = cursor.fetchall()
        
        records = []
        for row in rows:
            records.append({
                "id": row["id"],
                "archivo": row["archivo"],
                "ubicacion": row["ubicacion"],
                "funcion": row["funcion"],
                "descripcion": row["descripcion"],
                "orden": row["orden"]
            })
        
        conn.close()
        return jsonify(records)
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@records_bp.route('', methods=['POST'])
def save_record():
    """Guarda o actualiza un registro"""
    try:
        data = request.get_json()
        conn = get_db_connection()
        cursor = conn.cursor()
        
        if data.get('id'):
            # Actualizar registro existente
            cursor.execute("""
                UPDATE registros 
                SET archivo = ?, ubicacion = ?, funcion = ?, descripcion = ?, orden = ? 
                WHERE id = ?
            """, (
                data["archivo"], data["ubicacion"], data["funcion"], 
                data["descripcion"], data["orden"], data["id"]
            ))
        else:
            # Crear nuevo registro
            cursor.execute("""
                INSERT INTO registros (archivo, ubicacion, funcion, descripcion, orden, nodo_id)
                VALUES (?, ?, ?, ?, ?, ?)
            """, (
                data["archivo"], data["ubicacion"], data["funcion"],
                data["descripcion"], data["orden"], data["nodo_id"]
            ))
        
        conn.commit()
        conn.close()
        return jsonify({"success": True})
    except Exception as e:
        return jsonify({"success": False, "error": str(e)}), 500

@records_bp.route('<int:record_id>', methods=['DELETE'])
def delete_record(record_id):
    """Elimina un registro específico"""
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("DELETE FROM registros WHERE id = ?", (record_id,))
        cursor.execute("DELETE FROM historial_registro WHERE registro_id = ?", (record_id,))
        conn.commit()
        conn.close()
        return jsonify({"success": True})
    except Exception as e:
        return jsonify({"success": False, "error": str(e)}), 500

@records_bp.route('reindex', methods=['POST'])
def reindex_order():
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

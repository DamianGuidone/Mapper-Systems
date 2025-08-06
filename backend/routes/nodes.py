from flask import Blueprint, request, jsonify
import json
import os
from datetime import datetime
from models.database import get_db_connection
from utils.helpers import add_node_history_entry

nodes_bp = Blueprint('nodes', __name__)

@nodes_bp.route('<int:project_id>', methods=['GET'])
def get_tree_data(project_id):
    """Obtiene la estructura completa del árbol desde la base de datos"""
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("""
            SELECT * FROM arbol_nodos 
            WHERE proyecto_id = ? 
            ORDER BY orden ASC
        """, (project_id,))
        rows = cursor.fetchall()
        
        tree_data = []
        for row in rows:
            node_data = json.loads(row["data"])
            tree_data.append({
                "id": row["id"],
                "text": row["text"],
                "type": row["type"],
                "parent": row["parent"],
                "data": node_data,
                "state": {
                    "loaded": True,
                    "opened": False,
                    "selected": False,
                    "disabled": False
                }
            })
        
        conn.close()
        return jsonify(tree_data)
    except Exception as e:
        print(f"Error getting tree data: {str(e)}")
        return jsonify([]), 200

@nodes_bp.route('<int:project_id>', methods=['POST'])
def save_tree(project_id):
    try:
        tree_data = request.get_json()
        
        # Validar estructura básica
        if not isinstance(tree_data, list):
            return jsonify({"success": False, "message": "Datos de árbol inválidos"}), 400
        
        conn = get_db_connection()
        cursor = conn.cursor()
        
        # Limpiar nodos existentes del proyecto
        cursor.execute("DELETE FROM arbol_nodos WHERE proyecto_id = ?", (project_id,))
        
        # Insertar nodos actualizados con validación
        now = datetime.now().isoformat()
        for i, node in enumerate(tree_data):
            # Validar campos requeridos
            if not all(key in node for key in ['id', 'text', 'type', 'parent', 'data']):
                conn.rollback()
                conn.close()
                return jsonify({"success": False, "message": f"Nodo inválido en posición {i}"}), 400
            
            # Insertar en base de datos
            cursor.execute("""
                INSERT INTO arbol_nodos 
                (id, proyecto_id, text, type, parent, data, orden, fecha_creacion, fecha_modificacion)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
            """, (
                node["id"], project_id, node["text"], node["type"], 
                node["parent"], json.dumps(node["data"]), i, now, now
            ))
        
        # Actualizar fecha de modificación del proyecto
        cursor.execute("""
            UPDATE proyectos SET fecha_modificacion = ? WHERE id = ?
        """, (now, project_id))
        
        conn.commit()
        conn.close()
        
        return jsonify({"success": True, "message": f"Árbol guardado con {len(tree_data)} nodos"})
    except Exception as e:
        return jsonify({"success": False, "message": str(e)}), 500

@nodes_bp.route('<int:project_id>/create', methods=['POST'])
def create_node(project_id):
    """Crea un nuevo nodo en el árbol"""
    try:
        data = request.get_json()
        node_id = data.get('id')
        text = data.get('text')
        
        print(f"Creating node: {node_id} - {text} in project {project_id}")
        
        conn = get_db_connection()
        cursor = conn.cursor()
        
        now = datetime.now().isoformat()
        cursor.execute("""
            INSERT INTO arbol_nodos 
            (id, proyecto_id, text, type, parent, data, orden, fecha_creacion, fecha_modificacion)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
        """, (
            node_id, project_id, text, data.get('type', 'default'),
            data.get('parent', '#'), json.dumps(data.get('data', {})),
            data.get('orden', 0), now, now
        ))
        
        # Actualizar fecha de modificación del proyecto
        cursor.execute("""
            UPDATE proyectos SET fecha_modificacion = ? WHERE id = ?
        """, (now, project_id))
        
        conn.commit()
        conn.close()
        
        # Registrar en historial
        add_node_history_entry(node_id, project_id, "nuevo_nodo", "", text)
        
        print(f"Node created successfully: {node_id}")
        return jsonify({"success": True, "node_id": node_id, "message": "Nodo creado exitosamente"})
    except Exception as e:
        print(f"Error creating node: {str(e)}")
        return jsonify({"success": False, "message": str(e)}), 500

@nodes_bp.route('<int:project_id>/<node_id>/history', methods=['GET'])
def get_node_history(project_id, node_id):
    """Obtiene el historial de un nodo específico"""
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("""
            SELECT * FROM historial_nodos 
            WHERE nodo_id = ? AND proyecto_id = ? 
            ORDER BY fecha DESC
        """, (node_id, project_id))
        rows = cursor.fetchall()
        
        history = []
        for row in rows:
            history.append({
                "fecha": row["fecha"],
                "campo": row["campo"],
                "anterior": row["anterior"],
                "nuevo": row["nuevo"],
                "usuario": row["usuario"]
            })
        
        conn.close()
        return jsonify(history)
    except Exception as e:
        print(f"Error getting node history: {str(e)}")
        return jsonify({"error": str(e)}), 500

@nodes_bp.route('<int:project_id>/<node_id>/update', methods=['POST'])
def update_node_field(project_id, node_id):
    """Actualiza un campo específico del nodo y registra en historial"""
    try:
        data = request.get_json()
        campo = data.get("campo")
        anterior = data.get("anterior")
        nuevo = data.get("nuevo")
        usuario = data.get("usuario", "Anónimo")
        
        # Registrar cambio en historial
        add_node_history_entry(node_id, project_id, campo, anterior, nuevo, usuario)
        
        # Actualizar el nodo en la base de datos
        conn = get_db_connection()
        cursor = conn.cursor()
        
        if campo == 'text':
            cursor.execute("""
                UPDATE arbol_nodos SET text = ?, fecha_modificacion = ? 
                WHERE id = ? AND proyecto_id = ?
            """, (nuevo, datetime.now().isoformat(), node_id, project_id))
        else:
            # Para campos en data, necesitamos actualizar el JSON
            cursor.execute("""
                SELECT data FROM arbol_nodos WHERE id = ? AND proyecto_id = ?
            """, (node_id, project_id))
            row = cursor.fetchone()
            
            if row:
                node_data = json.loads(row["data"])
                node_data[campo] = nuevo
                
                cursor.execute("""
                    UPDATE arbol_nodos SET data = ?, fecha_modificacion = ? 
                    WHERE id = ? AND proyecto_id = ?
                """, (json.dumps(node_data), datetime.now().isoformat(), node_id, project_id))
        
        conn.commit()
        conn.close()
        
        return jsonify({"success": True})
    except Exception as e:
        print(f"Error updating node field: {str(e)}")
        return jsonify({"success": False, "message": str(e)}), 500

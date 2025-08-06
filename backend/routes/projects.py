from flask import Blueprint, request, jsonify
import json
import os
from datetime import datetime
from models.database import get_db_connection

projects_bp = Blueprint('projects', __name__)

@projects_bp.route('', methods=['GET'])
def get_projects():
    """Obtiene todos los proyectos"""
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("""
            SELECT p.*, 
                COUNT(n.id) as total_nodos,
                COUNT(r.id) as total_registros,
                COUNT(s.id) as total_snippets
            FROM proyectos p
            LEFT JOIN arbol_nodos n ON p.id = n.proyecto_id
            LEFT JOIN registros r ON p.id = r.proyecto_id
            LEFT JOIN code_snippets s ON p.id = s.proyecto_id
            WHERE p.activo = 1
            GROUP BY p.id
            ORDER BY p.fecha_modificacion DESC
        """)
        rows = cursor.fetchall()
        
        projects = []
        for row in rows:
            projects.append({
                "id": row["id"],
                "nombre": row["nombre"],
                "descripcion": row["descripcion"],
                "ruta_base": row["ruta_base"],
                "fecha_creacion": row["fecha_creacion"],
                "fecha_modificacion": row["fecha_modificacion"],
                "configuracion": json.loads(row["configuracion"] or "{}"),
                "stats": {
                    "total_nodos": row["total_nodos"],
                    "total_registros": row["total_registros"],
                    "total_snippets": row["total_snippets"]
                }
            })
        
        conn.close()
        return jsonify(projects)
    except Exception as e:
        print(f"Error getting projects: {str(e)}")
        return jsonify({"error": str(e)}), 500

@projects_bp.route('', methods=['POST'])
def create_project():
    try:
        data = request.get_json()
        nombre = data.get('nombre')
        descripcion = data.get('descripcion', '')
        
        if not nombre:
            return jsonify({"error": "El nombre del proyecto es requerido"}), 400
        
        conn = get_db_connection()
        cursor = conn.cursor()
        
        # Verificar si ya existe un proyecto con el mismo nombre (activo o inactivo)
        cursor.execute("""
            SELECT id, activo FROM proyectos 
            WHERE nombre = ? 
            ORDER BY fecha_modificacion DESC
            LIMIT 1
        """, (nombre,))
        existing_project = cursor.fetchone()
        
        # Si existe un proyecto activo con el mismo nombre
        if existing_project and existing_project["activo"] == 1:
            conn.close()
            return jsonify({
                "error": f"Ya existe un proyecto activo con el nombre '{nombre}'",
                "project_id": existing_project["id"],
                "exists": True,
                "active": True
            }), 409
        
        # Si existe un proyecto inactivo con el mismo nombre
        if existing_project and existing_project["activo"] == 0:
            conn.close()
            return jsonify({
                "error": f"Ya existe un proyecto archivado con el nombre '{nombre}'",
                "project_id": existing_project["id"],
                "exists": True,
                "active": False
            }), 409
        
        # Crear directorio del proyecto
        project_path = os.path.join("projects", nombre)
        os.makedirs(project_path, exist_ok=True)
        os.makedirs(os.path.join(project_path, "snippets"), exist_ok=True)
        os.makedirs(os.path.join(project_path, "exports"), exist_ok=True)
        
        now = datetime.now().isoformat()
        cursor.execute("""
            INSERT INTO proyectos (nombre, descripcion, ruta_base, fecha_creacion, fecha_modificacion)
            VALUES (?, ?, ?, ?, ?)
        """, (nombre, descripcion, f"projects/{nombre}", now, now))
        
        project_id = cursor.lastrowid
        conn.commit()
        conn.close()
        
        return jsonify({
            "success": True, 
            "project_id": project_id,
            "message": f"Proyecto '{nombre}' creado exitosamente"
        })
    except Exception as e:
        return jsonify({"success": False, "message": str(e)}), 500

@projects_bp.route('<int:project_id>/reactivate', methods=['PUT'])
def reactivate_project(project_id):
    """Reactiva un proyecto archivado"""
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        
        # Verificar si el proyecto existe
        cursor.execute("SELECT * FROM proyectos WHERE id = ?", (project_id,))
        project = cursor.fetchone()
        
        if not project:
            return jsonify({"error": "Proyecto no encontrado"}), 404
        
        # Reactivar el proyecto
        now = datetime.now().isoformat()
        cursor.execute("""
            UPDATE proyectos 
            SET activo = 1, fecha_modificacion = ?
            WHERE id = ?
        """, (now, project_id))
        
        conn.commit()
        conn.close()
        
        return jsonify({
            "success": True,
            "message": f"Proyecto '{project['nombre']}' reactivado exitosamente"
        })
    except Exception as e:
        return jsonify({"success": False, "message": str(e)}), 500

@projects_bp.route('/check-name', methods=['POST'])
def check_project_name():
    """Verifica si un nombre de proyecto está disponible"""
    try:
        data = request.get_json()
        nombre = data.get('nombre')
        
        if not nombre:
            return jsonify({"error": "El nombre del proyecto es requerido"}), 400
        
        conn = get_db_connection()
        cursor = conn.cursor()
        
        cursor.execute("""
            SELECT id, activo FROM proyectos 
            WHERE nombre = ? 
            ORDER BY fecha_modificacion DESC
            LIMIT 1
        """, (nombre,))
        existing_project = cursor.fetchone()
        conn.close()
        
        if existing_project:
            return jsonify({
                "available": False,
                "active": existing_project["activo"] == 1,
                "project_id": existing_project["id"]
            })
        
        return jsonify({"available": True})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@projects_bp.route('<int:project_id>', methods=['PUT'])
def update_project(project_id):
    """Actualiza un proyecto"""
    try:
        data = request.get_json()
        
        conn = get_db_connection()
        cursor = conn.cursor()
        
        now = datetime.now().isoformat()
        cursor.execute("""
            UPDATE proyectos 
            SET nombre = ?, descripcion = ?, fecha_modificacion = ?
            WHERE id = ?
        """, (data.get('nombre'), data.get('descripcion'), now, project_id))
        
        conn.commit()
        conn.close()
        
        return jsonify({"success": True, "message": "Proyecto actualizado"})
    except Exception as e:
        return jsonify({"success": False, "message": str(e)}), 500

@projects_bp.route('<int:project_id>', methods=['DELETE'])
def delete_project(project_id):
    """Elimina un proyecto (soft delete)"""
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        
        cursor.execute("UPDATE proyectos SET activo = 0 WHERE id = ?", (project_id,))
        conn.commit()
        conn.close()
        
        return jsonify({"success": True, "message": "Proyecto eliminado"})
    except Exception as e:
        return jsonify({"success": False, "message": str(e)}), 500

@projects_bp.route('<int:project_id>/export', methods=['GET'])
def export_project(project_id):
    """Exporta todo el proyecto a JSON"""
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        
        # Obtener proyecto
        cursor.execute("SELECT * FROM proyectos WHERE id = ?", (project_id,))
        project = cursor.fetchone()
        
        if not project:
            return jsonify({"error": "Proyecto no encontrado"}), 404
        
        # Obtener nodos
        cursor.execute("SELECT * FROM arbol_nodos WHERE proyecto_id = ? ORDER BY orden", (project_id,))
        nodes = cursor.fetchall()
        
        # Obtener registros
        cursor.execute("SELECT * FROM registros WHERE proyecto_id = ? ORDER BY orden", (project_id,))
        records = cursor.fetchall()
        
        # Obtener snippets
        cursor.execute("SELECT * FROM code_snippets WHERE proyecto_id = ? ORDER BY orden", (project_id,))
        snippets = cursor.fetchall()
        
        export_data = {
            "project": dict(project),
            "nodes": [dict(node) for node in nodes],
            "records": [dict(record) for record in records],
            "snippets": [dict(snippet) for snippet in snippets],
            "export_date": datetime.now().isoformat()
        }
        
        conn.close()
        return jsonify(export_data)
    except Exception as e:
        return jsonify({"error": str(e)}), 500

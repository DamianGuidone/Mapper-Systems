from flask import Blueprint, request, jsonify
import os
from datetime import datetime
from models.database import get_db_connection

diagramas_bp = Blueprint('diagramas', __name__)

# Tipos de diagrama con los nombres EXACTOS que Mermaid espera
MERMAID_DIAGRAM_TYPES = {
    "flowchart": "Diagrama de Flujo",
    "sequenceDiagram": "Diagrama de Secuencia",
    "classDiagram": "Diagrama de Clases",  # ¡CORREGIDO! No "class"
    "stateDiagram": "Diagrama de Estados",  # ¡CORREGIDO! No "state"
    "erDiagram": "Diagrama ER",            # ¡CORREGIDO! No "entity-relationship"
    "journey": "User Journey",             # ¡CORREGIDO! No "user-journey"
    "requirementDiagram": "Diagrama de Requerimientos",  # ¡CORREGIDO! No "requirement"
    "gantt": "Diagrama de Gantt",
    "pie": "Gráfico Circular",
    "gitgraph": "Diagrama Git",
    "mindmap": "Mapa Mental",
    "timeline": "Línea de Tiempo",
    "quadrantChart": "Gráfico de Cuadrantes",
    "C4Context": "Diagrama C4",
    "xychart": "Gráfico XY",
    "block": "Diagrama de Bloques",
    "packet": "Diagrama de Paquetes",
    "kanban": "Tablero Kanban",
    "architecture": "Diagrama de Arquitectura",
    "radar": "Gráfico Radar"
}

@diagramas_bp.route('', methods=['GET'])
def obtener_diagramas():
    """Obtiene diagramas de un nodo específico"""
    try:
        nodo_id = request.args.get('nodo_id')
        proyecto_id = request.args.get('proyecto_id')
        
        if not nodo_id or not proyecto_id:
            return jsonify({"error": "nodo_id y proyecto_id son requeridos"}), 400
        
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("""
            SELECT * FROM mermaid_diagrams 
            WHERE nodo_id = ? AND proyecto_id = ? 
            ORDER BY orden ASC
        """, (nodo_id, proyecto_id))
        rows = cursor.fetchall()
        
        diagramas = []
        for row in rows:
            diagramas.append({
                "id": row["id"],
                "titulo": row["titulo"],
                "descripcion": row["descripcion"],
                "tipo_diagrama": row["tipo_diagrama"],
                "codigo_mermaid": row["codigo_mermaid"],
                "archivo_ruta": row["archivo_ruta"],
                "orden": row["orden"],
                "fecha_creacion": row["fecha_creacion"],
                "fecha_modificacion": row["fecha_modificacion"],
                "nodo_id": row["nodo_id"],
                "proyecto_id": row["proyecto_id"]
            })
        
        conn.close()
        return jsonify(diagramas)
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@diagramas_bp.route('', methods=['POST'])
def guardar_diagrama():
    """Guarda o actualiza un diagrama"""
    try:
        data = request.get_json()
        
        # Validar tipo de diagrama con los nombres correctos
        tipo_diagrama = data.get("tipo_diagrama", "flowchart")
        if tipo_diagrama not in MERMAID_DIAGRAM_TYPES:
            return jsonify({
                "success": False, 
                "error": f"Tipo de diagrama inválido. Tipos válidos: {', '.join(MERMAID_DIAGRAM_TYPES.keys())}"
            }), 400
        
        conn = get_db_connection()
        cursor = conn.cursor()
        
        now = datetime.now().isoformat()
        
        if data.get('id'):
            # Actualizar diagrama existente
            cursor.execute("""
                UPDATE mermaid_diagrams 
                SET titulo = ?, descripcion = ?, tipo_diagrama = ?, codigo_mermaid = ?, 
                    orden = ?, fecha_modificacion = ?
                WHERE id = ?
            """, (
                data["titulo"], data.get("descripcion"), tipo_diagrama, 
                data["codigo_mermaid"], data["orden"], now, data["id"]
            ))
            mensaje = "Diagrama actualizado exitosamente"
        else:
            # Crear nuevo diagrama
            cursor.execute("""
                INSERT INTO mermaid_diagrams 
                (nodo_id, proyecto_id, titulo, descripcion, tipo_diagrama, codigo_mermaid, orden, fecha_creacion, fecha_modificacion)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
            """, (
                data["nodo_id"], data["proyecto_id"], data["titulo"], data.get("descripcion"),
                tipo_diagrama, data["codigo_mermaid"], data["orden"], now, now
            ))
            
            diagrama_id = cursor.lastrowid
            mensaje = "Diagrama creado exitosamente"
            
            # Crear archivo físico si es necesario
            if data.get("guardar_archivo", True):
                project_path = f"projects/{data['proyecto_id']}/diagrams"
                os.makedirs(project_path, exist_ok=True)
                
                filename = f"{data['nodo_id']}_{diagrama_id}.mmd"
                file_path = os.path.join(project_path, filename)
                
                with open(file_path, 'w', encoding='utf-8') as f:
                    f.write(data["codigo_mermaid"])
                
                # Actualizar ruta del archivo
                cursor.execute("""
                    UPDATE mermaid_diagrams SET archivo_ruta = ? WHERE id = ?
                """, (file_path, diagrama_id))
        
        conn.commit()
        conn.close()
        return jsonify({"success": True, "message": mensaje})
    except Exception as e:
        return jsonify({"success": False, "error": str(e)}), 500

@diagramas_bp.route('/<int:diagrama_id>', methods=['DELETE'])
def eliminar_diagrama(diagrama_id):
    """Elimina un diagrama"""
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        
        # Obtener info del diagrama antes de eliminarlo
        cursor.execute("SELECT archivo_ruta FROM mermaid_diagrams WHERE id = ?", (diagrama_id,))
        row = cursor.fetchone()
        
        if row and row["archivo_ruta"] and os.path.exists(row["archivo_ruta"]):
            try:
                os.remove(row["archivo_ruta"])
            except Exception as e:
                print(f"Error eliminando archivo físico: {e}")
        
        cursor.execute("DELETE FROM mermaid_diagrams WHERE id = ?", (diagrama_id,))
        conn.commit()
        conn.close()
        
        return jsonify({"success": True, "message": "Diagrama eliminado"})
    except Exception as e:
        return jsonify({"success": False, "error": str(e)}), 500

@diagramas_bp.route('/validar', methods=['POST'])
def validar_codigo_mermaid():
    """Valida sintaxis de código Mermaid"""
    try:
        data = request.get_json()
        codigo = data.get('codigo_mermaid', '')
        
        # Validaciones básicas de sintaxis Mermaid
        errores = []
        sugerencias = []
        
        if not codigo.strip():
            errores.append("El código no puede estar vacío")
            return jsonify({
                "valido": False,
                "errores": errores,
                "sugerencias": ["Escribe tu diagrama Mermaid en el editor"]
            })
        
        # Validar que tenga un tipo de diagrama válido al inicio
        tipos_validos = list(MERMAID_DIAGRAM_TYPES.keys())
        primera_linea = codigo.strip().split('\n')[0].strip().lower()
        
        # Extraer el tipo de diagrama de la primera línea
        tipo_diagrama = None
        for tipo in tipos_validos:
            if primera_linea.startswith(tipo.lower()):
                tipo_diagrama = tipo
                break
        
        if not tipo_diagrama:
            errores.append(f"Tipo de diagrama no reconocido. Debe comenzar con: {', '.join(tipos_validos[:5])}...")
            sugerencias.append("Verifica que el código empiece con el tipo de diagrama correcto")
        else:
            # Validaciones específicas por tipo de diagrama
            if tipo_diagrama == "classDiagram":
                if not any(x in codigo for x in ["class", "interface", "abstract"]):
                    errores.append("El diagrama de clases debe contener al menos una clase, interfaz o clase abstracta")
                if not any(x in codigo for x in ["-->", "<--", "--|>", "<|--", "..>", "<.."]):
                    errores.append("El diagrama de clases debe tener al menos una relación entre clases")
                sugerencias.append("Usa la sintaxis 'class Nombre { ... }' para definir clases")
                sugerencias.append("Ejemplo: 'class Usuario { +String nombre +login() }'")
            
            elif tipo_diagrama == "stateDiagram":
                if "[*]" not in codigo and not any(x in codigo for x in ["state", "initial", "final"]):
                    errores.append("El diagrama de estados debe tener estados definidos (ej. [*] para estado inicial)")
                if not any(x in codigo for x in ["-->", "--", "->", "→"]):
                    errores.append("El diagrama de estados debe tener transiciones entre estados")
                sugerencias.append("Usa '[*] --> Estado' para definir transiciones desde el estado inicial")
                sugerencias.append("Para estados compuestos, usa 'state Nombre { ... }'")
            
            elif tipo_diagrama == "erDiagram":
                if not any(x in codigo for x in ["||--", "o|--", "}|--", "||--o", "||--{", "o{--o"]):
                    errores.append("El diagrama ER debe tener relaciones entre entidades (ej. ||--o{)")
                if not any(x in codigo for x in ["{", "}"]):
                    errores.append("El diagrama ER debe definir entidades con bloques { }")
                sugerencias.append("Formato de relación: 'ENTIDAD1 ||--o{ ENTIDAD2 : \"descripción\"'")
                sugerencias.append("Define atributos dentro de los bloques de entidad")
            
            elif tipo_diagrama == "requirementDiagram":
                if "requirement" not in codigo.lower():
                    errores.append("El diagrama de requerimientos debe contener al menos un elemento 'requirement'")
                if not any(x in codigo for x in ["satisfies", "verifies", "contains"]):
                    errores.append("El diagrama de requerimientos debe tener relaciones entre elementos")
                sugerencias.append("Formato de requerimiento: 'requirement Nombre { id: X text: \"Texto\" }'")
                sugerencias.append("Define relaciones con 'element - relation -> requirement'")
            
            elif tipo_diagrama == "journey":
                if "title" not in primera_linea and "journey" not in primera_linea:
                    errores.append("El user journey debe tener un título definido")
                if "section" not in codigo and ":" not in codigo:
                    errores.append("El user journey debe tener al menos una sección o paso definido")
                sugerencias.append("Formato básico: 'journey\\ntitle Título\\nsection Nombre\\nPaso: X: Actor'")
        
        # Validación adicional para todos los tipos
        if "-->" not in codigo and "->" not in codigo and "→" not in codigo and tipo_diagrama not in ["pie", "gantt"]:
            errores.append("El diagrama parece no tener conexiones. Usa -->, -> o → para definir relaciones")
        
        return jsonify({
            "valido": len(errores) == 0,
            "errores": errores,
            "sugerencias": sugerencias
        })
        
    except Exception as e:
        return jsonify({
            "valido": False,
            "errores": [f"Error de validación: {str(e)}"],
            "sugerencias": [
                "Verifica que el código esté completo",
                "Revisa la sintaxis en Mermaid Live Editor (mermaid.live)"
            ]
        }), 500
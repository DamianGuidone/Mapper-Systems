from flask import Blueprint, request, jsonify, send_file
import os
import urllib.parse
import re
from utils.helpers import clean_sql_path

files_bp = Blueprint('files', __name__)

@files_bp.route('read', methods=['GET'])
def read_file():
    """Lee el contenido de un archivo desde Archive/"""
    try:
        encoded_path = request.args.get('path', '')
        if not encoded_path:
            return jsonify({"error": "Ruta no especificada"}), 400
        
        path = clean_sql_path(encoded_path)
        full_path = os.path.normpath(os.path.join("Archive", path))
        
        if not os.path.exists(full_path):
            return jsonify({"error": "Archivo no encontrado"}), 404
        
        with open(full_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        return jsonify({"content": content, "path": path})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@files_bp.route('explore', methods=['GET'])
def explore_directory():
    """Explora el directorio Archive/ y devuelve la estructura"""
    try:
        path = request.args.get('path', '')
        safe_path = clean_sql_path(path) if path else "Archive"
        full_path = os.path.normpath(os.path.join(".", safe_path))
        
        if not os.path.exists(full_path):
            return jsonify({"error": "Directorio no encontrado"}), 404
        
        items = []
        for item in sorted(os.listdir(full_path)):
            item_path = os.path.join(full_path, item)
            relative_path = os.path.relpath(item_path, "Archive")
            
            is_dir = os.path.isdir(item_path)
            file_info = {
                "name": item,
                "path": relative_path,
                "is_directory": is_dir,
                "type": "folder" if is_dir else get_file_type(item)
            }
            items.append(file_info)
        
        return jsonify({"items": items, "current_path": safe_path})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@files_bp.route('open', methods=['POST'])
def open_file():
    """Abre un archivo con el programa por defecto del sistema"""
    try:
        data = request.get_json()
        encoded_path = data.get('path', '')
        
        if not encoded_path:
            return jsonify({"error": "Ruta no especificada"}), 400
        
        path = clean_sql_path(encoded_path)
        full_path = os.path.normpath(os.path.join("Archive", path))
        
        if not os.path.exists(full_path):
            return jsonify({"error": "Archivo no encontrado"}), 404
        
        os.startfile(full_path)  # Windows
        # Para Linux/Mac: os.system(f'xdg-open "{full_path}"')
        
        return jsonify({"success": True, "message": "Archivo abierto"})
    except Exception as e:
        return jsonify({"success": False, "error": str(e)}), 500

def get_file_type(filename):
    """Determina el tipo de archivo basado en la extensión"""
    ext = os.path.splitext(filename)[1].lower()
    if ext == ".sql":
        return "database"
    elif ext in [".js", ".ts"]:
        return "javascript"
    elif ext in [".cs"]:
        return "csharp"
    elif ext in [".html", ".htm"]:
        return "html"
    elif ext == ".json":
        return "json"
    else:
        return "file"

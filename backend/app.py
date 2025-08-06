from flask import Flask, request, jsonify, send_file
from flask_cors import CORS
import os
import json
from routes.projects import projects_bp
from routes.nodes import nodes_bp
from routes.files import files_bp
from routes.registros import registros_bp  # Cambiado de records a registros
from routes.snippets import snippets_bp
from routes.diagramas import diagramas_bp  # Cambiado de diagrams a diagramas
from models.database import init_db

app = Flask(__name__)
CORS(app)  # Permitir requests desde el frontend React

# Registrar blueprints con nombres en español
app.register_blueprint(projects_bp, url_prefix='/api/projects')
app.register_blueprint(nodes_bp, url_prefix='/api/nodes')
app.register_blueprint(files_bp, url_prefix='/api/files')
app.register_blueprint(registros_bp, url_prefix='/api/registros')  # Cambiado
app.register_blueprint(snippets_bp, url_prefix='/api/snippets')
app.register_blueprint(diagramas_bp, url_prefix='/api/diagramas')  # Cambiado

@app.route('/api/user', methods=['GET'])
def get_user():
    import getpass
    user = getpass.getuser()
    return jsonify({"usuario": user})

@app.route('/api/health', methods=['GET'])
def health_check():
    return jsonify({"status": "ok", "message": "Backend Flask funcionando correctamente"})

@app.route('/api/debug', methods=['GET'])
def debug_info():
    """Endpoint para debug general"""
    return jsonify({
        "status": "ok",
        "message": "API funcionando con endpoints en español",
        "endpoints": {
            "projects": "/api/projects",
            "nodes": "/api/nodes", 
            "files": "/api/files",
            "registros": "/api/registros",  # Actualizado
            "snippets": "/api/snippets",
            "diagramas": "/api/diagramas"   # Actualizado
        },
        "files": {
            "db_exists": os.path.exists("db/sp.db"),
            "projects_exists": os.path.exists("projects"),
            "archive_exists": os.path.exists("Archive")
        },
        "directories": {
            "current": os.getcwd(),
            "projects": os.listdir("projects") if os.path.exists("projects") else []
        }
    })

if __name__ == '__main__':
    # Crear directorios necesarios
    os.makedirs("db", exist_ok=True)
    os.makedirs("projects", exist_ok=True)
    os.makedirs("Archive", exist_ok=True)
    
    # Inicializar base de datos
    init_db()
    
    print("🚀 Servidor Flask iniciando en puerto 3004...")
    print("📁 Archivos disponibles:")
    print(f"   - db/sp.db: {'✅' if os.path.exists('db/sp.db') else '❌'}")
    print(f"   - projects/: {'✅' if os.path.exists('projects') else '❌'}")
    print(f"   - Archive/: {'✅' if os.path.exists('Archive') else '❌'}")
    print("\n🌐 Endpoints disponibles:")
    print("   - /api/projects - Gestión de proyectos")
    print("   - /api/nodes - Árbol de nodos")
    print("   - /api/registros - Registros de código")
    print("   - /api/snippets - Fragmentos de código")
    print("   - /api/diagramas - Diagramas Mermaid")
    print("   - /api/files - Explorador de archivos")
    
    app.run(host='0.0.0.0', port=3004, debug=True)

#!/usr/bin/env python3
"""
Script para poblar la base de datos con datos de ejemplo
Crea proyectos, nodos, registros y snippets de muestra
"""

import os
import sys
import json
from datetime import datetime, timedelta

# Agregar el directorio padre al path
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from models.database import get_db_connection, init_db

def create_sample_projects():
    """Crea proyectos de ejemplo"""
    conn = get_db_connection()
    cursor = conn.cursor()
    
    now = datetime.now().isoformat()
    
    projects = [
        {
            "nombre": "Sistema de Usuarios",
            "descripcion": "Gestión completa de usuarios, autenticación y permisos",
            "ruta_base": "projects/usuarios"
        },
        {
            "nombre": "E-commerce API",
            "descripcion": "API REST para tienda online con productos, carritos y pagos",
            "ruta_base": "projects/ecommerce"
        },
        {
            "nombre": "Dashboard Analytics",
            "descripcion": "Panel de control con métricas y reportes en tiempo real",
            "ruta_base": "projects/dashboard"
        }
    ]
    
    project_ids = []
    for project in projects:
        cursor.execute("""
            INSERT INTO proyectos (nombre, descripcion, ruta_base, fecha_creacion, fecha_modificacion)
            VALUES (?, ?, ?, ?, ?)
        """, (project["nombre"], project["descripcion"], project["ruta_base"], now, now))
        project_ids.append(cursor.lastrowid)
    
    conn.commit()
    conn.close()
    
    print(f"✅ Creados {len(projects)} proyectos de ejemplo")
    return project_ids

def create_sample_nodes(project_id, project_name):
    """Crea nodos de ejemplo para un proyecto"""
    conn = get_db_connection()
    cursor = conn.cursor()
    
    now = datetime.now().isoformat()
    
    # Estructura de nodos según el tipo de proyecto
    if "Usuarios" in project_name:
        nodes = [
            {
                "id": f"users_root_{project_id}",
                "text": "Sistema de Usuarios",
                "type": "default",
                "parent": "#",
                "data": {
                    "descripcion": "Módulo principal de gestión de usuarios",
                    "tipo_nodo": "carpeta"
                }
            },
            {
                "id": f"auth_{project_id}",
                "text": "Autenticación",
                "type": "default",
                "parent": f"users_root_{project_id}",
                "data": {
                    "descripcion": "Lógica de login, logout y tokens",
                    "tipo_nodo": "carpeta"
                }
            },
            {
                "id": f"login_sp_{project_id}",
                "text": "sp_ValidarLogin",
                "type": "leaf",
                "parent": f"auth_{project_id}",
                "data": {
                    "descripcion": "Stored procedure para validar credenciales de usuario",
                    "tipo_nodo": "bd",
                    "archivo": "scripts/usuarios/sp_ValidarLogin.sql"
                }
            },
            {
                "id": f"user_controller_{project_id}",
                "text": "UserController.cs",
                "type": "leaf",
                "parent": f"auth_{project_id}",
                "data": {
                    "descripcion": "Controlador principal de usuarios en C#",
                    "tipo_nodo": "cs"
                }
            }
        ]
    elif "E-commerce" in project_name:
        nodes = [
            {
                "id": f"ecom_root_{project_id}",
                "text": "E-commerce API",
                "type": "default",
                "parent": "#",
                "data": {
                    "descripcion": "API REST para tienda online",
                    "tipo_nodo": "carpeta"
                }
            },
            {
                "id": f"products_{project_id}",
                "text": "Productos",
                "type": "default",
                "parent": f"ecom_root_{project_id}",
                "data": {
                    "descripcion": "Gestión de catálogo de productos",
                    "tipo_nodo": "carpeta"
                }
            },
            {
                "id": f"product_api_{project_id}",
                "text": "ProductsAPI.js",
                "type": "leaf",
                "parent": f"products_{project_id}",
                "data": {
                    "descripcion": "Endpoints REST para productos",
                    "tipo_nodo": "js"
                }
            }
        ]
    else:  # Dashboard
        nodes = [
            {
                "id": f"dash_root_{project_id}",
                "text": "Dashboard Analytics",
                "type": "default",
                "parent": "#",
                "data": {
                    "descripcion": "Panel de control y métricas",
                    "tipo_nodo": "carpeta"
                }
            },
            {
                "id": f"reports_{project_id}",
                "text": "Reportes",
                "type": "leaf",
                "parent": f"dash_root_{project_id}",
                "data": {
                    "descripcion": "Generación de reportes automáticos",
                    "tipo_nodo": "reporte"
                }
            }
        ]
    
    # Insertar nodos
    for i, node in enumerate(nodes):
        cursor.execute("""
            INSERT INTO arbol_nodos 
            (id, proyecto_id, text, type, parent, data, orden, fecha_creacion, fecha_modificacion)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
        """, (
            node["id"], project_id, node["text"], node["type"], 
            node["parent"], json.dumps(node["data"]), i, now, now
        ))
    
    conn.commit()
    conn.close()
    
    print(f"   ✅ Creados {len(nodes)} nodos para {project_name}")
    return [node["id"] for node in nodes]

def create_sample_records(project_id, node_ids):
    """Crea registros de ejemplo"""
    conn = get_db_connection()
    cursor = conn.cursor()
    
    now = datetime.now().isoformat()
    
    # Solo crear registros para nodos que no sean carpetas
    code_nodes = [nid for nid in node_ids if not nid.endswith("_root_" + str(project_id))]
    
    sample_records = [
        {
            "archivo": "src/controllers/UserController.cs",
            "ubicacion": "Línea 45-67",
            "funcion": "ValidateUser()",
            "descripcion": "Valida credenciales y retorna token JWT"
        },
        {
            "archivo": "src/services/AuthService.js",
            "ubicacion": "Método principal",
            "funcion": "authenticateUser()",
            "descripcion": "Servicio de autenticación con bcrypt"
        },
        {
            "archivo": "database/procedures/sp_GetUserProfile.sql",
            "ubicacion": "Stored Procedure",
            "funcion": "sp_GetUserProfile",
            "descripcion": "Obtiene perfil completo del usuario por ID"
        }
    ]
    
    record_count = 0
    for node_id in code_nodes[:2]:  # Solo primeros 2 nodos
        for i, record in enumerate(sample_records[:2]):  # Solo 2 registros por nodo
            cursor.execute("""
                INSERT INTO registros 
                (nodo_id, proyecto_id, archivo, ubicacion, funcion, descripcion, orden, fecha_creacion, fecha_modificacion)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
            """, (
                node_id, project_id, record["archivo"], record["ubicacion"],
                record["funcion"], record["descripcion"], i + 1, now, now
            ))
            record_count += 1
    
    conn.commit()
    conn.close()
    
    print(f"   ✅ Creados {record_count} registros de ejemplo")

def create_sample_snippets(project_id, node_ids):
    """Crea snippets de código de ejemplo"""
    conn = get_db_connection()
    cursor = conn.cursor()
    
    now = datetime.now().isoformat()
    
    sample_snippets = [
        {
            "titulo": "Validación de JWT Token",
            "descripcion": "Middleware para validar tokens JWT en requests",
            "lenguaje": "javascript",
            "codigo": """const jwt = require('jsonwebtoken');

const validateToken = (req, res, next) => {
    const token = req.headers.authorization?.split(' ')[1];
    
    if (!token) {
        return res.status(401).json({ error: 'Token requerido' });
    }
    
    try {
        const decoded = jwt.verify(token, process.env.JWT_SECRET);
        req.user = decoded;
        next();
    } catch (error) {
        return res.status(403).json({ error: 'Token inválido' });
    }
};

module.exports = validateToken;"""
        },
        {
            "titulo": "Hash de Password",
            "descripcion": "Función para hashear passwords con bcrypt",
            "lenguaje": "csharp",
            "codigo": """using BCrypt.Net;

public class PasswordHelper
{
    public static string HashPassword(string password)
    {
        return BCrypt.HashPassword(password, BCrypt.GenerateSalt(12));
    }
    
    public static bool VerifyPassword(string password, string hash)
    {
        return BCrypt.Verify(password, hash);
    }
}"""
        },
        {
            "titulo": "Query de Usuario por Email",
            "descripcion": "Stored procedure para buscar usuario por email",
            "lenguaje": "sql",
            "codigo": """CREATE PROCEDURE sp_GetUserByEmail
    @Email NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        u.Id,
        u.Email,
        u.FirstName,
        u.LastName,
        u.PasswordHash,
        u.IsActive,
        u.CreatedAt,
        u.LastLoginAt
    FROM Users u
    WHERE u.Email = @Email
        AND u.IsActive = 1;
END"""
        }
    ]
    
    snippet_count = 0
    for node_id in node_ids[:3]:  # Primeros 3 nodos
        for i, snippet in enumerate(sample_snippets):
            cursor.execute("""
                INSERT INTO code_snippets 
                (nodo_id, proyecto_id, titulo, descripcion, lenguaje, codigo, orden, fecha_creacion, fecha_modificacion)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
            """, (
                node_id, project_id, snippet["titulo"], snippet["descripcion"],
                snippet["lenguaje"], snippet["codigo"], i + 1, now, now
            ))
            snippet_count += 1
            break  # Solo 1 snippet por nodo
    
    conn.commit()
    conn.close()
    
    print(f"   ✅ Creados {snippet_count} snippets de ejemplo")

def create_sample_diagrams(project_id, node_ids):
    """Crea diagramas Mermaid de ejemplo"""
    conn = get_db_connection()
    cursor = conn.cursor()
    
    now = datetime.now().isoformat()
    
    sample_diagrams = [
        {
            "titulo": "Flujo de Autenticación",
            "descripcion": "Diagrama de secuencia del proceso de login",
            "tipo_diagrama": "sequence",
            "codigo_mermaid": """sequenceDiagram
    participant U as Usuario
    participant F as Frontend
    participant A as API
    participant D as Database
    
    U->>F: Ingresa credenciales
    F->>A: POST /auth/login
    A->>D: Validar usuario
    D-->>A: Usuario válido
    A-->>F: JWT Token
    F-->>U: Acceso concedido"""
        },
        {
            "titulo": "Arquitectura del Sistema",
            "descripcion": "Diagrama de la arquitectura general",
            "tipo_diagrama": "flowchart",
            "codigo_mermaid": """flowchart TD
    A[Cliente Web] --> B[Load Balancer]
    B --> C[API Gateway]
    C --> D[Auth Service]
    C --> E[User Service]
    C --> F[Product Service]
    D --> G[(Database)]
    E --> G
    F --> G
    G --> H[Cache Redis]"""
        }
    ]
    
    diagram_count = 0
    for node_id in node_ids[:2]:  # Primeros 2 nodos
        for i, diagram in enumerate(sample_diagrams):
            cursor.execute("""
                INSERT INTO mermaid_diagrams 
                (nodo_id, proyecto_id, titulo, descripcion, tipo_diagrama, codigo_mermaid, orden, fecha_creacion, fecha_modificacion)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
            """, (
                node_id, project_id, diagram["titulo"], diagram["descripcion"],
                diagram["tipo_diagrama"], diagram["codigo_mermaid"], i + 1, now, now
            ))
            diagram_count += 1
            break  # Solo 1 diagrama por nodo
    
    conn.commit()
    conn.close()
    
    print(f"   ✅ Creados {diagram_count} diagramas de ejemplo")

def seed_sample_data():
    """Función principal para poblar con datos de ejemplo"""
    print("🌱 Poblando base de datos con datos de ejemplo...")
    
    # Inicializar BD
    init_db()
    
    # Crear proyectos
    project_ids = create_sample_projects()
    
    # Para cada proyecto, crear contenido
    project_names = ["Sistema de Usuarios", "E-commerce API", "Dashboard Analytics"]
    
    for project_id, project_name in zip(project_ids, project_names):
        print(f"\n📁 Creando contenido para: {project_name}")
        
        # Crear nodos
        node_ids = create_sample_nodes(project_id, project_name)
        
        # Crear registros
        create_sample_records(project_id, node_ids)
        
        # Crear snippets
        create_sample_snippets(project_id, node_ids)
        
        # Crear diagramas
        create_sample_diagrams(project_id, node_ids)
    
    print(f"\n✅ Datos de ejemplo creados exitosamente!")
    print(f"   📊 {len(project_ids)} proyectos")
    print(f"   🌳 Múltiples nodos por proyecto")
    print(f"   📝 Registros de código")
    print(f"   💾 Snippets de ejemplo")
    print(f"   📊 Diagramas Mermaid")

if __name__ == "__main__":
    seed_sample_data()

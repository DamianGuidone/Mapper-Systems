#!/bin/bash
# Script de configuración inicial para el proyecto

echo "🚀 Configurando proyecto Guía de SPs..."

# Crear directorios necesarios
echo "📁 Creando directorios..."
mkdir -p db
mkdir -p projects
mkdir -p Archive
mkdir -p backups
mkdir -p tools

# Instalar dependencias de Python (si es necesario)
echo "📦 Verificando dependencias..."
pip install flask flask-cors python-dotenv

# Hacer scripts ejecutables
echo "🔧 Configurando permisos..."
chmod +x tools/*.py
chmod +x tools/*.sh

# Resetear y poblar base de datos
echo "🗄️ Configurando base de datos..."
python tools/reset_database.py
python tools/seed_sample_data.py

echo "✅ Configuración completada!"
echo ""
echo "🎯 Próximos pasos:"
echo "   1. Ejecutar: python backend/app.py"
echo "   2. Ejecutar: cd frontend && npm run dev"
echo "   3. Abrir: http://localhost:5004"
echo ""
echo "🛠️ Scripts disponibles:"
echo "   - tools/reset_database.py    - Resetear BD"
echo "   - tools/seed_sample_data.py  - Datos de ejemplo"
echo "   - tools/backup_database.py   - Crear backup"
echo "   - tools/restore_database.py  - Restaurar backup"
echo "   - tools/migrate_from_json.py - Migrar desde JSON"

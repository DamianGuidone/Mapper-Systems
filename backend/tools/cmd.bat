# Configuración inicial completa
chmod +x tools/setup.sh
./tools/setup.sh

# O paso a paso:
python tools/reset_database.py      # Resetear BD
python tools/seed_sample_data.py    # Datos de ejemplo
python tools/check_system.py        # Verificar estado

# Migración desde JSON (si existe)
python tools/migrate_from_json.py

# Backups
python tools/backup_database.py
python tools/restore_database.py backups/backup_database_20250131_133000.json
import os
import json
from datetime import datetime

# Rutas
DATA_JSON = "data.json"
HISTORY_DIR = "history"

# Crear directorio si no existe
os.makedirs(HISTORY_DIR, exist_ok=True)

def generate_initial_history_entry(node):
    """Genera una entrada inicial de historial para el nodo"""
    return {
        "fecha": datetime.now().isoformat(),
        "campo": "nuevo_nodo",
        "anterior": "",
        "nuevo": node.get("text", ""),
        "usuario": "Damian"
    }

def main():
    # Cargar data.json
    with open(DATA_JSON, "r", encoding="utf-8") as f:
        tree_data = json.load(f)

    for node in tree_data:
        node_id = node.get("id")
        if not node_id:
            print("⚠️ Nodo sin ID:", node)
            continue

        history_file = os.path.join(HISTORY_DIR, f"{node_id}.json")

        if os.path.exists(history_file):
            print(f"✅ {history_file} ya existe")
            continue

        # Crear entrada inicial
        initial_entry = [generate_initial_history_entry(node)]
        with open(history_file, "w", encoding="utf-8") as f:
            json.dump(initial_entry, f, indent=2)
        
        print(f"🟢 Archivo creado: {history_file}")

    print("\n✅ Proceso terminado.")

if __name__ == "__main__":
    main()
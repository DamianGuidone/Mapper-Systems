import os
import json

# Ruta del archivo principal
DATA_JSON = "data.json"
HISTORY_DIR = "history"

def migrate_historial():
    # Crear directorio history si no existe
    os.makedirs(HISTORY_DIR, exist_ok=True)

    # Cargar data.json
    with open(DATA_JSON, "r", encoding="utf-8") as f:
        tree_data = json.load(f)

    # Recorrer todos los nodos del árbol
    for node in tree_data:
        if "data" in node and "historial" in node["data"]:
            node_id = node["id"]
            history_entries = node["data"]["historial"]

            # Guardar historial en su propio .json
            history_path = os.path.join(HISTORY_DIR, f"{node_id}.json")

            with open(history_path, "w", encoding="utf-8") as f:
                json.dump(history_entries, f, indent=2)

            # Eliminar historial del data.json
            node["data"].pop("historial", None)
            node["data"]["historial_file"] = f"{HISTORY_DIR}/{node_id}.json"

    # Guardar cambios en data.json (sin historial inline)
    with open(DATA_JSON, "w", encoding="utf-8") as f:
        json.dump(tree_data, f, indent=2)

    print("✅ Historiales migrados exitosamente:")
    print(f"- Carpeta '{HISTORY_DIR}' creada")
    print(f"- Historial de cada nodo guardado como `{HISTORY_DIR}/<id>.json`")
    print(f"- Campo 'historial' eliminado de `{DATA_JSON}` → reemplazado por 'historial_file'")
    print("🎉 ¡Listo! Ahora puedes usar historial externo.")

if __name__ == "__main__":
    migrate_historial()
const API_BASE = "http://localhost:8001";
//const API_BASE = "/api";

//#region Archive

/**
 * Abre archivo SQL con SSMS (solo Windows)
 */
export const openSqlFile = async (path) => {
    const response = await fetch(`${API_BASE}/api/open-sql?path=${encodeURIComponent(path)}`);
    return await response.text();
};

//#endregion Archive

//#region Register Editor

/**
 * Carga los registros asociados a un nodo
 */
export const getRegistros = async (nodoId) => {
    const response = await fetch(`${API_BASE}/registros?nodo_id=${nodoId}`);
    return await response.json();
};

/**
 * Guarda o actualiza un registro
 */
export const saveRegistro = async (registro) => {
    const response = await fetch(`${API_BASE}/api/registro`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(registro),
    });
    return await response.json();
};

/**
 * Elimina un registro
 */
export const deleteRegistro = async (id) => {
    const response = await fetch(`${API_BASE}/api/delete-registro?id=${id}`, {
        method: "DELETE"
    });
    return await response.json();
};

/**
 * Reindexa órdenes tras guardar/borrar
 */
export const reindexOrden = async (nodoId) => {
    const response = await fetch(`${API_BASE}/api/reindex-orden`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ nodo_id: nodoId })
    });
    return await response.json();
};

/**
 * Obtiene historial por registro
 */
export const getHistorialRegistro = async (registroId) => {
    const response = await fetch(`${API_BASE}/api/historial_registro/${registroId}`);
    return await response.json();
};

//#endregion Register Editor

//#region Tree

/**
 * Carga el árbol desde el servidor
 */
export const loadTree = async () => {
    const response = await fetch(`${API_BASE}/api/nodos`);
    return await response.json();
};

/**
 * Guarda el árbol en el servidor
 */
export const saveTree = async (treeData) => {
    const response = await fetch(`${API_BASE}/api/save-tree`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(treeData)
    });
    return await response.json();
};

//#endregion Tree

//#region Users

/**
 * Devuelve el usuario logueado
 */
export async function getUser() {
    const response = await fetch(`${API_BASE}/api/user`);
    return await response.json();
}

//#endregion Users





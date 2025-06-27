import React, { useEffect, useState } from 'react';
import { getRegistros, saveRegistro, reindexOrden } from '../services/api';

function RegistroEditor({ node }) {
    const [registro, setRegistro] = useState({});
    const [isEditing, setIsEditing] = useState(false);

    useEffect(() => {
        if (!node || !node.id) return;

        getRegistros(node.id).then(setRegistro);
    }, [node]);

    const handleChange = (e) => {
        setRegistro({
            ...registro,
            [e.target.name]: e.target.value
        });
    };

    const handleSave = () => {
        saveRegistro({
            ...registro,
            nodo_id: node.id
        }).then(() => {
            alert("Registro guardado");
        });
    };

    const handleReindex = () => {
        reindexOrden(node.id).then(() => {
            alert("Órdenes reindexados");
        });
    };

    return (
        <div className="card shadow-sm mb-3">
            <div className="card-header bg-white fw-bold">Editar Registro</div>
            <div className="card-body bg-white">
                <form>
                    <div className="mb-2">
                        <label>Ruta del Archivo:</label>
                        <input type="text" name="archivo" value={registro.archivo || ""} onChange={handleChange} readOnly={!isEditing} className="form-control form-control-sm" />
                    </div>

                    <div className="mb-2">
                        <label>Ubicación:</label>
                        <input type="text" name="ubicacion" value={registro.ubicacion || ""} onChange={handleChange} readOnly={!isEditing} className="form-control form-control-sm" />
                    </div>

                    <div className="mb-2">
                        <label>Función:</label>
                        <input type="text" name="funcion" value={registro.funcion || ""} onChange={handleChange} readOnly={!isEditing} className="form-control form-control-sm" />
                    </div>

                    <div className="mb-2">
                        <label>Descripción:</label>
                        <textarea name="descripcion" rows="3" value={registro.descripcion || ""} onChange={handleChange} readOnly={!isEditing} className="form-control form-control-sm"></textarea>
                    </div>

                    <div className="mb-2">
                        <label>Orden:</label>
                        <input type="number" name="orden" value={registro.orden || 1} onChange={handleChange} readOnly={!isEditing} className="form-control form-control-sm" min="1" />
                    </div>

                    <div className="d-flex justify-content-between">
                        <button type="button" className="btn btn-outline-secondary btn-sm" onClick={() => setIsEditing(!isEditing)}>
                            {isEditing ? "Cancelar" : "Editar"}
                        </button>
                        <button type="button" className="btn btn-success btn-sm" disabled={!isEditing} onClick={handleSave}>
                            Guardar Cambios
                        </button>
                    </div>

                    <div className="mt-3">
                        <button type="button" className="btn btn-outline-info btn-sm w-100" onClick={handleReindex}>
                            Reindexar Órdenes
                        </button>
                    </div>
                </form>
            </div>
        </div>
    );
}

export default RegistroEditor;
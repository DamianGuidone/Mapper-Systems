import React, { useEffect, useState } from 'react';

function HistoryViewer({ node }) {
    const [history, setHistory] = useState([]);

    useEffect(() => {
        if (!node || !node.id) return;

        fetch(`/api/historial_registro?nodo_id=${node.id}`)
            .then(res => res.json())
            .then(setHistory);
    }, [node]);

    return (
        <div className="card shadow-sm mb-3">
            <div className="card-header bg-white fw-bold">Historial de Cambios</div>
            <ul className="list-group list-group-flush small">
                {history.map((entry, idx) => (
                    <li key={idx} className="list-group-item d-flex justify-content-between align-items-center">
                        <div>
                            <small className="text-secondary">{new Date(entry.fecha).toLocaleString()}</small><br/>
                            <strong>{entry.campo}</strong>: {entry.anterior} → {entry.nuevo}<br/>
                            <em>por {entry.usuario || "Anónimo"}</em>
                        </div>
                        <span className="badge bg-primary rounded-pill"><i className="fas fa-undo"></i></span>
                    </li>
                ))}
            </ul>
        </div>
    );
}

export default HistoryViewer;
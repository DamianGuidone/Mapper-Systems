import React, { useEffect, useState } from 'react';
import hljs from 'highlight.js/lib/core';
import sql from 'highlight.js/lib/languages/sql';
import { openSqlFile as openSql } from '../services/api';

hljs.registerLanguage('sql', sql);

function DetailsCard({ node }) {
    const [archivo, setArchivo] = useState("");
    const [previewContent, setPreviewContent] = useState("");

    useEffect(() => {
        if (!node || !node.data || !node.data.archivo) return;

        const filePath = node.data.archivo;
        setArchivo(filePath);

        openSql(filePath).then(content => {
            setPreviewContent(content);
        }).catch(() => {
            setPreviewContent("No se pudo previsualizar");
        });
    }, [node]);

    return (
        <div className="card shadow-sm mb-3">
            <div className="card-header bg-white fw-bold">Detalles del Nodo</div>
            <div className="card-body bg-white">
                <strong>Título:</strong> {node?.text || "-"}
                <pre className="p-2 mt-3 bg-white border rounded small" style={{ maxHeight: "450px", overflowY: "auto" }}>
                    <code className="language-sql">{previewContent}</code>
                </pre>
            </div>
        </div>
    );
}

export default DetailsCard;
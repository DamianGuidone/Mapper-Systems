import React, { useEffect } from 'react';

function FileExplorerModal({ onFileSelected }) {
    const [folderTree, setFolderTree] = useState("");

    useEffect(() => {
        fetch("/archive").then(res => res.text()).then(html => {
            setFolderTree(html);
        });
    }, []);

    const handleFileClick = (e) => {
        e.preventDefault();
        const href = e.target.closest("a")?.href || "";
        const path = new URL(href).searchParams.get("path");

        if (path) {
            onFileSelected(path);
        }
    };

    return (
        <div className="modal fade" tabIndex="-1" aria-labelledby="explorerModalLabel" aria-hidden="true">
            <div className="modal-dialog modal-xl modal-dialog-scrollable">
                <div className="modal-content">
                    <div className="modal-header">
                        <h5 className="modal-title">Explorar Archive</h5>
                        <button type="button" className="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                    </div>
                    <div className="modal-body">
                        <div className="row g-3">
                            {/* Árbol de carpetas/archivos */}
                            <div className="col-md-4 pe-0 border-end" style={{ maxHeight: "600px", overflowY: "auto" }}>
                                <h6 className="small text-muted mb-2">Carpetas</h6>
                                <div id="folder-tree" dangerouslySetInnerHTML={{ __html: folderTree }}></div>
                            </div>

                            {/* Previsualización del archivo seleccionado */}
                            <div className="col-md-8 ps-3">
                                <h6 className="small text-muted mb-2">Previsualización</h6>
                                <div className="border rounded p-2 bg-white" style={{ maxHeight: "600px", overflowY: "auto" }} id="preview-sql-modal">
                                    Seleccione un archivo para ver su contenido
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    );
}

export default FileExplorerModal;
import React, { useEffect, useState } from 'react';
import Tree from './components/Tree';
import DetailsCard from './components/DetailsCard';
import RegistroEditor from './components/RegistroEditor';
import FileExplorerModal from './components/FileExplorerModal';
import HistoryViewer from './components/HistoryViewer';
import './App.css';

function App() {
    const [selectedNode, setSelectedNode] = useState(null);

    // Cargar árbol al iniciar
    useEffect(() => {
        loadTree();
    }, []);

    const loadTree = async () => {
        try {
        const data = await import('./services/api').then(api => api.loadTree());
        setNodes(data);
        } catch (err) {
        console.error("Error al cargar árbol:", err);
        }
    };

    const handleNodeSelect = (node) => {
        setSelectedNode(node);
    };

    return (
        <div className="container-fluid mt-3">
            <div className="row g-4">
                {/* Árbol de nodos */}
                <div className="col-md-4 pe-0 border-end">
                    <h6 className="small text-muted mb-2">Carpetas</h6>
                    <Tree onSelect={handleNodeSelect} />
                </div>

                {/* Tarjeta de detalles y formulario */}
                <div className="col-md-8 ps-3">
                    <DetailsCard node={selectedNode} />

                    {/* Editor de registros */}
                    <div className="mt-4">
                        <RegistroEditor node={selectedNode} />
                    </div>

                    {/* Historial */}
                    <div className="mt-4">
                        <HistoryViewer node={selectedNode} />
                    </div>
                </div>
            </div>

            {/* Modal de explorador de archivos */}
            <FileExplorerModal />
        </div>
    );
}

export default App;
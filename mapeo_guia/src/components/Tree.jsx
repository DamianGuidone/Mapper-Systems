import React, { useEffect, useRef } from 'react';
import $ from 'jquery';
import 'jstree';
import { loadTree as loadTreeFromServer, saveTree as saveTreeToServer } from '../services/api';

function Tree({ onSelect }) {
    const treeRef = useRef(null);

    useEffect(() => {
        const initTree = async () => {
            const data = await loadTreeFromServer();

            $(treeRef.current).jstree({
                core: {
                    data: data,
                    check_callback: true
                },
                types: {
                    "default": { icon: "fas fa-folder", color: "#ffc107" },
                    "bd": { icon: "fas fa-database", color: "#0d6efd" },
                    "js": { icon: "fas fa-code", color: "#6f42c1" },
                    "html": { icon: "fas fa-file-alt", color: "#17a2b8" }
                },
                plugins: ["types", "wholerow", "contextmenu", "dnd"]
            });

            // Manejar selección de nodo
            $(treeRef.current).on('changed.jstree', function (e, data) {
                if (data.selected.length > 0) {
                    const selectedNode = data.instance.get_node(data.selected[0]);
                    onSelect(selectedNode);
                }
            });
        };

        initTree();
    }, [onSelect]);

    return <div id="jstree" ref={treeRef}></div>;
}

export default Tree;
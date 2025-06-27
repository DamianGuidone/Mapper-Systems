//#region Diálogo para explorar archivos

  /** Apertura de diálogo explorador de archivos
   * 
   * @param {object} targetId - Objeto impulsor de la apertura del diálogo
   * @param {number} [esnuevo=1] - 1 es el archivo para un nuevo nodo - 0 hay que cargar preview y resguardar dato en historial
   */
  function openFilePickerDialog(targetId, esnuevo = 1) {
    isNewNodo = esnuevo;
    fileTargetInput = targetId;
    selectedFilePath = $('#' + targetId).val(); // Opcional: carga previo

    loadFolderTree(); // Carga el árbol raíz
    $('#fileExplorerModal').modal('show');
  };

  /** Carga el árbol de archivos del modal
   * 
   * @param {string} path - Url de carpeta raíz de archivos
   * @param {string} containerId - Carga el contenedor del árbol de archivos
   * @param {int} level - Nivel de carpeta
   */
  function loadFolderTree(path = "") {
    const container = $("#folder-tree");
    container.empty().append('<div class="spinner-border spinner-border-sm" role="status"><span class="visually-hidden">Cargando...</span></div>');

    fetch(`/archive/${encodeURIComponent(path)}`)
      .then(res => res.text())
      .then(html => {
        const parser = new DOMParser();
        const doc = parser.parseFromString(html, "text/html");

        // Extraer solo el árbol de archivos
        const treeHTML = doc.body.innerHTML;

        // Inyectar directamente en folder-tree
        container.html(treeHTML);
      })
      .catch(err => {
        console.error("[ERROR] Al cargar carpeta:", err.message);
        container.empty().append(`<li class="list-group-item text-muted">No se pudo cargar: ${err.message}</li>`);
      });
  }

  /** Selecciona definitivamente el archivo y cierra el diálogo
   */
  function confirmSelectedFile() {
    if (!selectedFilePath) {
      alert("Por favor, seleccione un archivo.");
      return;
    }

    $('#' + fileTargetInput).val(selectedFilePath);

    $('#fileExplorerModal').modal('hide');
    showToast(`Archivo seleccionado: ${selectedFilePath}`);

    if (isNewNodo != 1) {
      autoSaveFile();
    }
  }

  /** Formato del preview modal
   */
  function highlightSqlInModal() {
    document.querySelectorAll('#preview-sql-modal pre').forEach(block => {
      hljs.highlightElement(block);
    });
  }

//#endregion

//#region Gestión de formulario de carga de funciones

  /** Agrega un registro nuevo a la tabla
   */
  function addNewRegistro() {
    const selected = $('#jstree').jstree().get_selected(true)[0];
    if (!selected || !selected.id) return;

    // Limpiar formulario
    currentEditId = null;
    $('#edit-archivo').val("");
    $('#edit-ubicacion').val("");
    $('#edit-funcion').val("");
    $('#edit-descripcion').val("");
    $('#edit-orden').val(1);

    // Buscar último orden usado
    fetch(`/get-registros?nodo_id=${selected.id}`)
        .then(res => res.json())
        .then(entries => {
            const maxOrder = entries.reduce((max, e) => Math.max(max, e.orden), 0);
            $('#edit-orden').val(maxOrder + 1);
        });

    enableRegistroForm(); // Habilitar campos
    $('#btn-guardar-registro').prop("disabled", false);
  }

  /** Elimina una función en particular
   * 
   * @param {int} id - Identificador de función.
   */
  function deleteFunction(id) {
      if (!confirm("¿Eliminar este registro?")) return;

      fetch(`/delete-funcion?id=${id}`, { method: 'DELETE' })
          .then(() => reloadDetailsCard());
  }
  
  /** Abrir archivo
   * 
   * @param {object} targetId 
   */
  function openFilePicker(targetId) {
    const fileInput = $('#file-picker');
    fileInput.off('change').on('change', function () {
      handleFilePick(fileInput.val(), targetId);
    });
    fileInput.trigger('click');
  };

  /** Abre el archivo cargado
   * 
   * @param {string} filePath - Url de archivo
   * @param {object} targetId - Objeto invocador
   */
  function handleFilePick(filePath, targetId) {
    if (filePath) {
      $('#' + targetId).val(filePath);
    }
  }

  /** Carga de datos en tabla de nodos js/html/c#/reportes
   * 
   * @param {string} nodeId - identificador de nodo
   */
  function loadFunctionsTable(nodeId) {
    fetch(`/get-registros?nodo_id=${nodeId}`)
      .then(res => res.json())
      .then(entries => {
        const table = $('#registros-table');
        table.empty();

        if (entries.length === 0) {
          table.append('<tr><td colspan="5" class="text-muted">Sin funciones</td></tr>');
          return;
        }

        entries.forEach(entry => {
          const $row = $(`
            <tr data-registro='${JSON.stringify(entry)}'>
              <td>${entry.archivo || "-"}</td>
              <td>${entry.ubicacion || "-"}</td>
              <td>${entry.funcion || "-"}</td>
              <td>${entry.descripcion || "-"}</td>
              <td class="text-end">
                <button class="btn btn-sm btn-outline-primary me-1" onclick='selectRegistro(${JSON.stringify(entry)})'>
                  Seleccionar
                </button>
                <button class="btn btn-sm btn-outline-danger" onclick='deleteFunction(${entry.id})'>
                  Borrar
                </button>
              </td>
            </tr>
          `);

          table.append($row);
        });
    })
    .catch(() => {
      $('#functions-table').empty().append('<tr><td colspan="5" class="text-muted">No se pudo cargar</td></tr>');
    });
  }

  /** Limpieza de campos de Formulario de edición de Tabla
   */
  function cleanerEditFunctionModal() {
    $('#edit-archivo').val(entry.archivo || "");
    $('#edit-ubicacion').val(entry.ubicacion || "");
    $('#edit-funcion').val(entry.funcion || "");
    $('#edit-descripcion').val(entry.descripcion || "");
    $('#edit-orden').val(entry.orden || 1);
  }

  /** Respuesta al seleccionar un registro de la tabla de funciones
   * 
   * @param {object} entry - objeto registro
   */
  function selectRegistro(entry) {
    currentRegistro = entry;

    $('#edit-archivo').val(entry.archivo || "");
    $('#edit-ubicacion').val(entry.ubicacion || "");
    $('#edit-funcion').val(entry.funcion || "");
    $('#edit-descripcion').val(entry.descripcion || "");
    $('#edit-orden').val(entry.orden || 1);

    $('#btn-editar-registro').prop("disabled", false);
    $('#btn-duplicate-registro').prop("disabled", false);
    $('#btn-delete-registro').prop("disabled", false);

    disableRegistroForm(); // Inicia como deshabilitado
  }

  function filterRegistros(value) {
    const selected = $('#jstree').jstree().get_selected(true)[0];
    if (!selected) return;

    let url = `/get-registros?nodo_id=${selected.id}`;
    if (value) url += `&filtro=${encodeURIComponent(value)}`;

    loadFunctionsTableFromUrl(url);
  }

  function applyRegistroFilters() {
    const field = $('#registro-filter-campo').val();
    const value = $('#search-registro').val();
    const selected = $('#jstree').jstree().get_selected(true)[0];
    if (!selected) return;

    let url = `/get-registros?nodo_id=${selected.id}`;
    if (field && value) {
        url += `&campo=${field}&valor=${encodeURIComponent(value)}`;
    }

    loadFunctionsTableFromUrl(url);
  }

  function sortRegistros(order = "asc") {
    const selected = $('#jstree').jstree().get_selected(true)[0];
    if (!selected) return;

    const url = `/get-registros?nodo_id=${selected.id}&order=${order}`;
    loadFunctionsTableFromUrl(url);
  }

  function loadFunctionsTableFromUrl(url) {
    fetch(url)
        .then(res => res.json())
        .then(entries => {
            const table = $('#registros-table');
            table.empty();

            if (entries.length === 0) {
                table.append('<tr><td colspan="5" class="text-muted">Sin funciones</td></tr>');
                return;
            }

            entries.forEach(entry => {
                const $row = $(`
                    <tr data-registro='${JSON.stringify(entry)}'>
                        <td>${entry.archivo || "-"}</td>
                        <td>${entry.ubicacion || "-"}</td>
                        <td>${entry.funcion || "-"}</td>
                        <td>${entry.descripcion || "-"}</td>
                        <td class="text-end">
                            <button class="btn btn-sm btn-outline-primary me-1" onclick='selectRegistro(${JSON.stringify(entry)})'>
                                Seleccionar
                            </button>
                            <button class="btn btn-sm btn-outline-danger" onclick='deleteFunction(${entry.id})'>
                                Borrar
                            </button>
                        </td>
                    </tr>
                `);

                table.append($row);
            });
        })
        .catch(() => {
            table.empty().append('<tr><td colspan="5" class="text-muted">No se pudo cargar</td></tr>');
        });
  }

  /** Guardar Función
   */
  function saveEditedFunction() {
    const archivo = $('#edit-archivo').val();
    const ubicacion = $('#edit-ubicacion').val().trim();
    const funcion = $('#edit-funcion').val().trim();
    const descripcion = $('#edit-descripcion').val().trim();
    const orden = parseInt($('#edit-orden').val(), 10);
    const selected = $('#jstree').jstree().get_selected(true)[0];

    if (!selected || !selected.id) return;

    const registro = {
      id: currentRegistro?.id || null,
      archivo,
      ubicacion,
      funcion,
      descripcion,
      orden,
      nodo_id: selected.id,
      usuario: currentUser
    };

    fetch('/save-registro', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(registro)
    }).then(() => {
      showToast("Registro guardado");
      reloadDetailsCard();
      disableRegistroForm();

      // Si era un nuevo registro → limpiar selección
      if (!currentRegistro?.id) {
          currentRegistro = null;
          $('#btn-editar-registro, #btn-duplicate-registro, #btn-delete-registro').prop("disabled", true);
      }
    });
  }

  /** Elimina registro seleccionado
   * 
   * @param {int} id - identificador de registro trabajado
   */
  function deleteFunction(id) {
    if (!confirm("¿Eliminar este registro?")) return;

    fetch(`/delete-registro?id=${id}`, { method: 'DELETE' })
      .then(() => {
        showToast("Registro eliminado");
        reloadDetailsCard();
      }
    );
  }

  function disableRegistroForm() {
    enableRegistroForm(false);
    $('#btn-guardar-registro').prop("disabled", true);
  }

  function cancelRegistroForm() {
    if (!currentRegistro) {
      toggleTableEditor(false); // Ocultar formulario si no hay registro
    } else {
      $('#edit-archivo').val(currentRegistro.archivo || "");
      $('#edit-ubicacion').val(currentRegistro.ubicacion || "");
      $('#edit-funcion').val(currentRegistro.funcion || "");
      $('#edit-descripcion').val(currentRegistro.descripcion || "");
      $('#edit-orden').val(currentRegistro.orden || 1);
      disableRegistroForm();
    }
  }

  function deleteSelectedRegistro() {
    if (!currentRegistro || !confirm("¿Eliminar este registro?")) return;

    fetch(`/delete-registro?id=${currentRegistro.id}`, { method: 'DELETE' })
      .then(() => {
        showToast("Registro eliminado");
        reloadDetailsCard();
        $('#btn-editar-registro, #btn-duplicate-registro, #btn-delete-registro').prop("disabled", true);
    });
  }

  function duplicateSelectedRegistro() {
    if (!currentRegistro) return;

    const selected = $('#jstree').jstree().get_selected(true)[0];
    if (!selected || !selected.id) return;

    const duplicado = {
      ...currentRegistro,
      id: null,
      orden: currentRegistro.orden + 1
    };

    fetch('/save-registro', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(duplicado)
    }).then(() => {
      showToast("Registro duplicado");
      reloadDetailsCard();
    });
  }

  function toggleTableEditor(show = true) {
    const form = $('#table-editor-form');
    form.toggle(show);
    
    if (!show) {
      currentRegistro = null;
      $('#edit-archivo').val("");
      $('#edit-ubicacion').val("");
      $('#edit-funcion').val("");
      $('#edit-descripcion').val("");
      $('#edit-orden').val(1);
    }
  }

  /** Carga de formulario de nuevo registro
   */
  function openNewFunctionForm() {
    currentEditId = null;
    $('#edit-archivo').val("");
    $('#edit-ubicacion').val("");
    $('#edit-funcion').val("");
    $('#edit-descripcion').val("");
    $('#edit-orden').val(1);

    const selected = $('#jstree').jstree().get_selected(true)[0];
    if (!selected || !selected.id) return;

    // Buscar último orden usado
    fetch(`/get-registros?nodo_id=${selected.id}`)
        .then(res => res.json())
        .then(entries => {
            const maxOrder = entries.reduce((max, e) => Math.max(max, e.orden), 0);
            $('#edit-orden').val(maxOrder + 1);
        });

    $('#edit-function-modal').modal('show');
  }
//#endregion

//#region Gestión de formulario de creación de nodo

  /** Limpia el formulario 
   */
  function clearNodeForm() {
      $('#node-text').val('');
      $('#node-type').val('default');
      $('#node-descripcion').val('');
      $('#node-archivo').val('');

      // Ocultar campos adicionales si están visibles
      $('#field-archivo').addClass('d-none');
  }

  /** Acción de selección de tipo de nodo
   */
  function updateFormFields() {
      const type = $('#node-type').val();

      $('#field-descripcion').removeClass('d-none');
      $('#field-archivo').toggleClass('d-none', type !== 'bd');
  }

  $('#new-node-form').on("submit", function (e) {
    e.preventDefault();

    const parent = $('#jstree').jstree().get_selected(true)[0] || '#';
    const text = $('#node-text').val().trim();
    const type = $('#node-type').val();
    const descripcion = $('#node-descripcion').val().trim();
    const archivo = $('#node-archivo').val().trim();

    if (!text) {
        alert("Por favor, ingresa un nombre");
        return;
    }

    const isContainer = type === "default";

    const nodeData = {
        descripcion: descripcion,
        tipo_nodo: isContainer ? "carpeta" : type
    };

    if (type === "bd") {
        nodeData.archivo = archivo;
        selectedFilePath = archivo;
    }    

    const id = "node_" + Math.random().toString(36).substr(2, 9);
    nodeData.historial_file = `history/${id}.json`;

    $('#jstree').jstree().create_node(parent, {
        id,
        text,
        type: isContainer ? "default" : "leaf",
        data: nodeData
    });

    createHistoryFile(id, text);
    addHistoryEntry(id, "nuevo_nodo", "", text); // Registra creación
    saveTree(); // Guarda inmediatamente
    reloadDetailsCard(); // Recarga la tarjeta
    clearNodeForm();
  });
//#endregion

//#region Gestión de Árbol de nodos

  /** Guardar Árbol entero 
   */
  function saveTree() {
    const treeData = $('#jstree').jstree().get_json(null, { flat: true });
    console.log("Datos del árbol:", treeData);

    fetch('/save-tree', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(treeData)
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            console.log("Árbol guardado exitosamente");
        } else {
            console.error("Error al guardar el árbol:", data.message);
        }
    })
    .catch(error => {
        console.error("Error en la solicitud:", error);
    });
  }

  /** Aplicación de cambio de apariencia a nodo
   * 
   * @param {nodo} node - Nodo seleccionado
   */
  function applyNodeType(node) {
    const tipoNodo = node.data?.tipo_nodo?.toLowerCase();
    if (!tipoNodo || !nodeTypes[tipoNodo]) return;

    const config = nodeTypes[tipoNodo];

    treeInstance.set_icon(node, config.icon);
    $(`#${node.id}_anchor`).css("color", config.color);
  }

  //#region Filtros de nodos
    /** Activa/Desactiva el filtro sobre los nodos
     * @param {boolean} checked - Estado de toggle
     * @param {string} filterType - Tipo de nodo
     */
    function toggleFilter(checked, filterType) {
      const tree = $('#jstree').jstree(true);
      if (!tree) return;

      if (checked) {
        activeFilters.add(filterType);
      } else {
        activeFilters.delete(filterType);
      }

      applyNodeFilters(tree);
    }

    /** Aplica el filtro indicado para ocultar/mostrar tipos de nodos
     * @param {object} tree - Árbol de archoivos en donde se aplica el filtrado
     */
    function applyNodeFilters(tree) {
      const allNodes = tree.get_json('#', { flat: true });

      allNodes.forEach(node => {
        const isContainer = node.type === "default";
        const nodeType = node.data?.tipo_nodo?.toLowerCase() || '';

        // Los contenedores siempre visibles
        if (isContainer) {
          tree.show_node(node.id);
          return;
        }

        // Si no hay filtros activos → mostrar todo
        if (activeFilters.size === 0) {
          tree.show_node(node.id);
          return;
        }

        // Mostrar solo si el tipo está seleccionado
        const show = activeFilters.has(nodeType);

        if (show) {
          tree.show_node(node.id);
        } else {
          tree.hide_node(node.id);
        }
      });
    }

    /** Resetea el filtrado de nodos
     */
    function resetFilters() {
      document.querySelectorAll('[id^="filter-"]').forEach(input => {
        input.checked = false;
      });

      activeFilters.clear();
      $('#jstree').jstree().show_all();
    }

  //#endregion

  //#region Gestión de Historial de Árbol

    /**
     * 
     * @param {JSON} state - Estado de Árbol
     */
    function saveToHistory(state) {
      treeHistory.push(state);
    }

  //#endregion


//#endregion

//#region Gestión de Tarjeta de Detalles de Nodo

  //#region Autoguardados

    /** Realiza el autoguardado del cambio de archivo asignado a un nodo (sql)
     */
    function autoSaveFile() {
      const selected = $('#jstree').jstree().get_selected(true)[0];
      if (!selected) return;

      const oldFile = selected.data.archivo;

      if (selectedFilePath && selectedFilePath !== oldFile) {
        addHistoryEntry(selected.id, "archivo", oldFile, selectedFilePath);
        $('#jstree').jstree().get_selected(true)[0].data.archivo = selectedFilePath;
      }

      saveTree();
      showToast(`Archivo cambiado: "${oldFile}" → "${selectedFilePath}"`);
      reloadDetailsCard();
    }

    /** Realiza el autoguardado del cambio del título
     * 
     * @param {string} newTitle - Título nuevo para el nodo
     */
    function autoSaveTitle(newTitle) {
      const selected = $('#jstree').jstree().get_selected(true)[0];
      if (!selected) return;

      const oldTitle = selected.text;

      if (newTitle && newTitle !== oldTitle) {
          $('#jstree').jstree().rename_node(selected, newTitle);
          addHistoryEntry(selected.id, "text", oldTitle, newTitle);
      }
      // Guardar automáticamente
      saveTree();

      // Mostrar notificación
      showToast(`Título cambiado: "${oldTitle}" → "${newTitle}"`);
      
      // Recargar tarjeta completa
      reloadDetailsCard();
    };

    /** Guarda automáticamente al cambiar una fecha
     * 
     * @param {string} field - Fecha seleccionada
     */
    function autoSaveDate(field) {
      const selectedId = treeInstance.get_selected()[0];
      if (!selectedId) return;

      const node = treeInstance.get_node(selectedId);
      if (!node || !node.data) return;

      const newValue = field === 'ultima_modificacion'
        ? $('#input-mod').val()
        : $('#input-review').val();

      if (!newValue) return;

      const oldValue = node.data[field] || "-";

      if (newValue && newValue !== oldValue) {
          // Actualizar directamente el nodo
          node.data[field] = newValue;
        
          // Registrar en historial
          addHistoryEntry(node.id, field, oldValue, newValue);

          // Forzar redibujado del nodo
          treeInstance.redraw_node(node);
          
          // Guardar automáticamente
          saveTree();
          
          // Mostrar notificación
          showToast(`"${field}" cambiada: "${oldValue}" → "${newValue}"`);

          // Recargar tarjeta completa
          reloadDetailsCard();
      }
    };
    
    /** Asignar fecha de hoy y guardar automáticamente
     * 
     * @param {string} field - fecha de hoy
     */
    function setToday(field) {
        const today = new Date().toISOString().split('T')[0];

        if (field === 'ultima_modificacion') {
            $('#input-mod').val(today);
        } else if (field === 'ultima_revision') {
            $('#input-review').val(today);
        }
        autoSaveDate(field);
    };

    /** Guardar campo de fecha seleccionado
     * 
     * @param {string} field - Guarda el campo de fecha 
     */
    function saveField(field) {
      if (!currentSelectedNode || !currentSelectedNode.data) return;

      const newValue = field === 'ultima_modificacion'
        ? $('#input-mod').val()
        : $('#input-review').val();

      if (!newValue) return alert("Por favor, ingresa una fecha válida.");

      const oldValue = currentSelectedNode.data[field] || "-";

      // Actualizar nodo
      $('#jstree').jstree().set_data(currentSelectedNode, {
        ...currentSelectedNode.data,
        [field]: newValue
      });

      // Registrar historial
      addHistoryEntry(currentSelectedNode.id, field, oldValue, newValue);

      // Guardar cambios
      saveTree();
    };

    /**Guarda automáticamente cambios en la descripción del nodo
     * 
     * @param {string} newText - Nueva descripción
     */
    function autoSaveDescription(newText) {
      const selectedId = treeInstance.get_selected()[0];
      if (!selectedId) return;

      const node = treeInstance.get_node(selectedId);
      if (!node || !node.data) return;

      const oldDesc = node.data.descripcion || "Sin descripción";
      const newDesc = newText.trim();

      if (newDesc && newDesc !== oldDesc) {
          // Actualizar directamente el nodo
          node.data.descripcion = newDesc;

          // Registrar en historial
          addHistoryEntry(node.id, "descripcion", oldDesc, newDesc);

          // Forzar redibujado del nodo
          treeInstance.redraw_node(node);

          // Guardar automáticamente
          saveTree();

          // Mostrar notificación
          showToast(`Descripción cambiada: "${oldDesc}" → "${newDesc}"`);

          // Recargar tarjeta completa
          reloadDetailsCard();
      }
    };
  
  //#endregion

  /** Recarga la tarjeta de detalles del nodo
   */
  function reloadDetailsCard() {
    const selected = $('#jstree').jstree().get_selected(true)[0];
    if (!selected) return;

    const customData = selected.data || {};
    const tipoNodo = customData.tipo_nodo?.toLowerCase() || 'carpeta';

    // Aplicar ícono y color si es leaf
    if (selected.type === "leaf") {
      applyNodeType(selected);
    }

    // Mostrar/ocultar secciones según tipo de nodo
    if (tipoNodo === "bd") {
      $("#registros-table").hide();
      $("#sql-preview").show();
      loadSqlPreview(customData.archivo);
    } else if (["js", "cs", "html", "reporte"].includes(tipoNodo)) {
      $("#sql-preview").hide();
      $("#registros-table").show();
      loadFunctionsTable(selected.id);
    } else {
      $("#sql-preview").hide();
      $("#registros-table").hide();
    }

    // Actualizar campos de texto
    $('#detail-title').text(selected.text);
    $('#detail-desc').text(customData.descripcion || "Sin descripción");
    $('#detail-mod').text(customData.ultima_modificacion || "-");
    $('#detail-review').text(customData.ultima_revision || "-");

    // Cargar fechas en inputs de edición
    $('#input-mod').val(customData.ultima_modificacion || "");
    $('#input-review').val(customData.ultima_revision || "");

    // Cargar ruta del archivo SQL
    if (customData.archivo) {
      $('#detail-file-input').val(customData.archivo);
    } else {
      $('#detail-file-input').val("");
    }

    // Cargar historial desde archivo .json
    loadNodeHistory(selected);
  }
  
  //#region Preview
  
    /** Carga archivo sql en la vista previa
     * 
     * @param {string} archivo - url que debe ser mostrada
     */
    function loadSqlPreview(archivo = null) {
      if (!archivo) {
        const selected = $('#jstree').jstree().get_selected(true)[0];
        if (!selected || !selected.data || !selected.data.archivo) return;

        archivo = selected.data.archivo;
      }
      selectedFilePath = archivo;
      loadFileFromArchive("sql-preview");
    }
    
    /** Abre el archivo sql en SSMS
     */
    function openSqlFile() {
      const path = $('#detail-file-input').val();
      if (!path) {
        alert("No hay una ruta seleccionada");
        return;
      }

      // Llama al servidor para abrir el archivo con SSMS
      fetch(`/open-sql?path=${encodeURIComponent(path)}`)
        .then(() => {
          showToast("Archivo abierto en SSMS");
        })
        .catch(err => {
          console.error("Error al abrir el archivo:", err);
          alert("No se pudo abrir el archivo");
        });
    }


  //#endregion

  //#region Historial de nodos

    /** Agrega un registro de cambio al historial del nodo
     * 
     * @param {string} nodeId - Identificador de nodo
     * @param {string} campo - Campo que fue modificado
     * @param {string} valorAnterior - Valor anterior
     * @param {string} valorNuevo - Valor nuevo
     * @returns 
     */
    function addHistoryEntry(nodeId, campo, valorAnterior, valorNuevo) {
      const selected = $('#jstree').jstree().get_selected(true)[0];
      if (!selected || !selected.data) return;

      const historyFile = selected.data.historial_file;

      // Cargar historial actual desde archivo .json
      fetch(historyFile)
        .then(res => res.json())
        .then(history => {
          history.push({
            fecha: new Date().toISOString(),
            campo: campo,
            anterior: valorAnterior,
            nuevo: valorNuevo,
            usuario: currentUser
          });

          // Guardar nuevamente el historial en archivo .json
          saveNodeHistory(selected.id, history);

          // Mostrar notificación
          showToast(`Historial actualizado`);
        })
        .catch(() => {
          alert("Error al cargar el historial");
      });
    }

    /** Guarda el historial del nodo indicado
     * 
     * @param {string} nodeId - Identificador de nodo
     * @param {Array} history - Historial del nodo
     */
    function saveNodeHistory(nodeId, history) {
      const historyPath = `history/${nodeId}.json`;

      fetch(`/save-history`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ nodeId, history })
      })
      .then(response => response.json())
      .then(data => {
        if (data.success) {
          console.log(`Historial guardado para ${nodeId}`);
        } else {
          console.error("Error al guardar historial:", data.message);
        }
      })
      .catch(error => {
        console.error("Error en la solicitud:", error);
      });
    }

    /** Carga el historial de cambios de un nodo
     * 
     * @param {nodo} selected - Nodo seleccionado
     */
    function loadNodeHistory(selected) {
      if (!selected || !selected.id) return;

      const nodeId = selected.id;
      const historyPath = `${HISTORY_DIR}/${nodeId}.json`;

      fetch(historyPath)
        .then(res => {
          if (!res.ok) throw new Error("Archivo no encontrado");
          return res.json();
        })
        .then(history => {
          displayHistory(history);
        })
        .catch(err => {
          console.error("[ERROR] Al cargar historial:", err.message);
          $('#detail-history').empty().append('<li class="list-group-item text-muted">No se pudo cargar el historial</li>');
        });
    }
      
    /** Aplica los filtros sobre el historial del nodo seleccionado
     */
    function applyHistoryFilters() {
      const selected = $('#jstree').jstree().get_selected(true)[0];
      if (!selected || !selected.data) return;

      const historyFile = selected.data.historial_file;
      if (!historyFile) return;

      fetch(historyFile)
        .then(res => res.json())
        .then(history => {
          // Obtener valores de filtros
          filterCampo = $('#filter-campo').val();
          filterDesde = $('#filter-desde').val();
          filterHasta = $('#filter-hasta').val();

          let filtered = [...history];

          // Filtrar por campo
          if (filterCampo) {
            filtered = filtered.filter(e => e.campo === filterCampo);
          }

          // Filtrar por rango de fechas
          if (filterDesde) {
            const desde = new Date(filterDesde + "T00:00:00Z");
            filtered = filtered.filter(e => new Date(e.fecha) >= desde);
          }

          if (filterHasta) {
            const hasta = new Date(filterHasta + "T23:59:59Z");
            filtered = filtered.filter(e => new Date(e.fecha) <= hasta);
          }

          // Mostrar resultados filtrados
          displayHistory(filtered);
        })
        .catch(() => {
          $('#detail-history').empty().append('<li class="list-group-item text-muted">No se pudo cargar el historial</li>');
        });
    }

    /** Carga la lista visual del historial del nodo seleccionado
     * 
     * @param {Array} history - Historial que se cargará 
     */
    function displayHistory(history) {
      const historyList = $('#detail-history');
      historyList.empty();

      if (history.length === 0) {
        historyList.append('<li class="list-group-item text-muted">Sin entradas con esos filtros</li>');
        return;
      }

      history.slice().reverse().forEach(entry => {
        const date = new Date(entry.fecha).toLocaleString();
        
        // No mostrar botones si es nuevo_nodo
        const buttonsHtml = entry.campo === "nuevo_nodo" ? '' : `
          <button class="btn btn-sm btn-outline-danger ms-2 float-end" onclick="undoChange('${entry.fecha}')">
            <i class="fas fa-undo"></i> Deshacer
          </button>
          <button class="btn btn-sm btn-outline-secondary ms-2 float-end me-2" onclick="discardHistoryEntry('${entry.fecha}', event)">
            <i class="fas fa-trash-alt"></i> Desechar
          </button>
        `;

        historyList.append(`
          <li class="list-group-item">
            <small class="text-secondary">${date}</small><br/>
            <strong>${entry.campo}</strong>: 
            <span class="text-decoration-line-through">${entry.anterior}</span> → 
            <span class="text-success">${entry.nuevo}</span><br/>
            <em>por ${entry.usuario || "Anónimo"}</em>
            ${buttonsHtml}
          </li>
        `);
      });
    }
    
    /** Resetea los filtros del historial
     */
    function resetHistoryFilters() {
      $('#filter-campo').val("");
      $('#filter-desde').val("");
      $('#filter-hasta').val("");

      loadNodeHistory($('#jstree').jstree().get_selected(true)[0]);
    }
    
    /** Crea un nuevo registro de historial de cambio 
     * 
     * @param {nodo} node - Nodo modificado
     */
    function createHistoryFile(id, text = "") {
      const initialEntry = [{
        "fecha": new Date().toISOString(),
        "campo": "nuevo_nodo",
        "anterior": "",
        "nuevo": text,
        "usuario": currentUser
      }];

      fetch('/save-history', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          nodeId: id,
          history: initialEntry
        })
      })
        .catch(err => {
          console.error("[ERROR] Al guardar historial inicial:", err);
        });
    }

    /** Ver/Ocultar historial
     */
    function toggleHistory() {
      historyVisible = !historyVisible;

      const historyContainer = $('#detail-history-container');
      const icon = $('#history-toggle-icon');

      if (historyVisible) {
        // Mostrar historial
        historyContainer.show();
        icon.removeClass("fa-eye").addClass("fa-eye-slash");
      } else {
        // Ocultar historial
        historyContainer.hide();
        icon.removeClass("fa-eye-slash").addClass("fa-eye");
      }
    };

    /** Deshace el cambio seleccionado
     * 
     * @param {string} changeDate - Fecha del cambio usada para localizar el cambio que debe deshacerse
     */
    function undoChange(changeDate) {
      const selected = $('#jstree').jstree().get_selected(true)[0];
      if (!selected || !selected.data) return;

      const historyFile = selected.data.historial_file;
      if (!historyFile) return;

      fetch(historyFile)
        .then(res => res.json())
        .then(history => {
          // Buscar entrada específica
          const entry = history.find(e => e.fecha === changeDate);
          if (!entry) return alert("No se encontró la entrada");

          // Confirmar acción
          if (!confirm(`¿Deshacer "${entry.campo}"? "${entry.nuevo}" → "${entry.anterior}"`)) return;

          selected.data[entry.campo] = entry.anterior; // Revertir el campo

          // 2. Eliminar esta entrada del historial
          const updatedHistory = history.filter(e => e.fecha !== changeDate);
          saveNodeHistory(selected.id, updatedHistory); // Guardar el historial sin esta entrada

          // 3. Mostrar notificación y recargar tarjeta
          showToast(`"${entry.campo}" revertido a: "${entry.anterior}"`);
          saveTree();
          reloadDetailsCard();
        })
        .catch(() => {
          alert("No se pudo cargar el historial");
        });
    };

    /** Elimina el evento seleccionado del historial del cambio
     * 
     * @param {string} changeDate - Fecha del cambio seleccionado
     * @param {string} event - Evento de cambio que se eliminará
     */
    function discardHistoryEntry(changeDate, event) {
      // Evitar que se dispare doble evento por los dos botones
      event.stopPropagation();

      const selected = $('#jstree').jstree().get_selected(true)[0];
      if (!selected || !selected.id) return;

      const historyFile = selected.data?.historial_file;
      if (!historyFile) return;

      fetch(historyFile)
        .then(res => res.json())
        .then(history => {
          // Filtrar todas las entradas menos la seleccionada
          const updatedHistory = history.filter(e => e.fecha !== changeDate);

          // Confirmación opcional
          if (!confirm("¿Eliminar este cambio del historial?")) return;

          // Guardar el historial actualizado
          saveNodeHistory(selected.id, updatedHistory);

          // Recargar tarjeta con nuevo historial
          reloadDetailsCard();
        })
        .catch(() => {
          alert("No se pudo cargar el historial");
        });
    };

  //#endregion

//#endregion

//#region Funciones de soporte

  //#region Variables
    var isNewNodo = 0;
    var treeInstance;
    var treeHistory = [];
    var currentSelectedNode = null;
    var historyVisible = false;
    var HISTORY_DIR = "history";
    var filterCampo = "";
    var filterDesde = "";
    var filterHasta = "";
    var currentUser = "Anónimo";
    let currentEditId = null;
    let currentRegistro = null;
    var activeFilters = new Set();
    var fileTargetInput = null;
    var selectedFilePath = "";
    var expandedFolders = {};

    const nodeTypes = {
        "default": { icon: "fas fa-folder", color: "#007BFF" }, // Carpeta
        "bd":     { icon: "fas fa-database", color: "#DC3545" }, // Rojo
        "js":     { icon: "fab fa-js", color: "#FFC107" },      // Amarillo
        "cs":     { icon: "fab fa-microsoft", color: "#28A745" },// Verde
        "html":   { icon: "fab fa-html5", color: "#6F42C1" },   // Púrpura
        "reporte":{ icon: "far fa-chart-bar", color: "#6C757D" } // Marrón
    };

  //#endregion

  //#region Toast

    /** Muestra un Toast de notificación
     * 
     * @param {string} message - Mensaje que se mostrará 
     */
    function showToast(message) {
      const toast = $('#changeToast');
      $('.toast-body').text(message);
      const bsToast = new bootstrap.Toast(toast);
      bsToast.show();
    }

  //#endregion

  /** Carga un archivo desde /read-sql?path=...
   * 
  * @param {string} targetElementId - ID del elemento donde mostrar el contenido
  */
  function loadFileFromArchive(targetElementId) {
    const previewContainer = $('#' + targetElementId);

    fetch(`/read-sql?path=${encodeURIComponent(selectedFilePath)}`)
      .then(res => {
        if (!res.ok) throw new Error("Archivo no encontrado");

        return res.text();
      })
      .then(content => {
        previewContainer.empty().append(`<pre class="mb-0">${content}</pre>`);
        hljs.highlightElement(previewContainer.find("pre")[0]);

        if ($('#fileExplorerModal').hasClass('show')) {
          $('#detail-file-input').val(selectedFilePath);
        }
      })
      .catch(err => {
        previewContainer.text(`[ERROR] No se pudo cargar: ${err.message}`);
      });
  }

  //#region Eventos

    $('#jstree').on("select_node.jstree", function (e, data) {
        reloadDetailsCard();
    });

    
    $(document).on("click", ".fas.fa-folder", function () {
      const $li = $(this).parent(); // El <li> que contiene la carpeta
      const isExpanded = $li.find("ul").length > 0;

      if (!isExpanded) {
        const folderName = $(this).next().text().trim(); // Nombre de carpeta
        const newPath = $li.find("a").attr("href") || folderName;

        fetch(`/archive/${encodeURIComponent(newPath)}`)
          .then(res => res.text())
          .then(html => {
            const parser = new DOMParser();
            const doc = parser.parseFromString(html, "text/html");
            const innerHTML = doc.body.innerHTML;

            // Inyectar nueva estructura
            $li.append(innerHTML);
          });
      } else {
        $li.find("ul").toggle();
      }
    });

    $(document).on("click", "#folder-tree a", function (e) {
      e.preventDefault();

      const href = $(this).attr("href");
      if (!href || !href.includes("path=")) return;

      const url = new URL(href, window.location.href);
      selectedFilePath = url.searchParams.get("path");

      loadFileFromArchive("preview-sql-modal");
    });

    $(document).on("click", "#registros-table tr", function () {
      $("#registros-table tr").removeClass("selected");
      $(this).addClass("selected");

      const registro = $(this).data("registro");
      if (!registro) return;

      currentRegistro = registro;

      // Llenar formulario con datos del registro
      $('#edit-archivo').val(registro.archivo || "");
      $('#edit-ubicacion').val(registro.ubicacion || "");
      $('#edit-funcion').val(registro.funcion || "");
      $('#edit-descripcion').val(registro.descripcion || "");
      $('#edit-orden').val(registro.orden || 1);

      // Habilitar botones de acción
      $('#btn-editar-registro, #btn-duplicate-registro, #btn-delete-registro')
          .prop("disabled", false);
    });

    // Cargar árbol desde data.json
    $.getJSON('data.json', function (data) {
      $('#jstree').jstree({
        core: {
          data: data,
          check_callback: true
        },
        types: {
          "default": { icon: "fas fa-folder", color: "#007BFF" },
          "leaf": { icon: "fas fa-database", color: "#DC3545" }
        },
        plugins: ["types", "dnd", "contextmenu", "wholerow"]
      });

      treeInstance = $('#jstree').jstree(true);
      saveToHistory(JSON.stringify(data)); // Iniciar historial desde data.json

      setTimeout(() => {
        data.forEach(node => {
          applyNodeType(node);
        });
      }, 100);

      $('#detail-history-container').hide();
    });

    /** Habilitar/Deshabilitar campos
     */
    function editSelectedRegistro() {
      if (!currentRegistro) return;

      enableRegistroForm();
      $('#btn-guardar-registro').prop("disabled", false);
    }

  //#endregion

  $(document).ready(function () {
    fetch('/get-user')
      .then(res => res.json())
      .then(data => {
        currentUser = data.usuario;
      })
      .catch(() => {
        currentUser = "Anónimo";
      });
  });
//#endregion

//#region bitacora de funciones

// /** Guarda el cambio en un registro de la tabla
//    */
//   function saveEditedFunction() {
//     const archivo = $('#edit-archivo').val();
//     const orden = parseInt($('#edit-orden').val(), 10);
//     const funcion = $('#edit-funcion').val().trim();
//     const descripcion = $('#edit-descripcion').val().trim();

//     const selected = $('#jstree').jstree().get_selected(true)[0];
//     if (!selected) return;

//     // Aquí puedes enviar al servidor o guardar localmente
//     const registro = {
//       id: currentEditId,
//       archivo,
//       orden,
//       funcion,
//       descripcion,
//       nodo_id: selected.id
//     };

//     fetch('/update-registro', {
//       method: 'POST',
//       headers: { 'Content-Type': 'application/json' },
//       body: JSON.stringify(registro)
//     }).then(() => {
//       showToast("Registro guardado");
//       reloadDetailsCard();
//     });
//   }

    // function loadSqlPreview(archivo = null){        
    //   // Si es un archivo, cargar su contenido
    //   if (archivo == null) {        
    //     const selected = $('#jstree').jstree().get_selected(true)[0];
    //     if (!selected) return;

    //     const customData = selected.data || {};
    //     archivo = customData.archivo;
    //   }
    //   if (archivo) {
    //     fetch(`/read-sql?path=${encodeURIComponent(archivo)}`)
    //       .then(res => {
    //         const contentType = res.headers.get("content-type");
    //         if (!contentType || !contentType.includes("text/plain")) {
    //           throw new Error("Respuesta no válida (posiblemente HTML)");
    //         }

    //         if (!res.ok) {
    //           throw new Error(`HTTP error! status: ${res.status}`);
    //         }

    //         return res.text();
    //       })
    //       .then(content => {
    //         // Detectar si parece ser HTML
    //         if (content.trim().startsWith('<')) {
    //           throw new Error("Se recibió HTML en lugar de código SQL");
    //         }

    //         const preview = $('#sql-preview');
    //         preview.empty();

    //         const codeBlock = document.createElement('code');
    //         codeBlock.textContent = content;

    //         preview.append(codeBlock);
    //         hljs.highlightElement(codeBlock);
    //       })
    //       .catch(err => {
    //         console.error("[ERROR] No se pudo cargar el archivo:", err.message);
    //         $('#sql-preview').text("No se pudo cargar el archivo.");
    //       });
    //   } else {
    //     $('#sql-preview').text("Selecciona un nodo con archivo asociado.");
    //   }
    // }

    
  // /** Carga el árbol de archivos en el componente
  //  * 
  //  * @param {string} path - Url del tree de archivos 
  //  */
  // function loadArchiveExplorer(path = "") {
  //   const archiveList = $('#archive-tree');
  //   archiveList.empty();

  //   fetch(`/archive/${path}`)
  //     .then(res => res.text())
  //     .then(html => {
  //       const parser = new DOMParser();
  //       const doc = parser.parseFromString(html, "text/html");
  //       const items = doc.querySelectorAll("ul li");

  //       if (items.length === 0 && path === "") {
  //         archiveList.append('<li class="list-group-item text-muted">No hay archivos</li>');
  //         return;
  //       }

  //       items.forEach(item => {
  //         const link = item.querySelector("a");
  //         if (!link) return;

  //         const name = link.textContent;
  //         const href = link.getAttribute("href").replace("/archive/", "");

  //         // Mostrar cada elemento
  //         archiveList.append(`
  //           <li class="list-group-item d-flex justify-content-between align-items-center">
  //             ${name}
  //             <div>
  //               <button class="btn btn-sm btn-outline-primary ms-2" onclick="selectArchivePath('${href}')">
  //                 <i class="fas fa-check"></i> Seleccionar
  //               </button>
  //               <button class="btn btn-sm btn-outline-secondary ms-2" onclick="previewArchiveFile('${href}')">
  //                 <i class="fas fa-binoculars"></i> Previsualizar
  //               </button>
  //             </div>
  //           </li>
  //         `);
  //       });
  //     })
  //     .catch(() => {
  //       archiveList.append('<li class="list-group-item text-muted">No se pudo cargar</li>');
  //     });
  // }

    // /** Carga la vista previa del SQL
    //  */
    // function previewSqlFile() {
    //   const path = $('#detail-file-input').val();
    //   if (!path) return;

    //   fetch(`/read-sql?path=${encodeURIComponent(path)}`)
    //     .then(res => res.text())
    //     .then(content => {
    //       $('#sql-preview').text(content);
    //       highlightSql();
    //     })
    //     .catch(() => {
    //       $('#sql-preview').text("No se pudo cargar el archivo");
    //     });
    // }

// /** Resguarda en servidor la función editada
//  * @param {int} id - Identificador de función editada. [Valor por defecto: null]
//  */
// function saveEditedFunction(id = null) {
//     const archivo = $('#edit-archivo').val();
//     const ubicacion = $('#edit-ubicacion').val();
//     const funcion = $('#edit-funcion').val();
//     const descripcion = $('#edit-descripcion').val();
//     const selectedNode = $('#jstree').jstree().get_selected(true)[0];

//     if (!selectedNode) return;

//     const entry = {
//         archivo, ubicacion, funcion, descripcion,
//         nodo_id: selectedNode.id
//     };

//     fetch('/save-funcion', {
//         method: 'POST',
//         headers: { 'Content-Type': 'application/json' },
//         body: JSON.stringify(entry)
//     })
//     .then(() => {
//         reloadDetailsCard(); // Recargar tarjeta
//         showToast("Registro guardado");
//         $('#edit-modal').modal('hide');
//     });
// }

// function openTableEditor(entry) {
//   currentEditId = entry.id;

//   $('#edit-archivo').val(entry.archivo || "");
//   $('#edit-orden').val(entry.orden || "1");
//   $('#edit-funcion').val(entry.funcion || "");
//   $('#edit-descripcion').val(entry.descripcion || "");
// }

// function filterTree(filterType) {
//   const tree = $('#jstree').jstree(true);
//   const allNodes = tree.get_json('#', { flat: true });

//   allNodes.forEach(node => {
//     const isContainer = node.type === 'default';
//     const nodeType = node.data?.tipo_nodo?.toLowerCase();

//     if (isContainer) {
//       // Los contenedores siempre visibles
//       tree.show_node(node.id);
//     } else {
//       if (filterType === 'all' || nodeType === filterType) {
//         tree.show_node(node.id);
//       } else {
//         tree.hide_node(node.id);
//       }
//     }
//   });
// }

// function addFile() {
//   const selected = $('#jstree').jstree().get_selected(true)[0];
//   if (!selected || !selected.data) return;

//   const newFile = {
//     archivo: prompt("Nombre del archivo:", ""),
//     ubicacion: prompt("Ubicación:", ""),
//     descripcion: prompt("Descripción:", "")
//   };

//   if (!newFile.archivo || !newFile.ubicacion || !newFile.descripcion) return;

//   const files = selected.data.archivos || [];
//   files.push(newFile);

//   $('#jstree').jstree().set_data(selected.id, {
//     ...selected.data,
//     archivos: files
//   });

//   saveTree();
//   reloadDetailsCard();
// }

// function addFunction() {
//   const selected = $('#jstree').jstree().get_selected(true)[0];
//   if (!selected || !selected.data) return;

//   const newFunction = {
//     archivo: prompt("Nombre del archivo:", ""),
//     ubicacion: prompt("Ubicación:", ""),
//     funcion: prompt("Nombre de la función:", ""),
//     descripcion: prompt("Descripción:", "")
//   };

//   if (!newFunction.archivo || !newFunction.ubicacion || !newFunction.funcion || !newFunction.descripcion) return;

//   const functions = selected.data.funciones || [];
//   functions.push(newFunction);

//   $('#jstree').jstree().set_data(selected.id, {
//     ...selected.data,
//     funciones: functions
//   });

//   saveTree();
//   reloadDetailsCard();
// }

// function loadFunctionsTable(nodeId) {
//     fetch(`/get-js-cs?nodeId=${nodeId}`)
//         .then(res => res.json())
//         .then(entries => {
//             const table = $('#functions-table');
//             table.empty();

//             entries.forEach(entry => {
//                 table.append(`
//                     <tr>
//                         <td>${entry.archivo}</td>
//                         <td>${entry.ubicacion}</td>
//                         <td>${entry.funcion}</td>
//                         <td>${entry.descripcion || "-"}</td>
//                         <td>
//                             <button class="btn btn-sm btn-outline-primary me-1" onclick="openEditFunctionModal(${JSON.stringify(entry)})">
//                                 <i class="fas fa-edit"></i>
//                             </button>
//                             <button class="btn btn-sm btn-outline-danger" onclick="deleteFunction(${entry.id})">
//                                 <i class="fas fa-trash-alt"></i>
//                             </button>
//                         </td>
//                     </tr>
//                 `);
//             });
//         })
//         .catch(() => {
//             console.error("No se pudo cargar la tabla de funciones");
//         });
// }

// function deleteFunction(index) {
//   const selected = $('#jstree').jstree().get_selected(true)[0];
//   if (!selected || !selected.data) return;

//   const functions = selected.data.funciones || [];
//   functions.splice(index, 1);

//   $('#jstree').jstree().set_data(selected.id, {
//     ...selected.data,
//     funciones: functions
//   });

//   saveTree();
//   reloadDetailsCard();
// }

// function saveTreeState() {
//   const treeData = $('#jstree').jstree().get_json(null, { flat: true });
//   treeHistory.push(treeData);

//   if (treeHistory.length > MAX_TREE_HISTORY) {
//     treeHistory.shift();
//   }
// }

// function loadFilesTable(nodeId) {
//   const selected = $('#jstree').jstree().get_node(nodeId);
//   if (!selected || !selected.data) return;

//   const files = selected.data.archivos || [];

//   const tableBody = $('#files-table');
//   tableBody.empty();

//   files.forEach((file, index) => {
//     const row = `
//       <tr>
//         <td>${file.archivo}</td>
//         <td>${file.ubicacion}</td>
//         <td>${file.descripcion}</td>
//       </tr>
//     `;
//     tableBody.append(row);
//   });
// }

//#endregion
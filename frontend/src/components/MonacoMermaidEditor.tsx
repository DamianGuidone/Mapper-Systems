"use client"
import type React from "react"
import { useRef, useEffect } from "react"
import Editor from "@monaco-editor/react"
import type * as monaco from "monaco-editor"
import { MERMAID_SNIPPETS } from "./MermaidTemplates"
import type { MermaidDiagramType } from "../types"

interface MonacoMermaidEditorProps {
  value: string
  onChange: (value: string) => void
  darkMode?: boolean
  onSave?: () => void
  onRender?: () => void
  diagramType?: MermaidDiagramType
}

export const MonacoMermaidEditor: React.FC<MonacoMermaidEditorProps> = ({
  value,
  onChange,
  darkMode = false,
  onSave,
  onRender,
  diagramType = "flowchart",
}) => {
  const editorRef = useRef<monaco.editor.IStandaloneCodeEditor | null>(null)

  const handleEditorDidMount = (editor: monaco.editor.IStandaloneCodeEditor, monacoInstance: any) => {
    editorRef.current = editor

    // Registrar el lenguaje Mermaid personalizado
    if (!monacoInstance.languages.getLanguages().some((lang: any) => lang.id === "mermaid")) {
      monacoInstance.languages.register({ id: "mermaid" })

      // Configurar syntax highlighting para Mermaid
      monacoInstance.languages.setMonarchTokensProvider("mermaid", {
        tokenizer: {
          root: [
            // Frontmatter YAML
            [/^---$/, "keyword.frontmatter"],
            [/^config:/, "keyword.config"],
            [/^\s*(theme|look|layout):/, "keyword.config"],

            // Tipos de diagrama modernos (incluyendo todos los nuevos)
            [
              /\b(flowchart|graph|sequenceDiagram|classDiagram|stateDiagram-v2|erDiagram|journey|gantt|pie|gitgraph|mindmap|timeline|sankey-beta|quadrantChart|requirementDiagram|C4Context|C4Container|C4Component|C4Dynamic|C4Deployment|zenuml|xychart-beta|block-beta|packet|kanban|architecture-beta|radar-beta|treemap-beta)\b/,
              "keyword.diagram",
            ],

            // Direcciones y orientaciones
            [/\b(TD|TB|BT|RL|LR|TOP|BOTTOM|LEFT|RIGHT|horizontal|vertical)\b/, "type.direction"],

            // Conectores modernos con animaciones
            [/[a-zA-Z0-9_]+@/, "identifier.edge"],
            [
              /-->|---|->>|-->>|-\.->>|-\.->|\|\|--o\{|\}--\|\||\|\|--\|\||==|==>|--o|--x|o--o|<-->|x--x|<<->>|<<-->>|-x|--x|-\)|--\)/,
              "operator.connector",
            ],

            // Formas de nodos modernas
            [/\[.*?\]/, "string.node.rect"],
            [/$$.*?$$/, "string.node.round"],
            [/\{.*?\}/, "string.node.rhombus"],
            [/$$$$.*?$$$$/, "string.node.circle"],
            [/>.*?\]/, "string.node.asymmetric"],
            [/\[\[.*?\]\]/, "string.node.subroutine"],

            // Nuevas formas v11.3.0+
            [/@\{\s*shape:\s*\w+/, "keyword.shape"],
            [/@\{\s*icon:\s*"[^"]*"/, "keyword.icon"],
            [/@\{\s*img:\s*"[^"]*"/, "keyword.image"],
            [/@\{\s*assigned:\s*"[^"]*"/, "keyword.metadata"],
            [/@\{\s*ticket:\s*"[^"]*"/, "keyword.metadata"],
            [/@\{\s*priority:\s*"[^"]*"/, "keyword.metadata"],

            // Palabras clave específicas actualizadas (incluyendo nuevos diagramas)
            [
              /\b(participant|actor|note|loop|alt|else|opt|par|and|critical|break|title|section|dateFormat|axisFormat|activate|deactivate|state|class|classDef|click|callback|link|style|end|subgraph|direction|requirementDiagram|element|requirement|Enterprise_Boundary|System_Boundary|Container_Boundary|Boundary|Person|Person_Ext|System|System_Ext|Container|Container_Ext|Component|Component_Ext|Rel|BiRel|UpdateElementStyle|UpdateRelStyle|UpdateLayoutConfig|columns|space|group|service|junction|axis|curve|max|min|showLegend|graticule|ticks)\b/,
              "keyword.control",
            ],

            // Estados y transiciones v2
            [/\b(state|choice|fork|join|end|\[\*\])\b/, "keyword.state"],

            // Clases y relaciones ER
            [/\b(class|interface|enum|abstract|PK|FK|UK)\b/, "keyword.class"],
            [/\|\|--o\{|\}--\|\||\|\|--\|\|/, "operator.relationship"],

            // Fechas y duraciones
            [/\d{4}-\d{2}-\d{2}/, "number.date"],
            [/\d+[dwmy]/, "number.duration"],

            // Comentarios
            [/%%.*$/, "comment"],
            [/\/\/.*$/, "comment"],

            // Strings con comillas y markdown
            [/"`[^`]*`"/, "string.markdown"],
            [/"([^"\\]|\\.)*"/, "string.quoted"],
            [/'([^'\\]|\\.)*'/, "string.quoted"],

            // Números y porcentajes
            [/\d+(\.\d+)?%?/, "number"],

            // Estilos y clases CSS
            [/\bstyle\b/, "keyword.style"],
            [/\bclassDef\b/, "keyword.classdef"],
            [/\bclass\b(?=\s+\w+\s+\w+)/, "keyword.class-assignment"],

            // Colores hexadecimales
            [/#[0-9a-fA-F]{3,6}/, "constant.color"],

            // Identificadores
            [/[a-zA-Z_]\w*/, "identifier"],

            // Operadores especiales
            [/[{}()[\]]/, "delimiter"],
            [/[;,.]/, "delimiter"],
          ],
        },
      })

      // Configurar tema personalizado para Mermaid
      monacoInstance.editor.defineTheme("mermaid-light", {
        base: "vs",
        inherit: true,
        rules: [
          { token: "keyword.diagram", foreground: "0066cc", fontStyle: "bold" },
          { token: "keyword.frontmatter", foreground: "0000ff", fontStyle: "bold" },
          { token: "keyword.config", foreground: "0000ff" },
          { token: "type.direction", foreground: "7c4dff", fontStyle: "bold" },
          { token: "operator.connector", foreground: "ff6b35" },
          { token: "string.node.rect", foreground: "2e7d32" },
          { token: "string.node.round", foreground: "1976d2" },
          { token: "string.node.rhombus", foreground: "f57c00" },
          { token: "string.node.circle", foreground: "8e24aa" },
          { token: "keyword.control", foreground: "d32f2f" },
          { token: "keyword.state", foreground: "388e3c" },
          { token: "keyword.class", foreground: "5d4037" },
          { token: "keyword.shape", foreground: "e91e63" },
          { token: "keyword.icon", foreground: "9c27b0" },
          { token: "keyword.image", foreground: "3f51b5" },
          { token: "keyword.metadata", foreground: "795548" },
          { token: "number.date", foreground: "00695c" },
          { token: "comment", foreground: "757575", fontStyle: "italic" },
          { token: "string.quoted", foreground: "2e7d32" },
          { token: "string.markdown", foreground: "0277bd", fontStyle: "bold" },
          { token: "constant.color", foreground: "e91e63" },
        ],
        colors: {
          "editor.background": "#ffffff",
          "editor.lineHighlightBackground": "#f5f5f5",
        },
      })

      monacoInstance.editor.defineTheme("mermaid-dark", {
        base: "vs-dark",
        inherit: true,
        rules: [
          { token: "keyword.diagram", foreground: "4fc3f7", fontStyle: "bold" },
          { token: "keyword.frontmatter", foreground: "42a5f5", fontStyle: "bold" },
          { token: "keyword.config", foreground: "42a5f5" },
          { token: "type.direction", foreground: "b39ddb", fontStyle: "bold" },
          { token: "operator.connector", foreground: "ff8a65" },
          { token: "string.node.rect", foreground: "81c784" },
          { token: "string.node.round", foreground: "64b5f6" },
          { token: "string.node.rhombus", foreground: "ffb74d" },
          { token: "string.node.circle", foreground: "ba68c8" },
          { token: "keyword.control", foreground: "f48fb1" },
          { token: "keyword.state", foreground: "81c784" },
          { token: "keyword.class", foreground: "a1887f" },
          { token: "keyword.shape", foreground: "f06292" },
          { token: "keyword.icon", foreground: "ce93d8" },
          { token: "keyword.image", foreground: "9fa8da" },
          { token: "keyword.metadata", foreground: "bcaaa4" },
          { token: "number.date", foreground: "4db6ac" },
          { token: "comment", foreground: "9e9e9e", fontStyle: "italic" },
          { token: "string.quoted", foreground: "81c784" },
          { token: "string.markdown", foreground: "4fc3f7", fontStyle: "bold" },
          { token: "constant.color", foreground: "f06292" },
        ],
        colors: {
          "editor.background": "#1e1e1e",
          "editor.lineHighlightBackground": "#2d2d2d",
        },
      })

      // Configurar autocompletado avanzado con snippets específicos por tipo de diagrama
      monacoInstance.languages.registerCompletionItemProvider("mermaid", {
        provideCompletionItems: (model: monaco.editor.ITextModel, position: monaco.Position) => {
          const word = model.getWordUntilPosition(position)
          const range = {
            startLineNumber: position.lineNumber,
            endLineNumber: position.lineNumber,
            startColumn: word.startColumn,
            endColumn: word.endColumn,
          }

          // Detectar el tipo de diagrama actual para ofrecer snippets específicos
          const text = model.getValue()
          let detectedType: MermaidDiagramType = diagramType

          // Intentar detectar el tipo de diagrama del texto actual
          if (text.includes("flowchart") || text.includes("graph ")) {
            detectedType = "flowchart"
          } else if (text.includes("sequenceDiagram")) {
            detectedType = "sequence"
          } else if (text.includes("classDiagram")) {
            detectedType = "classDiagram"
          } else if (text.includes("stateDiagram")) {
            detectedType = "stateDiagram"
          } else if (text.includes("erDiagram")) {
            detectedType = "erDiagram"
          } else if (text.includes("journey")) {
            detectedType = "journey"
          } else if (text.includes("gantt")) {
            detectedType = "gantt"
          } else if (text.includes("pie")) {
            detectedType = "pie"
          } else if (text.includes("gitGraph")) {
            detectedType = "gitgraph"
          } else if (text.includes("mindmap")) {
            detectedType = "mindmap"
          } else if (text.includes("timeline")) {
            detectedType = "timeline"
          } else if (text.includes("quadrantChart")) {
            detectedType = "quadrant"
          } else if (text.includes("requirementDiagram")) {
            detectedType = "requirementDiagram"
          } else if (text.includes("C4Context") || text.includes("C4Container") || text.includes("C4Component")) {
            detectedType = "c4"
          } else if (text.includes("xychart-beta")) {
            detectedType = "xychart"
          } else if (text.includes("block-beta")) {
            detectedType = "block"
          } else if (text.includes("packet")) {
            detectedType = "packet"
          } else if (text.includes("kanban")) {
            detectedType = "kanban"
          } else if (text.includes("architecture-beta")) {
            detectedType = "architecture"
          } else if (text.includes("radar-beta")) {
            detectedType = "radar"
          }

          // Snippets generales
          const generalSnippets = [
            {
              label: "frontmatter-config",
              kind: monacoInstance.languages.CompletionItemKind.Snippet,
              insertText:
                "---\nconfig:\n  theme: ${1|default,dark,forest,neutral|}\n  look: ${2|classic,handDrawn|}\n  layout: ${3|dagre,elk|}\n---\n${4}",
              insertTextRules: monacoInstance.languages.CompletionItemInsertTextRule.InsertAsSnippet,
              documentation: "Configuración moderna con frontmatter",
              range,
            },
            {
              label: "comment",
              kind: monacoInstance.languages.CompletionItemKind.Snippet,
              insertText: "%% ${1:Comentario}",
              insertTextRules: monacoInstance.languages.CompletionItemInsertTextRule.InsertAsSnippet,
              documentation: "Comentario en Mermaid",
              range,
            },
          ]

          // Obtener snippets específicos para el tipo de diagrama detectado
          const typeSpecificSnippets = (MERMAID_SNIPPETS[detectedType] || []).map((snippet) => ({
            label: snippet.label,
            kind: monacoInstance.languages.CompletionItemKind.Snippet,
            insertText: snippet.insertText,
            insertTextRules: monacoInstance.languages.CompletionItemInsertTextRule.InsertAsSnippet,
            documentation: snippet.documentation,
            range,
          }))

          return { suggestions: [...generalSnippets, ...typeSpecificSnippets] }
        },
      })

      // Configurar validación en tiempo real
      monacoInstance.languages.registerHoverProvider("mermaid", {
        provideHover: (model: monaco.editor.ITextModel, position: monaco.Position) => {
          const word = model.getWordAtPosition(position)
          if (!word) return null

          const hoverInfo: { [key: string]: string } = {
            flowchart: "Define un diagrama de flujo. Usa TD (top-down), LR (left-right), etc.",
            sequenceDiagram: "Crea un diagrama de secuencia para mostrar interacciones",
            classDiagram: "Crea un diagrama de clases para mostrar estructura de objetos",
            stateDiagram: "Crea un diagrama de estados para mostrar transiciones",
            erDiagram: "Crea un diagrama entidad-relación para modelar datos",
            gantt: "Genera un cronograma de proyecto con tareas y fechas",
            pie: "Crea un gráfico circular para mostrar distribuciones",
            gitGraph: "Visualiza flujos de trabajo Git con ramas y commits",
            mindmap: "Crea un mapa mental jerárquico",
            timeline: "Crea una línea de tiempo con eventos",
            journey: "Crea un diagrama de experiencia de usuario",
            quadrantChart: "Crea un diagrama de cuadrantes para análisis",
            requirementDiagram: "Crea un diagrama de requisitos",
            C4Context: "Crea un diagrama de contexto C4",
            "xychart-beta": "Crea gráficos XY con barras y líneas",
            "block-beta": "Crea diagramas de bloques para arquitectura",
            packet: "Crea diagramas de estructura de paquetes",
            kanban: "Crea tableros Kanban para gestión de tareas",
            "architecture-beta": "Crea diagramas de arquitectura de sistemas",
            "radar-beta": "Crea diagramas radar para comparaciones multidimensionales",
            participant: "Define un participante en un diagrama de secuencia",
            style: "Aplica estilos CSS a elementos del diagrama",
            classDef: "Define una clase de estilo reutilizable",
            TD: "Top Down - Dirección de arriba hacia abajo",
            LR: "Left Right - Dirección de izquierda a derecha",
            TB: "Top Bottom - Dirección de arriba hacia abajo",
            BT: "Bottom Top - Dirección de abajo hacia arriba",
            RL: "Right Left - Dirección de derecha a izquierda",
            columns: "Define el número de columnas en diagramas de bloques",
            space: "Crea espacios vacíos en diagramas de bloques",
            group: "Agrupa servicios en diagramas de arquitectura",
            service: "Define un servicio en diagramas de arquitectura",
            axis: "Define ejes en diagramas radar",
            curve: "Define curvas de datos en diagramas radar",
          }

          const info = hoverInfo[word.word]
          if (info) {
            return {
              range: new monacoInstance.Range(
                position.lineNumber,
                word.startColumn,
                position.lineNumber,
                word.endColumn,
              ),
              contents: [{ value: info }],
            }
          }

          return null
        },
      })

      // Cambiar el lenguaje a mermaid
      const model = editor.getModel()
      if (model) {
        monacoInstance.editor.setModelLanguage(model, "mermaid")
      }
    }

    // Configurar atajos de teclado
    editor.addCommand(monacoInstance.KeyMod.CtrlCmd | monacoInstance.KeyCode.KeyS, () => {
      onSave?.()
    })

    editor.addCommand(monacoInstance.KeyMod.CtrlCmd | monacoInstance.KeyCode.Enter, () => {
      onRender?.()
    })

    // Aplicar tema
    monacoInstance.editor.setTheme(darkMode ? "mermaid-dark" : "mermaid-light")
  }

  // Cambiar tema cuando cambie darkMode
  useEffect(() => {
    if (editorRef.current) {
      const monacoInstance = (window as any).monaco
      if (monacoInstance) {
        monacoInstance.editor.setTheme(darkMode ? "mermaid-dark" : "mermaid-light")
      }
    }
  }, [darkMode])

  return (
    <Editor
      height="100%"
      language="mermaid"
      value={value}
      onChange={(value) => onChange(value || "")}
      theme={darkMode ? "mermaid-dark" : "mermaid-light"}
      onMount={handleEditorDidMount}
      options={{
        minimap: { enabled: false },
        scrollBeyondLastLine: false,
        fontSize: 14,
        fontFamily: "'Fira Code', 'JetBrains Mono', 'Cascadia Code', 'Consolas', monospace",
        lineNumbers: "on",
        roundedSelection: false,
        scrollbar: {
          vertical: "visible",
          horizontal: "visible",
          useShadows: false,
          verticalHasArrows: false,
          horizontalHasArrows: false,
        },
        folding: true,
        wordWrap: "on",
        automaticLayout: true,
        tabSize: 2,
        insertSpaces: true,
        bracketPairColorization: {
          enabled: true,
        },
        suggest: {
          showKeywords: true,
          showSnippets: true,
          showFunctions: true,
        },
        quickSuggestions: {
          other: true,
          comments: true,
          strings: true,
        },
        parameterHints: {
          enabled: true,
        },
        acceptSuggestionOnCommitCharacter: true,
        acceptSuggestionOnEnter: "on",
        accessibilitySupport: "auto",
        autoIndent: "full",
        contextmenu: true,
        cursorBlinking: "blink",
        cursorSmoothCaretAnimation: "on",
        dragAndDrop: true,
        formatOnPaste: true,
        formatOnType: true,
        mouseWheelZoom: true,
        multiCursorModifier: "ctrlCmd",
        renderLineHighlight: "line",
        renderWhitespace: "selection",
        smoothScrolling: true,
        suggestOnTriggerCharacters: true,
        wordBasedSuggestions: "matchingDocuments",
      }}
    />
  )
}

import { MermaidDiagramType } from "../types";

/**
 * Detecta el tipo de diagrama Mermaid basado en el contenido del código
 * 
 * Esta función analiza el código para determinar qué tipo de diagrama es,
 * sin depender de ningún estado externo. Es crucial para que MermaidRenderer
 * funcione de forma autónoma.
 */
export const detectDiagramTypeFromCode = (code: string): MermaidDiagramType => {
  if (!code.trim()) return "flowchart";
  
  // Patrones de detección para cada tipo de diagrama
  const detectionPatterns: Array<{ 
    pattern: RegExp; 
    type: MermaidDiagramType 
  }> = [
    // Diagramas de flujo
    { pattern: /flowchart|graph/i, type: "flowchart" },
    
    // Diagramas de secuencia
    { pattern: /sequenceDiagram|participant|->|-->|alt|else/i, type: "sequence" },
    
    // Diagramas de clases
    { pattern: /classDiagram|class\s+\w+\s*\{/i, type: "class" },
    
    // Diagramas de estados
    { pattern: /stateDiagram(-v2)?|\[\*\]|-->|-->|-->|-->|-->|-->|-->|-->|-->|-->|-->|-->/i, type: "state" },
    
    // Diagramas ER
    { pattern: /erDiagram|\|\|--|o\{|{|\|--/i, type: "entity-relationship" },
    
    // Diagramas de journey
    { pattern: /journey|section|:|,|->/i, type: "user-journey" },
    
    // Diagramas de requisitos
    { pattern: /requirementDiagram|requirement\s+\w+\s*\{/i, type: "requirement" },
    
    // Diagramas de Gantt
    { pattern: /gantt|dateFormat|section|title/i, type: "gantt" },
    
    // Diagramas circulares
    { pattern: /pie|pie\s+"|"%/i, type: "pie" },
    
    // Diagramas Git
    { pattern: /gitgraph|commit|branch|checkout|merge/i, type: "gitgraph" },
    
    // Mapas mentales
    { pattern: /mindmap|root\(\(|-->|-->|-->|-->|-->|-->|-->|-->|-->|-->|-->|-->/i, type: "mindmap" },
    
    // Líneas de tiempo
    { pattern: /timeline|title|Date|End/i, type: "timeline" },
    
    // Diagramas de cuadrantes
    { pattern: /quadrantChart|title|axis|radar/i, type: "quadrant" },
    
    // Diagramas C4
    { pattern: /C4Context|C4Container|C4Component|C4Dynamic|C4Deployment|group\s+\w+\(.*\)/i, type: "c4" },
    
    // Diagramas XY
    { pattern: /xychart(-beta)?|x-axis|y-axis|bar|line/i, type: "xychart" },
    
    // Diagramas de bloques
    { pattern: /block(-beta)?|block\s+\w+\s*\{/i, type: "block" },
    
    // Diagramas de paquetes
    { pattern: /packet|packet\s+\w+\s*\{/i, type: "packet" },
    
    // Tableros Kanban
    { pattern: /kanban|Todo|In Progress|Done|id\d+\[/i, type: "kanban" },
    
    // Diagramas de arquitectura
    { pattern: /architecture(-beta)?|group\s+\w+\(.*\)|service\s+\w+\(.*\)/i, type: "architecture" },
    
    // Diagramas radar
    { pattern: /radar(-beta)?|title|axis|quadrant/i, type: "radar" }
  ];

  // Intentar detectar por patrones
  for (const { pattern, type } of detectionPatterns) {
    if (pattern.test(code)) {
      return type;
    }
  }

  // Si no se detectó por patrones, intentar inferir por estructura
  if (/-->|-->|-->|-->|-->|-->|-->|-->|-->|-->|-->|-->/.test(code)) {
    return "flowchart";
  } else if (/participant|->|-->|alt|else/.test(code)) {
    return "sequence";
  } else if (/class\s+\w+\s*\{/.test(code)) {
    return "class";
  } else if (/state\s+\w+/.test(code) || /\[\*\]/.test(code)) {
    return "state";
  } else if (/||--|o\{|{|\|--/.test(code)) {
    return "entity-relationship";
  } else if (/requirement\s+\w+\s*\{/.test(code)) {
    return "requirement";
  }

  // Por defecto
  return "flowchart";
};

/**
 * Procesa el código Mermaid para asegurar que use el formato correcto
 * 
 * Esta función es la clave para resolver tus problemas con los 5 tipos de diagrama.
 * Asegura que el código tenga el prefijo correcto que Mermaid espera,
 * independientemente de cómo se haya escrito originalmente.
 */
export const processMermaidCode = (code: string): string => {
  if (!code.trim()) return code;
  
  // Detectar el tipo de diagrama basado en el contenido
  const diagramType = detectDiagramTypeFromCode(code);
  
  // Mapeo de tipos internos a los nombres que espera Mermaid
  const mermaidTypeMap: Record<MermaidDiagramType, string> = {
    flowchart: 'flowchart',
    sequence: 'sequenceDiagram',
    class: 'classDiagram',
    state: 'stateDiagram-v2',
    'entity-relationship': 'erDiagram',
    'user-journey': 'journey',
    requirement: 'requirementDiagram',
    gantt: 'gantt',
    pie: 'pie',
    gitgraph: 'gitgraph',
    mindmap: 'mindmap',
    timeline: 'timeline',
    quadrant: 'quadrantChart',
    c4: 'C4Context',
    xychart: 'xychart-beta',
    block: 'block-beta',
    packet: 'packet',
    kanban: 'kanban',
    architecture: 'architecture-beta',
    radar: 'radar-beta'
  };
  
  const mermaidType = mermaidTypeMap[diagramType];
  
  // Verificar si el código ya tiene un prefijo de tipo
  const typeRegex = /^(flowchart|graph|sequenceDiagram|classDiagram|stateDiagram|stateDiagram-v2|erDiagram|journey|gantt|pie|gitgraph|mindmap|timeline|quadrantChart|requirementDiagram|C4Context|xychart|block|packet|kanban|architecture|radar)\b/m;
  const match = code.match(typeRegex);
  
  if (match) {
    const currentType = match[1];
    // Si el tipo actual no coincide con el que debería ser, lo reemplazamos
    if (currentType.toLowerCase() !== mermaidType.toLowerCase()) {
      return code.replace(typeRegex, mermaidType);
    }
    return code;
  }
  
  // Si no hay tipo especificado, lo agregamos al principio
  return `${mermaidType} ${code}`;
};
import type { MermaidDiagramType } from "../types"

// Plantillas corregidas y funcionales para los diagramas problemáticos
export const MERMAID_TEMPLATES: Record<MermaidDiagramType, { code: string; description: string }> = {
  flowchart: {
    code: `flowchart TD
    A[Inicio] --> B{¿Condición?}
    B -->|Sí| C[Proceso 1]
    B -->|No| D[Proceso 2]
    C --> E[Fin]
    D --> E
    
    style A fill:#e1f5fe,stroke:#01579b,stroke-width:2px
    style E fill:#c8e6c9,stroke:#2e7d32,stroke-width:2px
    style B fill:#fff3e0,stroke:#f57c00,stroke-width:2px`,
    description: "Diagrama de flujo con decisiones y estilos",
  },
  sequence: {
    code: `sequenceDiagram
    participant U as 👤 Usuario
    participant F as 🖥️ Frontend
    participant A as 🔧 API
    participant D as 🗄️ Database
    
    U->>F: Solicitud
    activate F
    F->>A: POST /api/data
    activate A
    A->>D: Query
    activate D
    D-->>A: Resultado
    deactivate D
    A-->>F: Response 200
    deactivate A
    F-->>U: Datos mostrados
    deactivate F
    
    Note over A,D: Validación de datos
    Note over F: Loading state`,
    description: "Diagrama de secuencia con participantes y activaciones",
  },
  classDiagram: {
    code: `classDiagram
    class Usuario {
        +String nombre
        +String email
        +Date fechaRegistro
        +login() Boolean
        +logout() void
        +actualizarPerfil() void
    }
    
    class Sistema {
        -String configuracion
        +autenticar(usuario) Boolean
        +autorizar(permisos) Boolean
        +log(evento) void
    }
    
    class Sesion {
        +String token
        +Date expiracion
        +Boolean activa
        +renovar() void
        +cerrar() void
    }
    
    Usuario --> Sistema : utiliza
    Usuario --> Sesion : tiene
    Sistema --> Sesion : gestiona`,
    description: "Diagrama de clases con propiedades, métodos y relaciones",
  },
  stateDiagram: {
    code: `stateDiagram-v2
    [*] --> Inactivo
    
    Inactivo --> Activo : iniciar
    Activo --> Procesando : procesar
    Procesando --> Activo : completar
    Procesando --> Error : fallar
    Error --> Inactivo : reiniciar
    Activo --> [*] : finalizar
    
    state Procesando {
        [*] --> Validando
        Validando --> Ejecutando
        Ejecutando --> Finalizando
        Finalizando --> [*]
    }
    
    note right of Error : Estado de error requiere intervención`,
    description: "Diagrama de estados v2 con estados compuestos y notas",
  },
  "erDiagram": {
    code: `erDiagram
    USUARIO {
        int id PK
        string nombre
        string email UK
        date fecha_registro
        boolean activo
    }
    
    PEDIDO {
        int id PK
        int usuario_id FK
        decimal total
        date fecha_pedido
        string estado
    }
    
    PRODUCTO {
        int id PK
        string nombre
        decimal precio
        int stock
        string categoria
    }
    
    PEDIDO_ITEM {
        int pedido_id FK
        int producto_id FK
        int cantidad
        decimal precio_unitario
    }
    
    USUARIO ||--o{ PEDIDO : "realiza"
    PEDIDO ||--|{ PEDIDO_ITEM : "contiene"
    PRODUCTO ||--o{ PEDIDO_ITEM : "incluido en"`,
    description: "Diagrama entidad-relación con claves y relaciones",
  },
  "journey": {
    code: `journey
    title Experiencia de Compra Online
    
    section Descubrimiento
      Buscar producto: 5: Usuario
      Ver detalles: 4: Usuario
      Leer reseñas: 3: Usuario
      Comparar precios: 4: Usuario
      
    section Decisión
      Agregar al carrito: 5: Usuario
      Revisar carrito: 4: Usuario
      Aplicar cupón: 3: Usuario
      
    section Compra
      Ingresar datos: 2: Usuario
      Seleccionar envío: 3: Usuario
      Procesar pago: 2: Usuario, Sistema
      Confirmar pedido: 5: Usuario, Sistema
      
    section Post-compra
      Recibir confirmación: 5: Sistema
      Seguir envío: 4: Usuario
      Recibir producto: 5: Usuario
      Dejar reseña: 3: Usuario`,
    description: "Mapa de experiencia del usuario con múltiples secciones",
  },
  gantt: {
    code: `gantt
    title Cronograma del Proyecto Web
    dateFormat YYYY-MM-DD
    axisFormat %d/%m
    
    section Análisis
    Requerimientos      :done, req, 2024-01-01, 2024-01-15
    Casos de uso        :done, casos, after req, 10d
    Arquitectura        :done, arq, 2024-01-10, 2024-01-20
    
    section Diseño
    Wireframes          :active, wire, 2024-01-15, 2024-01-25
    Diseño UI/UX        :design, after wire, 15d
    Prototipo           :proto, after design, 5d
    
    section Desarrollo
    Setup proyecto      :dev-setup, 2024-02-01, 3d
    Backend API         :dev-back, after dev-setup, 20d
    Frontend React      :dev-front, 2024-02-05, 25d
    Base de datos       :dev-db, 2024-02-01, 15d`,
    description: "Cronograma detallado con dependencias y estados",
  },
  pie: {
    code: `pie title Distribución del Tiempo de Desarrollo
    "Frontend React" : 35
    "Backend API" : 30
    "Base de Datos" : 15
    "Testing" : 12
    "DevOps/Deploy" : 5
    "Documentación" : 3`,
    description: "Gráfico circular con título y distribución porcentual",
  },
  gitgraph: {
    code: `gitGraph
    commit id: "Initial commit"
    branch develop
    checkout develop
    commit id: "Setup development"
    commit id: "Add authentication"
    
    branch feature/user-management
    checkout feature/user-management
    commit id: "User model"
    commit id: "User controller"
    commit id: "User tests"
    
    checkout develop
    merge feature/user-management
    commit id: "Integration tests"
    
    checkout main
    merge develop
    commit id: "Release v1.0"`,
    description: "Flujo de trabajo Git con ramas, commits y merges",
  },
  mindmap: {
    code: `mindmap
  root((Proyecto Web))
    Frontend
      React
        Components
        Hooks
        Context
      Styling
        Tailwind CSS
        Material-UI
        Responsive
      Testing
        Jest
        React Testing Library
        E2E Cypress
    Backend
      Node.js
        Express
        Middleware
        Routes
      Database
        PostgreSQL
        Prisma ORM
        Migrations
      API
        REST
        GraphQL
        Authentication`,
    description: "Mapa mental jerárquico del proyecto",
  },
  timeline: {
    code: `timeline
    title Historia del Desarrollo Web
    
    section Años 90
        1991 : Primera página web
             : Tim Berners-Lee
        1993 : Primer navegador gráfico
             : Mosaic
        1995 : JavaScript nace
             : Brendan Eich en Netscape
        1996 : CSS 1.0
             : Hojas de estilo
             
    section Años 2000
        2000 : XHTML 1.0
             : Web estándar
        2005 : AJAX popularizado
             : Aplicaciones dinámicas
        2006 : jQuery lanzado
             : Simplifica JavaScript
        2009 : HTML5 borrador
             : Nuevas capacidades`,
    description: "Línea de tiempo con secciones y eventos múltiples",
  },
  quadrant: {
    code: `quadrantChart
    title Reach and engagement of campaigns
    x-axis Low Reach --> High Reach
    y-axis Low Engagement --> High Engagement
    quadrant-1 We should expand
    quadrant-2 Need to promote
    quadrant-3 Re-evaluate
    quadrant-4 May be improved
    
    Campaign A: [0.3, 0.6]
    Campaign B: [0.45, 0.23]
    Campaign C: [0.57, 0.69]
    Campaign D: [0.78, 0.34]
    Campaign E: [0.40, 0.34]
    Campaign F: [0.35, 0.78]`,
    description: "Diagrama de cuadrantes para análisis de campañas",
  },
  requirementDiagram: {
    code: `requirementDiagram
    requirement test_req {
        id: 1
        text: the test text.
        risk: high
        verifymethod: test
    }
    
    element test_entity {
        type: simulation
    }
    
    test_entity - satisfies -> test_req`,
    description: "Diagrama de requisitos con relaciones",
  },
  c4: {
    code: `C4Context
    title System Context diagram for Internet Banking System
    
    Enterprise_Boundary(b0, "BankBoundary0") {
        Person(customerA, "Banking Customer A", "A customer of the bank, with personal bank accounts.")
        Person(customerB, "Banking Customer B")
        
        System(SystemAA, "Internet Banking System", "Allows customers to view information about their bank accounts, and make payments.")
        
        Enterprise_Boundary(b1, "BankBoundary") {
            SystemDb_Ext(SystemE, "Mainframe Banking System", "Stores all of the core banking information about customers, accounts, transactions, etc.")
            
            System_Boundary(b2, "BankBoundary2") {
                System(SystemA, "Banking System A")
                System(SystemB, "Banking System B", "A system of the bank, with personal bank accounts.")
            }
            
            System_Ext(SystemC, "E-mail system", "The internal Microsoft Exchange e-mail system.")
            SystemDb(SystemD, "Banking System D Database", "A system of the bank, with personal bank accounts.")
        }
    }
    
    BiRel(customerA, SystemAA, "Uses")
    BiRel(SystemAA, SystemE, "Uses")
    Rel(SystemAA, SystemC, "Sends e-mails", "SMTP")
    Rel(SystemC, customerA, "Sends e-mails to")`,
    description: "Diagrama de contexto C4 para arquitectura de sistemas",
  },
  xychart: {
    code: `xychart-beta
    title "Ventas Mensuales"
    x-axis [Ene, Feb, Mar, Abr, May, Jun, Jul, Ago, Sep, Oct, Nov, Dic]
    y-axis "Ventas (en miles)" 0 --> 100
    bar [20, 30, 45, 60, 55, 70, 85, 90, 75, 65, 50, 40]
    line [25, 35, 50, 65, 60, 75, 90, 95, 80, 70, 55, 45]`,
    description: "Gráfico XY con barras y líneas para datos temporales",
  },
  block: {
    code: `block-beta
    columns 3
    
    Frontend["🖥️ Frontend"] space Backend["⚙️ Backend"]
    
    block:group1:2
        columns 2
        React["React"] API["API REST"]
        Redux["Redux"] Auth["Auth"]
    end
    
    Database[("🗄️ Database")]
    
    Frontend --> group1
    group1 --> Database
    Backend --> Database
    
    style Frontend fill:#e1f5fe,stroke:#01579b
    style Backend fill:#f3e5f5,stroke:#7b1fa2
    style Database fill:#e8f5e8,stroke:#2e7d32`,
    description: "Diagrama de bloques para arquitectura de sistemas",
  },
  packet: {
    code: `packet
    title "TCP Packet Structure"
    0-15: "Source Port"
    16-31: "Destination Port"
    32-63: "Sequence Number"
    64-95: "Acknowledgment Number"
    96-99: "Data Offset"
    100-105: "Reserved"
    106: "URG"
    107: "ACK"
    108: "PSH"
    109: "RST"
    110: "SYN"
    111: "FIN"
    112-127: "Window"
    128-143: "Checksum"
    144-159: "Urgent Pointer"
    160-191: "Options"
    192-255: "Data"`,
    description: "Diagrama de estructura de paquetes de red",
  },
  kanban: {
    code: `kanban
    Todo
        [Crear documentación]
        docs[Escribir guía de usuario]
        
    [En Progreso]
        id1[Implementar autenticación]
        id2[Diseñar interfaz]
        
    [Revisión]
        id3[Pruebas unitarias]
        
    [Completado]
        id4[Setup inicial del proyecto]
        id5[Configurar CI/CD]`,
    description: "Tablero Kanban para gestión de tareas y proyectos",
  },
  architecture: {
    code: `architecture-beta
    group api(cloud)[API Layer]
    
    service web(server)[Web Server] in api
    service app(server)[App Server] in api
    service cache(database)[Cache] in api
    
    service db(database)[Database]
    service storage(disk)[File Storage]
    
    web:R --> L:app
    app:R --> L:cache
    app:B --> T:db
    app:B --> T:storage
    
    group external(cloud)[External Services]
    service auth(server)[Auth Service] in external
    service email(server)[Email Service] in external
    
    app:T --> B:auth
    app:T --> B:email`,
    description: "Diagrama de arquitectura de sistemas distribuidos",
  },
  radar: {
    code: `radar-beta
    title "Evaluación de Tecnologías"
    axis performance["Rendimiento"], scalability["Escalabilidad"], security["Seguridad"]
    axis maintainability["Mantenibilidad"], community["Comunidad"], learning["Curva de Aprendizaje"]
    
    curve react["React"]{8, 9, 7, 8, 9, 6}
    curve vue["Vue.js"]{7, 8, 7, 9, 8, 8}
    curve angular["Angular"]{8, 9, 8, 7, 8, 5}
    
    max 10
    min 0`,
    description: "Diagrama radar para comparación multidimensional",
  },
}

// Snippets para el editor de código
export const MERMAID_SNIPPETS = {
  flowchart: [
    {
      label: "flowchart-basic",
      insertText: `flowchart TD
    A[Inicio] --> B{Decisión}
    B -->|Sí| C[Proceso 1]
    B -->|No| D[Proceso 2]
    C --> E[Fin]
    D --> E`,
      documentation: "Diagrama de flujo básico",
    },
    {
      label: "flowchart-subgraph",
      insertText: `flowchart TD
    A[Inicio] --> B{Decisión}
    
    subgraph Proceso
        B -->|Sí| C[Proceso 1]
        B -->|No| D[Proceso 2]
    end
    
    C --> E[Fin]
    D --> E`,
      documentation: "Diagrama de flujo con subgrafo",
    },
  ],
  sequence: [
    {
      label: "sequence-basic",
      insertText: `sequenceDiagram
    participant A as Usuario
    participant B as Sistema
    
    A->>B: Solicitud
    B-->>A: Respuesta`,
      documentation: "Diagrama de secuencia básico",
    },
  ],
  classDiagram: [
    {
      label: "class-basic",
      insertText: `classDiagram
    class Usuario {
        +String nombre
        +String email
        +login() Boolean
        +logout() void
    }`,
      documentation: "Diagrama de clases básico",
    },
  ],
  // Añadir snippets para los otros tipos...
  stateDiagram: [],
  erDiagram: [],
  journey: [],
  gantt: [],
  pie: [],
  gitgraph: [],
  mindmap: [],
  timeline: [],
  quadrant: [],
  requirementDiagram: [],
  c4: [],
  xychart: [],
  block: [],
  packet: [],
  kanban: [],
  architecture: [],
  radar: [],
}

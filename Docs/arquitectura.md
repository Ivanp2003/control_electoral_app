# Arquitectura — Control Electoral Ecuador

## Diagrama de Capas

```mermaid
C4Container
  Person(usuario, "Usuario Electoral", "Veedor, Coordinador de Recinto, Coordinador Provincial")
  
  System_Boundary(app, "App Flutter") {
    Container(presentation, "Presentation", "Flutter Widgets + Riverpod", "UI, Providers, Screens")
    Container(domain, "Domain", "Pure Dart", "Entidades, Casos de Uso, Contratos")
    Container(data, "Data", "Dart + Drift + Appwrite SDK", "Datasources, Modelos, Repositorios")
    ContainerDb(local_db, "SQLite Local", "Drift", "11 tablas de caché offline")
  }
  
  System_Ext(appwrite, "Appwrite Backend", "BaaS")
  
  Rel(usuario, presentation, "Interactúa")
  Rel(presentation, domain, "Consume")
  Rel(domain, data, "Implementa")
  Rel(data, local_db, "Persiste", "Drift ORM")
  Rel(data, appwrite, "Sincroniza", "REST API")
```

## Stack Tecnológico

| Capa | Tecnología | Propósito |
|------|-----------|-----------|
| UI | Flutter 3.x + Material 3 | Renderizado multiplataforma |
| Estado | Riverpod 2.x + Freezed | DI, estado global, notificadores |
| Ruteo | GoRouter | Navegación declarativa con guards de autenticación |
| Local DB | Drift (SQLite) | Caché offline-first (11 tablas) |
| Backend | Appwrite | Auth, DB, Storage, Functions |
| Sync | SyncQueue + SyncProcessor | Cola de operaciones offline |
| GPS | geolocator | Captura de coordenadas |
| Cámara | camera + google_mlkit_text_recognition | Evidencia fotográfica con análisis de nitidez |

## Flujo de Datos — Offline First

```mermaid
flowchart TD
  User([Usuario]) --> UI[Pantalla Flutter]
  UI --> Provider[Riverpod Provider/Notifier]
  Provider --> UC[Caso de Uso]
  UC --> Repo[Repositorio]
  Repo --> Local[(SQLite Drift)]
  Repo --> Remote[Appwrite API]
  Repo -.-> Queue[SyncQueue]
  Queue -.-> Processor[SyncProcessor<br/>c/10s si online]
  Processor --> Remote
```

## Modelo de Datos (Drift — SQLite Local)

```mermaid
erDiagram
  ProvinciasLocal {
    string id PK
    string nombre
  }
  CantonesLocal {
    string id PK
    string nombre
    string provinciaId FK
  }
  ParroquiasLocal {
    string id PK
    string nombre
    string cantonId FK
  }
  RecintosLocal {
    string id PK
    string nombre
    string parroquiaId FK
    string direccion
    float latRef
    float lonRef
  }
  JrvLocal {
    string id PK
    string codigo
    string recintoId FK
  }
  OrganizacionesLocal {
    string id PK
    string nombre
    string cargo
  }
  ActasLocal {
    string id PK
    string jrvId FK
    string cargoElectoral
    int votosBlancos
    int votosNulos
    int totalSufragantes
    string fotoUrl
    float latitud
    float longitud
    bool synced
    string creadoPor
  }
  ActaDetalleLocal {
    string id PK
    string actaId FK
    string organizacionId
    string nombreOrganizacion
    int votos
  }
  ConfigSistemaLocal {
    string clave PK
    string valor
  }
  VeedorJrvLocal {
    string id PK
    string veedorId
    string jrvId FK
    string recintoId FK
  }

  ProvinciasLocal ||--o{ CantonesLocal : provinciaId
  CantonesLocal ||--o{ ParroquiasLocal : cantonId
  ParroquiasLocal ||--o{ RecintosLocal : parroquiaId
  RecintosLocal ||--o{ JrvLocal : recintoId
  ActasLocal ||--o{ ActaDetalleLocal : actaId
  JrvLocal ||--o{ ActasLocal : jrvId
  RecintosLocal ||--o{ VeedorJrvLocal : recintoId
  JrvLocal ||--o{ VeedorJrvLocal : jrvId
```

## Colecciones Appwrite

| Colección | Uso |
|-----------|-----|
| `usuarios` | Perfiles de usuario (rol, cédula, etc.) |
| `provincias` / `cantones` / `parroquias` / `recintos` / `jrv` | Jerarquía geográfica |
| `organizaciones_politicas` | Catálogo de listas electorales |
| `actas` + `acta_detalle` | Resultados electorales |
| `veedor_jrv` | Asignación veedor ↔ mesa |
| `config_sistema` | Flags del sistema (seed ejecutado) |
| `evidencia_fotografica` (bucket) | Fotos de actas |

## Casos de Uso por Actor

```mermaid
flowchart LR
  subgraph Veedor
    V1[Registrar Acta]
    V2[Corregir sus Actas]
    V3[Capturar Evidencia]
  end
  subgraph CoordRecinto["Coord. Recinto"]
    C1[Ver Actas del Recinto]
    C2[Corregir Actas del Recinto]
    C3[Crear Veedores]
    C4[Asignar Veedores a JRV]
  end
  subgraph CoordProvincial["Coord. Provincial"]
    P1[Crear Recintos]
    P2[Seeder Datos Iniciales]
    P3[Crear Usuarios]
    P4[Asignar Coord. Recinto]
    P5[Dashboard Avance]
    P6[Ver Coordenadas GPS]
  end
```

## Sincronización

```mermaid
flowchart TD
  Q[(SyncQueue<br/>SQLite)]
  O[SyncOrchestrator<br/>Riverpod Notifier]
  P[SyncProcessorImpl]
  R[ActasRemoteDatasource]
  C[connectivity_plus]

  O -->|escucha| C
  C -->|online| O
  O -->|timer 10s| P
  P -->|lee| Q
  P -->|procesa| R
  P -->|actualiza| Q

  Q -->|inserta| App[App Flutter]
```

## Permisos (AppPermissions)

| Método | Coord. Provincial | Coord. Recinto | Veedor |
|--------|:-:|:-:|:-:|
| `puedeCrearRecintos` | ✅ | ❌ | ❌ |
| `puedeCrearCoordinadoresRecinto` | ✅ | ❌ | ❌ |
| `puedeConsultarAvance` | ✅ | ❌ | ❌ |
| `puedeConsultarCoordenadas` | ✅ | ❌ | ❌ |
| `puedeCrearVeedores` | ❌ | ✅ | ❌ |
| `puedeAsignarVeedores` | ❌ | ✅ | ❌ |
| `puedeReasignarVeedores` | ❌ | ✅ | ❌ |
| `puedeRegistrarActas` | ❌ | ❌ | ✅ |
| `puedeCorregirSusPropiasActas` | ❌ | ❌ | ✅ |
| `puedeCapturarFotos` | ❌ | ❌ | ✅ |

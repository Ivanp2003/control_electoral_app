# Sistema de Control Electoral Ecuador (Flutter) - Estructura Base

Este proyecto contiene la base estructural (Fase 1) del Sistema de Control Electoral de Ecuador. Está diseñado siguiendo principios estrictos de **Clean Architecture** y una estrategia de diseño **Offline-First desde el día 1**.

---

## 1. Estructura de Carpetas

El código está estructurado en base a **Clean Architecture por feature**:

```
lib/
├── core/
│   ├── constants/      # Roles, permisos, configuración de Appwrite y cargos
│   ├── errors/         # Jerarquía de fallos (Failures) usando Equatable
│   ├── network/        # Inicialización de clientes (Appwrite y conectividad)
│   ├── validators/     # Validación de cédula y fórmulas matemáticas de actas
│   ├── theme/          # Estilos visuales globales de la app
│   └── utils/          # Utilidades auxiliares
├── database/           # Persistencia local con Drift (Tablas, DAOs y consultas)
├── features/           # Módulos de lógica agrupados por dominio
│   ├── auth/           # Autenticación, tokens y roles de usuario
│   ├── usuarios/       # Administración de perfiles
│   ├── recintos/       # Gestión territorial (provincias → cantones → parroquias → recintos → JRV)
│   ├── organizaciones/ # Partidos políticos precargados
│   ├── actas/          # Escrutinios de Alcalde y Prefecto
│   ├── evidencia/      # Captura de fotos y análisis de nitidez
│   ├── geolocalizacion/ # Servicios finos de GPS
│   └── sync/           # Cola de sincronización y orquestación offline -> online
└── shared/widgets/     # Componentes visuales genéricos reutilizables
```

### Separación en Features
Cada característica o feature importante (`auth`, `usuarios`, `recintos`, `organizaciones`, `actas`, `evidencia`) está estructurado físicamente en tres capas:
1. **data/**: Contiene implementaciones de repositorios, modelos (Freezed/JSON) y fuentes de datos (Appwrite y base local Drift).
2. **domain/**: Contiene las entidades puras de negocio, interfaces de repositorios y casos de uso (Use Cases).
3. **presentation/**: Contiene los providers de Riverpod (StateNotifier/Generados), pantallas (Screens) y widgets específicos.

---

## 2. Decisiones Clave de Diseño y Fase 1

* **State Management con Generador de Riverpod**: Se utiliza la sintaxis moderna con `@riverpod` y generación de código (`riverpod_generator`). Los proveedores se definen como singletons lazy o con auto-dispose automático controlados por el contenedor.
* **Offline-First Desde el Diseño**: Toda escritura pasa por una interfaz del repositorio en `domain`. El repositorio evalúa el estado del servicio de red (`ConnectivityService`) y decide escribir directamente en Appwrite o encolar localmente en Drift (`SyncQueue`) marcando la entidad como `synced = false`.
* **Variables de Entorno Seguras**: Las credenciales de Appwrite se cargan desde el entorno usando variables de compilación (`--dart-define`), evitando strings hardcodeados sensibles en el repositorio.
* **Contrato de Nitidez Intercambiable**: El módulo de evidencia define la interfaz abstracta `SharpnessAnalyzer` en `domain/services/`, aislando el resto del sistema de la decisión tecnológica final (ML Kit OCR vs OpenCV Laplaciano). Retorna un objeto `SharpnessResult` con puntuación analítica.

---

## 3. Instrucciones de Compilación y Ejecución

### Paso 1: Descargar dependencias
Descargue los paquetes requeridos definidos en `pubspec.yaml`:
```bash
flutter pub get
```

### Paso 2: Generar archivos generados (Codegen)
Ejecute el generador de código de Drift, Freezed y Riverpod:
```bash
dart run build_runner build --delete-conflicting-outputs
```

### Paso 3: Ejecutar la aplicación
Para compilar y correr la aplicación, es obligatorio inyectar los valores del servidor y proyecto de Appwrite mediante variables de entorno en la línea de comando. De lo contrario, la aplicación se iniciará mostrando la pantalla de error de inicialización.

```bash
flutter run --dart-define=APPWRITE_ENDPOINT=https://[TU-SERVIDOR-APPWRITE]/v1 --dart-define=APPWRITE_PROJECT_ID=[ID-DE-TU-PROYECTO]
```

---

## 4. Configuración Requerida en Appwrite (Consola de Administración)

Para asegurar el funcionamiento correcto de la autenticación de la Fase 2, aplique la siguiente configuración en su consola de Appwrite:

### A. Índices Únicos en Colección `usuarios`
1. Diríjase a **Database -> control_electoral_db -> usuarios**.
2. En la sección **Indexes**, cree los siguientes índices:
   - **Cédula**: Key `cedula`, Type `unique`, Attribute `cedula`.
   - **Correo**: Key `correo`, Type `unique`, Attribute `correo`.

### B. Cloud Function: `buscar_correo_por_cedula`
1. Cree una Cloud Function con el ID `buscar_correo_por_cedula`.
2. Habilite permisos de ejecución pública para **`any`** (Guests), de modo que usuarios no autenticados puedan invocarla en el Login.
3. Configure la variable de entorno `APPWRITE_API_KEY` con permisos de lectura de la base de datos.
4. La función recibirá la cédula `{"cedula": "..."}` y debe retornar `{"correo": "correo@dominio.com"}` o `{"error": "not_found"}` si no existe.

### C. Cloud Function: `crear_usuario`
1. Cree una Cloud Function con el ID `crear_usuario`.
2. Configure los permisos de ejecución para **`users`** (únicamente usuarios registrados y coordinadores).
3. La función debe validar que la cédula y correo no existan previamente y registrar la cuenta en Appwrite Auth (`users.create`) vinculándola con su respectivo documento de la colección `usuarios`.

---

## 5. Creación del Primer Usuario Coordinador Provincial (Bootstrap Manual)

Dado que los seeders automáticos se inyectan en la Fase 3, cree el primer usuario manualmente para poder acceder al sistema:

1. **Crear Registro en Auth**:
   - Vaya a **Auth** en la consola de Appwrite y presione **Add User**.
   - Ingrese un correo (ej. `provincial@control-electoral.gob.ec`) y la contraseña inicial `Ecuador2026`.
   - Copie el ID de usuario autogenerado (ej. `65f8a02c...`).

2. **Crear Perfil en Base de Datos**:
   - Vaya a **Database -> control_electoral_db -> usuarios** y haga clic en **Add Document**.
   - En **Document ID**, pegue exactamente el ID de usuario copiado en el paso anterior.
   - Rellene los campos:
     - `cedula`: Una cédula válida de 10 dígitos (ej: `1710034065`).
     - `nombres`: Juan Carlos
     - `apellidos`: Pérez Andrade
     - `telefono`: 0999999999
     - `correo`: `provincial@control-electoral.gob.ec`
     - `rol`: `coordinadorProvincial`
     - `passwordChanged`: `false` (lo que le obligará a actualizar su contraseña al ingresar).

---

## 6. Checklist de Avance del Proyecto

* [x] **Fase 1: Base Estructural**
* [x] **Fase 2: Auth y Roles**
  - Implementar flujo de Login con cédula como usuario y contraseña inicial default `Ecuador2026`.
  - Forzar cambio de contraseña en primer inicio de sesión mediante interceptores de GoRouter.
  - Implementar middleware/protección visual utilizando la clase `AppPermissions` y las reglas definidas en `app_roles.dart`.
* [x] **Fase 3: Recintos y Seeders**
  - Crear seeder local para poblar la provincia de Pichincha, cantón Quito, sus parroquias, recintos y JRVs.
  - Pre-cargar las 5 organizaciones políticas para Alcalde y las 5 para Prefecto.
* [x] **Fase 4: Actas**
  - Validación matemática obligatoria en `acta_validator.dart` (suma de votos = total sufragantes), con `ActaInconsistenteFailure` que indica la diferencia exacta.
  - Validación adicional: ningún candidato puede tener más votos que el total de sufragantes.
  - Permisos: Veedor registra y corrige solo sus actas; Coordinador de Recinto corrige cualquier acta de su recinto; Coordinador Provincial solo consulta.
  - Offline-first: registro en Drift (`ActasLocal` + `ActaDetalleLocal`) con encolado en `SyncQueue` cuando no hay conexión.
  - Edición con registro de quién corrigió y cuándo (`editadoPor`, `fechaEdicion`).
  - Tabla `VeedorJrvLocal` para asignación de veedores a JRV.
  - Pantallas: `RegistrarActaScreen` (flujo selección JRV → cargo → votos → validación → guardado) y `MisActasScreen`.
* [x] **Fase 5: Evidencia (Cámara, GPS y Nitidez)**
  - GPS gate: `GpsService` / `GeolocatorGpsService` con verificación de permiso y captura de coordenadas.
  - Cámara nativa obligatoria (bloqueando galería) con `camera` package.
  - `MlKitSharpnessAnalyzer` implementa `SharpnessAnalyzer` usando Google ML Kit text recognition.
  - Máquina de estados `EvidenciaFlowNotifier` (gpsPermission → cameraPermission → capturaFoto → analisisNitidez → completado/rechazado).
  - `EvidenciaData` se integra con el flujo de registro de actas (fotoPath, latitud, longitud).
  - Permisos nativos actualizados: `CAMERA`, `ACCESS_FINE_LOCATION`, `ACCESS_COARSE_LOCATION` (Android); `NSCameraUsageDescription`, `NSLocationWhenInUseUsageDescription` (iOS).
* [x] **Fase 6: Sync Engine**
  - `SyncProcessorImpl` procesa la `SyncQueue` (entityType + operation + payload JSON) con deserialización y dispatch al datasource remoto correspondiente.
  - Retry con max 3 intentos: al fallar incrementa `attempts`; al llegar a 3 marca `status = 'failed'`.
  - `SyncOrchestrator` (Riverpod Notifier) escucha `ConnectivityService.onConnectivityChanged` y ejecuta el processor cada 10s mientras esté online.
  - `SyncIndicator` widget en el AppBar del HomeScreen muestra estado (idle/syncing/error) y permite sincronización manual al tocar.
  - Cola existente `SyncQueue` (Drift, Fase 1) + CRUD (`obtenerColaPendiente`, `encolarOperacion`, `actualizarEstadoCola`, `eliminarDeLaCola`).
  - `ActasRemoteDatasource.getById()` añadido para eventual resolución LWW.

# 🗳️ Control Electoral Ecuador

Aplicación móvil para el registro, monitoreo y control de actas electorales durante procesos de votación en Ecuador. Diseñada con arquitectura **offline-first** para funcionar en zonas sin conectividad.

---

## ✨ Características

- 📸 **Registro de Actas** con captura fotográfica, geolocalización obligatoria y verificación de nitidez mediante OCR
- 🗺️ **Jerarquía Geográfica** — provincias, cantones, parroquias, recintos y JRV con drill-down
- 👥 **Gestión de Usuarios** — coordinadores provinciales, coordinadores de recinto y veedores con matriz de permisos
- 🔄 **Sincronización Offline-First** — cola de tareas pendientes con reintentos automáticos al recuperar conectividad
- 📊 **Dashboard de Avance** — cobertura geográfica, coordenadas GPS, total de actas y votos en tiempo real
- 🎨 **Modo Claro / Oscuro** con paleta Material 3
- 🌐 **Recuperación de Contraseña** vía email con enlace seguro
- 📋 **Seeder de Datos Iniciales** — carga masiva de provincias, cantones, parroquias, recintos, JRV y organizaciones políticas

---

## 🛠️ Tecnologías

| Categoría | Tecnología |
|-----------|-----------|
| **Framework** | Flutter 3.11+ • Dart SDK 3.11+ |
| **Estado & DI** | Riverpod con code generation |
| **Backend** | Appwrite (Auth, Databases, Storage, Functions) |
| **Base Local** | Drift (SQLite) — 11 tablas |
| **Navegación** | GoRouter con guards por rol |
| **GPS** | Geolocator |
| **Cámara** | Image Picker • Google ML Kit (detección de borrosidad) |
| **Arquitectura** | Clean Architecture (domain / data / presentation) |
| **Errores** | Dartz Either<Failure, T> |
| **IDs** | UUID • SHA-1 (deterministico para Appwrite) |

---

## 🧱 Arquitectura

```
📦 capa_presentation → Widgets + Providers (Riverpod)
📦 capa_domain      → Entidades puras • Use Cases • Contratos Repository
📦 capa_data        → Datasources (Appwrite • Drift) • Implementaciones Repository
```

**Offline-First:**
1. Las lecturas intentan Appwrite, cachean en SQLite, fallback a SQLite si no hay red
2. Las escrituras van directo a Appwrite; si fallan, se guardan localmente + encolan en `SyncQueue`
3. Un `SyncOrchestrator` escucha cambios de conectividad y procesa la cola automáticamente

**Roles y permisos:**

| Permiso | Coord. Provincial | Coord. Recinto | Veedor |
|---------|:-:|:-:|:-:|
| Crear recintos | ✅ | ❌ | ❌ |
| Asignar veedores | ❌ | ✅ | ❌ |
| Registrar actas | ❌ | ❌ | ✅ |
| Capturar fotos | ❌ | ❌ | ✅ |
| Ver dashboard | ✅ | ❌ | ❌ |

---

## 🔐 Flujo de Autenticación

1. El usuario ingresa su **cédula** en la pantalla de login
2. Se consulta una **Appwrite Function** que resuelve la cédula → correo electrónico
3. Se crea una sesión con `Account.createEmailPasswordSession`
4. Si es el **primer inicio**, se fuerza el cambio de contraseña
5. La sesión persiste y se verifica al iniciar la app

---

## 📱 Pantallas Principales

| Ruta | Pantalla | Acceso |
|------|----------|--------|
| `/home` | Menú principal | Todos |
| `/actas/registrar` | Registrar / corregir acta | Veedor, Coord. Recinto |
| `/actas/mis-actas` | Mis actas registradas | Veedor |
| `/recintos` | Jerarquía geográfica | Todos |
| `/mi-recinto` | Recinto asignado | Coord. Recinto |
| `/usuarios/crear` | Crear usuario | Coord. Provincial, Coord. Recinto |
| `/avance` | Dashboard de avance | Coord. Provincial |
| `/sync/estado` | Estado de sincronización | Todos |
| `/seeder` | Carga inicial de datos | Coord. Provincial |

---

## 🚀 Desarrollo

```bash
# Dependencias
flutter pub get

# Generar código (Riverpod, Drift, JSON, Freezed)
dart run build_runner build --delete-conflicting-outputs

# Análisis
flutter analyze

# APK Release
flutter build apk --release
```

> ⚠️ Requiere las variables de entorno de Appwrite configuradas en `lib/core/constants/appwrite_config.dart`.

---

## 📄 Licencia

Uso interno — Proceso electoral Ecuador.

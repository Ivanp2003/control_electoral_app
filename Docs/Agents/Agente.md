# AGENTE.md - Arquitecto Flutter Senior para Sistema de Control Electoral Ecuador

Actúa como un Arquitecto de Software Senior especializado en Flutter, Clean Architecture, Riverpod, Appwrite, Seguridad, Offline First y aplicaciones gubernamentales.

Tu objetivo es diseñar, revisar y generar código para un Sistema de Control Electoral para Ecuador.

Nunca propongas soluciones rápidas que incumplan requisitos funcionales o técnicos.

---

# Objetivo del Sistema

Aplicación móvil Flutter para control electoral con tres roles:

1. Coordinador Provincial
2. Coordinador de Recinto
3. Veedor de Mesa

La aplicación permitirá registrar actas de escrutinio para Alcalde y Prefecto, almacenar evidencia fotográfica, registrar coordenadas GPS y controlar el avance electoral.

---

# Arquitectura Obligatoria

Utilizar:

* Clean Architecture
* Riverpod
* Appwrite

Separar estrictamente:

* Presentation
* Domain
* Data

Nunca mezclar lógica de negocio dentro de Widgets.

---

# Roles y Permisos

## Coordinador Provincial

Puede:

* Crear recintos electorales.
* Crear coordinadores de recinto.
* Asignar coordinadores.
* Consultar avance electoral.
* Consultar coordenadas GPS de las actas.

No puede registrar actas.

---

## Coordinador de Recinto

Puede:

* Crear veedores.
* Asignar veedores a JRV.
* Reasignar veedores.
* Corregir cualquier acta de su recinto.

No puede acceder a otros recintos.

---

## Veedor

Puede:

* Ver únicamente sus JRV asignadas.
* Registrar actas.
* Editar sus actas.
* Capturar fotografías.
* Registrar resultados.

No puede acceder a otras mesas.

---

# Datos Precargados Obligatorios

Debe existir una provincia ecuatoriana precargada.

Ejemplo:

Provincia:
Pichincha

Cantón:
Quito

Parroquias:
Calderón
Carcelén
Conocoto
Tumbaco

Recintos:
Múltiples.

JRV:
Múltiples.

También deben existir:

* 5 organizaciones políticas para Alcalde.
* 5 organizaciones políticas para Prefecto.

Implementar Seeder inicial.

---

# Gestión de Usuarios

Campos obligatorios:

* Cédula
* Nombres
* Apellidos
* Teléfono
* Correo

Usuario:

cédula

Contraseña inicial:

Ecuador2026

Primer login:

Obligar cambio de contraseña.

---

# Validación de Cédula Ecuatoriana

Implementar algoritmo oficial.

Validar:

* Longitud 10
* Provincia válida
* Tercer dígito menor que 6
* Módulo 10

No permitir registros inválidos.

---

# Recuperación de Contraseña

Implementar mediante Appwrite.

Enviar correo de recuperación.

---

# Gestión de Actas

Cada JRV registra:

1 Acta Alcalde

1 Acta Prefecto

Cada acta contiene:

* Organización política 1
* Organización política 2
* Organización política 3
* Organización política 4
* Organización política 5
* Blancos
* Nulos
* Total sufragantes
* Fotografía
* Coordenadas GPS

---

# Validaciones de Acta

Validar:

Total sufragantes ==
Suma candidatos +
Blancos +
Nulos

Ningún candidato puede superar el total de sufragantes.

No permitir guardar si existen inconsistencias.

---

# GPS

GPS obligatorio.

Si el permiso está denegado:

Bloquear proceso.

No permitir registrar acta.

Guardar:

* Latitud
* Longitud

como campos de base de datos.

---

# Cámara

Usar cámara nativa.

No usar galería.

La fotografía debe tomarse desde la aplicación.

---

# Validación de Nitidez

Obligatoria.

Implementar:

Opción básica:
OCR con Google ML Kit.

Opción avanzada:
OpenCV + Variance of Laplacian.

Si la imagen es borrosa:

Rechazar captura.

Solicitar nueva fotografía.

---

# Offline First

Implementar persistencia local.

Tecnologías sugeridas:

* Drift
* Hive

Flujo:

Sin internet:
Guardar local.

Con internet:
Sincronizar automáticamente.

Manejar conflictos.

---

# Estados UI

Todas las operaciones deben tener:

* Loading
* Success
* Error
* Empty

Nunca dejar pantallas sin retroalimentación.

---

# Seguridad

Implementar permisos por rol.

Un veedor:

No puede acceder a mesas ajenas.

Un coordinador:

No puede acceder a recintos ajenos.

Implementar reglas también en Appwrite.

---

# Entregables

Generar:

* Código Flutter
* Estructura Clean Architecture
* Modelo de datos Appwrite
* Casos de uso
* Repositorios
* Providers Riverpod
* Diagramas
* README
* APK

Priorizar escalabilidad, mantenibilidad y facilidad de sustentación académica.

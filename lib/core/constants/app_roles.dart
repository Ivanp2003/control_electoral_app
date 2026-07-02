// app_roles.dart
// 
// Responsabilidad Única: Definir los roles del sistema y la matriz de permisos electorales.
// Cambios en esta clase ocurren si se modifica la matriz de permisos de la aplicación.
//
// HISTORIAL DE CAMBIOS:
//   - Fase 1: Definición original aprobada con nomenclatura en español (puede*).
//   - Fase 3 (corrección): Restaurada la nomenclatura española after detectar drift
//     silencioso a inglés (can*) durante generación de código de Fase 1.
//     Cambios en esta corrección:
//       • RESTAURADO: puedeCrearRecintos (era canCreateRecintos)
//       • RESTAURADO: puedeCrearCoordinadoresRecinto (era canCreateOrAssignCoordinadoresRecinto)
//       • RESTAURADO: puedeVerAvanceGlobalYGps como método único (era 2 métodos: canViewAvanceGlobal + canViewGpsGlobal)
//       • RESTAURADO: puedeCrearVeedores separado (estaba fusionado en canManageVeedores)
//       • RESTAURADO: puedeReasignarVeedores separado (estaba fusionado en canManageVeedores)
//       • RESTAURADO: puedeCorregirCualquierActaDelRecinto (era canCorrectAnyActaInRecinto)
//       • RESTAURADO: puedeRegistrarActas (era canRegisterActas)
//       • RESTAURADO: puedeCorregirSusPropiasActas (era canCorrectOwnActasOnly)
//       • ADICIÓN DELIBERADA Fase 3: puedeCapturarFotos — no existía en Fase 1;
//         se agrega ahora como método explícito porque Fase 4 (actas/evidencia) lo necesitará.
//         Se documenta aquí para que quede en la matriz de permisos, no implícito en el rol.

enum AppRole {
  coordinadorProvincial,
  coordinadorRecinto,
  veedor,
}

/// Define la matriz de permisos estática del sistema electoral.
class AppPermissions {
  AppPermissions._();

  // ---------------------------------------------------------------------------
  // Permisos de Coordinador Provincial
  // ---------------------------------------------------------------------------

  /// Permite crear recintos electorales.
  /// [RESTAURADO Fase 3] — nombre original Fase 1.
  static bool puedeCrearRecintos(AppRole role) =>
      role == AppRole.coordinadorProvincial;

  /// Permite crear coordinadores de recinto.
  /// [RESTAURADO Fase 3] — nombre literal de Fase 1 (sin "asignar" en el nombre,
  /// aunque en la práctica el permiso cubre tanto creación como asignación).
  static bool puedeCrearCoordinadoresRecinto(AppRole role) =>
      role == AppRole.coordinadorProvincial;

  /// Permite ver el avance global del proceso electoral.
  static bool puedeConsultarAvance(AppRole role) =>
      role == AppRole.coordinadorProvincial;

  /// Permite consultar las coordenadas GPS de las actas registradas.
  static bool puedeConsultarCoordenadas(AppRole role) =>
      role == AppRole.coordinadorProvincial;

  /// [Compatibilidad] Versión compuesta de los dos permisos anteriores.
  static bool puedeVerAvanceGlobalYGps(AppRole role) =>
      role == AppRole.coordinadorProvincial;

  // ---------------------------------------------------------------------------
  // Permisos de Coordinador de Recinto
  // ---------------------------------------------------------------------------

  /// Permite crear nuevos veedores para su recinto.
  /// [RESTAURADO Fase 3] — estaba fusionado con puedeReasignarVeedores
  /// en el método canManageVeedores; aquí se restaura la granularidad original.
  static bool puedeCrearVeedores(AppRole role) =>
      role == AppRole.coordinadorRecinto;

  /// Permite asignar veedores a JRV.
  static bool puedeAsignarVeedores(AppRole role) =>
      role == AppRole.coordinadorRecinto;

  /// Permite reasignar veedores entre JRV dentro de su recinto.
  /// [RESTAURADO Fase 3] — ver nota anterior sobre fusión incorrecta.
  static bool puedeReasignarVeedores(AppRole role) =>
      role == AppRole.coordinadorRecinto;

  /// Permite corregir cualquier acta perteneciente a su propio recinto electoral.
  /// [RESTAURADO Fase 3] — nombre original Fase 1.
  static bool puedeCorregirCualquierActaDelRecinto(AppRole role) =>
      role == AppRole.coordinadorRecinto;

  // ---------------------------------------------------------------------------
  // Permisos de Veedor
  // ---------------------------------------------------------------------------

  /// Permite registrar actas de escrutinio en las JRV asignadas.
  /// [RESTAURADO Fase 3] — nombre original Fase 1.
  static bool puedeRegistrarActas(AppRole role) =>
      role == AppRole.veedor;

  /// Permite corregir únicamente las actas que el propio veedor ha registrado.
  /// [RESTAURADO Fase 3] — nombre original Fase 1.
  static bool puedeCorregirSusPropiasActas(AppRole role) =>
      role == AppRole.veedor;

  /// Permite capturar fotografías del acta física desde la cámara nativa.
  /// [ADICIÓN DELIBERADA — Fase 3] No existía en Fase 1. Se agrega como
  /// método explícito en la matriz para que Fase 4 (evidencia/cámara) pueda
  /// verificar permisos contra este contrato en lugar de asumir el rol implícitamente.
  static bool puedeCapturarFotos(AppRole role) =>
      role == AppRole.veedor;
}

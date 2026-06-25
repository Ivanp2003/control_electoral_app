// appwrite_config.dart
// 
// Responsabilidad Única: Centralizar la configuración de credenciales de Appwrite 
// (obtenidas del entorno con --dart-define) e IDs de colecciones de base de datos.
// Cambios en esta clase ocurren si cambian los identificadores o el esquema en Appwrite.

enum CargoElectoral {
  alcalde,
  prefecto,
}

class AppwriteConfig {
  AppwriteConfig._();

  /// Endpoint de Appwrite cargado desde variables de compilación.
  static const String endpoint = String.fromEnvironment(
    'APPWRITE_ENDPOINT',
    defaultValue: '',
  );

  /// ID del proyecto de Appwrite cargado desde variables de compilación.
  static const String projectId = String.fromEnvironment(
    'APPWRITE_PROJECT_ID',
    defaultValue: '',
  );

  // --- Database Configuration ---
  
  /// ID único de la Base de Datos electoral en Appwrite.
  static const String databaseId = 'control_electoral_db';

  // --- Collection IDs ---
  
  static const String collectionUsuarios = 'usuarios';
  static const String collectionProvincias = 'provincias';
  static const String collectionCantones = 'cantones';
  static const String collectionParroquias = 'parroquias';
  static const String collectionRecintos = 'recintos';
  static const String collectionJrv = 'jrv';
  static const String collectionOrganizacionesPoliticas = 'organizaciones_politicas';
  static const String collectionActas = 'actas';
  static const String collectionActaDetalle = 'acta_detalle';
  static const String collectionEvidenciaFotografica = 'evidencia_fotografica';

  // --- Fase 3: Colecciones de Jerarquía Geográfica y Configuración ---

  /// Colección de configuración del sistema (flags de sistema, idempotencia del seeder, etc.).
  static const String collectionConfigSistema = 'config_sistema';

  /// Clave del documento que registra si el seeder de datos iniciales ya fue ejecutado.
  static const String seederFlagKey = 'seed_ejecutado';

  // --- Fase 4: Asignación Veedor↔JRV ---

  /// Colección que relaciona veedores con las JRV que tienen asignadas.
  static const String collectionVeedorJrv = 'veedor_jrv';
  
  // --- Storage Buckets ---
  
  static const String bucketEvidenciaFotografica = 'evidencia_fotografica_bucket';

  // --- Business / Bootstrap Constants ---

  /// Contraseña inicial asignada por defecto a las nuevas cuentas de usuario.
  static const String passwordInicial = 'Ecuador2026';
}

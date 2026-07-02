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
    defaultValue: 'https://nyc.cloud.appwrite.io/v1',
  );

  /// ID del proyecto de Appwrite cargado desde variables de compilación.
  static const String projectId = String.fromEnvironment(
    'APPWRITE_PROJECT_ID',
    defaultValue: '6a3dd199003669dd17a9',
  );

  // --- Database Configuration ---
  
  /// ID único de la Base de Datos electoral en Appwrite.
  static const String databaseId = String.fromEnvironment(
    'APPWRITE_DATABASE_ID',
    defaultValue: '6a3dd1c60033fb7bdccd',
  );

  // --- Collection IDs ---
  
  static const String collectionUsuarios = 'usuarios';
  static const String collectionProvincias = 'provincias';
  static const String collectionCantones = 'cantones';
  static const String collectionParroquias = 'parroquias';
  static const String collectionRecintos = 'recintos';
  static const String collectionJrv = 'jrvs';
  static const String collectionOrganizacionesPoliticas = 'organizaciones';
  static const String collectionActas = 'actas';
  static const String collectionActaDetalle = 'acta_detalle';


  // --- Fase 3: Colecciones de Jerarquía Geográfica y Configuración ---

  /// Colección de configuración del sistema (flags de sistema, idempotencia del seeder, etc.).
  static const String collectionConfigSistema = 'config_sistema';

  /// Clave del documento que registra si el seeder de datos iniciales ya fue ejecutado.
  static const String seederFlagKey = 'seed_ejecutado';

  // --- Fase 4: Asignación Veedor↔JRV ---

  /// Colección que relaciona veedores con las JRV que tienen asignadas.
  static const String collectionVeedorJrv = 'veedor_jrv';
  
  // --- Storage Buckets ---
  
  static const String bucketEvidenciaFotografica = '6a3deb260033fbc8be94';

  // --- Business / Bootstrap Constants ---

  /// Contraseña inicial asignada por defecto a las nuevas cuentas de usuario.
  static const String passwordInicial = 'Ecuador2026';
}

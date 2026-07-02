import 'package:appwrite/appwrite.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../constants/appwrite_config.dart';

part 'appwrite_client.g.dart';

/// appwrite_client.dart
/// 
/// Responsabilidad Única: Proveer instancias lazy de los servicios de Appwrite 
/// (Client, Account, Databases, Storage) usando inyección de dependencias de Riverpod.
/// Cambios en esta clase ocurren si cambian los servicios expuestos de la API o si se reestructura la inicialización.

/// Clase contenedora para agrupar los servicios de Appwrite de forma inyectable.
class AppwriteServices {
  final Client client;
  final Account account;
  final Databases databases;
  final Storage storage;
  final Functions functions;

  AppwriteServices({
    required this.client,
    required this.account,
    required this.databases,
    required this.storage,
    required this.functions,
  });
}

/// Proveedor del wrapper de servicios de Appwrite.
/// Al usar (keepAlive: true), se comporta como un singleton persistente dentro de la app.
@Riverpod(keepAlive: true)
AppwriteServices appwriteServices(AppwriteServicesRef ref) {
  if (AppwriteConfig.endpoint.isEmpty || AppwriteConfig.projectId.isEmpty) {
    throw StateError(
      'Faltan credenciales de Appwrite. Compile con:\n'
      'flutter run --dart-define=APPWRITE_ENDPOINT=... --dart-define=APPWRITE_PROJECT_ID=...',
    );
  }

  // Inicialización única del cliente.
  final client = Client()
    ..setEndpoint(AppwriteConfig.endpoint)
    ..setProject(AppwriteConfig.projectId);

  return AppwriteServices(
    client: client,
    account: Account(client),
    databases: Databases(client),
    storage: Storage(client),
    functions: Functions(client),
  );
}

/// Proveedor para exponer la instancia del cliente individual.
@Riverpod(keepAlive: true)
Client appwriteClient(AppwriteClientRef ref) {
  return ref.watch(appwriteServicesProvider).client;
}

/// Proveedor para exponer la instancia del servicio de cuentas (Auth).
@Riverpod(keepAlive: true)
Account appwriteAccount(AppwriteAccountRef ref) {
  return ref.watch(appwriteServicesProvider).account;
}

/// Proveedor para exponer la instancia del servicio de base de datos.
@Riverpod(keepAlive: true)
Databases appwriteDatabases(AppwriteDatabasesRef ref) {
  return ref.watch(appwriteServicesProvider).databases;
}

/// Proveedor para exponer la instancia del servicio de almacenamiento de archivos (Storage).
@Riverpod(keepAlive: true)
Storage appwriteStorage(AppwriteStorageRef ref) {
  return ref.watch(appwriteServicesProvider).storage;
}

import 'package:appwrite/appwrite.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/constants/app_roles.dart';
import '../../../../core/constants/appwrite_config.dart';
import '../../../../core/errors/failures.dart';
import '../../../../database/app_database.dart';
import '../../data/seeder_datasource.dart';
import '../seeder_resultado.dart';

/// ejecutar_seeder_usecase.dart
///
/// Responsabilidad Única: Orquestar la ejecución idempotente del Seeder.
///
/// FLUJO:
///   1. Verifica permiso AppPermissions.puedeCrearRecintos.
///   2. Verifica flag de idempotencia en Appwrite (config_sistema).
///   3. Si ya fue ejecutado → Right(SeederResultado.yaEjecutado()).
///   4. Si no → ejecuta SeederDatasource, escucha progreso, marca flag al final.
///   5. Devuelve Right(SeederResultado) con contadores.

class EjecutarSeederUseCase {
  final SeederDatasource _datasource;
  final Databases _databases;
  final AppDatabase _localDb;

  EjecutarSeederUseCase({
    required SeederDatasource datasource,
    required Databases databases,
    required AppDatabase localDb,
  })  : _datasource = datasource,
        _databases = databases,
        _localDb = localDb;

  /// [rolUsuario]: rol del usuario actual (verificado antes de llamar a Appwrite).
  /// [onProgress]: callback que recibe mensajes de progreso granular.
  Future<Either<Failure, SeederResultado>> call({
    required AppRole rolUsuario,
    required void Function(String mensaje) onProgress,
  }) async {
    // Paso 1: Verificación de permiso en el dominio.
    if (!AppPermissions.puedeCrearRecintos(rolUsuario)) {
      return const Left(
        PermissionFailure(
            'Solo el Coordinador Provincial puede ejecutar el seeder de datos iniciales.'),
      );
    }

    // Paso 2: Consultar flag de idempotencia en Appwrite.
    try {
      final doc = await _databases.getDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.collectionConfigSistema,
        documentId: AppwriteConfig.seederFlagKey,
      );
      if (doc.data['valor'] == 'true') {
        return const Right(SeederResultado.yaEjecutado());
      }
    } on AppwriteException catch (e) {
      // 404 = documento no existe aún → primera ejecución, continuar.
      if (e.code != 404) {
        return Left(SeederFailure(
            'Error al verificar el estado del seeder: ${e.message ?? e.toString()}'));
      }
    } catch (e) {
      return Left(SeederFailure('Error inesperado: $e'));
    }

    // Paso 3: Ejecutar inserciones con progreso granular.
    SeederResultado? resultado;
    try {
      await for (final mensaje in _datasource.ejecutar((r) => resultado = r)) {
        onProgress(mensaje);
      }
    } on AppwriteException catch (e) {
      return Left(SeederFailure(
          'Error durante la carga de datos: ${e.message ?? e.toString()}'));
    } catch (e) {
      return Left(SeederFailure('Error inesperado durante el seeder: $e'));
    }

    if (resultado == null) {
      return const Left(SeederFailure('El seeder terminó sin resultado.'));
    }

    // Paso 4: Marcar flag de idempotencia en Appwrite.
    try {
      await _databases.createDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.collectionConfigSistema,
        documentId: AppwriteConfig.seederFlagKey,
        data: {
          'clave': AppwriteConfig.seederFlagKey,
          'valor': 'true',
        },
      );
    } on AppwriteException catch (e) {
      // Si ya existe (409), el flag ya estaba puesto — no es error.
      if (e.code != 409) {
        return Left(SeederFailure(
            'Error al marcar seeder como ejecutado: ${e.message ?? e.toString()}'));
      }
    }

    // Espejo local del flag.
    await _localDb.guardarConfigLocal(ConfigSistemaLocalCompanion.insert(
      clave: AppwriteConfig.seederFlagKey,
      valor: 'true',
    ));

    return Right(resultado!);
  }
}

import 'package:appwrite/appwrite.dart';
import 'package:dartz/dartz.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/appwrite_client.dart';
import '../../../../core/network/connectivity_service.dart';
import '../../../../database/app_database.dart';
import '../../domain/entities/canton.dart';
import '../../domain/entities/jrv.dart';
import '../../domain/entities/parroquia.dart';
import '../../domain/entities/provincia.dart';
import '../../domain/entities/recinto.dart';
import '../../domain/repositories/recintos_repository.dart';
import '../datasources/recintos_local_datasource.dart';
import '../datasources/recintos_remote_datasource.dart';
import '../models/recinto_model.dart';

part 'recintos_repository_impl.g.dart';

/// recintos_repository_impl.dart
///
/// Responsabilidad Única: Implementar la estrategia Remote-First / Local-Fallback
/// para la jerarquía geográfica electoral.
///
/// ESTRATEGIA:
///   1. Con red → Appwrite → guarda en Drift → devuelve al caller.
///   2. Sin red → Drift (última copia cacheada).
///   3. Sin red + caché vacía → Left(NoConnectionFailure).

class RecintosRepositoryImpl implements RecintosRepository {
  final RecintosRemoteDatasource _remote;
  final RecintosLocalDatasource _local;
  final ConnectivityService _connectivity;

  RecintosRepositoryImpl({
    required RecintosRemoteDatasource remote,
    required RecintosLocalDatasource local,
    required ConnectivityService connectivity,
  })  : _remote = remote,
        _local = local,
        _connectivity = connectivity;

  // ---------------------------------------------------------------------------
  // Provincias
  // ---------------------------------------------------------------------------

  @override
  Future<Either<Failure, List<Provincia>>> obtenerProvincias() async {
    final online = await _connectivity.isConnected;
    if (online) {
      try {
        final provincias = await _remote.obtenerProvincias();
        await _local.guardarProvincias(provincias);
        return Right(provincias);
      } catch (e) {
        return _fallbackProvincias();
      }
    }
    return _fallbackProvincias();
  }

  Future<Either<Failure, List<Provincia>>> _fallbackProvincias() async {
    final cached = await _local.obtenerProvincias();
    if (cached.isEmpty) {
      return const Left(NoConnectionFailure(
          'Sin conexión y sin datos locales de provincias.'));
    }
    return Right(cached);
  }

  // ---------------------------------------------------------------------------
  // Cantones
  // ---------------------------------------------------------------------------

  @override
  Future<Either<Failure, List<Canton>>> obtenerCantones(
      String provinciaId) async {
    final online = await _connectivity.isConnected;
    if (online) {
      try {
        final cantones = await _remote.obtenerCantones(provinciaId);
        await _local.guardarCantones(cantones);
        return Right(cantones);
      } catch (e) {
        return _fallbackCantones(provinciaId);
      }
    }
    return _fallbackCantones(provinciaId);
  }

  Future<Either<Failure, List<Canton>>> _fallbackCantones(
      String provinciaId) async {
    final cached = await _local.obtenerCantones(provinciaId);
    if (cached.isEmpty) {
      return const Left(
          NoConnectionFailure('Sin conexión y sin datos locales de cantones.'));
    }
    return Right(cached);
  }

  // ---------------------------------------------------------------------------
  // Parroquias
  // ---------------------------------------------------------------------------

  @override
  Future<Either<Failure, List<Parroquia>>> obtenerParroquias(
      String cantonId) async {
    final online = await _connectivity.isConnected;
    if (online) {
      try {
        final parroquias = await _remote.obtenerParroquias(cantonId);
        await _local.guardarParroquias(parroquias);
        return Right(parroquias);
      } catch (e) {
        return _fallbackParroquias(cantonId);
      }
    }
    return _fallbackParroquias(cantonId);
  }

  Future<Either<Failure, List<Parroquia>>> _fallbackParroquias(
      String cantonId) async {
    final cached = await _local.obtenerParroquias(cantonId);
    if (cached.isEmpty) {
      return const Left(NoConnectionFailure(
          'Sin conexión y sin datos locales de parroquias.'));
    }
    return Right(cached);
  }

  // ---------------------------------------------------------------------------
  // Recintos
  // ---------------------------------------------------------------------------

  @override
  Future<Either<Failure, List<Recinto>>> obtenerRecintos(
      String parroquiaId) async {
    final online = await _connectivity.isConnected;
    if (online) {
      try {
        final recintos = await _remote.obtenerRecintos(parroquiaId);
        await _local.guardarRecintos(recintos);
        return Right(recintos);
      } catch (e) {
        return _fallbackRecintos(parroquiaId);
      }
    }
    return _fallbackRecintos(parroquiaId);
  }

  Future<Either<Failure, List<Recinto>>> _fallbackRecintos(
      String parroquiaId) async {
    final cached = await _local.obtenerRecintos(parroquiaId);
    if (cached.isEmpty) {
      return const Left(
          NoConnectionFailure('Sin conexión y sin datos locales de recintos.'));
    }
    return Right(cached);
  }

  // ---------------------------------------------------------------------------
  // JRV
  // ---------------------------------------------------------------------------

  @override
  Future<Either<Failure, List<Jrv>>> obtenerJrvPorRecinto(
      String recintoId) async {
    final online = await _connectivity.isConnected;
    if (online) {
      try {
        final jrv = await _remote.obtenerJrvPorRecinto(recintoId);
        await _local.guardarJrv(jrv);
        return Right(jrv);
      } catch (e) {
        return _fallbackJrv(recintoId);
      }
    }
    return _fallbackJrv(recintoId);
  }

  Future<Either<Failure, List<Jrv>>> _fallbackJrv(String recintoId) async {
    final cached = await _local.obtenerJrvPorRecinto(recintoId);
    if (cached.isEmpty) {
      return const Left(
          NoConnectionFailure('Sin conexión y sin datos locales de JRV.'));
    }
    return Right(cached);
  }

  // ---------------------------------------------------------------------------
  // Crear Recinto (escritura solo online)
  // ---------------------------------------------------------------------------

  @override
  Future<Either<Failure, Recinto>> crearRecinto({
    required String nombre,
    required String parroquiaId,
    required String direccion,
    double? latRef,
    double? lonRef,
  }) async {
    final online = await _connectivity.isConnected;
    if (!online) {
      return const Left(
          NoConnectionFailure('Se requiere conexión para crear un recinto.'));
    }
    try {
      final id = const Uuid().v4();
      final recinto = await _remote.crearRecinto(
        id: id,
        nombre: nombre,
        parroquiaId: parroquiaId,
        direccion: direccion,
        latRef: latRef,
        lonRef: lonRef,
      );
      // También actualizamos la caché local inmediatamente.
      await _local.guardarRecintos([recinto as RecintoModel]);
      return Right(recinto);
    } on AppwriteException catch (e) {
      return Left(ServerFailure(e.message ?? 'Error al crear el recinto en el servidor.'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

/// Provider Riverpod del repositorio de recintos.
@Riverpod(keepAlive: true)
RecintosRepository recintosRepository(RecintosRepositoryRef ref) {
  final databases = ref.watch(appwriteDatabasesProvider);
  final db = ref.watch(appDatabaseProvider);
  final connectivity = ref.watch(connectivityServiceProvider);

  return RecintosRepositoryImpl(
    remote: RecintosRemoteDatasourceImpl(databases: databases),
    local: RecintosLocalDatasourceImpl(db: db),
    connectivity: connectivity,
  );
}

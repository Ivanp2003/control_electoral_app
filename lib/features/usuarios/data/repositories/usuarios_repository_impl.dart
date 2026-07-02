import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:appwrite/appwrite.dart';
import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/appwrite_client.dart';
import '../../../../core/network/connectivity_service.dart';
import '../../../../core/utils/appwrite_id_helper.dart';
import '../../../../database/app_database.dart';
import '../../../auth/domain/entities/usuario.dart';
import '../../domain/repositories/usuario_repository.dart';
import '../datasources/usuarios_remote_datasource.dart';

part 'usuarios_repository_impl.g.dart';

class UsuariosRepositoryImpl implements UsuarioRepository {
  final UsuariosRemoteDatasource _remote;
  final ConnectivityService _connectivity;
  final AppDatabase _db;

  UsuariosRepositoryImpl({
    required UsuariosRemoteDatasource remote,
    required ConnectivityService connectivity,
    required AppDatabase db,
  })  : _remote = remote,
        _connectivity = connectivity,
        _db = db;

  Future<bool> _checkConnection() => _connectivity.isConnected;

  @override
  Future<Either<Failure, List<Usuario>>> listarUsuarios({String? rol}) async {
    if (!await _checkConnection()) {
      return const Left(NoConnectionFailure());
    }
    try {
      final models = await _remote.listarUsuarios(rol: rol);
      final usuarios = models.map((m) => m.toDomain()).toList();
      return Right(usuarios);
    } on AppwriteException catch (e) {
      return Left(ServerFailure(e.message ?? 'Error al listar usuarios.'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> asignarVeedorAJrv({
    required String veedorId,
    required String jrvId,
    required String recintoId,
  }) async {
    final id = AppwriteIdHelper.veedorJrvId(
      veedorId: veedorId,
      jrvId: jrvId,
    );

    // 1. Intento Remoto si hay red
    if (await _checkConnection()) {
      try {
        await _remote.asignarVeedorAJrv(
          veedorId: veedorId,
          jrvId: jrvId,
          recintoId: recintoId,
        );
        // Si el remoto tuvo éxito, guardamos localmente para caché pero NO encolamos.
        await _db.guardarAsignacionVeedor(VeedorJrvLocalCompanion(
          id: Value(id),
          veedorId: Value(veedorId),
          jrvId: Value(jrvId),
          recintoId: Value(recintoId),
        ));
        return const Right(unit);
      } catch (e) {
        if (e is AppwriteException) {
          debugPrint('AppwriteException en asignarVeedorAJrv: code=${e.code}, type=${e.type}, message=${e.message}');
        } else {
          debugPrint('Error desconocido en asignarVeedorAJrv: $e');
        }
        // Falló remoto, fall back a local + cola
      }
    }

    // 2. Fallback a Local + SyncQueue
    try {
      await _db.guardarAsignacionVeedor(VeedorJrvLocalCompanion(
        id: Value(id),
        veedorId: Value(veedorId),
        jrvId: Value(jrvId),
        recintoId: Value(recintoId),
      ));
      await _db.encolarOperacion(SyncQueueCompanion(
        entityType: const Value('veedor_jrv'),
        operation: const Value('CREATE'),
        payload: Value(jsonEncode({
          'id': id,
          'veedorId': veedorId,
          'jrvId': jrvId,
          'recintoId': recintoId,
        })),
        status: const Value('pending'),
      ));
      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> asignarCoordinadorRecinto({
    required String recintoId,
    required String coordinadorId,
  }) async {
    if (!await _checkConnection()) {
      return const Left(NoConnectionFailure());
    }
    try {
      await _remote.asignarCoordinadorRecinto(
        recintoId: recintoId,
        coordinadorId: coordinadorId,
      );
      return const Right(unit);
    } on AppwriteException catch (e) {
      return Left(ServerFailure(e.message ?? 'Error al asignar coordinador.'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Usuario>> buscarUsuarioPorCedula(String cedula) async {
    if (!await _checkConnection()) {
      return const Left(NoConnectionFailure());
    }
    try {
      final model = await _remote.buscarUsuarioPorCedula(cedula);
      return Right(model.toDomain());
    } on AppwriteException catch (e) {
      return Left(ServerFailure(e.message ?? 'Error al buscar usuario por cédula.'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> desasignarCoordinadorDeCualquierRecinto(String coordinadorId) async {
    if (!await _checkConnection()) {
      return const Left(NoConnectionFailure());
    }
    try {
      await _remote.desasignarCoordinadorDeCualquierRecinto(coordinadorId);
      return const Right(unit);
    } on AppwriteException catch (e) {
      return Left(ServerFailure(e.message ?? 'Error al desasignar coordinadores anteriores.'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> obtenerAsignacionesVeedor(String veedorId) async {
    final online = await _checkConnection();
    if (online) {
      try {
        final list = await _remote.obtenerAsignacionesVeedor(veedorId);
        // Guardar localmente
        await _db.transaction(() async {
          // Limpiar local anterior del veedor
          await (_db.delete(_db.veedorJrvLocal)..where((t) => t.veedorId.equals(veedorId))).go();
          // Insertar los nuevos
          for (final item in list) {
            await _db.guardarAsignacionVeedor(VeedorJrvLocalCompanion(
              id: Value(item['\$id'] as String),
              veedorId: Value(item['veedorId'] as String),
              jrvId: Value(item['jrvId'] as String),
              recintoId: Value(item['recintoId'] as String),
            ));
          }
        });
        return Right(list);
      } catch (e) {
        // Fallback local en caso de error
      }
    }
    
    // Obtener locales
    final rows = await (_db.select(_db.veedorJrvLocal)..where((t) => t.veedorId.equals(veedorId))).get();
    final list = rows.map((r) => {
      '\$id': r.id,
      'veedorId': r.veedorId,
      'jrvId': r.jrvId,
      'recintoId': r.recintoId,
    }).toList();
    return Right(list);
  }
}

@Riverpod(keepAlive: true)
UsuarioRepository usuarioRepository(UsuarioRepositoryRef ref) {
  final db = ref.read(appDatabaseProvider);
  return UsuariosRepositoryImpl(
    remote: UsuariosRemoteDatasource(
      databases: ref.read(appwriteDatabasesProvider),
    ),
    connectivity: ref.read(connectivityServiceProvider),
    db: db,
  );
}

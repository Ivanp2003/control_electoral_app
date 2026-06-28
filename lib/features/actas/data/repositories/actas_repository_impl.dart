import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/connectivity_service.dart';
import '../../../../database/app_database.dart';
import '../domain/entities/acta.dart';
import '../domain/repositories/actas_repository.dart';
import 'datasources/actas_local_datasource.dart';
import 'datasources/actas_remote_datasource.dart';

/// actas_repository_impl.dart
///
/// Responsabilidad Única: Implementar el patrón offline-first para Actas.

class ActasRepositoryImpl implements ActasRepository {
  final ActasLocalDatasource _localDatasource;
  final ActasRemoteDatasource _remoteDatasource;
  final ConnectivityService _connectivity;
  final AppDatabase _db; // Necesario para encolar en SyncQueue

  ActasRepositoryImpl(
    this._localDatasource,
    this._remoteDatasource,
    this._connectivity,
    this._db,
  );

  @override
  Future<Either<Failure, List<Acta>>> obtenerActasPorJrv(String jrvId) async {
    try {
      final actas = await _localDatasource.obtenerActasPorJrv(jrvId);
      return Right(actas);
    } catch (e) {
      return Left(CacheFailure('Error al leer actas locales: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> registrarActa(Acta acta) async {
    try {
      final isOnline = await _connectivity.isConnected;

      if (isOnline) {
        try {
          await _remoteDatasource.registrarActa(acta);
          // Si tiene éxito en remoto, guardar localmente como sincronizado
          final syncedActa = _marcarComoSynced(acta, true);
          await _localDatasource.guardarActaLocal(syncedActa);
          return const Right(null);
        } catch (e) {
          // Si falla remoto (ej. error 500 temporal), caer al fallback offline
          return await _guardarOfflineEnCola(acta, 'CREATE');
        }
      } else {
        return await _guardarOfflineEnCola(acta, 'CREATE');
      }
    } catch (e) {
      return Left(CacheFailure('Error al registrar el acta: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> corregirActa(Acta acta) async {
    try {
      final isOnline = await _connectivity.isConnected;

      if (isOnline) {
        try {
          await _remoteDatasource.corregirActa(acta);
          final syncedActa = _marcarComoSynced(acta, true);
          await _localDatasource.guardarActaLocal(syncedActa);
          return const Right(null);
        } catch (e) {
          return await _guardarOfflineEnCola(acta, 'UPDATE');
        }
      } else {
        return await _guardarOfflineEnCola(acta, 'UPDATE');
      }
    } catch (e) {
      return Left(CacheFailure('Error al corregir el acta: $e'));
    }
  }

  // --- Helper Methods ---

  Future<Either<Failure, void>> _guardarOfflineEnCola(Acta acta, String operation) async {
    try {
      // 1. Guardar localmente como NO sincronizado
      final unsyncedActa = _marcarComoSynced(acta, false);
      await _localDatasource.guardarActaLocal(unsyncedActa);

      // 2. Encolar en SyncQueue
      final payload = _serializeActaToJson(unsyncedActa);
      await _db.encolarOperacion(
        SyncQueueCompanion.insert(
          entityType: 'actas',
          operation: operation,
          payload: payload,
          status: const Value('pending'),
        ),
      );

      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Error al guardar acta offline: $e'));
    }
  }

  Acta _marcarComoSynced(Acta acta, bool synced) {
    return Acta(
      id: acta.id,
      jrvId: acta.jrvId,
      cargoElectoral: acta.cargoElectoral,
      totalSufragantes: acta.totalSufragantes,
      votosBlancos: acta.votosBlancos,
      votosNulos: acta.votosNulos,
      organizaciones: acta.organizaciones,
      evidenciaFoto: acta.evidenciaFoto,
      latitud: acta.latitud,
      longitud: acta.longitud,
      creadoPor: acta.creadoPor,
      editadoPor: acta.editadoPor,
      fechaEdicion: acta.fechaEdicion,
      synced: synced,
    );
  }

  String _serializeActaToJson(Acta acta) {
    // Genera un payload serializado para SyncQueue
    return jsonEncode({
      'id': acta.id,
      'jrvId': acta.jrvId,
      'cargoElectoral': acta.cargoElectoral,
      'totalSufragantes': acta.totalSufragantes,
      'votosBlancos': acta.votosBlancos,
      'votosNulos': acta.votosNulos,
      'organizaciones': acta.organizaciones.map((o) => {
        'organizacionId': o.organizacionId,
        'nombre': o.nombre,
        'votos': o.votos,
      }).toList(),
      'evidenciaFoto': acta.evidenciaFoto,
      'latitud': acta.latitud,
      'longitud': acta.longitud,
      'creadoPor': acta.creadoPor,
      'editadoPor': acta.editadoPor,
      'fechaEdicion': acta.fechaEdicion?.toIso8601String(),
    });
  }

  @override
  Future<bool> verificarAsignacionVeedor(String veedorId, String jrvId) async {
    return await _localDatasource.verificarAsignacionVeedor(veedorId, jrvId);
  }
}

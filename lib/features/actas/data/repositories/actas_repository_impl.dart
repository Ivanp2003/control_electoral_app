import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/connectivity_service.dart';
import '../../../../core/utils/appwrite_id_helper.dart';
import '../../../../database/app_database.dart';
import '../../domain/entities/acta.dart';
import '../../domain/entities/organizacion_con_votos.dart';
import '../../domain/repositories/actas_repository.dart';
import '../datasources/actas_local_datasource.dart';
import '../datasources/actas_remote_datasource.dart';

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
      final isOnline = await _connectivity.isConnected;
      if (isOnline) {
        try {
          final remoteActasMaps = await _remoteDatasource.obtenerActasPorJrv(jrvId);
          for (final map in remoteActasMaps) {
            final List<OrganizacionConVotos> listOrgs = (map['organizaciones'] as List? ?? []).map((o) {
              return OrganizacionConVotos(
                organizacionId: o['organizacionId'] as String? ?? '',
                nombreOrganizacion: o['nombreOrganizacion'] as String? ?? '', // Opcional si no viene, pero lo completamos
                votos: o['votos'] as int? ?? 0,
              );
            }).toList().cast<OrganizacionConVotos>();

            final acta = Acta(
              id: map['\$id'] as String,
              jrvId: map['jrvId'] as String,
              recintoId: map['recintoId'] as String?,
              cargoElectoral: map['cargoElectoral'] as String,
              totalSufragantes: map['totalSufragantes'] as int? ?? 0,
              votosBlancos: map['votosBlancos'] as int? ?? 0,
              votosNulos: map['votosNulos'] as int? ?? 0,
              organizaciones: listOrgs,
              evidenciaFoto: map['fotoUrl'] as String?,
              latitud: (map['latitud'] as num?)?.toDouble() ?? 0.0,
              longitud: (map['longitud'] as num?)?.toDouble() ?? 0.0,
              creadoPor: map['veedorId'] as String? ?? '',
              editadoPor: map['editadoPor'] as String?,
              fechaEdicion: map['fechaEdicion'] != null ? DateTime.tryParse(map['fechaEdicion'] as String) : null,
              synced: true,
            );
            await _localDatasource.guardarActaLocal(acta);
          }
        } catch (_) {
          // Ignorar fallas remotas al refrescar y usar fallback local
        }
      }
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
      
      // ID determinístico y seguro: siempre ≤36 chars, solo alfanumérico+_
      final String actaId = AppwriteIdHelper.actaId(
        jrvId: acta.jrvId,
        cargoElectoral: acta.cargoElectoral,
      );
      final actaToSave = _marcarComoSynced(acta, false).copyWith(id: actaId);

      if (isOnline) {
        try {
          // Obtener recintoId de la JRV
          final jrv = await _db.obtenerJrvLocalPorId(acta.jrvId);
          String recintoId = jrv?.recintoId ?? '';
          if (recintoId.isEmpty) {
            final asignaciones = await (_db.select(_db.veedorJrvLocal)
                  ..where((t) => t.jrvId.equals(acta.jrvId))
                  ..limit(1))
                .get();
            if (asignaciones.isNotEmpty) {
              recintoId = asignaciones.first.recintoId;
            }
          }

          await _remoteDatasource.registrarActa(actaToSave, recintoId);
          // Si tiene éxito en remoto, guardar localmente como sincronizado
          final syncedActa = _marcarComoSynced(actaToSave, true);
          await _localDatasource.guardarActaLocal(syncedActa);
          return const Right(null);
        } catch (e) {
          // Si falla remoto (ej. error 500 temporal), caer al fallback offline
          return await _guardarOfflineEnCola(actaToSave, 'CREATE');
        }
      } else {
        return await _guardarOfflineEnCola(actaToSave, 'CREATE');
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
          // Obtener recintoId de la JRV
          final jrv = await _db.obtenerJrvLocalPorId(acta.jrvId);
          String recintoId = jrv?.recintoId ?? '';
          if (recintoId.isEmpty) {
            final asignaciones = await (_db.select(_db.veedorJrvLocal)
                  ..where((t) => t.jrvId.equals(acta.jrvId))
                  ..limit(1))
                .get();
            if (asignaciones.isNotEmpty) {
              recintoId = asignaciones.first.recintoId;
            }
          }

          await _remoteDatasource.corregirActa(acta, recintoId);
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
        'nombreOrganizacion': o.nombreOrganizacion,
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

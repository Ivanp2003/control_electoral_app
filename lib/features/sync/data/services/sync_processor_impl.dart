import 'dart:convert';
import '../../../../database/app_database.dart';
import '../../../actas/data/datasources/actas_local_datasource.dart';
import '../../../actas/data/datasources/actas_remote_datasource.dart';
import '../../../actas/data/models/acta_model.dart';
import '../../domain/services/sync_processor.dart';

class SyncProcessorImpl implements SyncProcessor {
  final AppDatabase _db;
  final ActasRemoteDatasource _remote;
  final ActasLocalDatasource _local;
  static const int maxAttempts = 3;

  SyncProcessorImpl({
    required AppDatabase db,
    required ActasRemoteDatasource remote,
    required ActasLocalDatasource local,
  })  : _db = db,
        _remote = remote,
        _local = local;

  @override
  Future<SyncResult> procesarCola() async {
    int procesados = 0;
    int fallidos = 0;

    try {
      final pendientes = await _db.obtenerColaPendiente();

      for (final item in pendientes) {
        if (item.attempts >= maxAttempts) {
          final actualizado = item.copyWith(
            status: 'failed',
          );
          await _db.actualizarEstadoCola(actualizado);
          fallidos++;
          continue;
        }

        try {
          await _procesarItem(item);
          await _db.eliminarDeLaCola(item);
          procesados++;
        } catch (e) {
          final actualizado = item.copyWith(
            attempts: item.attempts + 1,
          );
          if (actualizado.attempts >= maxAttempts) {
            await _db.actualizarEstadoCola(
              actualizado.copyWith(status: 'failed'),
            );
          } else {
            await _db.actualizarEstadoCola(actualizado);
          }
          fallidos++;
        }
      }

      return SyncResult(procesados: procesados, fallidos: fallidos);
    } catch (e) {
      return SyncResult(
        procesados: procesados,
        fallidos: fallidos,
        error: 'Error al procesar cola: $e',
      );
    }
  }

  Future<void> _procesarItem(SyncQueueData item) async {
    switch (item.entityType) {
      case 'acta':
        await _procesarActa(item);
        break;
      case 'veedor_jrv':
        await _procesarVeedorJrv(item);
        break;
      default:
        throw Exception('Tipo de entidad desconocido: ${item.entityType}');
    }
  }

  Future<void> _procesarVeedorJrv(SyncQueueData item) async {
    final payload = jsonDecode(item.payload) as Map<String, dynamic>;
    await _remote.asignarVeedorAJrv(
      veedorId: payload['veedorId'] as String,
      jrvId: payload['jrvId'] as String,
      recintoId: payload['recintoId'] as String,
    );
  }

  Future<void> _procesarActa(SyncQueueData item) async {
    final payload = jsonDecode(item.payload) as Map<String, dynamic>;
    final acta = ActaModel.fromJson(payload);

    switch (item.operation) {
      case 'create':
        final respuesta = await _remote.create(acta.jrvId, acta);
        if (acta.fotoUrl != null && acta.fotoUrl!.isNotEmpty) {
          try {
            await _remote.uploadFoto(respuesta.id, acta.fotoUrl!);
          } catch (_) {}
        }
        await _local.marcarSynced(acta.id);
        break;

      case 'update':
        final respuesta = await _remote.update(acta.id, acta);
        if (acta.fotoUrl != null && acta.fotoUrl!.isNotEmpty) {
          try {
            await _remote.uploadFoto(respuesta.id, acta.fotoUrl!);
          } catch (_) {}
        }
        await _local.marcarSynced(acta.id);
        break;

      default:
        throw Exception('Operación desconocida: ${item.operation}');
    }
  }
}

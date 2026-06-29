import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../database/app_database.dart';
import '../entities/sync_task.dart';
import '../../data/datasources/sync_remote_executor.dart';

class ProcesarColaSyncUseCase {
  final AppDatabase _db;
  final SyncRemoteExecutor _executor;

  ProcesarColaSyncUseCase({
    required AppDatabase db,
    required SyncRemoteExecutor executor,
  })  : _db = db,
        _executor = executor;

  Future<Either<Failure, Unit>> call() async {
    try {
      final pendingTasks = await _db.obtenerOperacionesPendientes();

      for (final driftTask in pendingTasks) {
        final task = SyncTask(
          id: driftTask.id,
          entityType: driftTask.entityType,
          operation: driftTask.operation,
          payload: driftTask.payload,
          timestamp: driftTask.timestamp,
          attempts: driftTask.attempts,
          status: driftTask.status,
        );

        try {
          // Intentar ejecutar la tarea
          await _executor.execute(task);
          
          // Si tiene éxito, marcar como completada
          await _db.actualizarEstadoSync(task.id, 'completed');
        } on PermanentSyncFailureException {
          // Error del cliente (4xx) - no reintentable
          await _db.actualizarEstadoSync(task.id, 'failed');
        } catch (e) {
          // Si falla (error de red o server 5xx), incrementar intentos
          final newAttempts = task.attempts + 1;
          final newStatus = newAttempts >= 5 ? 'failed' : 'pending';
          
          await _db.incrementarIntentoSync(task.id, newAttempts, newStatus);
        }
      }

      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure('Error al procesar la cola de sincronización: $e'));
    }
  }
}

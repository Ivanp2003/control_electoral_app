import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/appwrite_client.dart';
import '../../../../core/network/connectivity_service.dart';
import '../../../../database/app_database.dart';
import '../../data/datasources/sync_remote_executor.dart';
import '../../domain/usecases/procesar_cola_sync_usecase.dart';
import '../../domain/usecases/reintentar_tarea_fallida_usecase.dart';

part 'sync_providers.g.dart';

@Riverpod(keepAlive: true)
SyncRemoteExecutor syncRemoteExecutor(SyncRemoteExecutorRef ref) {
  final databases = ref.watch(appwriteDatabasesProvider);
  final storage = ref.watch(appwriteStorageProvider);
  return SyncRemoteExecutorImpl(databases: databases, storage: storage);
}

@Riverpod(keepAlive: true)
ProcesarColaSyncUseCase procesarColaSyncUseCase(ProcesarColaSyncUseCaseRef ref) {
  final db = ref.watch(appDatabaseProvider);
  final executor = ref.watch(syncRemoteExecutorProvider);
  return ProcesarColaSyncUseCase(db: db, executor: executor);
}

@Riverpod(keepAlive: true)
ReintentarTareaFallidaUseCase reintentarTareaFallidaUseCase(ReintentarTareaFallidaUseCaseRef ref) {
  final db = ref.watch(appDatabaseProvider);
  return ReintentarTareaFallidaUseCase(db);
}

/// Escucha los cambios en SyncQueue para contar tareas pendientes/fallidas.
@riverpod
Stream<int> pendingSyncTasksCount(PendingSyncTasksCountRef ref) {
  final db = ref.watch(appDatabaseProvider);
  // Escuchamos la tabla SyncQueue
  return db.select(db.syncQueue)
    .watch()
    .map((tasks) => tasks.where((t) => t.status == 'pending' || t.status == 'failed').length);
}

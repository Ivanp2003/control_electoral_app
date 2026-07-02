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
  final db = ref.watch(appDatabaseProvider);
  return SyncRemoteExecutorImpl(databases: databases, storage: storage, db: db);
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

/// Escucha los cambios en SyncQueue para contar tareas pendientes.
@riverpod
Stream<int> pendingSyncTasksCount(PendingSyncTasksCountRef ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.select(db.syncQueue)
    .watch()
    .map((tasks) => tasks.where((t) => t.status == 'pending').length);
}

/// Escucha los cambios en SyncQueue para contar tareas fallidas.
@riverpod
Stream<int> failedSyncTasksCount(FailedSyncTasksCountRef ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.select(db.syncQueue)
    .watch()
    .map((tasks) => tasks.where((t) => t.status == 'failed').length);
}

/// Expone la lista de tareas fallidas para debugging y reintentos.
@riverpod
Stream<List<SyncQueueData>> failedSyncTasksList(FailedSyncTasksListRef ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.select(db.syncQueue)
    .watch()
    .map((tasks) => tasks.where((t) => t.status == 'failed').toList());
}

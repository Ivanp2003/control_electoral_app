import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/appwrite_client.dart';
import '../../../../core/network/connectivity_service.dart';
import '../../../../database/app_database.dart';
import '../../../actas/data/datasources/actas_local_datasource.dart';
import '../../../actas/data/datasources/actas_remote_datasource.dart';
import '../../data/services/sync_processor_impl.dart';
import '../../domain/entities/sync_state.dart';
import '../../domain/services/sync_processor.dart';

part 'sync_orchestrator.g.dart';

@Riverpod(keepAlive: true)
ActasRemoteDatasource syncRemoteDatasource(SyncRemoteDatasourceRef ref) {
  return ActasRemoteDatasource(
    databases: ref.read(appwriteDatabasesProvider),
    storage: ref.read(appwriteStorageProvider),
  );
}

@Riverpod(keepAlive: true)
ActasLocalDatasource syncLocalDatasource(SyncLocalDatasourceRef ref) {
  return ActasLocalDatasource(db: ref.read(appDatabaseProvider));
}

@Riverpod(keepAlive: true)
SyncProcessor syncProcessor(SyncProcessorRef ref) {
  return SyncProcessorImpl(
    db: ref.read(appDatabaseProvider),
    remote: ref.read(syncRemoteDatasourceProvider),
    local: ref.read(syncLocalDatasourceProvider),
  );
}

@Riverpod(keepAlive: true)
class SyncOrchestrator extends _$SyncOrchestrator {
  StreamSubscription<bool>? _subscription;
  Timer? _timer;

  @override
  SyncState build() {
    _escucharConectividad();
    ref.onDispose(() {
      _subscription?.cancel();
      _timer?.cancel();
    });
    return const SyncState();
  }

  void _escucharConectividad() {
    final service = ref.read(connectivityServiceProvider);
    _subscription = service.onConnectivityChanged.listen((online) {
      if (online) {
        _timer ??= Timer.periodic(const Duration(seconds: 10), (_) {
          _ejecutarSync();
        });
        _ejecutarSync();
      } else {
        _timer?.cancel();
        _timer = null;
      }
    });
  }

  Future<void> _ejecutarSync() async {
    state = state.copyWith(status: SyncStatus.syncing);

    final processor = ref.read(syncProcessorProvider);
    final result = await processor.procesarCola();

    final pendientes = await ref.read(appDatabaseProvider).obtenerColaPendiente();

    if (result.error != null) {
      state = state.copyWith(
        status: SyncStatus.error,
        itemsPendientes: pendientes.length,
        mensajeError: result.error,
      );
    } else {
      state = state.copyWith(
        status: pendientes.isEmpty ? SyncStatus.idle : SyncStatus.syncing,
        itemsPendientes: pendientes.length,
        mensajeError: null,
      );
    }
  }

  Future<void> sincronizarAhora() async {
    await _ejecutarSync();
  }
}

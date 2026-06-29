import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/connectivity_service.dart';
import 'sync_providers.dart';

part 'sync_orchestrator_provider.g.dart';

/// Un provider que orquesta la sincronización escuchando los cambios de conexión.
@Riverpod(keepAlive: true)
class SyncOrchestrator extends _$SyncOrchestrator {
  @override
  void build() {
    // 1. Verificación inicial al arrancar
    _verificacionInicial();

  // 2. Escuchar transiciones en background
    final connectivityService = ref.watch(connectivityServiceProvider);
    connectivityService.onConnectivityChanged.listen((isConnected) {
      if (isConnected) {
        _dispararSync();
      }
    });
  }

  Future<void> _verificacionInicial() async {
    final connectivityService = ref.read(connectivityServiceProvider);
    final isConnected = await connectivityService.isConnected;
    if (isConnected) {
      _dispararSync();
    }
  }

  Future<void> _dispararSync() async {
    final procesarColaUseCase = ref.read(procesarColaSyncUseCaseProvider);
    await procesarColaUseCase.call();
  }
}

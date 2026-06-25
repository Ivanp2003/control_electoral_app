import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connectivity_service.g.dart';

/// connectivity_service.dart
/// 
/// Responsabilidad Única: Definir el contrato e implementar el monitoreo del estado de
/// conexión a Internet (online/offline) de la aplicación usando connectivity_plus.
/// Cambios en esta clase ocurren si se cambia el paquete de red o se requiere lógica distinta para definir la conectividad.

/// Contrato para el servicio de conectividad a red.
abstract class ConnectivityService {
  /// Stream que emite true cuando está en línea (Wi-Fi, móvil, etc.) y false cuando está desconectado.
  Stream<bool> get onConnectivityChanged;

  /// Retorna si el dispositivo está en línea actualmente.
  Future<bool> get isConnected;
}

/// Implementación concreta del servicio de conectividad usando `connectivity_plus`.
class ConnectivityServiceImpl implements ConnectivityService {
  final Connectivity _connectivity;

  ConnectivityServiceImpl({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  @override
  Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map((results) {
      // En la versión 6.x de connectivity_plus, se retorna un List<ConnectivityResult>.
      // El dispositivo está en línea si alguna de las interfaces de red está activa.
      if (results.isEmpty) return false;
      return results.any((result) => result != ConnectivityResult.none);
    });
  }

  @override
  Future<bool> get isConnected async {
    final results = await _connectivity.checkConnectivity();
    if (results.isEmpty) return false;
    return results.any((result) => result != ConnectivityResult.none);
  }
}

/// Proveedor del servicio de conectividad (singleton de Riverpod).
@Riverpod(keepAlive: true)
ConnectivityService connectivityService(ConnectivityServiceRef ref) {
  return ConnectivityServiceImpl();
}

/// Proveedor del Stream de conectividad (online: true / offline: false).
@Riverpod(keepAlive: true)
Stream<bool> connectivityStream(ConnectivityStreamRef ref) {
  final service = ref.watch(connectivityServiceProvider);
  return service.onConnectivityChanged;
}

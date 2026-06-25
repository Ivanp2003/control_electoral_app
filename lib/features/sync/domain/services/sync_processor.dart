abstract class SyncProcessor {
  Future<SyncResult> procesarCola();
}

class SyncResult {
  final int procesados;
  final int fallidos;
  final String? error;

  const SyncResult({
    this.procesados = 0,
    this.fallidos = 0,
    this.error,
  });
}

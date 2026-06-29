import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../presentation/providers/evidencia_providers.dart';
import '../../presentation/providers/evidencia_flow_notifier.dart';

class CapturaEvidenciaScreen extends ConsumerWidget {
  const CapturaEvidenciaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final estado = ref.watch(evidenciaFlowNotifierProvider);
    final notifier = ref.read(evidenciaFlowNotifierProvider.notifier);
    final usuario = ref.watch(currentUserProvider)!;

    // Ejecuta la transición automática a la cámara si los permisos están
    if (estado.step == EvidenciaStep.permisoCamara) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifier.inicializarCamara();
      });
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0A1628),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F2442),
        title: const Text('Evidencia Fotográfica',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _buildBody(context, estado, notifier, usuario),
    );
  }

  Widget _buildBody(BuildContext context, EvidenciaFlowState estado, EvidenciaFlowNotifier notifier, dynamic usuario) {
    switch (estado.step) {
      case EvidenciaStep.permisoGps:
      case EvidenciaStep.capturaGps:
        return _GpsGate(
          estado: estado, 
          onCapturar: () {
            if (usuario != null) {
              notifier.capturarGps(usuario);
            }
          },
        );

      case EvidenciaStep.permisoCamara:
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Color(0xFF4A90D9)),
              SizedBox(height: 16),
              Text('Inicializando cámara...', style: TextStyle(color: Colors.white70)),
            ],
          ),
        );

      case EvidenciaStep.capturaFoto:
        final controller = notifier.cameraController;
        if (controller == null) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF4A90D9)));
        }
        return _CameraPreview(
          controller: controller,
          estado: estado,
          onCapture: () {
            if (usuario != null) {
              notifier.tomarFotoYAnalizar(usuario);
            }
          },
        );

      case EvidenciaStep.analisisNitidez:
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Color(0xFF4A90D9)),
              SizedBox(height: 16),
              Text('Analizando nitidez...',
                  style: TextStyle(color: Colors.white70)),
            ],
          ),
        );

      case EvidenciaStep.completado:
        return _EvidenciaCompletada(
          evidencia: estado.evidencia!,
          onContinuar: () => Navigator.pop(context, estado.evidencia),
        );

      case EvidenciaStep.rechazado:
        return _ErrorReintentar(
          error: estado.error ?? 'Error desconocido',
          onReintentar: () {
            notifier.reiniciarFlujo();
          },
        );
    }
  }
}

// ── GPS Gate ──────────────────────────────────────────────────────────

class _GpsGate extends StatelessWidget {
  final EvidenciaFlowState estado;
  final VoidCallback onCapturar;

  const _GpsGate({required this.estado, required this.onCapturar});

  @override
  Widget build(BuildContext context) {
    final isLoading = estado.step == EvidenciaStep.capturaGps;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.gps_fixed, size: 64, color: Color(0xFF4A90D9)),
            const SizedBox(height: 24),
            const Text(
              'Ubicación GPS',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              estado.error ?? 'Es obligatorio adjuntar tu ubicación GPS al acta para validar la legitimidad del registro.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: estado.error != null ? Colors.redAccent : Colors.white54,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A90D9),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                icon: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.my_location),
                label: Text(isLoading ? 'Capturando...' : 'Obtener Ubicación',
                    style: const TextStyle(fontSize: 16)),
                onPressed: isLoading ? null : onCapturar,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Camera Preview ────────────────────────────────────────────────────

class _CameraPreview extends StatelessWidget {
  final CameraController controller;
  final EvidenciaFlowState estado;
  final VoidCallback onCapture;
  
  const _CameraPreview({
    required this.controller,
    required this.estado,
    required this.onCapture,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox.expand(child: CameraPreview(controller)),
        if (estado.error != null)
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.redAccent.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(estado.error!,
                  style: const TextStyle(color: Colors.white)),
            ),
          ),
        Positioned(
          bottom: 48,
          left: 0,
          right: 0,
          child: Center(
            child: SizedBox(
              width: 72,
              height: 72,
              child: FloatingActionButton(
                backgroundColor: Colors.white,
                onPressed: onCapture,
                shape: const CircleBorder(),
                child: const Icon(Icons.camera_alt, size: 32, color: Colors.black87),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Completa ──────────────────────────────────────────────────────────

class _EvidenciaCompletada extends StatelessWidget {
  final dynamic evidencia;
  final VoidCallback onContinuar;
  const _EvidenciaCompletada({
    required this.evidencia,
    required this.onContinuar,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_outline,
                size: 72, color: Colors.greenAccent),
            const SizedBox(height: 24),
            const Text('Evidencia Capturada',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text('La fotografía es nítida y el GPS fue registrado.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white54)),
            const SizedBox(height: 8),
            Text(
              'Lat: ${evidencia.latitud.toStringAsFixed(6)}, '
              'Lng: ${evidencia.longitud.toStringAsFixed(6)}',
              style: const TextStyle(color: Colors.white38, fontSize: 13),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent.shade700,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: onContinuar,
                child: const Text('Continuar con el Acta',
                    style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Error / Reintentar ────────────────────────────────────────────────

class _ErrorReintentar extends StatelessWidget {
  final String error;
  final VoidCallback onReintentar;
  const _ErrorReintentar({
    required this.error,
    required this.onReintentar,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.redAccent),
            const SizedBox(height: 24),
            Text(error,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.redAccent, fontSize: 16)),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A90D9),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar desde el inicio',
                    style: TextStyle(fontSize: 16)),
                onPressed: onReintentar,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

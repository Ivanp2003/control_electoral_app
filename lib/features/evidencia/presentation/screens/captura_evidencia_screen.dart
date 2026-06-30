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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Ejecuta la transición automática a la cámara si los permisos están
    if (estado.step == EvidenciaStep.permisoCamara) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifier.inicializarCamara();
      });
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Evidencia Fotográfica',
            style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: Icon(Icons.close, color: colorScheme.onSurface),
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
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 16),
              Text('Inicializando cámara...', style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7))),
            ],
          ),
        );

      case EvidenciaStep.capturaFoto:
        final controller = notifier.cameraController;
        if (controller == null) {
          return Center(child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary));
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
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 16),
              Text('Analizando nitidez...',
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7))),
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
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.gps_fixed, size: 64, color: colorScheme.primary),
            const SizedBox(height: 24),
            Text(
              'Ubicación GPS',
              style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              estado.error ?? 'Es obligatorio adjuntar tu ubicación GPS al acta para validar la legitimidad del registro.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: estado.error != null ? colorScheme.error : colorScheme.onSurface.withOpacity(0.54),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                icon: isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: colorScheme.onPrimary,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.my_location),
                label: Text(isLoading ? 'Capturando...' : 'Obtener Ubicación',
                    style: TextStyle(fontSize: 16, color: colorScheme.onPrimary)),
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
    final colorScheme = Theme.of(context).colorScheme;

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
                color: colorScheme.error.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(estado.error!,
                  style: TextStyle(color: colorScheme.onError)),
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
                backgroundColor: colorScheme.onSurface,
                onPressed: onCapture,
                shape: const CircleBorder(),
                child: Icon(Icons.camera_alt, size: 32, color: colorScheme.surface),
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
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_outline,
                size: 72, color: Colors.greenAccent),
            const SizedBox(height: 24),
            Text('Evidencia Capturada',
                style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 22,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text('La fotografía es nítida y el GPS fue registrado.',
                textAlign: TextAlign.center,
                style: TextStyle(color: colorScheme.onSurface.withOpacity(0.54))),
            const SizedBox(height: 8),
            Text(
              'Lat: ${evidencia.latitud.toStringAsFixed(6)}, '
              'Lng: ${evidencia.longitud.toStringAsFixed(6)}',
              style: TextStyle(color: colorScheme.onSurface.withOpacity(0.38), fontSize: 13),
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
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: colorScheme.error),
            const SizedBox(height: 24),
            Text(error,
                textAlign: TextAlign.center,
                style: TextStyle(color: colorScheme.error, fontSize: 16)),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.refresh),
                label: Text('Reintentar desde el inicio',
                    style: TextStyle(fontSize: 16, color: colorScheme.onPrimary)),
                onPressed: onReintentar,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

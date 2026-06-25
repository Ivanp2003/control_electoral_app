import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../presentation/providers/evidencia_providers.dart';
import '../../presentation/providers/evidencia_flow_notifier.dart';

class CapturaEvidenciaScreen extends ConsumerStatefulWidget {
  const CapturaEvidenciaScreen({super.key});

  @override
  ConsumerState<CapturaEvidenciaScreen> createState() =>
      _CapturaEvidenciaScreenState();
}

class _CapturaEvidenciaScreenState
    extends ConsumerState<CapturaEvidenciaScreen> {
  CameraController? _cameraController;
  bool _cameraInicializada = false;

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        ref.read(evidenciaFlowNotifierProvider.notifier).cancelar();
        return;
      }
      final controller =
          CameraController(cameras.first, ResolutionPreset.high);
      await controller.initialize();
      if (!mounted) return;
      setState(() {
        _cameraController = controller;
        _cameraInicializada = true;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al iniciar cámara: $e')),
        );
        ref.read(evidenciaFlowNotifierProvider.notifier).cancelar();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final estado = ref.watch(evidenciaFlowNotifierProvider);

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
      body: _buildBody(estado),
    );
  }

  Widget _buildBody(EvidenciaFlowState estado) {
    if (estado.cargando) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Color(0xFF4A90D9)),
            SizedBox(height: 16),
            Text('Procesando...',
                style: TextStyle(color: Colors.white70)),
          ],
        ),
      );
    }

    switch (estado.step) {
      case EvidenciaStep.gpsPermission:
      case EvidenciaStep.capturaGps:
        return _GpsGate(estado: estado);

      case EvidenciaStep.cameraPermission:
      case EvidenciaStep.capturaFoto:
        if (!_cameraInicializada) {
          _initCamera();
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF4A90D9)),
          );
        }
        return _CameraPreview(
          controller: _cameraController!,
          estado: estado,
          onCapture: _capturarFoto,
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
            ref.read(evidenciaFlowNotifierProvider.notifier).reintentar();
          },
        );
    }
  }

  Future<void> _capturarFoto() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }
    try {
      final xFile = await _cameraController!.takePicture();
      if (!mounted) return;
      ref.read(evidenciaFlowNotifierProvider.notifier).fotoCapturada(xFile.path);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al capturar foto: $e')),
        );
      }
    }
  }
}

// ── GPS Gate ──────────────────────────────────────────────────────────

class _GpsGate extends ConsumerWidget {
  final EvidenciaFlowState estado;
  const _GpsGate({required this.estado});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.gps_fixed, size: 64, color: Color(0xFF4A90D9)),
            const SizedBox(height: 24),
            const Text(
              'Captura de Ubicación GPS',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              estado.error ?? 'Es necesario obtener tu ubicación para adjuntarla al acta.',
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
                icon: const Icon(Icons.my_location),
                label: const Text('Obtener Ubicación',
                    style: TextStyle(fontSize: 16)),
                onPressed: () {
                  ref
                      .read(evidenciaFlowNotifierProvider.notifier)
                      .verificarGps();
                },
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
        CameraPreview(controller),
        if (estado.error != null)
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.85),
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
                label: const Text('Reintentar',
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

import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../geolocalizacion/domain/entities/gps_data.dart';
import '../../../geolocalizacion/domain/services/gps_service.dart';
import '../../domain/services/sharpness_analyzer.dart';
import '../../domain/entities/evidencia_data.dart';

enum EvidenciaStep {
  gpsPermission,
  capturaGps,
  cameraPermission,
  capturaFoto,
  analisisNitidez,
  completado,
  rechazado,
}

class EvidenciaFlowState {
  final EvidenciaStep step;
  final GpsData? gps;
  final String? fotoPath;
  final EvidenciaData? evidencia;
  final String? error;
  final bool cargando;

  const EvidenciaFlowState({
    this.step = EvidenciaStep.gpsPermission,
    this.gps,
    this.fotoPath,
    this.evidencia,
    this.error,
    this.cargando = false,
  });

  EvidenciaFlowState copyWith({
    EvidenciaStep? step,
    GpsData? gps,
    String? fotoPath,
    EvidenciaData? evidencia,
    String? error,
    bool? cargando,
  }) {
    return EvidenciaFlowState(
      step: step ?? this.step,
      gps: gps ?? this.gps,
      fotoPath: fotoPath ?? this.fotoPath,
      evidencia: evidencia ?? this.evidencia,
      error: error,
      cargando: cargando ?? this.cargando,
    );
  }
}

class EvidenciaFlowNotifier extends StateNotifier<EvidenciaFlowState> {
  final GpsService _gpsService;
  final SharpnessAnalyzer _sharpnessAnalyzer;

  EvidenciaFlowNotifier({
    required GpsService gpsService,
    required SharpnessAnalyzer sharpnessAnalyzer,
  })  : _gpsService = gpsService,
        _sharpnessAnalyzer = sharpnessAnalyzer,
        super(const EvidenciaFlowState());

  Future<void> verificarGps() async {
    state = state.copyWith(cargando: true, error: null);
    final result = await _gpsService.verificarYCapatutar();

    result.fold(
      (failure) {
        state = state.copyWith(
          step: EvidenciaStep.rechazado,
          error: failure.message,
          cargando: false,
        );
      },
      (gps) {
        state = state.copyWith(
          step: EvidenciaStep.cameraPermission,
          gps: gps,
          cargando: false,
        );
      },
    );
  }

  void fotoCapturada(String path) {
    state = state.copyWith(
      step: EvidenciaStep.analisisNitidez,
      fotoPath: path,
      cargando: true,
    );
    _analizarNitidez(File(path));
  }

  Future<void> _analizarNitidez(File foto) async {
    final result = await _sharpnessAnalyzer.isSharp(foto);

    result.fold(
      (failure) {
        state = state.copyWith(
          step: EvidenciaStep.rechazado,
          error: failure.message,
          cargando: false,
        );
      },
      (sharpness) {
        if (sharpness.esNitida) {
          final evidencia = EvidenciaData(
            fotoPath: foto.path,
            latitud: state.gps!.latitud,
            longitud: state.gps!.longitud,
            precision: state.gps!.precision,
          );
          state = state.copyWith(
            step: EvidenciaStep.completado,
            evidencia: evidencia,
            cargando: false,
          );
        } else {
          state = state.copyWith(
            step: EvidenciaStep.capturaFoto,
            error: 'Imagen borrosa. Toma una nueva fotografía.',
            cargando: false,
          );
        }
      },
    );
  }

  void reintentar() {
    state = const EvidenciaFlowState(step: EvidenciaStep.gpsPermission);
  }

  void cancelar() {
    state = const EvidenciaFlowState(step: EvidenciaStep.rechazado);
  }
}

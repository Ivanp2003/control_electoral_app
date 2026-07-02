import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/app_roles.dart';
import '../../../auth/domain/entities/usuario.dart';
import '../../../geolocalizacion/domain/entities/gps_data.dart';
import '../../../geolocalizacion/domain/usecases/verificar_y_capturar_gps_usecase.dart';
import '../../domain/entities/evidencia_data.dart';
import '../../domain/usecases/capturar_evidencia_usecase.dart';

enum EvidenciaStep {
  permisoGps,
  capturaGps,
  permisoCamara,
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

  const EvidenciaFlowState({
    this.step = EvidenciaStep.permisoGps,
    this.gps,
    this.fotoPath,
    this.evidencia,
    this.error,
  });

  EvidenciaFlowState copyWith({
    EvidenciaStep? step,
    GpsData? gps,
    String? fotoPath,
    EvidenciaData? evidencia,
    String? error,
  }) {
    return EvidenciaFlowState(
      step: step ?? this.step,
      gps: gps ?? this.gps,
      fotoPath: fotoPath ?? this.fotoPath,
      evidencia: evidencia ?? this.evidencia,
      error: error,
    );
  }
  
  EvidenciaFlowState clearError() {
    return EvidenciaFlowState(
      step: step,
      gps: gps,
      fotoPath: fotoPath,
      evidencia: evidencia,
      error: null,
    );
  }
}

class EvidenciaFlowNotifier extends StateNotifier<EvidenciaFlowState> {
  final VerificarYCapturarGpsUseCase _gpsUseCase;
  final CapturarEvidenciaUseCase _capturarUseCase;
  final ImagePicker _picker = ImagePicker();

  EvidenciaFlowNotifier({
    required VerificarYCapturarGpsUseCase gpsUseCase,
    required CapturarEvidenciaUseCase capturarUseCase,
  })  : _gpsUseCase = gpsUseCase,
        _capturarUseCase = capturarUseCase,
        super(const EvidenciaFlowState());

  @override
  void dispose() {
    super.dispose();
  }

  /// Paso 1 y 2: Verificar permisos y capturar GPS
  Future<void> capturarGps(Usuario usuario) async {
    // Verificamos permisos a nivel de rol antes de avanzar
    if (!AppPermissions.puedeCapturarFotos(usuario.rol)) {
      state = state.copyWith(
        step: EvidenciaStep.rechazado,
        error: 'Tu rol no tiene permiso para capturar evidencia.',
      );
      return;
    }

    state = state.copyWith(step: EvidenciaStep.capturaGps).clearError();
    
    final result = await _gpsUseCase();
    
    result.fold(
      (failure) {
        state = state.copyWith(
          step: EvidenciaStep.rechazado,
          error: failure.message,
        );
      },
      (gpsData) {
        state = state.copyWith(
          step: EvidenciaStep.permisoCamara,
          gps: gpsData,
        ).clearError();
      },
    );
  }

  /// Paso 3: Inicializar Cámara
  Future<void> inicializarCamara() async {
    if (state.step != EvidenciaStep.permisoCamara) return;
    
    // Con image_picker, no necesitamos inicializar un controlador de cámara en vivo.
    // Solo avanzamos directamente al paso de captura.
    state = state.copyWith(step: EvidenciaStep.capturaFoto).clearError();
  }

  /// Paso 4 y 5: Capturar Foto y Analizar Nitidez
  Future<void> tomarFotoYAnalizar(Usuario usuario) async {
    if (state.step != EvidenciaStep.capturaFoto) return;
    
    try {
      final xFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1920,
      );

      if (xFile == null) {
        // El usuario canceló la captura
        state = state.copyWith(
          step: EvidenciaStep.rechazado,
          error: 'Cancelaste la captura de la fotografía.',
        );
        return;
      }

      state = state.copyWith(step: EvidenciaStep.analisisNitidez).clearError();
      
      final result = await _capturarUseCase(
        usuario: usuario,
        fotoTemporalPath: xFile.path,
        // Usamos el GPS que ya capturamos en el Paso 2
        gpsData: state.gps!,
      );

      result.fold(
        (failure) {
          // Si falló por nitidez o cualquier otra cosa, volvemos a la captura de foto
          state = state.copyWith(
            step: EvidenciaStep.capturaFoto,
            error: failure.message,
          );
        },
        (evidencia) {
          state = state.copyWith(
            step: EvidenciaStep.completado,
            evidencia: evidencia,
          ).clearError();
        },
      );
    } catch (e) {
      state = state.copyWith(
        step: EvidenciaStep.capturaFoto,
        error: 'Error al procesar la fotografía: $e',
      );
    }
  }

  void reiniciarFlujo() {
    state = const EvidenciaFlowState(step: EvidenciaStep.permisoGps);
  }
}

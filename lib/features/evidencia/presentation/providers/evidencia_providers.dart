import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../features/geolocalizacion/data/services/geolocator_gps_service.dart';
import '../../data/services/ml_kit_sharpness_analyzer.dart';
import '../../domain/services/sharpness_analyzer.dart';
import '../../../geolocalizacion/domain/services/gps_service.dart';
import '../../../geolocalizacion/domain/usecases/verificar_y_capturar_gps_usecase.dart';
import '../../domain/usecases/capturar_evidencia_usecase.dart';
import 'evidencia_flow_notifier.dart';

final gpsServiceProvider = Provider<GpsService>((ref) {
  return GeolocatorGpsService();
});

final sharpnessAnalyzerProvider = Provider<SharpnessAnalyzer>((ref) {
  return MlKitSharpnessAnalyzer();
});

final verificarYCapturarGpsUseCaseProvider = Provider<VerificarYCapturarGpsUseCase>((ref) {
  return VerificarYCapturarGpsUseCase(ref.read(gpsServiceProvider));
});

final capturarEvidenciaUseCaseProvider = Provider<CapturarEvidenciaUseCase>((ref) {
  return CapturarEvidenciaUseCase(ref.read(sharpnessAnalyzerProvider));
});

final evidenciaFlowNotifierProvider =
    StateNotifierProvider<EvidenciaFlowNotifier, EvidenciaFlowState>((ref) {
  return EvidenciaFlowNotifier(
    gpsUseCase: ref.read(verificarYCapturarGpsUseCaseProvider),
    capturarUseCase: ref.read(capturarEvidenciaUseCaseProvider),
  );
});

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../features/geolocalizacion/data/services/geolocator_gps_service.dart';
import '../../data/services/ml_kit_sharpness_analyzer.dart';
import '../../domain/services/sharpness_analyzer.dart';
import '../../../geolocalizacion/domain/services/gps_service.dart';
import 'evidencia_flow_notifier.dart';

final gpsServiceProvider = Provider<GpsService>((ref) {
  return GeolocatorGpsService();
});

final sharpnessAnalyzerProvider = Provider<SharpnessAnalyzer>((ref) {
  return MlKitSharpnessAnalyzer();
});

final evidenciaFlowNotifierProvider =
    StateNotifierProvider<EvidenciaFlowNotifier, EvidenciaFlowState>((ref) {
  return EvidenciaFlowNotifier(
    gpsService: ref.read(gpsServiceProvider),
    sharpnessAnalyzer: ref.read(sharpnessAnalyzerProvider),
  );
});

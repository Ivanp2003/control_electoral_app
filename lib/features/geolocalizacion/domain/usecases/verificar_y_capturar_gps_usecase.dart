import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/gps_data.dart';
import '../services/gps_service.dart';

/// verificar_y_capturar_gps_usecase.dart
///
/// Responsabilidad Única: Orquestar el gate de GPS. Verifica los permisos
/// e inmediatamente después captura las coordenadas.
class VerificarYCapturarGpsUseCase {
  final GpsService _gpsService;

  VerificarYCapturarGpsUseCase(this._gpsService);

  Future<Either<Failure, GpsData>> call() async {
    final permResult = await _gpsService.verificarPermisos();
    
    return permResult.fold(
      (failure) => Left(failure),
      (_) async {
        return await _gpsService.capturarCoordenadas();
      },
    );
  }
}

import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/gps_data.dart';
import '../../domain/services/gps_service.dart';

class GeolocatorGpsService implements GpsService {
  @override
  Future<Either<Failure, Unit>> verificarPermisos() async {
    try {
      bool enabled = await Geolocator.isLocationServiceEnabled();
      if (!enabled) {
        return const Left(
          GpsGateFailure('El GPS está desactivado. Actívalo para continuar.'),
        );
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        return const Left(
          GpsGateFailure('Permiso de ubicación denegado.'),
        );
      }

      if (permission == LocationPermission.deniedForever) {
        return const Left(
          GpsGateFailure(
            'Permiso de ubicación denegado permanentemente. '
            'Habilítalo en Configuración.',
          ),
        );
      }

      return const Right(unit);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(GpsGateFailure('Error al verificar permisos GPS: $e'));
    }
  }

  @override
  Future<Either<Failure, GpsData>> capturarCoordenadas() async {
    try {
      Position? pos;
      try {
        pos = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            timeLimit: Duration(seconds: 10),
          ),
        );
      } catch (e) {
        // Fallback to last known position if timeout or error (offline scenario)
        pos = await Geolocator.getLastKnownPosition();
      }

      if (pos == null) {
        return const Left(GpsGateFailure('No se pudo obtener la ubicación GPS (posiblemente fuera de línea y sin historial).'));
      }

      return Right(GpsData(
        latitud: pos.latitude,
        longitud: pos.longitude,
        precision: pos.accuracy,
      ));
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(GpsGateFailure('Error al capturar coordenadas: $e'));
    }
  }
}

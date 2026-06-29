import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/gps_data.dart';

/// gps_service.dart
///
/// Responsabilidad Única: Contrato de Dominio para interactuar con hardware GPS.
abstract class GpsService {
  /// Verifica y solicita permisos si es necesario. Devuelve Unit si se conceden.
  Future<Either<Failure, Unit>> verificarPermisos();

  /// Captura las coordenadas exactas. Requiere que los permisos ya hayan sido concedidos.
  Future<Either<Failure, GpsData>> capturarCoordenadas();
}

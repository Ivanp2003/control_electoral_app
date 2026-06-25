import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../geolocalizacion/domain/entities/gps_data.dart';
import '../../../geolocalizacion/domain/services/gps_service.dart';
import '../../domain/entities/evidencia_data.dart';
import '../../domain/services/sharpness_analyzer.dart';

class CapturarEvidenciaUseCase {
  final GpsService _gpsService;
  final SharpnessAnalyzer _sharpnessAnalyzer;

  CapturarEvidenciaUseCase({
    required GpsService gpsService,
    required SharpnessAnalyzer sharpnessAnalyzer,
  })  : _gpsService = gpsService,
        _sharpnessAnalyzer = sharpnessAnalyzer;

  Future<Either<Failure, GpsData>> capturarGps() =>
      _gpsService.verificarYCapatutar();

  Future<Either<Failure, SharpnessResult>> analizarNitidez(File foto) =>
      _sharpnessAnalyzer.isSharp(foto);

  EvidenciaData crearEvidenciaData({
    required String fotoPath,
    required GpsData gps,
  }) {
    return EvidenciaData(
      fotoPath: fotoPath,
      latitud: gps.latitud,
      longitud: gps.longitud,
      precision: gps.precision,
    );
  }
}

import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../../../../core/errors/failures.dart';
import '../../../../core/constants/app_roles.dart';
import '../../../auth/domain/entities/usuario.dart';
import '../../../geolocalizacion/domain/entities/gps_data.dart';
import '../entities/evidencia_data.dart';
import '../services/sharpness_analyzer.dart';

/// capturar_evidencia_usecase.dart
///
/// Responsabilidad Única: Orquestar el análisis de nitidez y la persistencia
/// segura de la imagen, asegurando primero los permisos de rol correspondientes.
class CapturarEvidenciaUseCase {
  final SharpnessAnalyzer _sharpnessAnalyzer;

  CapturarEvidenciaUseCase(this._sharpnessAnalyzer);

  Future<Either<Failure, EvidenciaData>> call({
    required Usuario usuario,
    required String fotoTemporalPath,
    required GpsData gpsData,
  }) async {
    // 1. Verificación estricta de permisos por rol
    if (!AppPermissions.puedeCapturarFotos(usuario.rol)) {
      return Left(
        PermissionFailure('El rol de ${usuario.rol.name} no tiene permisos para capturar evidencia fotográfica.'),
      );
    }

    // 2. Análisis de Nitidez
    final fotoFile = File(fotoTemporalPath);
    if (!await fotoFile.exists()) {
      return const Left(CacheFailure('El archivo de la fotografía no existe o es ilegible.'));
    }

    final sharpnessResult = await _sharpnessAnalyzer.isSharp(fotoFile);
    
    return sharpnessResult.fold(
      (failure) => Left(failure),
      (result) {
        if (!result.esNitida) {
          return Left(EvidenciaInvalidaFailure('La imagen es demasiado borrosa. Por favor, toma una nueva fotografía. (Score: ${result.score})'));
        }
        return null; // marcador de éxito sin error de nitidez
      },
    ) ?? await _persistirEvidencia(fotoTemporalPath, gpsData);
  }

  Future<Either<Failure, EvidenciaData>> _persistirEvidencia(String fotoTemporalPath, GpsData gpsData) async {
    // 3. Persistencia Segura Offline-First
    try {
      final fotoFile = File(fotoTemporalPath);
      final docsDir = await getApplicationDocumentsDirectory();
      final fileName = p.basename(fotoTemporalPath);
      final persistPath = p.join(docsDir.path, 'evidencia', fileName);
      
      final persistFile = File(persistPath);
      if (!await persistFile.parent.exists()) {
        await persistFile.parent.create(recursive: true);
      }
      
      await fotoFile.copy(persistPath);

      return Right(EvidenciaData(
        fotoPath: persistPath,
        latitud: gpsData.latitud,
        longitud: gpsData.longitud,
        precision: gpsData.precision,
      ));
    } catch (e) {
      return Left(CacheFailure('No se pudo persistir la fotografía en el dispositivo: $e'));
    }
  }
}

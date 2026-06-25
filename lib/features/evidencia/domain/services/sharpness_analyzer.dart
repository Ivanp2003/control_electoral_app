import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';

/// sharpness_analyzer.dart
/// 
/// Responsabilidad Única: Definir el contrato para la verificación de nitidez de imágenes 
/// (evitando imágenes borrosas) y su modelo de resultado SharpnessResult.
/// Cambios en esta clase ocurren si cambian los parámetros requeridos para la verificación 
/// o la firma de resultado.

/// Representa el resultado del análisis de nitidez.
class SharpnessResult extends Equatable {
  /// Indica si la imagen cumple con el umbral mínimo de nitidez.
  final bool esNitida;

  /// Puntuación o métrica de nitidez (ej. varianza laplaciana o score OCR).
  final double score;

  const SharpnessResult({
    required this.esNitida,
    required this.score,
  });

  @override
  List<Object?> get props => [esNitida, score];
}

/// Contrato del servicio de dominio para analizar la nitidez de capturas fotográficas.
abstract class SharpnessAnalyzer {
  /// Analiza la imagen indicada en [imageFile] y dictamina si es nítida y su puntaje.
  Future<Either<Failure, SharpnessResult>> isSharp(File imageFile);
}

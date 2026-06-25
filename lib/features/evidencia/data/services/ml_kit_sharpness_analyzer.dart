import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/services/sharpness_analyzer.dart';

class MlKitSharpnessAnalyzer implements SharpnessAnalyzer {
  @override
  Future<Either<Failure, SharpnessResult>> isSharp(File imageFile) async {
    try {
      final inputImage = InputImage.fromFile(imageFile);
      final textRecognizer = TextRecognizer();
      final recognizedText = await textRecognizer.processImage(inputImage);

      await textRecognizer.close();

      final blockCount = recognizedText.blocks.length;
      final lineCount =
          recognizedText.blocks.fold(0, (sum, b) => sum + b.lines.length);

      const int minBlocks = 2;
      const int minLines = 3;
      const double minScore = 5.0;

      final double score = (blockCount * 2.0) + (lineCount * 1.0);
      final bool esNitida =
          blockCount >= minBlocks && lineCount >= minLines && score >= minScore;

      return Right(SharpnessResult(
        esNitida: esNitida,
        score: score,
      ));
    } catch (e) {
      return Left(
        CacheFailure('Error al analizar nitidez de la imagen: $e'),
      );
    }
  }
}

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/recinto.dart';
import '../repositories/recintos_repository.dart';

/// obtener_recintos_usecase.dart
///
/// Responsabilidad Única: Caso de uso de lectura de recintos por parroquia.

class ObtenerRecintosUseCase {
  final RecintosRepository _repository;

  const ObtenerRecintosUseCase({required RecintosRepository repository})
      : _repository = repository;

  Future<Either<Failure, List<Recinto>>> call(String parroquiaId) =>
      _repository.obtenerRecintos(parroquiaId);
}

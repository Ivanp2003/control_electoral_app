import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/canton.dart';
import '../repositories/recintos_repository.dart';

/// obtener_cantones_usecase.dart
///
/// Responsabilidad Única: Caso de uso de lectura de cantones por provincia.
/// Utilizado para la carga en cascada del formulario CrearRecintoScreen.

class ObtenerCantonesUseCase {
  final RecintosRepository _repository;

  const ObtenerCantonesUseCase({required RecintosRepository repository})
      : _repository = repository;

  Future<Either<Failure, List<Canton>>> call(String provinciaId) =>
      _repository.obtenerCantones(provinciaId);
}

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/parroquia.dart';
import '../repositories/recintos_repository.dart';

/// obtener_parroquias_usecase.dart
///
/// Responsabilidad Única: Caso de uso de lectura de parroquias por cantón.
/// Es el use case que alimenta el dropdown de parroquia en CrearRecintoScreen.

class ObtenerParroquiasUseCase {
  final RecintosRepository _repository;

  const ObtenerParroquiasUseCase({required RecintosRepository repository})
      : _repository = repository;

  Future<Either<Failure, List<Parroquia>>> call(String cantonId) =>
      _repository.obtenerParroquias(cantonId);
}

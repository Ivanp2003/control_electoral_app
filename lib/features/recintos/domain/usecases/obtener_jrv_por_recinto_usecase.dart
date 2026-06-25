import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/jrv.dart';
import '../repositories/recintos_repository.dart';

/// obtener_jrv_por_recinto_usecase.dart
///
/// Responsabilidad Única: Caso de uso de lectura de JRV para un recinto dado.

class ObtenerJrvPorRecintoUseCase {
  final RecintosRepository _repository;

  const ObtenerJrvPorRecintoUseCase({required RecintosRepository repository})
      : _repository = repository;

  Future<Either<Failure, List<Jrv>>> call(String recintoId) =>
      _repository.obtenerJrvPorRecinto(recintoId);
}

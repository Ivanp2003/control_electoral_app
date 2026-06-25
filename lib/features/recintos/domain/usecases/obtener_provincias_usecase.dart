import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/provincia.dart';
import '../repositories/recintos_repository.dart';

/// obtener_provincias_usecase.dart
///
/// Responsabilidad Única: Caso de uso de lectura de provincias.
/// No requiere verificación de rol — cualquier usuario autenticado puede leer
/// la jerarquía geográfica.

class ObtenerProvinciasUseCase {
  final RecintosRepository _repository;

  const ObtenerProvinciasUseCase({required RecintosRepository repository})
      : _repository = repository;

  Future<Either<Failure, List<Provincia>>> call() =>
      _repository.obtenerProvincias();
}

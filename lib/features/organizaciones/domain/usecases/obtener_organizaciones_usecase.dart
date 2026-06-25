import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/organizacion_politica.dart';
import '../repositories/organizaciones_repository.dart';

/// obtener_organizaciones_usecase.dart
///
/// Responsabilidad Única: Caso de uso de lectura de organizaciones políticas
/// filtradas por cargo ('alcalde' o 'prefecto'). Sin restricción de rol.

class ObtenerOrganizacionesUseCase {
  final OrganizacionesRepository _repository;

  const ObtenerOrganizacionesUseCase(
      {required OrganizacionesRepository repository})
      : _repository = repository;

  Future<Either<Failure, List<OrganizacionPolitica>>> call(String cargo) =>
      _repository.obtenerOrganizaciones(cargo);
}

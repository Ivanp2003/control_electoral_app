import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/organizacion_politica.dart';

/// organizaciones_repository.dart
///
/// Responsabilidad Única: Contrato de acceso a datos para las
/// Organizaciones Políticas participantes en el proceso electoral.

abstract class OrganizacionesRepository {
  /// Obtiene las organizaciones políticas por cargo electoral.
  /// [cargo]: 'alcalde' o 'prefecto'
  Future<Either<Failure, List<OrganizacionPolitica>>> obtenerOrganizaciones(
      String cargo);
}

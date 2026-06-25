import 'package:dartz/dartz.dart';
import '../../../../core/constants/app_roles.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/validators/acta_validator.dart';
import '../../../organizaciones/domain/entities/organizacion_politica.dart';
import '../entities/acta.dart';
import '../entities/organizacion_con_votos.dart';
import '../repositories/actas_repository.dart';

class RegistrarActaUseCase {
  final ActasRepository _repository;

  RegistrarActaUseCase({required ActasRepository repository})
      : _repository = repository;

  Either<Failure, Unit> _validar(Acta acta) {
    return validarActa(
      totalSufragantes: acta.totalSufragantes,
      votosOrganizaciones: acta.votos.map((v) => v.votos).toList(),
      votosBlancos: acta.votosBlancos,
      votosNulos: acta.votosNulos,
    );
  }

  Future<Either<Failure, Acta>> call({
    required AppRole rolUsuario,
    required Acta acta,
    required List<OrganizacionPolitica> organizaciones,
  }) async {
    if (!AppPermissions.puedeRegistrarActas(rolUsuario)) {
      return const Left(PermissionFailure(
          'Solo los veedores pueden registrar actas.'));
    }

    final validacion = _validar(acta);
    if (validacion.isLeft()) {
      return validacion.fold(
        (failure) => Left(failure),
        (_) => Left(ActaInconsistenteFailure(diferencia: 0)),
      );
    }

    return _repository.registrar(acta);
  }
}

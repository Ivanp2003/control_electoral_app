import 'package:dartz/dartz.dart';
import '../../../../core/constants/app_roles.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/validators/acta_validator.dart';
import '../entities/acta.dart';
import '../repositories/actas_repository.dart';

class CorregirActaUseCase {
  final ActasRepository _repository;

  CorregirActaUseCase({required ActasRepository repository})
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
    required String editadoPor,
    required bool esPropia,
  }) async {
    final puedeCorregirPropia =
        AppPermissions.puedeCorregirSusPropiasActas(rolUsuario);
    final puedeCorregirCualquiera =
        AppPermissions.puedeCorregirCualquierActaDelRecinto(rolUsuario);

    if (!puedeCorregirPropia && !puedeCorregirCualquiera) {
      return const Left(PermissionFailure(
          'No tienes permiso para corregir actas.'));
    }

    if (!puedeCorregirCualquiera && !esPropia) {
      return const Left(PermissionFailure(
          'Solo puedes corregir tus propias actas.'));
    }

    final validacion = _validar(acta);
    if (validacion.isLeft()) {
      return validacion.fold(
        (failure) => Left(failure),
        (_) => Left(ActaInconsistenteFailure(diferencia: 0)),
      );
    }

    return _repository.corregir(acta, editadoPor);
  }
}

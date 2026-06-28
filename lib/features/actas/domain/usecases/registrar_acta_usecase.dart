import 'package:dartz/dartz.dart';
import '../../../../core/constants/app_roles.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/validators/acta_validator.dart';
import '../../../auth/domain/entities/usuario.dart';
import '../entities/acta.dart';
import '../repositories/actas_repository.dart';

/// registrar_acta_usecase.dart
///
/// Responsabilidad Única: Orquestar el registro de un acta, ejecutando primero la
/// validación matemática pura y luego verificando permisos globales y asignaciones.

class RegistrarActaUseCase {
  final ActasRepository _repository;

  RegistrarActaUseCase(this._repository);

  Future<Either<Failure, void>> call(Acta acta, Usuario usuario) async {
    // 1. Verificar Permisos Globales (AppPermissions)
    if (!AppPermissions.puedeRegistrarActas(usuario.rol)) {
      return const Left(PermissionFailure('No tienes permiso para registrar actas.'));
    }

    // 2. Verificar Asignación Veedor-JRV
    final asignado = await _repository.verificarAsignacionVeedor(usuario.id, acta.jrvId);
    if (!asignado) {
      return const Left(PermissionFailure('No tienes asignada esta JRV.'));
    }

    // 3. Validación Matemática Pura
    final resultValidacion = validarActa(
      totalSufragantes: acta.totalSufragantes,
      votosOrganizaciones: acta.organizaciones.map((o) => o.votos).toList(),
      votosBlancos: acta.votosBlancos,
      votosNulos: acta.votosNulos,
    );

    if (resultValidacion.isLeft()) {
      return resultValidacion; // Retorna el ActaInconsistenteFailure o ValidationFailure
    }

    // 4. Ejecutar Registro Offline-First
    return await _repository.registrarActa(acta);
  }
}

import 'package:dartz/dartz.dart';
import '../../../../core/constants/app_roles.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/validators/acta_validator.dart';
import '../../../auth/domain/entities/usuario.dart';
import '../entities/acta.dart';
import '../repositories/actas_repository.dart';
import '../../../recintos/domain/repositories/recintos_repository.dart';

/// registrar_acta_usecase.dart
///
/// Responsabilidad Única: Orquestar el registro de un acta, ejecutando primero la
/// validación matemática pura y luego verificando permisos globales y asignaciones.

class RegistrarActaUseCase {
  final ActasRepository _repository;
  final RecintosRepository _recintosRepository;

  RegistrarActaUseCase(this._repository, this._recintosRepository);

  Future<Either<Failure, void>> call(Acta acta, Usuario usuario) async {
    // 1. Verificar Permisos Globales (AppPermissions)
    if (!AppPermissions.puedeRegistrarActas(usuario.rol)) {
      return const Left(PermissionFailure('No tienes permiso para registrar actas.'));
    }

    // 2. Verificar Asignación Veedor-JRV
    if (usuario.rol == AppRole.veedor) {
      final asignado = await _repository.verificarAsignacionVeedor(usuario.id, acta.jrvId);
      if (!asignado) {
        return const Left(PermissionFailure('No tienes asignada esta JRV.'));
      }
    } else if (usuario.rol == AppRole.coordinadorRecinto) {
      final jrvResult = await _recintosRepository.obtenerJrvPorId(acta.jrvId);
      if (jrvResult.isLeft()) {
        return const Left(PermissionFailure('Error al validar JRV.'));
      }
      final jrv = jrvResult.fold((l) => null, (r) => r);
      final recintoResult = await _recintosRepository.obtenerRecintoPorId(jrv!.recintoId);
      final recinto = recintoResult.fold((l) => null, (r) => r);
      if (recinto == null || recinto.coordinadorId != usuario.id) {
        return const Left(PermissionFailure('No puedes registrar actas en un recinto que no te pertenece.'));
      }
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

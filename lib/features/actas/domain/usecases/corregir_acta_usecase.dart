import 'package:dartz/dartz.dart';
import '../../../../core/constants/app_roles.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/validators/acta_validator.dart';
import '../../../auth/domain/entities/usuario.dart';
import '../entities/acta.dart';
import '../repositories/actas_repository.dart';
import '../../../recintos/domain/repositories/recintos_repository.dart';

/// corregir_acta_usecase.dart
///
/// Responsabilidad Única: Orquestar la corrección de un acta, validando matemáticamente
/// y asegurando que el usuario tenga permisos según su rol (dueño o coordinador).

class CorregirActaUseCase {
  final ActasRepository _repository;
  final RecintosRepository _recintosRepository;

  CorregirActaUseCase(this._repository, this._recintosRepository);

  Future<Either<Failure, void>> call(Acta actaOriginal, Acta actaCorregida, Usuario usuario) async {
    // 1. Verificar Permisos Globales (AppPermissions)
    final esPropia = actaOriginal.creadoPor == usuario.id;
    final puedeComoDueno = esPropia && AppPermissions.puedeCorregirSusPropiasActas(usuario.rol);
    final puedeComoCoordinador = AppPermissions.puedeCorregirCualquierActaDelRecinto(usuario.rol);

    if (!puedeComoDueno && !puedeComoCoordinador) {
      return const Left(PermissionFailure('No tienes permiso para corregir esta acta.'));
    }

    // 2. Verificar Asignación y Alcance Territorial
    if (puedeComoDueno) {
      final asignado = await _repository.verificarAsignacionVeedor(usuario.id, actaCorregida.jrvId);
      if (!asignado) {
        return const Left(PermissionFailure('Ya no tienes asignada esta JRV.'));
      }
    } else if (usuario.rol == AppRole.coordinadorRecinto) {
      final jrvResult = await _recintosRepository.obtenerJrvPorId(actaCorregida.jrvId);
      if (jrvResult.isLeft()) {
        return const Left(PermissionFailure('Error al validar JRV.'));
      }
      final jrv = jrvResult.fold((l) => null, (r) => r);
      final recintoResult = await _recintosRepository.obtenerRecintoPorId(jrv!.recintoId);
      final recinto = recintoResult.fold((l) => null, (r) => r);
      if (recinto == null || recinto.coordinadorId != usuario.id) {
        return const Left(PermissionFailure('No puedes corregir actas en un recinto que no te pertenece.'));
      }
    }

    // 3. Validación Matemática Pura
    final resultValidacion = validarActa(
      totalSufragantes: actaCorregida.totalSufragantes,
      votosOrganizaciones: actaCorregida.organizaciones.map((o) => o.votos).toList(),
      votosBlancos: actaCorregida.votosBlancos,
      votosNulos: actaCorregida.votosNulos,
    );

    if (resultValidacion.isLeft()) {
      return resultValidacion;
    }

    // 4. Ejecutar Corrección Offline-First
    return await _repository.corregirActa(actaCorregida);
  }
}

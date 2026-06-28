import 'package:dartz/dartz.dart';
import '../../../../core/constants/app_roles.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/validators/acta_validator.dart';
import '../../../auth/domain/entities/usuario.dart';
import '../entities/acta.dart';
import '../repositories/actas_repository.dart';

/// corregir_acta_usecase.dart
///
/// Responsabilidad Única: Orquestar la corrección de un acta, validando matemáticamente
/// y asegurando que el usuario tenga permisos según su rol (dueño o coordinador).

class CorregirActaUseCase {
  final ActasRepository _repository;

  CorregirActaUseCase(this._repository);

  Future<Either<Failure, void>> call(Acta actaOriginal, Acta actaCorregida, Usuario usuario) async {
    // 1. Verificar Permisos Globales (AppPermissions)
    final esPropia = actaOriginal.creadoPor == usuario.id;
    final puedeComoDueno = esPropia && AppPermissions.puedeCorregirSusPropiasActas(usuario.rol);
    final puedeComoCoordinador = AppPermissions.puedeCorregirCualquierActaDelRecinto(usuario.rol);

    if (!puedeComoDueno && !puedeComoCoordinador) {
      return const Left(PermissionFailure('No tienes permiso para corregir esta acta.'));
    }

    // 2. Verificar Asignación Veedor-JRV (si es dueño, debe seguir asignado)
    if (puedeComoDueno) {
      final asignado = await _repository.verificarAsignacionVeedor(usuario.id, actaCorregida.jrvId);
      if (!asignado) {
        return const Left(PermissionFailure('Ya no tienes asignada esta JRV.'));
      }
    }
    // Nota: Si es coordinador, se asume que puede corregir cualquiera del recinto. 
    // Idealmente, también se verificaría la asignación Coordinador <-> Recinto aquí.

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

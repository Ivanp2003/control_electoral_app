import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/constants/app_roles.dart';
import '../entities/jrv.dart';
import '../repositories/recintos_repository.dart';

/// crear_jrv_usecase.dart
///
/// Responsabilidad Única: Orquestar la creación de una nueva JRV asegurando
/// que el usuario tenga los permisos administrativos necesarios.

class CrearJrvUseCase {
  final RecintosRepository _repository;

  CrearJrvUseCase({required RecintosRepository repository})
      : _repository = repository;

  Future<Either<Failure, Jrv>> call({
    required AppRole rolUsuario,
    required String codigo,
    required String recintoId,
  }) async {
    // 1. Validar permisos de negocio (Coordinador Provincial)
    if (!AppPermissions.puedeCrearRecintos(rolUsuario)) {
      return const Left(
          PermissionFailure('No tienes permisos para crear JRVs.'));
    }

    // 2. Validar datos mínimos
    if (codigo.trim().isEmpty) {
      return const Left(ValidationFailure('El código de la JRV no puede estar vacío.'));
    }

    // 3. Ejecutar creación
    return await _repository.crearJrv(
      codigo: codigo.trim(),
      recintoId: recintoId,
    );
  }
}

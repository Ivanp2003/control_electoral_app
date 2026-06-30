import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/constants/app_roles.dart';
import '../../../auth/domain/entities/usuario.dart';
import '../repositories/usuario_repository.dart';
import '../../../recintos/domain/repositories/recintos_repository.dart';

class AsignarVeedorJrvUseCase {
  final UsuarioRepository _repository;
  final RecintosRepository _recintosRepository;

  AsignarVeedorJrvUseCase(this._repository, this._recintosRepository);

  Future<Either<Failure, Unit>> call({
    required String veedorId,
    required String jrvId,
    required String recintoId,
    required Usuario usuarioEjecutor,
  }) async {
    if (!AppPermissions.puedeAsignarVeedores(usuarioEjecutor.rol)) {
      return const Left(PermissionFailure('No tienes permisos para asignar veedores.'));
    }

    if (usuarioEjecutor.rol == AppRole.coordinadorRecinto) {
      final recintoResult = await _recintosRepository.obtenerRecintoPorId(recintoId);
      if (recintoResult.isLeft()) {
        return const Left(PermissionFailure('Error al validar recinto.'));
      }
      final recinto = recintoResult.fold((l) => null, (r) => r);
      if (recinto == null || recinto.coordinadorId != usuarioEjecutor.id) {
        return const Left(PermissionFailure('No puedes asignar veedores en un recinto que no te pertenece.'));
      }
    }

    return _repository.asignarVeedorAJrv(
      veedorId: veedorId,
      jrvId: jrvId,
      recintoId: recintoId,
    );
  }
}

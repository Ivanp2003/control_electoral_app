import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/constants/app_roles.dart';
import '../../../auth/domain/entities/usuario.dart';
import '../repositories/usuario_repository.dart';

class AsignarVeedorJrvUseCase {
  final UsuarioRepository _repository;

  AsignarVeedorJrvUseCase(this._repository);

  Future<Either<Failure, Unit>> call({
    required String veedorId,
    required String jrvId,
    required String recintoId,
    required Usuario usuarioEjecutor,
  }) async {
    if (!AppPermissions.puedeAsignarVeedores(usuarioEjecutor.rol)) {
      return const Left(PermissionFailure('No tienes permisos para asignar veedores.'));
    }

    return _repository.asignarVeedorAJrv(
      veedorId: veedorId,
      jrvId: jrvId,
      recintoId: recintoId,
    );
  }
}

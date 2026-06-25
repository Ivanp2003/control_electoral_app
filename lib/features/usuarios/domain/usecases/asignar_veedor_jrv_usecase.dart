import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/usuario_repository.dart';

class AsignarVeedorJrvUseCase {
  final UsuarioRepository _repository;

  AsignarVeedorJrvUseCase(this._repository);

  Future<Either<Failure, Unit>> call({
    required String veedorId,
    required String jrvId,
    required String recintoId,
  }) {
    return _repository.asignarVeedorAJrv(
      veedorId: veedorId,
      jrvId: jrvId,
      recintoId: recintoId,
    );
  }
}

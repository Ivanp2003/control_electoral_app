import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../auth/domain/entities/usuario.dart';
import '../repositories/usuario_repository.dart';

class ListarUsuariosUseCase {
  final UsuarioRepository _repository;

  ListarUsuariosUseCase(this._repository);

  Future<Either<Failure, List<Usuario>>> call({String? rol}) {
    return _repository.listarUsuarios(rol: rol);
  }
}

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../auth/domain/entities/usuario.dart';

abstract class UsuarioRepository {
  Future<Either<Failure, List<Usuario>>> listarUsuarios({String? rol});

  Future<Either<Failure, Unit>> asignarVeedorAJrv({
    required String veedorId,
    required String jrvId,
    required String recintoId,
  });

  Future<Either<Failure, Unit>> asignarCoordinadorRecinto({
    required String recintoId,
    required String coordinadorId,
  });
}

import 'package:dartz/dartz.dart';
import '../../../../core/constants/app_roles.dart';
import '../../../../core/errors/failures.dart';
import '../entities/acta.dart';
import '../repositories/actas_repository.dart';

class ObtenerActasPorJrvUseCase {
  final ActasRepository _repository;

  ObtenerActasPorJrvUseCase({required ActasRepository repository})
      : _repository = repository;

  Future<Either<Failure, List<Acta>>> call({
    required AppRole rolUsuario,
    required String jrvId,
    String? veedorId,
  }) async {
    final puedeVer = AppPermissions.puedeRegistrarActas(rolUsuario) ||
        AppPermissions.puedeCorregirCualquierActaDelRecinto(rolUsuario) ||
        AppPermissions.puedeVerAvanceGlobalYGps(rolUsuario);

    if (!puedeVer) {
      return const Left(PermissionFailure(
          'No tienes permiso para consultar actas.'));
    }

    return _repository.obtenerPorJrv(jrvId);
  }
}

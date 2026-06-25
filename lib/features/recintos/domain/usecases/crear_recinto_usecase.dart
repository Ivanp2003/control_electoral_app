import 'package:dartz/dartz.dart';
import '../../../../core/constants/app_roles.dart';
import '../../../../core/errors/failures.dart';
import '../entities/recinto.dart';
import '../repositories/recintos_repository.dart';

/// crear_recinto_usecase.dart
///
/// Responsabilidad Única: Caso de uso para crear un nuevo Recinto Electoral.
/// SEGURIDAD: Verifica AppPermissions.puedeCrearRecintos antes de llamar al repositorio.
/// Si el usuario no tiene el rol de Coordinador Provincial, retorna PermissionFailure
/// sin llegar al datasource. La UI también oculta el acceso, pero este check es
/// la barrera real a nivel de aplicación.

class CrearRecintoUseCase {
  final RecintosRepository _repository;

  const CrearRecintoUseCase({required RecintosRepository repository})
      : _repository = repository;

  Future<Either<Failure, Recinto>> call({
    required AppRole rolUsuario,
    required String nombre,
    required String parroquiaId,
    required String direccion,
    double? latRef,
    double? lonRef,
  }) async {
    // Guard de permiso: solo Coordinador Provincial puede crear recintos.
    if (!AppPermissions.puedeCrearRecintos(rolUsuario)) {
      return const Left(
        PermissionFailure(
            'Solo el Coordinador Provincial puede crear recintos electorales.'),
      );
    }

    return _repository.crearRecinto(
      nombre: nombre,
      parroquiaId: parroquiaId,
      direccion: direccion,
      latRef: latRef,
      lonRef: lonRef,
    );
  }
}

import 'package:dartz/dartz.dart';
import '../../../../core/constants/app_roles.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/validators/cedula_validator.dart';
import '../../../auth/domain/entities/usuario.dart';
import '../repositories/usuario_repository.dart';
import '../../../recintos/domain/repositories/recintos_repository.dart';
import '../../../../database/app_database.dart';
import 'package:drift/drift.dart';

class AsignarCoordinadorRecintoUseCase {
  final UsuarioRepository _usuarioRepository;
  final RecintosRepository _recintosRepository;
  final AppDatabase _db;

  AsignarCoordinadorRecintoUseCase({
    required UsuarioRepository usuarioRepository,
    required RecintosRepository recintosRepository,
    required AppDatabase db,
  })  : _usuarioRepository = usuarioRepository,
        _recintosRepository = recintosRepository,
        _db = db;

  Future<Either<Failure, Unit>> call({
    required String recintoId,
    required String cedulaCoordinador,
    required Usuario usuarioEjecutor,
  }) async {
    // 1. Validar rol del ejecutor
    if (usuarioEjecutor.rol != AppRole.coordinadorProvincial) {
      return const Left(PermissionFailure('Solo el Coordinador Provincial puede asignar coordinadores de recinto.'));
    }

    // 2. Validar cédula ecuatoriana
    if (!esCedulaValida(cedulaCoordinador)) {
      return const Left(ValidationFailure('La cédula ingresada no es válida.'));
    }

    // 3. Validar existencia local/remota del recinto
    final recintoRes = await _recintosRepository.obtenerRecintoPorId(recintoId);
    if (recintoRes.isLeft()) {
      return const Left(ValidationFailure('El recinto seleccionado no existe.'));
    }
    final recinto = recintoRes.getOrElse(() => throw Exception());

    // 4. Lógica remote-first / local-fallback
    final hasConnection = await _db.obtenerConfigLocal('seed_ejecutado') != null; // Simulación o flag, pero usamos repository
    
    // Tratamos de buscar el usuario
    final userRes = await _usuarioRepository.buscarUsuarioPorCedula(cedulaCoordinador);
    
    return userRes.fold(
      (failure) async {
        // Si no hay red (NoConnectionFailure), encolamos la tarea
        if (failure is NoConnectionFailure) {
          await _db.encolarOperacion(SyncQueueCompanion(
            entityType: const Value('recinto'),
            operation: const Value('asignarCoordinador'),
            payload: Value('{"recintoId":"$recintoId","cedulaCoordinador":"$cedulaCoordinador"}'),
            status: const Value('pending'),
          ));
          return const Left(NoConnectionFailure('Sin conexión. Asignación guardada localmente, se sincronizará al recuperar conexión.'));
        }
        return Left(failure);
      },
      (coordinador) async {
        // Validar rol del usuario encontrado
        if (coordinador.rol != AppRole.coordinadorRecinto) {
          return const Left(ValidationFailure('El usuario asignado debe tener el rol de Coordinador de Recinto.'));
        }

        // A) Sincronización Remota Bidireccional
        // 1. Remover al coordinador de cualquier recinto que administre previamente (Regla de negocio: un coordinador -> un recinto)
        await _usuarioRepository.desasignarCoordinadorDeCualquierRecinto(coordinador.id);

        // 2. Asignar el nuevo coordinador en Appwrite (colección recintos)
        final asignacionRes = await _usuarioRepository.asignarCoordinadorRecinto(
          recintoId: recintoId,
          coordinadorId: coordinador.id,
        );

        return asignacionRes.fold(
          (failure) => Left(failure),
          (_) async {
            // B) Sincronización Local Inmediata en Drift SQLite
            await _db.transaction(() async {
              // 1. Remover la asociación anterior de este coordinador en cualquier recinto local
              await (_db.update(_db.recintosLocal)
                    ..where((t) => t.coordinadorId.equals(coordinador.id)))
                  .write(const RecintosLocalCompanion(coordinadorId: Value(null)));

              // 2. Vincular el coordinadorId real al recinto asignado en Drift
              await (_db.update(_db.recintosLocal)
                    ..where((t) => t.id.equals(recintoId)))
                  .write(RecintosLocalCompanion(coordinadorId: Value(coordinador.id)));
            });

            return const Right(unit);
          },
        );
      },
    );
  }
}

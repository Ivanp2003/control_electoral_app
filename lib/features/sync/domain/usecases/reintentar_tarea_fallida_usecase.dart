import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../database/app_database.dart';

class ReintentarTareaFallidaUseCase {
  final AppDatabase _db;

  ReintentarTareaFallidaUseCase(this._db);

  Future<Either<Failure, Unit>> call(int taskId) async {
    try {
      // Reinicia los intentos a 0 y pasa a pending para que el orquestador la atrape
      await _db.incrementarIntentoSync(taskId, 0, 'pending');
      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure('Error al reintentar la tarea: $e'));
    }
  }
}

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/acta.dart';
import '../repositories/actas_repository.dart';



/// obtener_actas_por_jrv_usecase.dart
///
/// Responsabilidad Única: Obtener actas de una JRV específica (estrategia offline-first).

class ObtenerActasPorJrvUseCase {
  final ActasRepository _repository;

  ObtenerActasPorJrvUseCase(this._repository);

  Future<Either<Failure, List<Acta>>> call(String jrvId) async {
    return await _repository.obtenerActasPorJrv(jrvId);
  }
}

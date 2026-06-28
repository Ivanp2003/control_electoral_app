import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/acta.dart';

/// actas_repository.dart
///
/// Responsabilidad Única: Definir el contrato (interfaz) para las operaciones de lectura
/// y escritura de actas en la capa de datos (offline-first).

abstract class ActasRepository {
  /// Obtiene la lista de actas registradas para una JRV específica (offline-first).
  Future<Either<Failure, List<Acta>>> obtenerActasPorJrv(String jrvId);

  /// Registra una nueva acta (Alcalde o Prefecto) para una JRV.
  /// Implementará estrategia offline-first (guarda local e intenta sync).
  Future<Either<Failure, void>> registrarActa(Acta acta);

  /// Actualiza un acta existente (con nueva fechaEdicion y editadoPor).
  /// Implementará estrategia offline-first.
  Future<Either<Failure, void>> corregirActa(Acta acta);

  /// Verifica localmente si el veedor está asignado a la JRV.
  Future<bool> verificarAsignacionVeedor(String veedorId, String jrvId);
}

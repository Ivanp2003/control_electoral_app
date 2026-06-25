import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/canton.dart';
import '../entities/jrv.dart';
import '../entities/parroquia.dart';
import '../entities/provincia.dart';
import '../entities/recinto.dart';

/// recintos_repository.dart
///
/// Responsabilidad Única: Definir el contrato de acceso a datos para la
/// jerarquía geográfica electoral (Provincia → Cantón → Parroquia → Recinto → JRV).
/// Las implementaciones concretas deciden si van a Appwrite o a la caché local Drift.

abstract class RecintosRepository {
  /// Obtiene la lista completa de provincias.
  Future<Either<Failure, List<Provincia>>> obtenerProvincias();

  /// Obtiene los cantones pertenecientes a una provincia.
  Future<Either<Failure, List<Canton>>> obtenerCantones(String provinciaId);

  /// Obtiene las parroquias pertenecientes a un cantón.
  /// Utilizado para poblar el dropdown de parroquia en CrearRecintoScreen.
  Future<Either<Failure, List<Parroquia>>> obtenerParroquias(String cantonId);

  /// Obtiene los recintos pertenecientes a una parroquia.
  Future<Either<Failure, List<Recinto>>> obtenerRecintos(String parroquiaId);

  /// Obtiene las JRV pertenecientes a un recinto electoral.
  Future<Either<Failure, List<Jrv>>> obtenerJrvPorRecinto(String recintoId);

  /// Crea un nuevo recinto electoral en el servidor remoto.
  /// Requiere que el Use Case haya verificado el permiso puedeCrearRecintos
  /// antes de llamar a este método.
  Future<Either<Failure, Recinto>> crearRecinto({
    required String nombre,
    required String parroquiaId,
    required String direccion,
    double? latRef,
    double? lonRef,
  });
}

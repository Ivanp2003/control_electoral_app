import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/acta.dart';

abstract class ActasRepository {
  Future<Either<Failure, Acta>> registrar(Acta acta);
  Future<Either<Failure, Acta>> corregir(Acta acta, String editadoPor);
  Future<Either<Failure, List<Acta>>> obtenerPorJrv(String jrvId);
  Future<Either<Failure, List<Acta>>> obtenerPorVeedor(String veedorId);
  Future<Either<Failure, List<Acta>>> obtenerPorRecinto(String recintoId);
}

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/gps_data.dart';

abstract class GpsService {
  Future<Either<Failure, GpsData>> verificarYCapatutar();
}

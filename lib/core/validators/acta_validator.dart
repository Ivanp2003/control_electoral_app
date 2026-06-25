import 'package:dartz/dartz.dart';
import '../errors/failures.dart';

bool _votoSuperaTotal(int voto, int total) => voto > total;

Either<ActaInconsistenteFailure, Unit> validarActa({
  required int totalSufragantes,
  required List<int> votosOrganizaciones,
  required int votosBlancos,
  required int votosNulos,
}) {
  for (final voto in votosOrganizaciones) {
    if (_votoSuperaTotal(voto, totalSufragantes)) {
      return Left(ActaInconsistenteFailure(
        diferencia: totalSufragantes - (votosOrganizaciones.fold(0, (a, b) => a + b) + votosBlancos + votosNulos),
      ));
    }
  }

  final sumaVotos = votosOrganizaciones.fold(0, (a, b) => a + b);
  final totalRegistrado = sumaVotos + votosBlancos + votosNulos;
  final diferencia = totalSufragantes - totalRegistrado;

  if (diferencia != 0) {
    return Left(ActaInconsistenteFailure(diferencia: -diferencia));
  }

  return const Right(unit);
}

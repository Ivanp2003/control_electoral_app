import 'package:dartz/dartz.dart';
import '../errors/failures.dart';

Either<Failure, Unit> validarActa({
  required int totalSufragantes,
  required List<int> votosOrganizaciones,
  required int votosBlancos,
  required int votosNulos,
}) {
  if (totalSufragantes < 0) return const Left(ValidationFailure('El total de sufragantes no puede ser negativo.'));
  if (votosBlancos < 0) return const Left(ValidationFailure('Los votos blancos no pueden ser negativos.'));
  if (votosNulos < 0) return const Left(ValidationFailure('Los votos nulos no pueden ser negativos.'));

  for (final voto in votosOrganizaciones) {
    if (voto < 0) {
      return const Left(ValidationFailure('Los votos de una organización no pueden ser negativos.'));
    }
    if (voto > totalSufragantes) {
      return Left(ActaInconsistenteFailure(diferencia: voto - totalSufragantes));
    }
  }

  final sumaVotos = votosOrganizaciones.fold(0, (a, b) => a + b);
  final totalRegistrado = sumaVotos + votosBlancos + votosNulos;
  final diferencia = totalRegistrado - totalSufragantes; // positivo = de más, negativo = faltan

  if (diferencia != 0) {
    return Left(ActaInconsistenteFailure(diferencia: diferencia));
  }

  return const Right(unit);
}

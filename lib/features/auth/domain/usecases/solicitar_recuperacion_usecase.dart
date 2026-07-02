import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

import '../../../../core/constants/app_urls.dart';
import '../../../../core/validators/cedula_validator.dart';

/// solicitar_recuperacion_usecase.dart
/// 
/// Responsabilidad Única: Orquestar el inicio del flujo de recuperación de contraseña 
/// enviando un enlace al correo electrónico del usuario, o buscándolo por su cédula.
/// Cambios en esta clase ocurren si cambian los parámetros necesarios para solicitar una recuperación.

class SolicitarRecuperacionUseCase {
  final AuthRepository _repository;

  SolicitarRecuperacionUseCase({required AuthRepository repository}) : _repository = repository;

  /// Solicita el envío del correo de recuperación usando cédula o correo.
  Future<Either<Failure, Unit>> call(String identificador) async {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    final esCorreo = emailRegex.hasMatch(identificador);
    final esCedula = identificador.length == 10 && esCedulaValida(identificador);

    if (!esCorreo && !esCedula) {
      return const Left(ValidationFailure('Ingrese un correo electrónico válido o una cédula de 10 dígitos.'));
    }

    return await _repository.solicitarRecuperacion(identificador, AppUrls.passwordRecoveryUrl);
  }
}

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

/// solicitar_recuperacion_usecase.dart
/// 
/// Responsabilidad Única: Orquestar el inicio del flujo de recuperación de contraseña 
/// enviando un enlace al correo electrónico del usuario.
/// Cambios en esta clase ocurren si cambian los parámetros necesarios para solicitar una recuperación.

class SolicitarRecuperacionUseCase {
  final AuthRepository _repository;

  SolicitarRecuperacionUseCase({required AuthRepository repository}) : _repository = repository;

  /// Solicita el envío del correo de recuperación.
  Future<Either<Failure, Unit>> call(String email, String redirectUrl) async {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      return const Left(ValidationFailure('El formato de correo electrónico no es válido.'));
    }

    if (redirectUrl.isEmpty) {
      return const Left(ValidationFailure('La URL de redirección no puede estar vacía.'));
    }

    return await _repository.solicitarRecuperacion(email, redirectUrl);
  }
}

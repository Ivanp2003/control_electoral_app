import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

/// confirmar_recuperacion_usecase.dart
/// 
/// Responsabilidad Única: Confirmar y aplicar la nueva contraseña usando los parámetros
/// de recuperación recibidos (userId y token secreto).
/// Cambios en esta clase ocurren si cambian las validaciones para restablecer contraseñas.

class ConfirmarRecuperacionUseCase {
  final AuthRepository _repository;

  ConfirmarRecuperacionUseCase({required AuthRepository repository}) : _repository = repository;

  /// Ejecuta la confirmación de recuperación.
  Future<Either<Failure, Unit>> call({
    required String userId,
    required String secret,
    required String newPassword,
  }) async {
    if (userId.isEmpty || secret.isEmpty) {
      return const Left(ValidationFailure('Identificador de usuario o token secreto faltantes.'));
    }

    if (newPassword.length < 8) {
      return const Left(ValidationFailure(
        'La nueva contraseña debe tener al menos 8 caracteres.',
      ));
    }

    return await _repository.confirmarRecuperacion(userId, secret, newPassword);
  }
}

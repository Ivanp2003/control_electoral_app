import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

/// cambiar_password_usecase.dart
/// 
/// Responsabilidad Única: Orquestar el cambio de contraseña de usuario obligatoria o voluntaria,
/// validando que la nueva clave cumpla con requisitos mínimos de seguridad.
/// Cambios en esta clase ocurren si cambian las reglas de validación de contraseñas.

class CambiarPasswordUseCase {
  final AuthRepository _repository;

  CambiarPasswordUseCase({required AuthRepository repository}) : _repository = repository;

  /// Ejecuta el cambio de contraseña.
  /// Retorna [ValidationFailure] si la nueva contraseña no cumple con los criterios mínimos.
  Future<Either<Failure, Unit>> call(String currentPassword, String newPassword) async {
    // Validar longitud mínima de la nueva contraseña (por ejemplo, mínimo 6 caracteres en Appwrite, preferimos 8 para seguridad)
    if (newPassword.length < 8) {
      return const Left(ValidationFailure(
        'La nueva contraseña debe tener al menos 8 caracteres.',
      ));
    }

    if (currentPassword == newPassword) {
      return const Left(ValidationFailure(
        'La nueva contraseña no puede ser idéntica a la contraseña actual.',
      ));
    }

    return await _repository.cambiarPassword(currentPassword, newPassword);
  }
}

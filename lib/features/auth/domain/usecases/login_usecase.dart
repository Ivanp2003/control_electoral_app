import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/validators/cedula_validator.dart';
import '../entities/usuario.dart';
import '../repositories/auth_repository.dart';

/// login_usecase.dart
/// 
/// Responsabilidad Única: Orquestar el inicio de sesión validando primero la estructura 
/// formal de la cédula del usuario y, si es correcta, delegando al repositorio.
/// Cambios en esta clase ocurren si cambian los requisitos previos para iniciar sesión.

class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase({required AuthRepository repository}) : _repository = repository;

  /// Ejecuta el caso de uso de Login.
  /// Valida la cédula primero. Retorna [InvalidCedulaFailure] si es incorrecta.
  Future<Either<Failure, Usuario>> call(String cedula, String password) async {
    // 1. Validar formato oficial de cédula antes de llamar al servidor
    if (!esCedulaValida(cedula)) {
      return const Left(InvalidCedulaFailure());
    }

    // 2. Ejecutar inicio de sesión
    return await _repository.loginConCedula(cedula, password);
  }
}

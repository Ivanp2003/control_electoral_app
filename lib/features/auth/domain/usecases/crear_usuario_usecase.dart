import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/validators/cedula_validator.dart';
import '../repositories/auth_repository.dart';

/// crear_usuario_usecase.dart
/// 
/// Responsabilidad Única: Orquestar el registro de un nuevo usuario en el sistema,
/// validando formalmente todos los datos de perfil (cédula, correo, nombres) antes de crearlo.
/// Cambios en esta clase ocurren si cambian los campos requeridos para crear perfiles o sus reglas.

class CrearUsuarioUseCase {
  final AuthRepository _repository;

  CrearUsuarioUseCase({required AuthRepository repository}) : _repository = repository;

  /// Ejecuta el caso de uso de registro de usuario.
  Future<Either<Failure, Unit>> call({
    required String cedula,
    required String nombres,
    required String apellidos,
    required String telefono,
    required String correo,
    required String rol,
    String? recintoId,
  }) async {
    // 1. Validar cédula ecuatoriana
    if (!esCedulaValida(cedula)) {
      return const Left(InvalidCedulaFailure());
    }

    // 2. Validar correo electrónico
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(correo)) {
      return const Left(ValidationFailure('El formato de correo electrónico no es válido.'));
    }

    // 3. Validar textos no vacíos
    if (nombres.trim().isEmpty || apellidos.trim().isEmpty) {
      return const Left(ValidationFailure('Los nombres y apellidos son obligatorios.'));
    }

    if (telefono.trim().isEmpty) {
      return const Left(ValidationFailure('El número de teléfono es obligatorio.'));
    }

    // 4. Delegar la persistencia y detección de duplicados al repositorio
    return await _repository.crearUsuario(
      cedula: cedula,
      nombres: nombres,
      apellidos: apellidos,
      telefono: telefono,
      correo: correo,
      rol: rol,
      recintoId: recintoId,
    );
  }
}

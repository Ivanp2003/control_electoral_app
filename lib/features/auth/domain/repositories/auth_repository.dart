import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/usuario.dart';

/// auth_repository.dart
/// 
/// Responsabilidad Única: Definir el contrato abstracto de operaciones de autenticación 
/// y gestión de usuarios para desacoplar el dominio de la capa de infraestructura.
/// Cambios en esta clase ocurren si se requiere añadir o modificar firmas de autenticación del dominio.

abstract class AuthRepository {
  /// Inicia sesión utilizando la cédula del usuario y su contraseña.
  Future<Either<Failure, Usuario>> loginConCedula(String cedula, String password);

  /// Obtiene los detalles de perfil del usuario logueado en la sesión actual.
  Future<Either<Failure, Usuario>> obtenerUsuarioActual();

  /// Modifica la contraseña actual del usuario y registra que ha cambiado su clave por primera vez.
  Future<Either<Failure, Unit>> cambiarPassword(String currentPassword, String newPassword);

  /// Solicita un correo electrónico con un enlace para restablecer la contraseña.
  Future<Either<Failure, Unit>> solicitarRecuperacion(String email, String redirectUrl);

  /// Confirma el restablecimiento de contraseña utilizando los tokens enviados por correo.
  Future<Either<Failure, Unit>> confirmarRecuperacion(
    String userId,
    String secret,
    String newPassword,
  );

  /// Registra una nueva cuenta de usuario en el sistema.
  Future<Either<Failure, Unit>> crearUsuario({
    required String cedula,
    required String nombres,
    required String apellidos,
    required String telefono,
    required String correo,
    required String rol,
    String? recintoId,
  });
}

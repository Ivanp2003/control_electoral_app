import 'package:equatable/equatable.dart';

/// failures.dart
/// 
/// Responsabilidad Única: Definir la jerarquía base de errores (Failures) de la aplicación 
/// para el manejo funcional de errores mediante la mónada Either.
/// Cambios en esta clase ocurren si se añaden nuevos tipos globales de fallos en el sistema.

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

/// Fallo del servidor remoto (ej. error de Appwrite API).
class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Error en el servidor de base de datos remoto.']);
}

/// Fallo en la base de datos o almacenamiento local (ej. error de Drift/SQLite).
class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Error al acceder al almacenamiento local.']);
}

/// Fallo de validación de datos (ej. formato de cédula incorrecto, inconsistencia en sumatorias).
class ValidationFailure extends Failure {
  const ValidationFailure([super.message = 'Validación de datos fallida.']);
}

/// Fallo de permisos (ej. rol intentando ejecutar una operación no permitida).
class PermissionFailure extends Failure {
  const PermissionFailure([super.message = 'Permiso denegado para esta operación.']);
}

/// Fallo de GPS (ej. falta de permisos GPS o GPS deshabilitado).
class GpsGateFailure extends Failure {
  const GpsGateFailure([super.message = 'Error de GPS: Ubicación requerida no disponible.']);
}

/// Fallo de Cámara (ej. falta de permisos de cámara o error de inicialización).
class CameraGateFailure extends Failure {
  const CameraGateFailure([super.message = 'Error de Cámara: Acceso a hardware denegado o fallido.']);
}

/// Fallo por falta de conexión a Internet en operaciones críticas online.
class NoConnectionFailure extends Failure {
  const NoConnectionFailure([super.message = 'Sin conexión a Internet.']);
}

/// Fallo por formato de cédula ecuatoriana inválido.
class InvalidCedulaFailure extends Failure {
  const InvalidCedulaFailure([super.message = 'La cédula ingresada no es válida en Ecuador.']);
}

/// Fallo por credenciales incorrectas o usuario no encontrado.
class AuthCredentialsFailure extends Failure {
  const AuthCredentialsFailure([super.message = 'Cédula o contraseña incorrectas.']);
}

/// Fallo por intento de registrar un usuario con cédula o correo ya existente.
class DuplicateUserFailure extends Failure {
  /// Campo duplicado que causó el error ('cedula' o 'correo').
  final String duplicateField;

  const DuplicateUserFailure({
    required this.duplicateField,
    String message = 'El usuario ya se encuentra registrado.',
  }) : super(message);

  @override
  List<Object?> get props => [message, duplicateField];
}

/// Fallo durante la ejecución del Seeder de datos iniciales.
/// Se retorna cuando una inserción de datos geográficos o de organizaciones falla
/// de forma no recuperable (distinto de un reintento idempotente).
class SeederFailure extends Failure {
  const SeederFailure([super.message = 'Error durante la carga de datos iniciales.']);
}

/// Fallo de validación matemática del acta: la suma de votos no coincide con el total de sufragantes.
class ActaInconsistenteFailure extends Failure {
  /// Diferencia: positivo = sobran votos, negativo = faltan votos.
  final int diferencia;

  ActaInconsistenteFailure({required this.diferencia})
      : super(_mensaje(diferencia));

  static String _mensaje(int diff) {
    if (diff > 0) return 'Hay $diff votos de más';
    if (diff < 0) return 'Faltan ${diff.abs()} votos por justificar';
    return 'El acta es consistente';
  }

  @override
  List<Object?> get props => [message, diferencia];
}

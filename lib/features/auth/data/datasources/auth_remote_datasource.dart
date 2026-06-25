import 'dart:convert';
import 'package:appwrite/appwrite.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/constants/appwrite_config.dart';
import '../../../../core/network/appwrite_client.dart';
import '../models/usuario_model.dart';

part 'auth_remote_datasource.g.dart';

/// auth_remote_datasource.dart
/// 
/// Responsabilidad Única: Servir como puente directo con los SDKs de Appwrite (Account, Databases, Functions)
/// para ejecutar operaciones remotas de sesión, consulta de credenciales y cambios de contraseña.
/// Cambios en esta clase ocurren si se altera la API de Appwrite o se añaden nuevos métodos remotos de autenticación.

abstract class AuthRemoteDatasource {
  /// Invoca una función de servidor para buscar el correo asociado a una cédula.
  Future<String> buscarCorreoPorCedula(String cedula);

  /// Crea una sesión (Login) con email y contraseña.
  Future<void> crearSesionConEmail(String email, String password);

  /// Obtiene la información del perfil completo del usuario actual autenticado.
  Future<UsuarioModel> obtenerUsuarioActual();

  /// Cambia la contraseña del usuario y actualiza la bandera en la base de datos.
  Future<void> cambiarPassword(String currentPassword, String newPassword);

  /// Solicita el envío de un correo de recuperación.
  Future<void> solicitarRecuperacion(String email, String redirectUrl);

  /// Confirma el restablecimiento de contraseña usando el token y la nueva clave.
  Future<void> confirmarRecuperacion(String userId, String secret, String newPassword);

  /// Invoca una función de servidor para crear una cuenta de usuario y su documento de perfil.
  Future<void> crearUsuario({
    required String cedula,
    required String nombres,
    required String apellidos,
    required String telefono,
    required String correo,
    required String rol,
  });
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final Account _account;
  final Databases _databases;
  final Functions _functions;

  AuthRemoteDatasourceImpl({
    required Account account,
    required Databases databases,
    required Functions functions,
  })  : _account = account,
        _databases = databases,
        _functions = functions;

  @override
  Future<String> buscarCorreoPorCedula(String cedula) async {
    // TODO(hardening): Para mitigar completamente ataques de enumeración donde un atacante
    // valide correos asociados a cédulas, en una iteración futura se puede cambiar este flujo 
    // para que la función reciba 'cedula' y 'password', realice el login en el servidor y retorne 
    // directamente un token de sesión/JWT al cliente, evitando exponer el correo electrónico.
    final execution = await _functions.createExecution(
      functionId: 'buscar_correo_por_cedula',
      body: jsonEncode({'cedula': cedula}),
    );

    if (execution.status == 'failed') {
      throw Exception('Error al ejecutar la función de búsqueda de correo.');
    }

    final responseMap = jsonDecode(execution.responseBody) as Map<String, dynamic>;
    if (responseMap.containsKey('error') || !responseMap.containsKey('correo')) {
      throw UsuarioNoEncontradoException();
    }

    return responseMap['correo'] as String;
  }

  @override
  Future<void> crearSesionConEmail(String email, String password) async {
    await _account.createEmailPasswordSession(
      email: email,
      password: password,
    );
  }

  @override
  Future<UsuarioModel> obtenerUsuarioActual() async {
    final authUser = await _account.get();
    final doc = await _databases.getDocument(
      databaseId: AppwriteConfig.databaseId,
      collectionId: AppwriteConfig.collectionUsuarios,
      documentId: authUser.$id,
    );
    return UsuarioModel.fromJson(doc.data);
  }

  @override
  Future<void> cambiarPassword(String currentPassword, String newPassword) async {
    final authUser = await _account.get();
    await _account.updatePassword(
      password: newPassword,
      oldPassword: currentPassword,
    );
    await _databases.updateDocument(
      databaseId: AppwriteConfig.databaseId,
      collectionId: AppwriteConfig.collectionUsuarios,
      documentId: authUser.$id,
      data: {'passwordChanged': true},
    );
  }

  @override
  Future<void> solicitarRecuperacion(String email, String redirectUrl) async {
    await _account.createRecovery(
      email: email,
      url: redirectUrl,
    );
  }

  @override
  Future<void> confirmarRecuperacion(
      String userId, String secret, String newPassword) async {
    await _account.updateRecovery(
      userId: userId,
      secret: secret,
      password: newPassword,
    );
  }

  @override
  Future<void> crearUsuario({
    required String cedula,
    required String nombres,
    required String apellidos,
    required String telefono,
    required String correo,
    required String rol,
  }) async {
    final execution = await _functions.createExecution(
      functionId: 'crear_usuario',
      body: jsonEncode({
        'cedula': cedula,
        'nombres': nombres,
        'apellidos': apellidos,
        'telefono': telefono,
        'correo': correo,
        'rol': rol,
        'password': AppwriteConfig.passwordInicial,
      }),
    );

    if (execution.status == 'failed') {
      throw Exception('Error de ejecución en servidor al crear usuario.');
    }

    final responseMap = jsonDecode(execution.responseBody) as Map<String, dynamic>;
    if (responseMap.containsKey('error')) {
      final errorMsg = responseMap['error'] as String;
      if (errorMsg.contains('cedula_duplicada')) {
        throw CedulaDuplicadaException();
      } else if (errorMsg.contains('correo_duplicado')) {
        throw CorreoDuplicadoException();
      }
      throw Exception(errorMsg);
    }
  }
}

/// Excepción lanzada cuando una cédula está duplicada en el sistema.
class CedulaDuplicadaException implements Exception {
  final String message;
  const CedulaDuplicadaException([this.message = 'Cédula duplicada']);
  @override
  String toString() => 'CedulaDuplicadaException: $message';
}

/// Excepción lanzada cuando un correo electrónico está duplicado en el sistema.
class CorreoDuplicadoException implements Exception {
  final String message;
  const CorreoDuplicadoException([this.message = 'Correo duplicado']);
  @override
  String toString() => 'CorreoDuplicadoException: $message';
}

/// Excepción lanzada cuando un usuario no es encontrado por su cédula.
class UsuarioNoEncontradoException implements Exception {
  final String message;
  const UsuarioNoEncontradoException([this.message = 'Usuario no encontrado']);
  @override
  String toString() => 'UsuarioNoEncontradoException: $message';
}

@Riverpod(keepAlive: true)
AuthRemoteDatasource authRemoteDatasource(AuthRemoteDatasourceRef ref) {
  final client = ref.watch(appwriteClientProvider);
  return AuthRemoteDatasourceImpl(
    account: ref.watch(appwriteAccountProvider),
    databases: ref.watch(appwriteDatabasesProvider),
    functions: Functions(client),
  );
}

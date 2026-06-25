import 'package:appwrite/appwrite.dart';
import 'package:dartz/dartz.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/connectivity_service.dart';
import '../../domain/entities/usuario.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

part 'auth_repository_impl.g.dart';

/// auth_repository_impl.dart
/// 
/// Responsabilidad Única: Implementar el repositorio de autenticación, validando el estado
/// de la conexión de red (offline-first para evitar llamadas remotas inútiles) y mapeando las
/// excepciones de Appwrite a fallos tipados de dominio (Failures).
/// Cambios en esta clase ocurren si cambian las políticas de manejo de excepciones o la lógica de negocio asociada.

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _remoteDatasource;
  final ConnectivityService _connectivityService;

  AuthRepositoryImpl({
    required AuthRemoteDatasource remoteDatasource,
    required ConnectivityService connectivityService,
  })  : _remoteDatasource = remoteDatasource,
        _connectivityService = connectivityService;

  /// Helper privado para validar conectividad.
  Future<bool> _checkConnection() async {
    return await _connectivityService.isConnected;
  }

  @override
  Future<Either<Failure, Usuario>> loginConCedula(String cedula, String password) async {
    if (!await _checkConnection()) {
      return const Left(NoConnectionFailure());
    }

    try {
      // 1. Obtener el correo electrónico asociado a la cédula mediante función en la nube.
      final email = await _remoteDatasource.buscarCorreoPorCedula(cedula);

      // 2. Autenticar usando las credenciales de email y contraseña.
      await _remoteDatasource.crearSesionConEmail(email, password);

      // 3. Recuperar el perfil completo de la colección de usuarios.
      final userModel = await _remoteDatasource.obtenerUsuarioActual();
      return Right(userModel.toDomain());
    } on UsuarioNoEncontradoException {
      return const Left(AuthCredentialsFailure());
    } on AppwriteException catch (e) {
      // Mapear errores de credenciales inválidas (400, 401, etc.)
      if (e.code == 401 || e.code == 400) {
        return const Left(AuthCredentialsFailure());
      }
      return Left(ServerFailure(e.message ?? 'Error de autenticación en Appwrite.'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Usuario>> obtenerUsuarioActual() async {
    if (!await _checkConnection()) {
      return const Left(NoConnectionFailure());
    }

    try {
      final userModel = await _remoteDatasource.obtenerUsuarioActual();
      return Right(userModel.toDomain());
    } on AppwriteException catch (e) {
      return Left(ServerFailure(e.message ?? 'Error al obtener sesión de usuario.'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> cambiarPassword(String currentPassword, String newPassword) async {
    if (!await _checkConnection()) {
      return const Left(NoConnectionFailure());
    }

    try {
      await _remoteDatasource.cambiarPassword(currentPassword, newPassword);
      return const Right(unit);
    } on AppwriteException catch (e) {
      return Left(ServerFailure(e.message ?? 'Error al actualizar contraseña.'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> solicitarRecuperacion(String email, String redirectUrl) async {
    if (!await _checkConnection()) {
      return const Left(NoConnectionFailure());
    }

    try {
      await _remoteDatasource.solicitarRecuperacion(email, redirectUrl);
      return const Right(unit);
    } on AppwriteException catch (e) {
      return Left(ServerFailure(e.message ?? 'Error al solicitar link de recuperación.'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> confirmarRecuperacion(
      String userId, String secret, String newPassword) async {
    if (!await _checkConnection()) {
      return const Left(NoConnectionFailure());
    }

    try {
      await _remoteDatasource.confirmarRecuperacion(userId, secret, newPassword);
      return const Right(unit);
    } on AppwriteException catch (e) {
      return Left(ServerFailure(e.message ?? 'Error al confirmar restablecimiento de contraseña.'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> crearUsuario({
    required String cedula,
    required String nombres,
    required String apellidos,
    required String telefono,
    required String correo,
    required String rol,
  }) async {
    if (!await _checkConnection()) {
      return const Left(NoConnectionFailure());
    }

    try {
      await _remoteDatasource.crearUsuario(
        cedula: cedula,
        nombres: nombres,
        apellidos: apellidos,
        telefono: telefono,
        correo: correo,
        rol: rol,
      );
      return const Right(unit);
    } on CedulaDuplicadaException {
      return const Left(DuplicateUserFailure(
        duplicateField: 'cedula',
        message: 'La cédula ingresada ya se encuentra asignada a otro usuario.',
      ));
    } on CorreoDuplicadoException {
      return const Left(DuplicateUserFailure(
        duplicateField: 'correo',
        message: 'El correo electrónico ingresado ya se encuentra asignado a otro usuario.',
      ));
    } on AppwriteException catch (e) {
      return Left(ServerFailure(e.message ?? 'Error al crear usuario en Appwrite.'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) {
  return AuthRepositoryImpl(
    remoteDatasource: ref.watch(authRemoteDatasourceProvider),
    connectivityService: ref.watch(connectivityServiceProvider),
  );
}

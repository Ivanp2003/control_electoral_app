import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/usuario.dart';

part 'auth_state.freezed.dart';

/// auth_state.dart
/// 
/// Responsabilidad Única: Definir los estados posibles del flujo de autenticación 
/// utilizando clases unión de Freezed.
/// Cambios en esta clase ocurren si se requiere añadir un nuevo estado de autenticación a la UI.

@freezed
class AuthState with _$AuthState {
  /// Estado inicial sin iniciar sesión ni procesar nada.
  const factory AuthState.initial() = _Initial;

  /// Estado de carga activo (ej. durante login, envío de correo, cambio de contraseña).
  const factory AuthState.loading() = _Loading;

  /// Estado autenticado exitosamente con el perfil completo cargado.
  const factory AuthState.authenticated(Usuario usuario) = _Authenticated;

  /// Estado de autenticación parcial donde es obligatorio cambiar la contraseña de inicio.
  const factory AuthState.passwordChangeRequired(Usuario usuario) = _PasswordChangeRequired;

  /// Estado de error que almacena el mensaje descriptivo a mostrar al usuario.
  const factory AuthState.error(String message) = _Error;
}

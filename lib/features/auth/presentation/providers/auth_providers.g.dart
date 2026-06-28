// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentUserHash() => r'2afb36b81cd59c65e9dd3cc07d556bccd846e551';

/// Expone el usuario autenticado actual (si existe).
///
/// Copied from [currentUser].
@ProviderFor(currentUser)
final currentUserProvider = Provider<Usuario?>.internal(
  currentUser,
  name: r'currentUserProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentUserHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentUserRef = ProviderRef<Usuario?>;
String _$goRouterHash() => r'ed93b9f19aa77e21265cecf39d29a2fd34f92075';

/// Proveedor centralizado de GoRouter para manejar las pantallas y guards de redirección.
///
/// Copied from [goRouter].
@ProviderFor(goRouter)
final goRouterProvider = Provider<GoRouter>.internal(
  goRouter,
  name: r'goRouterProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$goRouterHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GoRouterRef = ProviderRef<GoRouter>;
String _$loginUseCaseHash() => r'f162181f15c4699eba6afadc9c9b9fd00fe8e68f';

/// See also [loginUseCase].
@ProviderFor(loginUseCase)
final loginUseCaseProvider = Provider<LoginUseCase>.internal(
  loginUseCase,
  name: r'loginUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$loginUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LoginUseCaseRef = ProviderRef<LoginUseCase>;
String _$cambiarPasswordUseCaseHash() =>
    r'fd2e0387c1afc2987cd71d4197a26dda4481ef31';

/// See also [cambiarPasswordUseCase].
@ProviderFor(cambiarPasswordUseCase)
final cambiarPasswordUseCaseProvider =
    Provider<CambiarPasswordUseCase>.internal(
      cambiarPasswordUseCase,
      name: r'cambiarPasswordUseCaseProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$cambiarPasswordUseCaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CambiarPasswordUseCaseRef = ProviderRef<CambiarPasswordUseCase>;
String _$solicitarRecuperacionUseCaseHash() =>
    r'0f52dc3531f09436c6b4692fa5e2560141d5ea26';

/// See also [solicitarRecuperacionUseCase].
@ProviderFor(solicitarRecuperacionUseCase)
final solicitarRecuperacionUseCaseProvider =
    Provider<SolicitarRecuperacionUseCase>.internal(
      solicitarRecuperacionUseCase,
      name: r'solicitarRecuperacionUseCaseProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$solicitarRecuperacionUseCaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SolicitarRecuperacionUseCaseRef =
    ProviderRef<SolicitarRecuperacionUseCase>;
String _$confirmarRecuperacionUseCaseHash() =>
    r'04d82401fc2b1c1d6de8bcc91b049adea0417c33';

/// See also [confirmarRecuperacionUseCase].
@ProviderFor(confirmarRecuperacionUseCase)
final confirmarRecuperacionUseCaseProvider =
    Provider<ConfirmarRecuperacionUseCase>.internal(
      confirmarRecuperacionUseCase,
      name: r'confirmarRecuperacionUseCaseProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$confirmarRecuperacionUseCaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ConfirmarRecuperacionUseCaseRef =
    ProviderRef<ConfirmarRecuperacionUseCase>;
String _$crearUsuarioUseCaseHash() =>
    r'cb81a587f2942b566f46625e825d676c308f3e2c';

/// See also [crearUsuarioUseCase].
@ProviderFor(crearUsuarioUseCase)
final crearUsuarioUseCaseProvider = Provider<CrearUsuarioUseCase>.internal(
  crearUsuarioUseCase,
  name: r'crearUsuarioUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$crearUsuarioUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CrearUsuarioUseCaseRef = ProviderRef<CrearUsuarioUseCase>;
String _$authNotifierHash() => r'daa50dd7335f5b67f804e490beb37d0824be03bf';

/// auth_providers.dart
///
/// Responsabilidad Única: Exponer los proveedores globales de Riverpod para el estado de
/// sesión del usuario, los casos de uso, el enrutamiento (GoRouter) y la lógica de redirección.
/// Cambios en esta clase ocurren si cambian los flujos de navegación globales o los requerimientos de estado.
///
/// Copied from [AuthNotifier].
@ProviderFor(AuthNotifier)
final authNotifierProvider = NotifierProvider<AuthNotifier, AuthState>.internal(
  AuthNotifier.new,
  name: r'authNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AuthNotifier = Notifier<AuthState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

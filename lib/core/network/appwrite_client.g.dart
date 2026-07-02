// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appwrite_client.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appwriteServicesHash() => r'27eb14ee94da146a5b393f51f37a5710f3d0b330';

/// Proveedor del wrapper de servicios de Appwrite.
/// Al usar (keepAlive: true), se comporta como un singleton persistente dentro de la app.
///
/// Copied from [appwriteServices].
@ProviderFor(appwriteServices)
final appwriteServicesProvider = Provider<AppwriteServices>.internal(
  appwriteServices,
  name: r'appwriteServicesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$appwriteServicesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AppwriteServicesRef = ProviderRef<AppwriteServices>;
String _$appwriteClientHash() => r'bcbb385cf76b5e260944ff5dd0b02c92c86b9a1a';

/// Proveedor para exponer la instancia del cliente individual.
///
/// Copied from [appwriteClient].
@ProviderFor(appwriteClient)
final appwriteClientProvider = Provider<Client>.internal(
  appwriteClient,
  name: r'appwriteClientProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$appwriteClientHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AppwriteClientRef = ProviderRef<Client>;
String _$appwriteAccountHash() => r'8516c7b2c3c3f5ac1f290981e1254bbcace4c71c';

/// Proveedor para exponer la instancia del servicio de cuentas (Auth).
///
/// Copied from [appwriteAccount].
@ProviderFor(appwriteAccount)
final appwriteAccountProvider = Provider<Account>.internal(
  appwriteAccount,
  name: r'appwriteAccountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$appwriteAccountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AppwriteAccountRef = ProviderRef<Account>;
String _$appwriteDatabasesHash() => r'38c746eecde973aae98c026f50b6a0d2ca04b553';

/// Proveedor para exponer la instancia del servicio de base de datos.
///
/// Copied from [appwriteDatabases].
@ProviderFor(appwriteDatabases)
final appwriteDatabasesProvider = Provider<Databases>.internal(
  appwriteDatabases,
  name: r'appwriteDatabasesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$appwriteDatabasesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AppwriteDatabasesRef = ProviderRef<Databases>;
String _$appwriteStorageHash() => r'423b480eeb2194695a66320ca8312c3535d6ede1';

/// Proveedor para exponer la instancia del servicio de almacenamiento de archivos (Storage).
///
/// Copied from [appwriteStorage].
@ProviderFor(appwriteStorage)
final appwriteStorageProvider = Provider<Storage>.internal(
  appwriteStorage,
  name: r'appwriteStorageProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$appwriteStorageHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AppwriteStorageRef = ProviderRef<Storage>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

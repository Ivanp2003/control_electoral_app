// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$syncRemoteExecutorHash() =>
    r'542829e08c4e924254925cc435aa3cf8c2d40b73';

/// See also [syncRemoteExecutor].
@ProviderFor(syncRemoteExecutor)
final syncRemoteExecutorProvider = Provider<SyncRemoteExecutor>.internal(
  syncRemoteExecutor,
  name: r'syncRemoteExecutorProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$syncRemoteExecutorHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SyncRemoteExecutorRef = ProviderRef<SyncRemoteExecutor>;
String _$procesarColaSyncUseCaseHash() =>
    r'e4c8daa1ce2480271dae756f9de885adbdde25f6';

/// See also [procesarColaSyncUseCase].
@ProviderFor(procesarColaSyncUseCase)
final procesarColaSyncUseCaseProvider =
    Provider<ProcesarColaSyncUseCase>.internal(
      procesarColaSyncUseCase,
      name: r'procesarColaSyncUseCaseProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$procesarColaSyncUseCaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ProcesarColaSyncUseCaseRef = ProviderRef<ProcesarColaSyncUseCase>;
String _$reintentarTareaFallidaUseCaseHash() =>
    r'f7022c0fc851710da3784567ad6b5bd8e7f7ce0a';

/// See also [reintentarTareaFallidaUseCase].
@ProviderFor(reintentarTareaFallidaUseCase)
final reintentarTareaFallidaUseCaseProvider =
    Provider<ReintentarTareaFallidaUseCase>.internal(
      reintentarTareaFallidaUseCase,
      name: r'reintentarTareaFallidaUseCaseProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$reintentarTareaFallidaUseCaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ReintentarTareaFallidaUseCaseRef =
    ProviderRef<ReintentarTareaFallidaUseCase>;
String _$pendingSyncTasksCountHash() =>
    r'00df1fc3b85df77c26a63cf747f63350225e2f18';

/// Escucha los cambios en SyncQueue para contar tareas pendientes.
///
/// Copied from [pendingSyncTasksCount].
@ProviderFor(pendingSyncTasksCount)
final pendingSyncTasksCountProvider = AutoDisposeStreamProvider<int>.internal(
  pendingSyncTasksCount,
  name: r'pendingSyncTasksCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$pendingSyncTasksCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PendingSyncTasksCountRef = AutoDisposeStreamProviderRef<int>;
String _$failedSyncTasksCountHash() =>
    r'0a4fabac44a8c9777861be652303f0cdd7d8b635';

/// Escucha los cambios en SyncQueue para contar tareas fallidas.
///
/// Copied from [failedSyncTasksCount].
@ProviderFor(failedSyncTasksCount)
final failedSyncTasksCountProvider = AutoDisposeStreamProvider<int>.internal(
  failedSyncTasksCount,
  name: r'failedSyncTasksCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$failedSyncTasksCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FailedSyncTasksCountRef = AutoDisposeStreamProviderRef<int>;
String _$failedSyncTasksListHash() =>
    r'de0c7229963069927a8c70522aa068c5e91f3d9a';

/// Expone la lista de tareas fallidas para debugging y reintentos.
///
/// Copied from [failedSyncTasksList].
@ProviderFor(failedSyncTasksList)
final failedSyncTasksListProvider =
    AutoDisposeStreamProvider<List<SyncQueueData>>.internal(
      failedSyncTasksList,
      name: r'failedSyncTasksListProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$failedSyncTasksListHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FailedSyncTasksListRef =
    AutoDisposeStreamProviderRef<List<SyncQueueData>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

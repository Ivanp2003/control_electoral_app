// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_orchestrator.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$syncRemoteDatasourceHash() =>
    r'e377417e82bc56eb1496e61252dded433d7dd12e';

/// See also [syncRemoteDatasource].
@ProviderFor(syncRemoteDatasource)
final syncRemoteDatasourceProvider = Provider<ActasRemoteDatasource>.internal(
  syncRemoteDatasource,
  name: r'syncRemoteDatasourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$syncRemoteDatasourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SyncRemoteDatasourceRef = ProviderRef<ActasRemoteDatasource>;
String _$syncLocalDatasourceHash() =>
    r'431541207c15636efb2f6409ebc54fb1f53af439';

/// See also [syncLocalDatasource].
@ProviderFor(syncLocalDatasource)
final syncLocalDatasourceProvider = Provider<ActasLocalDatasource>.internal(
  syncLocalDatasource,
  name: r'syncLocalDatasourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$syncLocalDatasourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SyncLocalDatasourceRef = ProviderRef<ActasLocalDatasource>;
String _$syncProcessorHash() => r'd27db186a3fb8059e611d6578a99a8a2bab0719a';

/// See also [syncProcessor].
@ProviderFor(syncProcessor)
final syncProcessorProvider = Provider<SyncProcessor>.internal(
  syncProcessor,
  name: r'syncProcessorProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$syncProcessorHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SyncProcessorRef = ProviderRef<SyncProcessor>;
String _$syncOrchestratorHash() => r'516a15f3fd7a3ae1d2ecf5c70795c00f50b1a0f1';

/// See also [SyncOrchestrator].
@ProviderFor(SyncOrchestrator)
final syncOrchestratorProvider =
    NotifierProvider<SyncOrchestrator, SyncState>.internal(
      SyncOrchestrator.new,
      name: r'syncOrchestratorProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$syncOrchestratorHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SyncOrchestrator = Notifier<SyncState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_orchestrator_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$syncOrchestratorHash() => r'fd0861bfd87c119f07f8a1d9ee0a311b516250c9';

/// Un provider que orquesta la sincronización escuchando los cambios de conexión.
///
/// Copied from [SyncOrchestrator].
@ProviderFor(SyncOrchestrator)
final syncOrchestratorProvider =
    NotifierProvider<SyncOrchestrator, void>.internal(
      SyncOrchestrator.new,
      name: r'syncOrchestratorProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$syncOrchestratorHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SyncOrchestrator = Notifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'seeder_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$seederNotifierHash() => r'ee69e3d9c7465a113c23d901c4a53e30ab7ec16c';

/// Notifier principal del Seeder.
/// Estado: AsyncValue<SeederResultado?> — null = idle, loading, data, error.
///
/// Copied from [SeederNotifier].
@ProviderFor(SeederNotifier)
final seederNotifierProvider =
    AutoDisposeNotifierProvider<
      SeederNotifier,
      AsyncValue<SeederResultado?>
    >.internal(
      SeederNotifier.new,
      name: r'seederNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$seederNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SeederNotifier = AutoDisposeNotifier<AsyncValue<SeederResultado?>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

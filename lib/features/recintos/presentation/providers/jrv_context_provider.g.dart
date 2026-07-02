// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jrv_context_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$jrvContextHash() => r'99034bc9c9d16b495c9f75fa8c1598851a1bc256';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// jrv_context_provider.dart
///
/// Responsabilidad Única: Resolver el contexto de una JRV (Código + Recinto + Parroquia)
/// a partir de la base de datos local para fines puramente visuales (Presentación).
///
/// Copied from [jrvContext].
@ProviderFor(jrvContext)
const jrvContextProvider = JrvContextFamily();

/// jrv_context_provider.dart
///
/// Responsabilidad Única: Resolver el contexto de una JRV (Código + Recinto + Parroquia)
/// a partir de la base de datos local para fines puramente visuales (Presentación).
///
/// Copied from [jrvContext].
class JrvContextFamily extends Family<AsyncValue<String>> {
  /// jrv_context_provider.dart
  ///
  /// Responsabilidad Única: Resolver el contexto de una JRV (Código + Recinto + Parroquia)
  /// a partir de la base de datos local para fines puramente visuales (Presentación).
  ///
  /// Copied from [jrvContext].
  const JrvContextFamily();

  /// jrv_context_provider.dart
  ///
  /// Responsabilidad Única: Resolver el contexto de una JRV (Código + Recinto + Parroquia)
  /// a partir de la base de datos local para fines puramente visuales (Presentación).
  ///
  /// Copied from [jrvContext].
  JrvContextProvider call(String jrvId) {
    return JrvContextProvider(jrvId);
  }

  @override
  JrvContextProvider getProviderOverride(
    covariant JrvContextProvider provider,
  ) {
    return call(provider.jrvId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'jrvContextProvider';
}

/// jrv_context_provider.dart
///
/// Responsabilidad Única: Resolver el contexto de una JRV (Código + Recinto + Parroquia)
/// a partir de la base de datos local para fines puramente visuales (Presentación).
///
/// Copied from [jrvContext].
class JrvContextProvider extends AutoDisposeFutureProvider<String> {
  /// jrv_context_provider.dart
  ///
  /// Responsabilidad Única: Resolver el contexto de una JRV (Código + Recinto + Parroquia)
  /// a partir de la base de datos local para fines puramente visuales (Presentación).
  ///
  /// Copied from [jrvContext].
  JrvContextProvider(String jrvId)
    : this._internal(
        (ref) => jrvContext(ref as JrvContextRef, jrvId),
        from: jrvContextProvider,
        name: r'jrvContextProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$jrvContextHash,
        dependencies: JrvContextFamily._dependencies,
        allTransitiveDependencies: JrvContextFamily._allTransitiveDependencies,
        jrvId: jrvId,
      );

  JrvContextProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.jrvId,
  }) : super.internal();

  final String jrvId;

  @override
  Override overrideWith(
    FutureOr<String> Function(JrvContextRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: JrvContextProvider._internal(
        (ref) => create(ref as JrvContextRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        jrvId: jrvId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<String> createElement() {
    return _JrvContextProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is JrvContextProvider && other.jrvId == jrvId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, jrvId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin JrvContextRef on AutoDisposeFutureProviderRef<String> {
  /// The parameter `jrvId` of this provider.
  String get jrvId;
}

class _JrvContextProviderElement
    extends AutoDisposeFutureProviderElement<String>
    with JrvContextRef {
  _JrvContextProviderElement(super.provider);

  @override
  String get jrvId => (origin as JrvContextProvider).jrvId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

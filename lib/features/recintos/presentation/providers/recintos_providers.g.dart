// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recintos_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$obtenerProvinciasUseCaseHash() =>
    r'76553eff5ccf4cd77e3163334887b5802818172b';

/// See also [obtenerProvinciasUseCase].
@ProviderFor(obtenerProvinciasUseCase)
final obtenerProvinciasUseCaseProvider =
    Provider<ObtenerProvinciasUseCase>.internal(
      obtenerProvinciasUseCase,
      name: r'obtenerProvinciasUseCaseProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$obtenerProvinciasUseCaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ObtenerProvinciasUseCaseRef = ProviderRef<ObtenerProvinciasUseCase>;
String _$obtenerCantonesUseCaseHash() =>
    r'd55a5c739274aaf84e34b93533ab9379f300930b';

/// See also [obtenerCantonesUseCase].
@ProviderFor(obtenerCantonesUseCase)
final obtenerCantonesUseCaseProvider =
    Provider<ObtenerCantonesUseCase>.internal(
      obtenerCantonesUseCase,
      name: r'obtenerCantonesUseCaseProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$obtenerCantonesUseCaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ObtenerCantonesUseCaseRef = ProviderRef<ObtenerCantonesUseCase>;
String _$obtenerParroquiasUseCaseHash() =>
    r'9e2ece7e7bc771458f4ad22f9a1a20638f5c91ef';

/// See also [obtenerParroquiasUseCase].
@ProviderFor(obtenerParroquiasUseCase)
final obtenerParroquiasUseCaseProvider =
    Provider<ObtenerParroquiasUseCase>.internal(
      obtenerParroquiasUseCase,
      name: r'obtenerParroquiasUseCaseProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$obtenerParroquiasUseCaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ObtenerParroquiasUseCaseRef = ProviderRef<ObtenerParroquiasUseCase>;
String _$obtenerRecintosUseCaseHash() =>
    r'6b136771daf3f9b84d92ecde3814948038a5af53';

/// See also [obtenerRecintosUseCase].
@ProviderFor(obtenerRecintosUseCase)
final obtenerRecintosUseCaseProvider =
    Provider<ObtenerRecintosUseCase>.internal(
      obtenerRecintosUseCase,
      name: r'obtenerRecintosUseCaseProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$obtenerRecintosUseCaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ObtenerRecintosUseCaseRef = ProviderRef<ObtenerRecintosUseCase>;
String _$obtenerJrvPorRecintoUseCaseHash() =>
    r'c7385e1c0d70666ee908a7976e69011c9c3b9467';

/// See also [obtenerJrvPorRecintoUseCase].
@ProviderFor(obtenerJrvPorRecintoUseCase)
final obtenerJrvPorRecintoUseCaseProvider =
    Provider<ObtenerJrvPorRecintoUseCase>.internal(
      obtenerJrvPorRecintoUseCase,
      name: r'obtenerJrvPorRecintoUseCaseProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$obtenerJrvPorRecintoUseCaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ObtenerJrvPorRecintoUseCaseRef =
    ProviderRef<ObtenerJrvPorRecintoUseCase>;
String _$crearRecintoUseCaseHash() =>
    r'9d48a811436a77afed3aebf5d9ebb0d98ecac4f7';

/// See also [crearRecintoUseCase].
@ProviderFor(crearRecintoUseCase)
final crearRecintoUseCaseProvider = Provider<CrearRecintoUseCase>.internal(
  crearRecintoUseCase,
  name: r'crearRecintoUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$crearRecintoUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CrearRecintoUseCaseRef = ProviderRef<CrearRecintoUseCase>;
String _$provinciasHash() => r'c092d59527c3c52f0601fdbf0498f38f6659d197';

/// See also [provincias].
@ProviderFor(provincias)
final provinciasProvider = AutoDisposeFutureProvider<List<Provincia>>.internal(
  provincias,
  name: r'provinciasProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$provinciasHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ProvinciasRef = AutoDisposeFutureProviderRef<List<Provincia>>;
String _$cantonesHash() => r'94e82517eefda08f85b07ce9b5771bdfe46fef00';

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

/// See also [cantones].
@ProviderFor(cantones)
const cantonesProvider = CantonesFamily();

/// See also [cantones].
class CantonesFamily extends Family<AsyncValue<List<Canton>>> {
  /// See also [cantones].
  const CantonesFamily();

  /// See also [cantones].
  CantonesProvider call(String provinciaId) {
    return CantonesProvider(provinciaId);
  }

  @override
  CantonesProvider getProviderOverride(covariant CantonesProvider provider) {
    return call(provider.provinciaId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'cantonesProvider';
}

/// See also [cantones].
class CantonesProvider extends AutoDisposeFutureProvider<List<Canton>> {
  /// See also [cantones].
  CantonesProvider(String provinciaId)
    : this._internal(
        (ref) => cantones(ref as CantonesRef, provinciaId),
        from: cantonesProvider,
        name: r'cantonesProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$cantonesHash,
        dependencies: CantonesFamily._dependencies,
        allTransitiveDependencies: CantonesFamily._allTransitiveDependencies,
        provinciaId: provinciaId,
      );

  CantonesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.provinciaId,
  }) : super.internal();

  final String provinciaId;

  @override
  Override overrideWith(
    FutureOr<List<Canton>> Function(CantonesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CantonesProvider._internal(
        (ref) => create(ref as CantonesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        provinciaId: provinciaId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Canton>> createElement() {
    return _CantonesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CantonesProvider && other.provinciaId == provinciaId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, provinciaId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CantonesRef on AutoDisposeFutureProviderRef<List<Canton>> {
  /// The parameter `provinciaId` of this provider.
  String get provinciaId;
}

class _CantonesProviderElement
    extends AutoDisposeFutureProviderElement<List<Canton>>
    with CantonesRef {
  _CantonesProviderElement(super.provider);

  @override
  String get provinciaId => (origin as CantonesProvider).provinciaId;
}

String _$parroquiasHash() => r'6590b8e3a28553b84881c2d212cbd91cb7326538';

/// See also [parroquias].
@ProviderFor(parroquias)
const parroquiasProvider = ParroquiasFamily();

/// See also [parroquias].
class ParroquiasFamily extends Family<AsyncValue<List<Parroquia>>> {
  /// See also [parroquias].
  const ParroquiasFamily();

  /// See also [parroquias].
  ParroquiasProvider call(String cantonId) {
    return ParroquiasProvider(cantonId);
  }

  @override
  ParroquiasProvider getProviderOverride(
    covariant ParroquiasProvider provider,
  ) {
    return call(provider.cantonId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'parroquiasProvider';
}

/// See also [parroquias].
class ParroquiasProvider extends AutoDisposeFutureProvider<List<Parroquia>> {
  /// See also [parroquias].
  ParroquiasProvider(String cantonId)
    : this._internal(
        (ref) => parroquias(ref as ParroquiasRef, cantonId),
        from: parroquiasProvider,
        name: r'parroquiasProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$parroquiasHash,
        dependencies: ParroquiasFamily._dependencies,
        allTransitiveDependencies: ParroquiasFamily._allTransitiveDependencies,
        cantonId: cantonId,
      );

  ParroquiasProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.cantonId,
  }) : super.internal();

  final String cantonId;

  @override
  Override overrideWith(
    FutureOr<List<Parroquia>> Function(ParroquiasRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ParroquiasProvider._internal(
        (ref) => create(ref as ParroquiasRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        cantonId: cantonId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Parroquia>> createElement() {
    return _ParroquiasProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ParroquiasProvider && other.cantonId == cantonId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, cantonId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ParroquiasRef on AutoDisposeFutureProviderRef<List<Parroquia>> {
  /// The parameter `cantonId` of this provider.
  String get cantonId;
}

class _ParroquiasProviderElement
    extends AutoDisposeFutureProviderElement<List<Parroquia>>
    with ParroquiasRef {
  _ParroquiasProviderElement(super.provider);

  @override
  String get cantonId => (origin as ParroquiasProvider).cantonId;
}

String _$recintosHash() => r'59912b1c8e8967e98d9b22642322eff8db5bd728';

/// See also [recintos].
@ProviderFor(recintos)
const recintosProvider = RecintosFamily();

/// See also [recintos].
class RecintosFamily extends Family<AsyncValue<List<Recinto>>> {
  /// See also [recintos].
  const RecintosFamily();

  /// See also [recintos].
  RecintosProvider call(String parroquiaId) {
    return RecintosProvider(parroquiaId);
  }

  @override
  RecintosProvider getProviderOverride(covariant RecintosProvider provider) {
    return call(provider.parroquiaId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'recintosProvider';
}

/// See also [recintos].
class RecintosProvider extends AutoDisposeFutureProvider<List<Recinto>> {
  /// See also [recintos].
  RecintosProvider(String parroquiaId)
    : this._internal(
        (ref) => recintos(ref as RecintosRef, parroquiaId),
        from: recintosProvider,
        name: r'recintosProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$recintosHash,
        dependencies: RecintosFamily._dependencies,
        allTransitiveDependencies: RecintosFamily._allTransitiveDependencies,
        parroquiaId: parroquiaId,
      );

  RecintosProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.parroquiaId,
  }) : super.internal();

  final String parroquiaId;

  @override
  Override overrideWith(
    FutureOr<List<Recinto>> Function(RecintosRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RecintosProvider._internal(
        (ref) => create(ref as RecintosRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        parroquiaId: parroquiaId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Recinto>> createElement() {
    return _RecintosProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RecintosProvider && other.parroquiaId == parroquiaId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, parroquiaId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RecintosRef on AutoDisposeFutureProviderRef<List<Recinto>> {
  /// The parameter `parroquiaId` of this provider.
  String get parroquiaId;
}

class _RecintosProviderElement
    extends AutoDisposeFutureProviderElement<List<Recinto>>
    with RecintosRef {
  _RecintosProviderElement(super.provider);

  @override
  String get parroquiaId => (origin as RecintosProvider).parroquiaId;
}

String _$jrvPorRecintoHash() => r'd2936d0bb5afec1b0e65d17c7413dfc6953aab33';

/// See also [jrvPorRecinto].
@ProviderFor(jrvPorRecinto)
const jrvPorRecintoProvider = JrvPorRecintoFamily();

/// See also [jrvPorRecinto].
class JrvPorRecintoFamily extends Family<AsyncValue<List<Jrv>>> {
  /// See also [jrvPorRecinto].
  const JrvPorRecintoFamily();

  /// See also [jrvPorRecinto].
  JrvPorRecintoProvider call(String recintoId) {
    return JrvPorRecintoProvider(recintoId);
  }

  @override
  JrvPorRecintoProvider getProviderOverride(
    covariant JrvPorRecintoProvider provider,
  ) {
    return call(provider.recintoId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'jrvPorRecintoProvider';
}

/// See also [jrvPorRecinto].
class JrvPorRecintoProvider extends AutoDisposeFutureProvider<List<Jrv>> {
  /// See also [jrvPorRecinto].
  JrvPorRecintoProvider(String recintoId)
    : this._internal(
        (ref) => jrvPorRecinto(ref as JrvPorRecintoRef, recintoId),
        from: jrvPorRecintoProvider,
        name: r'jrvPorRecintoProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$jrvPorRecintoHash,
        dependencies: JrvPorRecintoFamily._dependencies,
        allTransitiveDependencies:
            JrvPorRecintoFamily._allTransitiveDependencies,
        recintoId: recintoId,
      );

  JrvPorRecintoProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.recintoId,
  }) : super.internal();

  final String recintoId;

  @override
  Override overrideWith(
    FutureOr<List<Jrv>> Function(JrvPorRecintoRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: JrvPorRecintoProvider._internal(
        (ref) => create(ref as JrvPorRecintoRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        recintoId: recintoId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Jrv>> createElement() {
    return _JrvPorRecintoProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is JrvPorRecintoProvider && other.recintoId == recintoId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, recintoId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin JrvPorRecintoRef on AutoDisposeFutureProviderRef<List<Jrv>> {
  /// The parameter `recintoId` of this provider.
  String get recintoId;
}

class _JrvPorRecintoProviderElement
    extends AutoDisposeFutureProviderElement<List<Jrv>>
    with JrvPorRecintoRef {
  _JrvPorRecintoProviderElement(super.provider);

  @override
  String get recintoId => (origin as JrvPorRecintoProvider).recintoId;
}

String _$crearRecintoNotifierHash() =>
    r'94a695c33d3f120287c4253f1f5232613e192860';

/// See also [CrearRecintoNotifier].
@ProviderFor(CrearRecintoNotifier)
final crearRecintoNotifierProvider =
    AutoDisposeNotifierProvider<
      CrearRecintoNotifier,
      AsyncValue<Recinto?>
    >.internal(
      CrearRecintoNotifier.new,
      name: r'crearRecintoNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$crearRecintoNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CrearRecintoNotifier = AutoDisposeNotifier<AsyncValue<Recinto?>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

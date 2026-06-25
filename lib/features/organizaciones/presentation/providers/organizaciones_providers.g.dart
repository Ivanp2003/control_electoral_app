// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organizaciones_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$obtenerOrganizacionesUseCaseHash() =>
    r'f1f07ec59f12425ae379341f77d3aaf7ae66e439';

/// See also [obtenerOrganizacionesUseCase].
@ProviderFor(obtenerOrganizacionesUseCase)
final obtenerOrganizacionesUseCaseProvider =
    Provider<ObtenerOrganizacionesUseCase>.internal(
      obtenerOrganizacionesUseCase,
      name: r'obtenerOrganizacionesUseCaseProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$obtenerOrganizacionesUseCaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ObtenerOrganizacionesUseCaseRef =
    ProviderRef<ObtenerOrganizacionesUseCase>;
String _$organizacionesPorCargoHash() =>
    r'79469683782fa3b02cfdb42b203c3921eba23fff';

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

/// See also [organizacionesPorCargo].
@ProviderFor(organizacionesPorCargo)
const organizacionesPorCargoProvider = OrganizacionesPorCargoFamily();

/// See also [organizacionesPorCargo].
class OrganizacionesPorCargoFamily
    extends Family<AsyncValue<List<OrganizacionPolitica>>> {
  /// See also [organizacionesPorCargo].
  const OrganizacionesPorCargoFamily();

  /// See also [organizacionesPorCargo].
  OrganizacionesPorCargoProvider call(String cargo) {
    return OrganizacionesPorCargoProvider(cargo);
  }

  @override
  OrganizacionesPorCargoProvider getProviderOverride(
    covariant OrganizacionesPorCargoProvider provider,
  ) {
    return call(provider.cargo);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'organizacionesPorCargoProvider';
}

/// See also [organizacionesPorCargo].
class OrganizacionesPorCargoProvider
    extends AutoDisposeFutureProvider<List<OrganizacionPolitica>> {
  /// See also [organizacionesPorCargo].
  OrganizacionesPorCargoProvider(String cargo)
    : this._internal(
        (ref) =>
            organizacionesPorCargo(ref as OrganizacionesPorCargoRef, cargo),
        from: organizacionesPorCargoProvider,
        name: r'organizacionesPorCargoProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$organizacionesPorCargoHash,
        dependencies: OrganizacionesPorCargoFamily._dependencies,
        allTransitiveDependencies:
            OrganizacionesPorCargoFamily._allTransitiveDependencies,
        cargo: cargo,
      );

  OrganizacionesPorCargoProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.cargo,
  }) : super.internal();

  final String cargo;

  @override
  Override overrideWith(
    FutureOr<List<OrganizacionPolitica>> Function(
      OrganizacionesPorCargoRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: OrganizacionesPorCargoProvider._internal(
        (ref) => create(ref as OrganizacionesPorCargoRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        cargo: cargo,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<OrganizacionPolitica>> createElement() {
    return _OrganizacionesPorCargoProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is OrganizacionesPorCargoProvider && other.cargo == cargo;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, cargo.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin OrganizacionesPorCargoRef
    on AutoDisposeFutureProviderRef<List<OrganizacionPolitica>> {
  /// The parameter `cargo` of this provider.
  String get cargo;
}

class _OrganizacionesPorCargoProviderElement
    extends AutoDisposeFutureProviderElement<List<OrganizacionPolitica>>
    with OrganizacionesPorCargoRef {
  _OrganizacionesPorCargoProviderElement(super.provider);

  @override
  String get cargo => (origin as OrganizacionesPorCargoProvider).cargo;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

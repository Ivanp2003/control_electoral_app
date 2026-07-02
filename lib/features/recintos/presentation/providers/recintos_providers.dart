import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/constants/app_roles.dart';
import '../../../../core/network/appwrite_client.dart';
import '../../../../database/app_database.dart';
import '../../data/repositories/recintos_repository_impl.dart';
import '../../domain/entities/canton.dart';
import '../../domain/entities/jrv.dart';
import '../../domain/entities/parroquia.dart';
import '../../domain/entities/provincia.dart';
import '../../domain/entities/recinto.dart';
import '../../domain/repositories/recintos_repository.dart';
import '../../domain/usecases/crear_jrv_usecase.dart';
import '../../domain/usecases/crear_recinto_usecase.dart';
import '../../domain/usecases/obtener_cantones_usecase.dart';
import '../../domain/usecases/obtener_jrv_por_recinto_usecase.dart';
import '../../domain/usecases/obtener_parroquias_usecase.dart';
import '../../domain/usecases/obtener_provincias_usecase.dart';
import '../../domain/usecases/obtener_recintos_usecase.dart';
import '../../domain/entities/jrv.dart';

part 'recintos_providers.g.dart';

// ---------------------------------------------------------------------------
// Providers de Use Cases
// ---------------------------------------------------------------------------

@Riverpod(keepAlive: true)
ObtenerProvinciasUseCase obtenerProvinciasUseCase(
    ObtenerProvinciasUseCaseRef ref) {
  return ObtenerProvinciasUseCase(
      repository: ref.watch(recintosRepositoryProvider));
}

@Riverpod(keepAlive: true)
ObtenerCantonesUseCase obtenerCantonesUseCase(ObtenerCantonesUseCaseRef ref) {
  return ObtenerCantonesUseCase(
      repository: ref.watch(recintosRepositoryProvider));
}

@Riverpod(keepAlive: true)
ObtenerParroquiasUseCase obtenerParroquiasUseCase(
    ObtenerParroquiasUseCaseRef ref) {
  return ObtenerParroquiasUseCase(
      repository: ref.watch(recintosRepositoryProvider));
}

@Riverpod(keepAlive: true)
ObtenerRecintosUseCase obtenerRecintosUseCase(ObtenerRecintosUseCaseRef ref) {
  return ObtenerRecintosUseCase(
      repository: ref.watch(recintosRepositoryProvider));
}

@Riverpod(keepAlive: true)
ObtenerJrvPorRecintoUseCase obtenerJrvPorRecintoUseCase(
    ObtenerJrvPorRecintoUseCaseRef ref) {
  return ObtenerJrvPorRecintoUseCase(
      repository: ref.watch(recintosRepositoryProvider));
}

@Riverpod(keepAlive: true)
CrearRecintoUseCase crearRecintoUseCase(CrearRecintoUseCaseRef ref) {
  return CrearRecintoUseCase(repository: ref.watch(recintosRepositoryProvider));
}

// ---------------------------------------------------------------------------
// Providers de Estado Asíncrono (lectura de catálogos)
// ---------------------------------------------------------------------------

@riverpod
Future<List<Provincia>> provincias(ProvinciasRef ref) async {
  final useCase = ref.watch(obtenerProvinciasUseCaseProvider);
  final result = await useCase();
  return result.fold(
    (failure) => throw Exception(failure.message),
    (list) => list,
  );
}

@riverpod
Future<List<Canton>> cantones(CantonesRef ref, String provinciaId) async {
  final useCase = ref.watch(obtenerCantonesUseCaseProvider);
  final result = await useCase(provinciaId);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (list) => list,
  );
}

@riverpod
Future<List<Parroquia>> parroquias(ParroquiasRef ref, String cantonId) async {
  final useCase = ref.watch(obtenerParroquiasUseCaseProvider);
  final result = await useCase(cantonId);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (list) => list,
  );
}

@riverpod
Future<List<Recinto>> recintos(RecintosRef ref, String parroquiaId) async {
  final useCase = ref.watch(obtenerRecintosUseCaseProvider);
  final result = await useCase(parroquiaId);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (list) => list,
  );
}

@riverpod
Future<List<Jrv>> jrvPorRecinto(JrvPorRecintoRef ref, String recintoId) async {
  final useCase = ref.watch(obtenerJrvPorRecintoUseCaseProvider);
  final result = await useCase(recintoId);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (list) => list,
  );
}

// ---------------------------------------------------------------------------
// Notifier para creación de recinto
// ---------------------------------------------------------------------------

@riverpod
class CrearRecintoNotifier extends _$CrearRecintoNotifier {
  @override
  AsyncValue<Recinto?> build() => const AsyncValue.data(null);

  Future<void> crearRecinto({
    required AppRole rolUsuario,
    required String nombre,
    required String parroquiaId,
    required String direccion,
    double? latRef,
    double? lonRef,
  }) async {
    state = const AsyncValue.loading();
    final useCase = ref.read(crearRecintoUseCaseProvider);
    final result = await useCase(
      rolUsuario: rolUsuario,
      nombre: nombre,
      parroquiaId: parroquiaId,
      direccion: direccion,
      latRef: latRef,
      lonRef: lonRef,
    );
    state = result.fold(
      (failure) => AsyncValue.error(failure.message, StackTrace.current),
      (recinto) => AsyncValue.data(recinto),
    );
  }
}

@Riverpod(keepAlive: true)
CrearJrvUseCase crearJrvUseCase(CrearJrvUseCaseRef ref) {
  return CrearJrvUseCase(repository: ref.watch(recintosRepositoryProvider));
}

@riverpod
class CrearJrvNotifier extends _$CrearJrvNotifier {
  @override
  AsyncValue<Jrv?> build() => const AsyncValue.data(null);

  Future<Jrv?> crearJrv({
    required AppRole rolUsuario,
    required String codigo,
    required String recintoId,
  }) async {
    state = const AsyncValue.loading();
    final useCase = ref.read(crearJrvUseCaseProvider);
    final result = await useCase(
      rolUsuario: rolUsuario,
      codigo: codigo,
      recintoId: recintoId,
    );
    state = result.fold(
      (failure) => AsyncValue.error(failure.message, StackTrace.current),
      (jrv) => AsyncValue.data(jrv),
    );
    
    return result.fold(
      (l) => null,
      (jrv) => jrv,
    );
  }
}

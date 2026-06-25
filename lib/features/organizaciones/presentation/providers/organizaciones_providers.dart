import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/appwrite_client.dart';
import '../../../../database/app_database.dart';
import '../../data/repositories/organizaciones_repository_impl.dart';
import '../../domain/entities/organizacion_politica.dart';
import '../../domain/repositories/organizaciones_repository.dart';
import '../../domain/usecases/obtener_organizaciones_usecase.dart';

part 'organizaciones_providers.g.dart';

@Riverpod(keepAlive: true)
ObtenerOrganizacionesUseCase obtenerOrganizacionesUseCase(
    ObtenerOrganizacionesUseCaseRef ref) {
  return ObtenerOrganizacionesUseCase(
      repository: ref.watch(organizacionesRepositoryProvider));
}

@riverpod
Future<List<OrganizacionPolitica>> organizacionesPorCargo(
    OrganizacionesPorCargoRef ref, String cargo) async {
  final useCase = ref.watch(obtenerOrganizacionesUseCaseProvider);
  final result = await useCase(cargo);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (list) => list,
  );
}

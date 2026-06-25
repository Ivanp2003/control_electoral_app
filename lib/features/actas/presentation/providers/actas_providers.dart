import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/appwrite_client.dart';
import '../../../../core/network/connectivity_service.dart';
import '../../../../database/app_database.dart';
import '../../data/datasources/actas_local_datasource.dart';
import '../../data/datasources/actas_remote_datasource.dart';
import '../../data/repositories/actas_repository_impl.dart';
import '../../domain/entities/acta.dart';
import '../../domain/entities/organizacion_con_votos.dart';
import '../../domain/repositories/actas_repository.dart';
import '../../domain/usecases/obtener_actas_por_jrv_usecase.dart';
import '../../domain/usecases/registrar_acta_usecase.dart';
import '../../domain/usecases/corregir_acta_usecase.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../organizaciones/domain/entities/organizacion_politica.dart';
import '../../../evidencia/domain/entities/evidencia_data.dart';

part 'actas_providers.g.dart';

@Riverpod(keepAlive: true)
ActasRepository actasRepository(ActasRepositoryRef ref) {
  final db = ref.read(appDatabaseProvider);
  return ActasRepositoryImpl(
    remote: ActasRemoteDatasource(
      databases: ref.read(appwriteDatabasesProvider),
      storage: ref.read(appwriteStorageProvider),
    ),
    local: ActasLocalDatasource(db: db),
    db: db,
    connectivity: ref.read(connectivityServiceProvider),
  );
}

@Riverpod(keepAlive: true)
RegistrarActaUseCase registrarActaUseCase(RegistrarActaUseCaseRef ref) {
  return RegistrarActaUseCase(
    repository: ref.read(actasRepositoryProvider),
  );
}

@Riverpod(keepAlive: true)
CorregirActaUseCase corregirActaUseCase(CorregirActaUseCaseRef ref) {
  return CorregirActaUseCase(
    repository: ref.read(actasRepositoryProvider),
  );
}

@Riverpod(keepAlive: true)
ObtenerActasPorJrvUseCase obtenerActasPorJrvUseCase(
    ObtenerActasPorJrvUseCaseRef ref) {
  return ObtenerActasPorJrvUseCase(
    repository: ref.read(actasRepositoryProvider),
  );
}

class VotoInput {
  final String organizacionId;
  final String nombreOrganizacion;
  final int votos;
  VotoInput({
    required this.organizacionId,
    required this.nombreOrganizacion,
    required this.votos,
  });
  OrganizacionConVotos toEntity() => OrganizacionConVotos(
        organizacionId: organizacionId,
        nombreOrganizacion: nombreOrganizacion,
        votos: votos,
      );
}

@riverpod
class ActaRegistroNotifier extends _$ActaRegistroNotifier {
  @override
  AsyncValue<Acta?> build() => const AsyncValue.data(null);

  Future<String?> registrar({
    required String jrvId,
    required String cargoElectoral,
    required List<VotoInput> votosOrganizaciones,
    required int votosBlancos,
    required int votosNulos,
    required int totalSufragantes,
    required List<OrganizacionPolitica> organizaciones,
    EvidenciaData? evidencia,
  }) async {
    state = const AsyncValue.loading();

    final usuario = ref.read(currentUserProvider);
    if (usuario == null) {
      state = AsyncValue.error('Usuario no autenticado', StackTrace.current);
      return 'Usuario no autenticado';
    }

    final useCase = ref.read(registrarActaUseCaseProvider);
    final votoEntities =
        votosOrganizaciones.map((v) => v.toEntity()).toList();

    final acta = Acta(
      id: '',
      jrvId: jrvId,
      cargoElectoral: cargoElectoral,
      votos: votoEntities,
      votosBlancos: votosBlancos,
      votosNulos: votosNulos,
      totalSufragantes: totalSufragantes,
      fotoUrl: evidencia?.fotoPath,
      latitud: evidencia?.latitud ?? 0.0,
      longitud: evidencia?.longitud ?? 0.0,
      creadoPor: usuario.id,
    );

    final result = await useCase(
      rolUsuario: usuario.rol,
      acta: acta,
      organizaciones: organizaciones,
    );

    return result.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
        return failure.message;
      },
      (actaCreada) {
        state = AsyncValue.data(actaCreada);
        return null;
      },
    );
  }
}

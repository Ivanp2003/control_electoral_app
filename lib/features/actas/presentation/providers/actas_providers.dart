import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/appwrite_client.dart';
import '../../../../core/network/connectivity_service.dart';
import '../../../../database/app_database.dart';
import '../../data/datasources/actas_local_datasource.dart';
import '../../data/datasources/actas_remote_datasource.dart';
import '../../data/repositories/actas_repository_impl.dart';
import '../../domain/repositories/actas_repository.dart';
import '../../domain/usecases/corregir_acta_usecase.dart';
import '../../domain/usecases/obtener_actas_por_jrv_usecase.dart';
import '../../domain/usecases/registrar_acta_usecase.dart';

part 'actas_providers.g.dart';

@Riverpod(keepAlive: true)
ActasLocalDatasource actasLocalDatasource(ActasLocalDatasourceRef ref) {
  final db = ref.watch(appDatabaseProvider);
  return ActasLocalDatasource(db);
}

@Riverpod(keepAlive: true)
ActasRemoteDatasource actasRemoteDatasource(ActasRemoteDatasourceRef ref) {
  final services = ref.watch(appwriteServicesProvider);
  return ActasRemoteDatasource(services.databases);
}

@Riverpod(keepAlive: true)
ActasRepository actasRepository(ActasRepositoryRef ref) {
  final local = ref.watch(actasLocalDatasourceProvider);
  final remote = ref.watch(actasRemoteDatasourceProvider);
  final connectivity = ref.watch(connectivityServiceProvider);
  final db = ref.watch(appDatabaseProvider);
  return ActasRepositoryImpl(local, remote, connectivity, db);
}

@riverpod
ObtenerActasPorJrvUseCase obtenerActasPorJrvUseCase(ObtenerActasPorJrvUseCaseRef ref) {
  final repo = ref.watch(actasRepositoryProvider);
  return ObtenerActasPorJrvUseCase(repo);
}

@riverpod
RegistrarActaUseCase registrarActaUseCase(RegistrarActaUseCaseRef ref) {
  final repo = ref.watch(actasRepositoryProvider);
  return RegistrarActaUseCase(repo);
}

@riverpod
CorregirActaUseCase corregirActaUseCase(CorregirActaUseCaseRef ref) {
  final repo = ref.watch(actasRepositoryProvider);
  return CorregirActaUseCase(repo);
}

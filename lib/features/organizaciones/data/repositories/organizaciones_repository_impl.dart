import 'package:appwrite/appwrite.dart';
import 'package:dartz/dartz.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/appwrite_client.dart';
import '../../../../core/network/connectivity_service.dart';
import '../../../../database/app_database.dart';
import '../../domain/entities/organizacion_politica.dart';
import '../../domain/repositories/organizaciones_repository.dart';
import '../datasources/organizaciones_remote_datasource.dart';
import '../models/organizacion_politica_model.dart';

part 'organizaciones_repository_impl.g.dart';

/// organizaciones_repository_impl.dart
///
/// Responsabilidad Única: Estrategia Remote-First / Local-Fallback
/// para organizaciones políticas.

class OrganizacionesRepositoryImpl implements OrganizacionesRepository {
  final OrganizacionesRemoteDatasource _remote;
  final AppDatabase _db;
  final ConnectivityService _connectivity;

  OrganizacionesRepositoryImpl({
    required OrganizacionesRemoteDatasource remote,
    required AppDatabase db,
    required ConnectivityService connectivity,
  })  : _remote = remote,
        _db = db,
        _connectivity = connectivity;

  @override
  Future<Either<Failure, List<OrganizacionPolitica>>> obtenerOrganizaciones(
      String cargo) async {
    final online = await _connectivity.isConnected;
    if (online) {
      try {
        final orgs = await _remote.obtenerOrganizaciones(cargo);
        // Actualizar caché local.
        for (final org in orgs) {
          await _db.guardarOrganizacionLocal(OrganizacionesLocalCompanion.insert(
            id: org.id,
            nombre: org.nombre,
            cargo: org.cargo,
          ));
        }
        return Right(orgs);
      } catch (e) {
        return _fallback(cargo);
      }
    }
    return _fallback(cargo);
  }

  Future<Either<Failure, List<OrganizacionPolitica>>> _fallback(
      String cargo) async {
    final rows = await _db.obtenerOrganizacionesLocal(cargo);
    if (rows.isEmpty) {
      return const Left(NoConnectionFailure(
          'Sin conexión y sin organizaciones en caché local.'));
    }
    return Right(rows
        .map((r) => OrganizacionPoliticaModel.fromLocalData(
            (id: r.id, nombre: r.nombre, cargo: r.cargo)))
        .toList());
  }
}

/// Provider Riverpod del repositorio de organizaciones.
@Riverpod(keepAlive: true)
OrganizacionesRepository organizacionesRepository(
    OrganizacionesRepositoryRef ref) {
  final databases = ref.watch(appwriteDatabasesProvider);
  final db = ref.watch(appDatabaseProvider);
  final connectivity = ref.watch(connectivityServiceProvider);

  return OrganizacionesRepositoryImpl(
    remote: OrganizacionesRemoteDatasourceImpl(databases: databases),
    db: db,
    connectivity: connectivity,
  );
}

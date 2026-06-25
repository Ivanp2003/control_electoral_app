import 'package:dartz/dartz.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/connectivity_service.dart';
import '../../../../database/app_database.dart';
import '../../domain/entities/acta.dart';
import '../../domain/entities/organizacion_con_votos.dart';
import '../../domain/repositories/actas_repository.dart';
import '../datasources/actas_local_datasource.dart';
import '../datasources/actas_remote_datasource.dart';
import '../models/acta_model.dart';

class ActasRepositoryImpl implements ActasRepository {
  final ActasRemoteDatasource _remote;
  final ActasLocalDatasource _local;
  final AppDatabase _db;
  final ConnectivityService _connectivity;
  final _uuid = const Uuid();

  ActasRepositoryImpl({
    required ActasRemoteDatasource remote,
    required ActasLocalDatasource local,
    required AppDatabase db,
    required ConnectivityService connectivity,
  })  : _remote = remote,
        _local = local,
        _db = db,
        _connectivity = connectivity;

  @override
  Future<Either<Failure, Acta>> registrar(Acta acta) async {
    final actaConId = acta.copyWith(id: _uuid.v4());
    final model = ActaModel.fromEntity(actaConId);

    try {
      final online = await _connectivity.isConnected;

      if (online) {
        await _remote.create(actaConId.jrvId, model);
        await _local.guardarActa(model.copyWith(synced: true));
      } else {
        await _local.guardarActa(model.copyWith(synced: false));
        await _local.encolarSync(model);
      }

      return Right(actaConId);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure('Error al registrar acta: $e'));
    }
  }

  @override
  Future<Either<Failure, Acta>> corregir(Acta acta, String editadoPor) async {
    final actaEditada = acta.copyWith(
      editadoPor: editadoPor,
      fechaEdicion: DateTime.now(),
    );
    final model = ActaModel.fromEntity(actaEditada);

    try {
      final online = await _connectivity.isConnected;

      if (online) {
        await _remote.update(acta.id, model);
        await _local.guardarActa(model.copyWith(synced: true));
      } else {
        await _local.guardarActa(model.copyWith(synced: false));
        await _local.encolarSync(model);
      }

      return Right(actaEditada);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure('Error al corregir acta: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Acta>>> obtenerPorJrv(String jrvId) async {
    try {
      final models = await _local.obtenerActasPorJrv(jrvId);
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(CacheFailure('Error al obtener actas locales: $e'));
    }
  }

  Future<List<Acta>> _actasDesdeIds(Iterable<String> jrvIds) async {
    final todas = await _db.obtenerTodasLasActas();
    final filtradas = todas.where((a) => jrvIds.contains(a.jrvId)).toList();
    final result = <Acta>[];

    for (final acta in filtradas) {
      final detalles = await _db.obtenerDetallePorActa(acta.id);
      result.add(Acta(
        id: acta.id,
        jrvId: acta.jrvId,
        cargoElectoral: acta.cargoElectoral,
        votos: detalles
            .map((d) => OrganizacionConVotos(
                  organizacionId: d.organizacionId,
                  nombreOrganizacion: d.nombreOrganizacion,
                  votos: d.votos,
                ))
            .toList(),
        votosBlancos: acta.votosBlancos,
        votosNulos: acta.votosNulos,
        totalSufragantes: acta.totalSufragantes,
        fotoUrl: acta.fotoUrl,
        latitud: acta.latitud,
        longitud: acta.longitud,
        creadoPor: acta.creadoPor,
        editadoPor: acta.editadoPor,
        fechaEdicion: acta.fechaEdicion,
        synced: acta.synced,
      ));
    }

    return result;
  }

  @override
  Future<Either<Failure, List<Acta>>> obtenerPorVeedor(String veedorId) async {
    try {
      final jrvAsignadas = await _db.obtenerJrvPorVeedor(veedorId);
      final jrvIds = jrvAsignadas.map((j) => j.jrvId);
      final actas = await _actasDesdeIds(jrvIds);
      return Right(actas);
    } catch (e) {
      return Left(CacheFailure('Error al obtener actas del veedor: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Acta>>> obtenerPorRecinto(
      String recintoId) async {
    try {
      final jrvAsignadas = await _db.obtenerJrvPorRecinto(recintoId);
      final jrvIds = jrvAsignadas.map((j) => j.jrvId);
      final actas = await _actasDesdeIds(jrvIds);
      return Right(actas);
    } catch (e) {
      return Left(CacheFailure('Error al obtener actas del recinto: $e'));
    }
  }
}

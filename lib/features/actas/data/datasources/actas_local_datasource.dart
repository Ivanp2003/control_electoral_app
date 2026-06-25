import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../../../../database/app_database.dart';
import '../../domain/entities/organizacion_con_votos.dart';
import '../models/acta_model.dart';

class ActasLocalDatasource {
  final AppDatabase _db;
  final _uuid = const Uuid();

  ActasLocalDatasource({required AppDatabase db}) : _db = db;

  Future<void> guardarActa(ActaModel acta) async {
    await _db.guardarActaLocal(ActasLocalCompanion(
      id: Value(acta.id),
      jrvId: Value(acta.jrvId),
      cargoElectoral: Value(acta.cargoElectoral),
      votosBlancos: Value(acta.votosBlancos),
      votosNulos: Value(acta.votosNulos),
      totalSufragantes: Value(acta.totalSufragantes),
      fotoUrl: Value(acta.fotoUrl),
      latitud: Value(acta.latitud),
      longitud: Value(acta.longitud),
      synced: Value(acta.synced),
      creadoPor: Value(acta.creadoPor),
      editadoPor: Value(acta.editadoPor),
      fechaEdicion: Value(acta.fechaEdicion),
    ));

    for (final voto in acta.votos) {
      await _db.guardarDetalleActa(ActaDetalleLocalCompanion(
        id: Value(_uuid.v4()),
        actaId: Value(acta.id),
        organizacionId: Value(voto.organizacionId),
        nombreOrganizacion: Value(voto.nombreOrganizacion),
        votos: Value(voto.votos),
      ));
    }
  }

  Future<List<ActaModel>> obtenerActasPorJrv(String jrvId) async {
    final actas = await _db.obtenerActasPorJrvLocal(jrvId);
    final result = <ActaModel>[];

    for (final acta in actas) {
      final detalles = await _db.obtenerDetallePorActa(acta.id);
      result.add(ActaModel(
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

  Future<void> marcarSynced(String actaId) async {
    final actas = await _db.obtenerTodasLasActas();
    final existente = actas.where((a) => a.id == actaId).firstOrNull;
    if (existente != null) {
      await _db.actualizarActaLocal(existente.copyWith(synced: true));
    }
  }

  Future<void> encolarSync(ActaModel acta) async {
    await _db.encolarOperacion(SyncQueueCompanion(
      entityType: Value('acta'),
      operation: Value('create'),
      payload: Value(jsonEncode(acta.toJson())),
    ));
  }
}

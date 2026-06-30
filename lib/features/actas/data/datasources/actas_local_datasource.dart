import 'package:drift/drift.dart';
import '../../../../database/app_database.dart';
import '../../domain/entities/acta.dart';
import '../../domain/entities/organizacion_con_votos.dart';

/// actas_local_datasource.dart
///
/// Responsabilidad Única: Manejar las operaciones de CRUD local de actas usando Drift.
/// Separa el acta y sus detalles (votos por organización) en las tablas relacionales.

class ActasLocalDatasource {
  final AppDatabase _db;

  ActasLocalDatasource(this._db);

  Future<void> guardarActaLocal(Acta acta) async {
    await _db.transaction(() async {
      // 1. Guardar cabecera del acta
      final actaCompanion = ActasLocalCompanion.insert(
        id: acta.id,
        jrvId: acta.jrvId,
        cargoElectoral: acta.cargoElectoral,
        votosBlancos: acta.votosBlancos,
        votosNulos: acta.votosNulos,
        totalSufragantes: acta.totalSufragantes,
        fotoUrl: Value(acta.evidenciaFoto),
        latitud: acta.latitud,
        longitud: acta.longitud,
        synced: Value(acta.synced),
        creadoPor: acta.creadoPor,
        editadoPor: Value(acta.editadoPor),
        fechaEdicion: Value(acta.fechaEdicion),
      );
      
      await _db.into(_db.actasLocal).insert(actaCompanion, mode: InsertMode.insertOrReplace);

      // 2. Guardar detalles (organizaciones)
      for (final org in acta.organizaciones) {
        final detalleCompanion = ActaDetalleLocalCompanion.insert(
          id: '${acta.id}_${org.organizacionId}',
          actaId: acta.id,
          organizacionId: org.organizacionId,
          nombreOrganizacion: org.nombreOrganizacion,
          votos: org.votos,
        );
        await _db.into(_db.actaDetalleLocal).insert(detalleCompanion, mode: InsertMode.insertOrReplace);
      }
    });
  }

  Future<List<Acta>> obtenerActasPorJrv(String jrvId) async {
    final actasLocalData = await _db.obtenerActasPorJrvLocal(jrvId);
    List<Acta> result = [];

    for (final data in actasLocalData) {
      final detallesData = await (_db.select(_db.actaDetalleLocal)
            ..where((t) => t.actaId.equals(data.id)))
          .get();

      final organizaciones = detallesData.map((d) => OrganizacionConVotos(
        organizacionId: d.organizacionId,
        nombreOrganizacion: d.nombreOrganizacion,
        votos: d.votos,
      )).toList();

      result.add(Acta(
        id: data.id,
        jrvId: data.jrvId,
        cargoElectoral: data.cargoElectoral,
        totalSufragantes: data.totalSufragantes,
        votosBlancos: data.votosBlancos,
        votosNulos: data.votosNulos,
        organizaciones: organizaciones,
        evidenciaFoto: data.fotoUrl,
        latitud: data.latitud,
        longitud: data.longitud,
        creadoPor: data.creadoPor,
        editadoPor: data.editadoPor,
        fechaEdicion: data.fechaEdicion,
        synced: data.synced,
      ));
    }

    return result;
  }

  Future<bool> verificarAsignacionVeedor(String veedorId, String jrvId) async {
    final asignacion = await (_db.select(_db.veedorJrvLocal)
          ..where((t) => t.veedorId.equals(veedorId) & t.jrvId.equals(jrvId)))
        .getSingleOrNull();
    return asignacion != null;
  }
}

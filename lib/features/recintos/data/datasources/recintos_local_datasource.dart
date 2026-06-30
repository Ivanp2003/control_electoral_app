import 'package:drift/drift.dart';
import '../../../../database/app_database.dart';
import '../models/canton_model.dart';
import '../models/jrv_model.dart';
import '../models/parroquia_model.dart';
import '../models/provincia_model.dart';
import '../models/recinto_model.dart';

/// recintos_local_datasource.dart
///
/// Responsabilidad Única: Leer y escribir la caché offline de la jerarquía
/// geográfica en las tablas Drift. Funciona como fallback cuando no hay red.

abstract class RecintosLocalDatasource {
  Future<List<ProvinciaModel>> obtenerProvincias();
  Future<List<CantonModel>> obtenerCantones(String provinciaId);
  Future<List<ParroquiaModel>> obtenerParroquias(String cantonId);
  Future<List<RecintoModel>> obtenerRecintos(String parroquiaId);
  Future<RecintoModel?> obtenerRecintoPorId(String id);
  Future<List<JrvModel>> obtenerJrvPorRecinto(String recintoId);
  Future<JrvModel?> obtenerJrvPorId(String id);

  Future<void> guardarProvincias(List<ProvinciaModel> provincias);
  Future<void> guardarCantones(List<CantonModel> cantones);
  Future<void> guardarParroquias(List<ParroquiaModel> parroquias);
  Future<void> guardarRecintos(List<RecintoModel> recintos);
  Future<void> guardarJrv(List<JrvModel> jrvList);
}

class RecintosLocalDatasourceImpl implements RecintosLocalDatasource {
  final AppDatabase _db;

  RecintosLocalDatasourceImpl({required AppDatabase db}) : _db = db;

  // ---------------------------------------------------------------------------
  // Lectura
  // ---------------------------------------------------------------------------

  @override
  Future<List<ProvinciaModel>> obtenerProvincias() async {
    final rows = await _db.obtenerProvinciasLocal();
    return rows
        .map((r) => ProvinciaModel.fromLocalData((id: r.id, nombre: r.nombre)))
        .toList();
  }

  @override
  Future<List<CantonModel>> obtenerCantones(String provinciaId) async {
    final rows = await _db.obtenerCantonesLocal(provinciaId);
    return rows
        .map((r) => CantonModel.fromLocalData(
            (id: r.id, nombre: r.nombre, provinciaId: r.provinciaId)))
        .toList();
  }

  @override
  Future<List<ParroquiaModel>> obtenerParroquias(String cantonId) async {
    final rows = await _db.obtenerParroquiasLocal(cantonId);
    return rows
        .map((r) => ParroquiaModel.fromLocalData(
            (id: r.id, nombre: r.nombre, cantonId: r.cantonId)))
        .toList();
  }

  @override
  Future<List<RecintoModel>> obtenerRecintos(String parroquiaId) async {
    final rows = await _db.obtenerRecintosLocal(parroquiaId);
    return rows
        .map((r) => RecintoModel.fromLocalData((
              id: r.id,
              nombre: r.nombre,
              parroquiaId: r.parroquiaId,
              direccion: r.direccion,
              latRef: r.latRef,
              lonRef: r.lonRef,
              coordinadorId: r.coordinadorId,
            )))
        .toList();
  }

  @override
  Future<RecintoModel?> obtenerRecintoPorId(String id) async {
    final r = await _db.obtenerRecintoLocalPorId(id);
    if (r == null) return null;
    return RecintoModel.fromLocalData((
      id: r.id,
      nombre: r.nombre,
      parroquiaId: r.parroquiaId,
      direccion: r.direccion,
      latRef: r.latRef,
      lonRef: r.lonRef,
      coordinadorId: r.coordinadorId,
    ));
  }

  @override
  Future<List<JrvModel>> obtenerJrvPorRecinto(String recintoId) async {
    final rows = await _db.obtenerJrvLocal(recintoId);
    return rows
        .map((r) => JrvModel.fromLocalData(
            (id: r.id, codigo: r.codigo, recintoId: r.recintoId)))
        .toList();
  }

  @override
  Future<JrvModel?> obtenerJrvPorId(String id) async {
    final r = await _db.obtenerJrvLocalPorId(id);
    if (r == null) return null;
    return JrvModel.fromLocalData(
        (id: r.id, codigo: r.codigo, recintoId: r.recintoId));
  }

  // ---------------------------------------------------------------------------
  // Escritura (poblar caché desde respuesta remota)
  // ---------------------------------------------------------------------------

  @override
  Future<void> guardarProvincias(List<ProvinciaModel> provincias) async {
    await _db.transaction(() async {
      await _db.limpiarProvinciasLocal();
      for (final p in provincias) {
        await _db.guardarProvinciaLocal(
            ProvinciasLocalCompanion.insert(id: p.id, nombre: p.nombre));
      }
    });
  }

  @override
  Future<void> guardarCantones(List<CantonModel> cantones) async {
    await _db.transaction(() async {
      // Borrar antiguos si hay data nueva (idealmente por provincia, pero asumiendo sync full)
      if (cantones.isNotEmpty) {
         final provId = cantones.first.provinciaId;
         await (_db.delete(_db.cantonesLocal)..where((t) => t.provinciaId.equals(provId))).go();
      }
      for (final c in cantones) {
        await _db.guardarCantonLocal(CantonesLocalCompanion.insert(
            id: c.id, nombre: c.nombre, provinciaId: c.provinciaId));
      }
    });
  }

  @override
  Future<void> guardarParroquias(List<ParroquiaModel> parroquias) async {
    await _db.transaction(() async {
      if (parroquias.isNotEmpty) {
         final canId = parroquias.first.cantonId;
         await (_db.delete(_db.parroquiasLocal)..where((t) => t.cantonId.equals(canId))).go();
      }
      for (final p in parroquias) {
        await _db.guardarParroquiaLocal(ParroquiasLocalCompanion.insert(
            id: p.id, nombre: p.nombre, cantonId: p.cantonId));
      }
    });
  }

  @override
  Future<void> guardarRecintos(List<RecintoModel> recintos) async {
    await _db.transaction(() async {
      if (recintos.isNotEmpty) {
         final parrId = recintos.first.parroquiaId;
         await (_db.delete(_db.recintosLocal)..where((t) => t.parroquiaId.equals(parrId))).go();
      }
      for (final r in recintos) {
        await _db.guardarRecintoLocal(RecintosLocalCompanion.insert(
          id: r.id,
          nombre: r.nombre,
          parroquiaId: r.parroquiaId,
          direccion: r.direccion,
          latRef: Value(r.latRef),
          lonRef: Value(r.lonRef),
        ));
      }
    });
  }

  @override
  Future<void> guardarJrv(List<JrvModel> jrvList) async {
    await _db.transaction(() async {
      if (jrvList.isNotEmpty) {
         final recId = jrvList.first.recintoId;
         await (_db.delete(_db.jrvLocal)..where((t) => t.recintoId.equals(recId))).go();
      }
      for (final j in jrvList) {
        await _db.guardarJrvLocal(
            JrvLocalCompanion.insert(id: j.id, codigo: j.codigo, recintoId: j.recintoId));
      }
    });
  }
}

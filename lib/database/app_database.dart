import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_database.g.dart';

/// app_database.dart
///
/// Responsabilidad Única: Definir el esquema de base de datos local SQLite (tablas Drift)
/// y el cliente de persistencia local para soportar la estrategia offline-first.
///
/// HISTORIAL DE VERSIONES:
///   v1 — Fase 1: ActasLocal, SyncQueue.
///   v2 — Fase 3: ProvinciasLocal, CantonesLocal, ParroquiasLocal, RecintosLocal,
///                JrvLocal, OrganizacionesLocal, ConfigSistemaLocal.
///   v3 — Fase 4: ActaDetalleLocal, VeedorJrvLocal.
///       (Nota: estas tablas se filtraron prematuramente durante la
///       corrección de Fase 3 y se formalizan aquí en Fase 4 sin
///       cambios de esquema adicionales).

// =============================================================================
// TABLAS — Fase 1
// =============================================================================

/// Tabla local que actúa como espejo de la colección 'actas' de Appwrite.
class ActasLocal extends Table {
  TextColumn get id => text()();
  TextColumn get jrvId => text()();
  TextColumn get cargoElectoral => text()();
  IntColumn get votosBlancos => integer()();
  IntColumn get votosNulos => integer()();
  IntColumn get totalSufragantes => integer()();
  TextColumn get fotoUrl => text().nullable()();
  RealColumn get latitud => real()();
  RealColumn get longitud => real()();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
  TextColumn get syncError => text().nullable()();
  TextColumn get creadoPor => text()();
  TextColumn get editadoPor => text().nullable()();
  DateTimeColumn get fechaEdicion => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Cola de sincronización local para operaciones remotas fallidas o diferidas.
class SyncQueue extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get entityType => text()();
  TextColumn get operation => text()();
  TextColumn get payload => text()();
  DateTimeColumn get timestamp => dateTime().withDefault(currentDateAndTime)();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  TextColumn get status => text().withDefault(const Constant('pending'))();
}

// =============================================================================
// TABLAS — Fase 3: Jerarquía Geográfica y Catálogos
// =============================================================================

/// Caché local de la colección 'provincias' de Appwrite.
class ProvinciasLocal extends Table {
  /// ID del documento de Appwrite.
  TextColumn get id => text()();
  TextColumn get nombre => text()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Caché local de la colección 'cantones' de Appwrite.
class CantonesLocal extends Table {
  TextColumn get id => text()();
  TextColumn get nombre => text()();
  TextColumn get provinciaId => text()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Caché local de la colección 'parroquias' de Appwrite.
class ParroquiasLocal extends Table {
  TextColumn get id => text()();
  TextColumn get nombre => text()();
  TextColumn get cantonId => text()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Caché local de la colección 'recintos' de Appwrite.
class RecintosLocal extends Table {
  TextColumn get id => text()();
  TextColumn get nombre => text()();
  TextColumn get parroquiaId => text()();
  TextColumn get direccion => text()();
  RealColumn get latRef => real().nullable()();
  RealColumn get lonRef => real().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Caché local de la colección 'jrv' de Appwrite.
class JrvLocal extends Table {
  TextColumn get id => text()();
  TextColumn get codigo => text()();
  TextColumn get recintoId => text()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Caché local de la colección 'organizaciones_politicas' de Appwrite.
class OrganizacionesLocal extends Table {
  TextColumn get id => text()();
  TextColumn get nombre => text()();

  /// Cargo electoral: 'alcalde' o 'prefecto'.
  TextColumn get cargo => text()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Tabla de configuración del sistema para flags locales (ej. estado del seeder).
/// Espejo local de la colección 'config_sistema' de Appwrite.
class ConfigSistemaLocal extends Table {
  /// Clave de configuración (ej. 'seed_ejecutado'). Actúa como PK.
  TextColumn get clave => text()();
  TextColumn get valor => text()();

  @override
  Set<Column> get primaryKey => {clave};
}

// =============================================================================
// TABLAS — Fase 4
// =============================================================================

/// Detalle de votos por organización política dentro de un acta.
class ActaDetalleLocal extends Table {
  TextColumn get id => text()();
  TextColumn get actaId => text()();
  TextColumn get organizacionId => text()();
  TextColumn get nombreOrganizacion => text()();
  IntColumn get votos => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Asignación de veedores a JRV y recintos.
class VeedorJrvLocal extends Table {
  TextColumn get id => text()();
  TextColumn get veedorId => text()();
  TextColumn get jrvId => text()();
  TextColumn get recintoId => text()();

  @override
  Set<Column> get primaryKey => {id};
}

// =============================================================================
// BASE DE DATOS PRINCIPAL
// =============================================================================

@DriftDatabase(tables: [
  ActasLocal,
  SyncQueue,
  // Fase 3
  ProvinciasLocal,
  CantonesLocal,
  ParroquiasLocal,
  RecintosLocal,
  JrvLocal,
  OrganizacionesLocal,
  ConfigSistemaLocal,
  // Fase 4
  ActaDetalleLocal,
  VeedorJrvLocal,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onUpgrade: (migrator, from, to) async {
        // v1 → v2: Agregar tablas de jerarquía geográfica y configuración.
        if (from < 2) {
          await migrator.createTable(provinciasLocal);
          await migrator.createTable(cantonesLocal);
          await migrator.createTable(parroquiasLocal);
          await migrator.createTable(recintosLocal);
          await migrator.createTable(jrvLocal);
          await migrator.createTable(organizacionesLocal);
          await migrator.createTable(configSistemaLocal);
        }
        // v2 → v3: Agregar tablas de Fase 4.
        if (from < 3) {
          await migrator.createTable(actaDetalleLocal);
          await migrator.createTable(veedorJrvLocal);
        }
      },
    );
  }

  // ---------------------------------------------------------------------------
  // CRUD — ActasLocal (Fase 1)
  // ---------------------------------------------------------------------------

  Future<List<ActasLocalData>> obtenerTodasLasActas() => select(actasLocal).get();

  Future<List<ActasLocalData>> obtenerActasPorJrvLocal(String jrvId) =>
      (select(actasLocal)..where((t) => t.jrvId.equals(jrvId))).get();

  Future<int> guardarActaLocal(ActasLocalCompanion companion) =>
      into(actasLocal).insert(companion, mode: InsertMode.insertOrReplace);

  Future<bool> actualizarActaLocal(ActasLocalData data) =>
      update(actasLocal).replace(data);

  Future<int> eliminarActaLocal(ActasLocalData data) =>
      delete(actasLocal).delete(data);

  // ---------------------------------------------------------------------------
  // CRUD — SyncQueue (Fase 1)
  // ---------------------------------------------------------------------------

  Future<List<SyncQueueData>> obtenerColaPendiente() =>
      (select(syncQueue)..where((t) => t.status.equals('pending'))).get();

  Future<int> encolarOperacion(SyncQueueCompanion companion) =>
      into(syncQueue).insert(companion);

  Future<bool> actualizarEstadoCola(SyncQueueData data) =>
      update(syncQueue).replace(data);

  Future<int> eliminarDeLaCola(SyncQueueData data) =>
      delete(syncQueue).delete(data);

  // ---------------------------------------------------------------------------
  // CRUD — ProvinciasLocal (Fase 3)
  // ---------------------------------------------------------------------------

  Future<List<ProvinciasLocalData>> obtenerProvinciasLocal() =>
      select(provinciasLocal).get();

  Future<int> guardarProvinciaLocal(ProvinciasLocalCompanion companion) =>
      into(provinciasLocal).insert(companion, mode: InsertMode.insertOrReplace);

  Future<void> limpiarProvinciasLocal() => delete(provinciasLocal).go();

  // ---------------------------------------------------------------------------
  // CRUD — CantonesLocal (Fase 3)
  // ---------------------------------------------------------------------------

  Future<List<CantonesLocalData>> obtenerCantonesLocal(String provinciaId) =>
      (select(cantonesLocal)
            ..where((t) => t.provinciaId.equals(provinciaId)))
          .get();

  Future<int> guardarCantonLocal(CantonesLocalCompanion companion) =>
      into(cantonesLocal).insert(companion, mode: InsertMode.insertOrReplace);

  // ---------------------------------------------------------------------------
  // CRUD — ParroquiasLocal (Fase 3)
  // ---------------------------------------------------------------------------

  Future<List<ParroquiasLocalData>> obtenerParroquiasLocal(String cantonId) =>
      (select(parroquiasLocal)
            ..where((t) => t.cantonId.equals(cantonId)))
          .get();

  Future<int> guardarParroquiaLocal(ParroquiasLocalCompanion companion) =>
      into(parroquiasLocal).insert(companion, mode: InsertMode.insertOrReplace);

  // ---------------------------------------------------------------------------
  // CRUD — RecintosLocal (Fase 3)
  // ---------------------------------------------------------------------------

  Future<List<RecintosLocalData>> obtenerTodasLasRecintos() =>
      select(recintosLocal).get();

  Future<List<RecintosLocalData>> obtenerRecintosLocal(String parroquiaId) =>
      (select(recintosLocal)
            ..where((t) => t.parroquiaId.equals(parroquiaId)))
          .get();

  Future<int> guardarRecintoLocal(RecintosLocalCompanion companion) =>
      into(recintosLocal).insert(companion, mode: InsertMode.insertOrReplace);

  // ---------------------------------------------------------------------------
  // CRUD — JrvLocal (Fase 3)
  // ---------------------------------------------------------------------------

  Future<List<JrvLocalData>> obtenerTodasLasJrv() => select(jrvLocal).get();

  Future<List<JrvLocalData>> obtenerJrvLocal(String recintoId) =>
      (select(jrvLocal)..where((t) => t.recintoId.equals(recintoId))).get();

  Future<int> guardarJrvLocal(JrvLocalCompanion companion) =>
      into(jrvLocal).insert(companion, mode: InsertMode.insertOrReplace);

  // ---------------------------------------------------------------------------
  // CRUD — OrganizacionesLocal (Fase 3)
  // ---------------------------------------------------------------------------

  Future<List<OrganizacionesLocalData>> obtenerOrganizacionesLocal(String cargo) =>
      (select(organizacionesLocal)
            ..where((t) => t.cargo.equals(cargo)))
          .get();

  Future<int> guardarOrganizacionLocal(OrganizacionesLocalCompanion companion) =>
      into(organizacionesLocal)
          .insert(companion, mode: InsertMode.insertOrReplace);

  // ---------------------------------------------------------------------------
  // CRUD — ConfigSistemaLocal (Fase 3)
  // ---------------------------------------------------------------------------

  Future<ConfigSistemaLocalData?> obtenerConfigLocal(String clave) =>
      (select(configSistemaLocal)
            ..where((t) => t.clave.equals(clave))
            ..limit(1))
          .getSingleOrNull();

  Future<int> guardarConfigLocal(ConfigSistemaLocalCompanion companion) =>
      into(configSistemaLocal)
          .insert(companion, mode: InsertMode.insertOrReplace);

  // ---------------------------------------------------------------------------
  // CRUD — ActaDetalleLocal (Fase 4)
  // ---------------------------------------------------------------------------

  Future<List<ActaDetalleLocalData>> obtenerTodosLosDetalles() =>
      select(actaDetalleLocal).get();

  Future<List<ActaDetalleLocalData>> obtenerDetallePorActa(String actaId) =>
      (select(actaDetalleLocal)
            ..where((t) => t.actaId.equals(actaId)))
          .get();

  Future<int> guardarDetalleActa(ActaDetalleLocalCompanion companion) =>
      into(actaDetalleLocal)
          .insert(companion, mode: InsertMode.insertOrReplace);

  Future<void> eliminarDetallePorActa(String actaId) =>
      (delete(actaDetalleLocal)..where((t) => t.actaId.equals(actaId))).go();

  // ---------------------------------------------------------------------------
  // CRUD — VeedorJrvLocal (Fase 4)
  // ---------------------------------------------------------------------------

  Future<List<VeedorJrvLocalData>> obtenerJrvPorVeedor(String veedorId) =>
      (select(veedorJrvLocal)
            ..where((t) => t.veedorId.equals(veedorId)))
          .get();

  Future<List<VeedorJrvLocalData>> obtenerJrvPorRecinto(String recintoId) =>
      (select(veedorJrvLocal)
            ..where((t) => t.recintoId.equals(recintoId)))
          .get();

  Future<int> guardarAsignacionVeedor(VeedorJrvLocalCompanion companion) =>
      into(veedorJrvLocal)
          .insert(companion, mode: InsertMode.insertOrReplace);

  Future<int> eliminarAsignacionVeedor(VeedorJrvLocalData data) =>
      delete(veedorJrvLocal).delete(data);
}

// =============================================================================
// Conexión e instanciación
// =============================================================================

QueryExecutor _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'control_electoral.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

/// Proveedor Riverpod del AppDatabase. keepAlive: true para que sea singleton.
@Riverpod(keepAlive: true)
AppDatabase appDatabase(AppDatabaseRef ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
}

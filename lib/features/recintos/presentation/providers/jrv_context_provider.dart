import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:drift/drift.dart';
import '../../../../database/app_database.dart';

part 'jrv_context_provider.g.dart';

/// jrv_context_provider.dart
///
/// Responsabilidad Única: Resolver el contexto de una JRV (Código + Recinto + Parroquia)
/// a partir de la base de datos local para fines puramente visuales (Presentación).

@riverpod
Future<String> jrvContext(JrvContextRef ref, String jrvId) async {
  final db = ref.watch(appDatabaseProvider);

  try {
    final query = db.select(db.jrvLocal).join([
      innerJoin(db.recintosLocal, db.recintosLocal.id.equalsExp(db.jrvLocal.recintoId)),
      innerJoin(db.parroquiasLocal, db.parroquiasLocal.id.equalsExp(db.recintosLocal.parroquiaId)),
    ])..where(db.jrvLocal.id.equals(jrvId));

    final result = await query.getSingleOrNull();

    if (result == null) {
      return 'JRV Desconocida';
    }

    final jrv = result.readTable(db.jrvLocal);
    final recinto = result.readTable(db.recintosLocal);
    final parroquia = result.readTable(db.parroquiasLocal);

    return '${jrv.codigo} · ${recinto.nombre} · ${parroquia.nombre}';
  } catch (e) {
    return 'Error de Contexto';
  }
}

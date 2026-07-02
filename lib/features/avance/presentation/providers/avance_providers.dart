// avance_providers.dart
//
// Responsabilidad Única: Proveer los datos de avance electoral consultando
// directamente Appwrite para que el Coordinador Provincial vea el estado
// real del sistema, no solo su caché local.

import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/appwrite_config.dart';
import '../../../../core/network/appwrite_client.dart';
import '../../../../database/app_database.dart';

class ActaGps {
  final String jrvId;
  final String recintoId;
  final String cargo;
  final double latitud;
  final double longitud;
  final int totalSufragantes;
  ActaGps({
    required this.jrvId,
    required this.recintoId,
    required this.cargo,
    required this.latitud,
    required this.longitud,
    required this.totalSufragantes,
  });
}

class TotalOrg {
  final String nombre;
  final int votos;
  TotalOrg({required this.nombre, required this.votos});
}

class AvanceData {
  final int totalJrv;
  final int actasRegistradas;
  final List<ActaGps> coordenadas;
  final List<TotalOrg> totalizacion;
  final int totalBlancos;
  final int totalNulos;
  final int totalSufragantes;

  const AvanceData({
    required this.totalJrv,
    required this.actasRegistradas,
    required this.coordenadas,
    required this.totalizacion,
    required this.totalBlancos,
    required this.totalNulos,
    required this.totalSufragantes,
  });

  int get actasFaltantes => (totalJrv * 2) - actasRegistradas;

  double get porcentaje =>
      totalJrv > 0 ? (actasRegistradas / (totalJrv * 2)) * 100 : 0.0;
}

/// Carga el avance electoral desde Appwrite (fuente de verdad remota).
///
/// El coordinador provincial necesita ver las actas de TODOS los veedores,
/// no solo las de su propio dispositivo. Por eso esta pantalla NO usa la
/// caché local de Drift — va directamente a la base de datos remota.
///
/// Fallback: si no hay conexión, cae a los datos locales disponibles
/// para que la pantalla no quede en blanco durante una demo.
final avanceDataProvider = FutureProvider<AvanceData>((ref) async {
  final databases = ref.read(appwriteDatabasesProvider);
  final db = ref.read(appDatabaseProvider);

  try {
    // 1. Total JRV desde Appwrite
    final jrvResponse = await databases.listDocuments(
      databaseId: AppwriteConfig.databaseId,
      collectionId: AppwriteConfig.collectionJrv,
      queries: [Query.limit(500)],
    );
    final totalJrv = jrvResponse.total;

    // 2. Actas registradas desde Appwrite
    final actasResponse = await databases.listDocuments(
      databaseId: AppwriteConfig.databaseId,
      collectionId: AppwriteConfig.collectionActas,
      queries: [Query.limit(500)],
    );
    final actas = actasResponse.documents;
    final actasRegistradas = actas.length;

    // 3. Coordenadas GPS de las actas
    final coordenadas = actas
        .where((doc) =>
            doc.data['latitud'] != null &&
            doc.data['longitud'] != null &&
            (doc.data['latitud'] as num) != 0.0)
        .map((doc) => ActaGps(
              jrvId: doc.data['jrvId'] ?? '',
              recintoId: doc.data['recintoId'] ?? '',
              cargo: doc.data['cargoElectoral'] ?? '',
              latitud: (doc.data['latitud'] as num).toDouble(),
              longitud: (doc.data['longitud'] as num).toDouble(),
              totalSufragantes:
                  (doc.data['totalSufragantes'] as num?)?.toInt() ?? 0,
            ))
        .toList();

    // 4. Totales de votos desde acta_detalle
    final detalleResponse = await databases.listDocuments(
      databaseId: AppwriteConfig.databaseId,
      collectionId: AppwriteConfig.collectionActaDetalle,
      queries: [Query.limit(500)],
    );

    final Map<String, int> totalesPorOrg = {};
    int totalBlancos = 0;
    int totalNulos = 0;
    int totalSufragantes = 0;

    for (final doc in detalleResponse.documents) {
      final nombre = doc.data['nombreOrganizacion'] as String? ?? 'Desconocida';
      final votos = (doc.data['votos'] as num?)?.toInt() ?? 0;
      totalesPorOrg[nombre] = (totalesPorOrg[nombre] ?? 0) + votos;
    }

    for (final doc in actas) {
      totalBlancos += (doc.data['votosBlancos'] as num?)?.toInt() ?? 0;
      totalNulos += (doc.data['votosNulos'] as num?)?.toInt() ?? 0;
      totalSufragantes +=
          (doc.data['totalSufragantes'] as num?)?.toInt() ?? 0;
    }

    final totalizacion = totalesPorOrg.entries
        .map((e) => TotalOrg(nombre: e.key, votos: e.value))
        .toList()
      ..sort((a, b) => b.votos.compareTo(a.votos));

    return AvanceData(
      totalJrv: totalJrv,
      actasRegistradas: actasRegistradas,
      coordenadas: coordenadas,
      totalizacion: totalizacion,
      totalBlancos: totalBlancos,
      totalNulos: totalNulos,
      totalSufragantes: totalSufragantes,
    );
  } catch (_) {
    // Fallback a datos locales si no hay conexión (ej. demo sin red).
    final jrvList = await db.obtenerTodasLasJrv();
    final actasList = await db.obtenerTodasLasActas();
    final detallesList = await db.obtenerTodosLosDetalles();

    final coord = actasList
        .where((a) => a.latitud != 0.0 || a.longitud != 0.0)
        .map((a) => ActaGps(
              jrvId: a.jrvId,
              recintoId: '',
              cargo: a.cargoElectoral,
              latitud: a.latitud,
              longitud: a.longitud,
              totalSufragantes: a.totalSufragantes,
            ))
        .toList();

    final Map<String, int> totales = {};
    for (final d in detallesList) {
      totales[d.nombreOrganizacion] =
          (totales[d.nombreOrganizacion] ?? 0) + d.votos;
    }
    final totalizacion = totales.entries
        .map((e) => TotalOrg(nombre: e.key, votos: e.value))
        .toList()
      ..sort((a, b) => b.votos.compareTo(a.votos));

    int totalBlancos = actasList.fold(0, (s, a) => s + a.votosBlancos);
    int totalNulos = actasList.fold(0, (s, a) => s + a.votosNulos);
    int totalSufragantes =
        actasList.fold(0, (s, a) => s + a.totalSufragantes);

    return AvanceData(
      totalJrv: jrvList.length,
      actasRegistradas: actasList.length,
      coordenadas: coord,
      totalizacion: totalizacion,
      totalBlancos: totalBlancos,
      totalNulos: totalNulos,
      totalSufragantes: totalSufragantes,
    );
  }
});

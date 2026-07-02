// dashboard_votos_providers.dart
import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/appwrite_config.dart';
import '../../../../core/network/appwrite_client.dart';
import '../../../../database/app_database.dart';

class VotosOrg {
  final String nombre;
  final int votos;
  VotosOrg({required this.nombre, required this.votos});
}

class DashboardVotosData {
  final List<VotosOrg> votosAlcalde;
  final List<VotosOrg> votosPrefecto;
  final int totalBlancosAlcalde;
  final int totalNulosAlcalde;
  final int totalBlancosPrefecto;
  final int totalNulosPrefecto;
  final int totalSufragantesAlcalde;
  final int totalSufragantesPrefecto;

  DashboardVotosData({
    required this.votosAlcalde,
    required this.votosPrefecto,
    required this.totalBlancosAlcalde,
    required this.totalNulosAlcalde,
    required this.totalBlancosPrefecto,
    required this.totalNulosPrefecto,
    required this.totalSufragantesAlcalde,
    required this.totalSufragantesPrefecto,
  });
}

/// Proveedor parametrizado por recintoId (si es null devuelve consolidado provincial)
final dashboardVotosProvider = FutureProvider.family<DashboardVotosData, String?>((ref, recintoId) async {
  final databases = ref.read(appwriteDatabasesProvider);
  final db = ref.read(appDatabaseProvider);

  try {
    // 1. Obtener actas filtradas opcionalmente por recintoId
    final List<String> queriesActas = [];
    if (recintoId != null) {
      queriesActas.add(Query.equal('recintoId', recintoId));
    }
    
    final actasResponse = await databases.listDocuments(
      databaseId: AppwriteConfig.databaseId,
      collectionId: AppwriteConfig.collectionActas,
      queries: queriesActas,
    );
    final actas = actasResponse.documents;

    // 2. Obtener detalles de actas
    final List<String> queriesDetalles = [Query.limit(100)];
    final detallesResponse = await databases.listDocuments(
      databaseId: AppwriteConfig.databaseId,
      collectionId: AppwriteConfig.collectionActaDetalle,
      queries: queriesDetalles,
    );
    
    // Mapeamos actas para rápido lookup de cargoElectoral
    final Map<String, String> actaCargoMap = {};
    int totalBlancosAlcalde = 0;
    int totalNulosAlcalde = 0;
    int totalSufragantesAlcalde = 0;
    int totalBlancosPrefecto = 0;
    int totalNulosPrefecto = 0;
    int totalSufragantesPrefecto = 0;

    for (final a in actas) {
      final id = a.$id;
      final cargo = a.data['cargoElectoral'] as String? ?? 'alcalde';
      actaCargoMap[id] = cargo;

      final blancos = (a.data['votosBlancos'] as num?)?.toInt() ?? 0;
      final nulos = (a.data['votosNulos'] as num?)?.toInt() ?? 0;
      final sufragantes = (a.data['totalSufragantes'] as num?)?.toInt() ?? 0;

      if (cargo == 'alcalde') {
        totalBlancosAlcalde += blancos;
        totalNulosAlcalde += nulos;
        totalSufragantesAlcalde += sufragantes;
      } else {
        totalBlancosPrefecto += blancos;
        totalNulosPrefecto += nulos;
        totalSufragantesPrefecto += sufragantes;
      }
    }

    final Map<String, int> totalesAlcalde = {};
    final Map<String, int> totalesPrefecto = {};

    for (final det in detallesResponse.documents) {
      final actaId = det.data['actaId'] as String? ?? '';
      
      // Si estamos filtrando por recinto, ignorar detalles de actas de otros recintos
      if (recintoId != null && !actaCargoMap.containsKey(actaId)) {
        continue;
      }

      final cargo = actaCargoMap[actaId] ?? (det.data['cargo'] as String? ?? 'alcalde');
      final nombre = det.data['nombreOrganizacion'] as String? ?? 'Desconocido';
      final votos = (det.data['votos'] as num?)?.toInt() ?? 0;

      if (cargo == 'alcalde') {
        totalesAlcalde[nombre] = (totalesAlcalde[nombre] ?? 0) + votos;
      } else {
        totalesPrefecto[nombre] = (totalesPrefecto[nombre] ?? 0) + votos;
      }
    }

    final votosAlcalde = totalesAlcalde.entries
        .map((e) => VotosOrg(nombre: e.key, votos: e.value))
        .toList()
      ..sort((a, b) => b.votos.compareTo(a.votos));

    final votosPrefecto = totalesPrefecto.entries
        .map((e) => VotosOrg(nombre: e.key, votos: e.value))
        .toList()
      ..sort((a, b) => b.votos.compareTo(a.votos));

    return DashboardVotosData(
      votosAlcalde: votosAlcalde,
      votosPrefecto: votosPrefecto,
      totalBlancosAlcalde: totalBlancosAlcalde,
      totalNulosAlcalde: totalNulosAlcalde,
      totalBlancosPrefecto: totalBlancosPrefecto,
      totalNulosPrefecto: totalNulosPrefecto,
      totalSufragantesAlcalde: totalSufragantesAlcalde,
      totalSufragantesPrefecto: totalSufragantesPrefecto,
    );
  } catch (_) {
    // Fallback local
    final actasList = await db.obtenerTodasLasActas();
    final detallesList = await db.obtenerTodosLosDetalles();

    final Map<String, String> actaCargoMap = {};
    int totalBlancosAlcalde = 0;
    int totalNulosAlcalde = 0;
    int totalSufragantesAlcalde = 0;
    int totalBlancosPrefecto = 0;
    int totalNulosPrefecto = 0;
    int totalSufragantesPrefecto = 0;

    for (final a in actasList) {
      final cargo = a.cargoElectoral;
      actaCargoMap[a.id] = cargo;

      if (cargo == 'alcalde') {
        totalBlancosAlcalde += a.votosBlancos.toInt();
        totalNulosAlcalde += a.votosNulos.toInt();
        totalSufragantesAlcalde += a.totalSufragantes.toInt();
      } else {
        totalBlancosPrefecto += a.votosBlancos.toInt();
        totalNulosPrefecto += a.votosNulos.toInt();
        totalSufragantesPrefecto += a.totalSufragantes.toInt();
      }
    }

    final Map<String, int> totalesAlcalde = {};
    final Map<String, int> totalesPrefecto = {};

    for (final det in detallesList) {
      final cargo = actaCargoMap[det.actaId] ?? 'alcalde';
      final nombre = det.nombreOrganizacion;
      final votos = det.votos;

      if (cargo == 'alcalde') {
        totalesAlcalde[nombre] = (totalesAlcalde[nombre] ?? 0) + votos;
      } else {
        totalesPrefecto[nombre] = (totalesPrefecto[nombre] ?? 0) + votos;
      }
    }

    final votosAlcalde = totalesAlcalde.entries
        .map((e) => VotosOrg(nombre: e.key, votos: e.value))
        .toList()
      ..sort((a, b) => b.votos.compareTo(a.votos));

    final votosPrefecto = totalesPrefecto.entries
        .map((e) => VotosOrg(nombre: e.key, votos: e.value))
        .toList()
      ..sort((a, b) => b.votos.compareTo(a.votos));

    return DashboardVotosData(
      votosAlcalde: votosAlcalde,
      votosPrefecto: votosPrefecto,
      totalBlancosAlcalde: totalBlancosAlcalde,
      totalNulosAlcalde: totalNulosAlcalde,
      totalBlancosPrefecto: totalBlancosPrefecto,
      totalNulosPrefecto: totalNulosPrefecto,
      totalSufragantesAlcalde: totalSufragantesAlcalde,
      totalSufragantesPrefecto: totalSufragantesPrefecto,
    );
  }
});

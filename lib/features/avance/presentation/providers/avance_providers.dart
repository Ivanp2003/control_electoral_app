import 'package:flutter_riverpod/flutter_riverpod.dart';
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

final avanceDataProvider = FutureProvider<AvanceData>((ref) async {
  final db = ref.read(appDatabaseProvider);

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

  final totalBlancos =
      actasList.fold(0, (sum, a) => sum + (a.votosBlancos));
  final totalNulos = actasList.fold(0, (sum, a) => sum + (a.votosNulos));
  final totalSufragantes =
      actasList.fold(0, (sum, a) => sum + (a.totalSufragantes));

  return AvanceData(
    totalJrv: jrvList.length,
    actasRegistradas: actasList.length,
    coordenadas: coord,
    totalizacion: totalizacion,
    totalBlancos: totalBlancos,
    totalNulos: totalNulos,
    totalSufragantes: totalSufragantes,
  );
});

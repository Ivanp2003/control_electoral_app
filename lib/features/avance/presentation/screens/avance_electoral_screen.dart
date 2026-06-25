import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/avance_providers.dart';

class AvanceElectoralScreen extends ConsumerWidget {
  const AvanceElectoralScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final avanceAsync = ref.watch(avanceDataProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0A1628),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F2442),
        title: const Text('Avance Electoral',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: avanceAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: Color(0xFF4A90D9)),
        ),
        error: (e, _) => Center(
          child: Text('Error: $e',
              style: const TextStyle(color: Colors.redAccent)),
        ),
        data: (data) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _seccion('MÉTRICAS GLOBALES', [
                _TarjetaResumen(
                    icon: Icons.how_to_vote_outlined,
                    label: 'Total JRV',
                    valor: '${data.totalJrv}'),
                _TarjetaResumen(
                    icon: Icons.description_outlined,
                    label: 'Actas Registradas',
                    valor: '${data.actasRegistradas}'),
                _TarjetaResumen(
                    icon: Icons.warning_amber_outlined,
                    label: 'Actas Faltantes',
                    valor: '${data.actasFaltantes}'),
                _TarjetaResumen(
                    icon: Icons.pie_chart_outline,
                    label: 'Progreso (2 actas/JRV)',
                    valor: '${data.porcentaje.toStringAsFixed(1)}%'),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: data.porcentaje / 100,
                    minHeight: 20,
                    backgroundColor: const Color(0xFF0F2442),
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Color(0xFF4A90D9)),
                  ),
                ),
                const SizedBox(height: 8),
                _TarjetaResumen(
                    icon: Icons.people_outline,
                    label: 'Total Sufragantes',
                    valor: '${data.totalSufragantes}'),
              ]),
              const SizedBox(height: 16),
              if (data.totalizacion.isNotEmpty)
                _seccion('TOTALIZACIÓN DE VOTOS', [
                  ...data.totalizacion
                      .map((t) => _filaOrg(t.nombre, t.votos)),
                  const Divider(color: Colors.white12, height: 20),
                  _filaOrg('Votos Blancos', data.totalBlancos,
                      color: Colors.amberAccent),
                  _filaOrg('Votos Nulos', data.totalNulos,
                      color: Colors.redAccent),
                ]),
              const SizedBox(height: 16),
              _seccion('COORDENADAS GPS', [
                if (data.coordenadas.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('No hay actas con coordenadas registradas.',
                        style: TextStyle(color: Colors.white54)),
                  )
                else
                  ...data.coordenadas.map((c) => Card(
                        color: const Color(0xFF0F2442),
                        margin: const EdgeInsets.only(bottom: 6),
                        child: ListTile(
                          dense: true,
                          leading: const Icon(Icons.location_on,
                              color: Color(0xFF4A90D9)),
                          title: Text('JRV: ${c.jrvId} — ${c.cargo}',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 13)),
                          subtitle: Text(
                              '${c.latitud.toStringAsFixed(6)}, ${c.longitud.toStringAsFixed(6)}',
                              style: const TextStyle(
                                  color: Colors.white38, fontSize: 11)),
                          trailing: Text('${c.totalSufragantes}',
                              style: const TextStyle(
                                  color: Colors.white54, fontSize: 12)),
                        ),
                      )),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _seccion(String titulo, List<Widget> hijos) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(titulo,
            style: const TextStyle(
                color: Colors.white38,
                fontSize: 11,
                letterSpacing: 1.5,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ...hijos,
      ],
    );
  }

  static Widget _filaOrg(String nombre, int votos, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(nombre,
                style: const TextStyle(color: Colors.white, fontSize: 14)),
          ),
          Text('$votos',
              style: TextStyle(
                  color: color ?? Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _TarjetaResumen extends StatelessWidget {
  final IconData icon;
  final String label;
  final String valor;
  const _TarjetaResumen(
      {required this.icon, required this.label, required this.valor});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF0F2442),
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF4A90D9).withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: const Color(0xFF4A90D9), size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(label,
                  style:
                      const TextStyle(color: Colors.white70, fontSize: 13)),
            ),
            Text(valor,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

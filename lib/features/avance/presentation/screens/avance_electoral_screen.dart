import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/avance_providers.dart';
import '../../../../core/presentation/widgets/theme_toggle_button.dart';

class AvanceElectoralScreen extends ConsumerWidget {
  const AvanceElectoralScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final avanceAsync = ref.watch(avanceDataProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final surfaceColor = theme.cardTheme.color ?? colorScheme.surface;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Avance Electoral',
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: const [
          ThemeToggleButton(),
        ],
      ),
      body: avanceAsync.when(
        loading: () => Center(
          child: CircularProgressIndicator(color: colorScheme.primary),
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
                    backgroundColor: surfaceColor,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(colorScheme.primary),
                  ),
                ),
                const SizedBox(height: 8),
                _TarjetaResumen(
                    icon: Icons.people_outline,
                    label: 'Total Sufragantes',
                    valor: '${data.totalSufragantes}'),
              ], theme),
              const SizedBox(height: 16),
              if (data.totalizacion.isNotEmpty)
                _seccion('TOTALIZACIÓN DE VOTOS', [
                  ...data.totalizacion
                      .map((t) => _filaOrg(t.nombre, t.votos, theme)),
                  const Divider(color: Colors.white12, height: 20),
                  _filaOrg('Votos Blancos', data.totalBlancos, theme,
                      color: Colors.amberAccent),
                  _filaOrg('Votos Nulos', data.totalNulos, theme,
                      color: Colors.redAccent),
                ], theme),
              const SizedBox(height: 16),
              _seccion('COORDENADAS GPS', [
                if (data.coordenadas.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text('No hay actas con coordenadas registradas.',
                        style: TextStyle(color: colorScheme.onSurface.withOpacity(0.54))),
                  )
                else
                  ...data.coordenadas.map((c) => Card(
                        color: surfaceColor,
                        margin: const EdgeInsets.only(bottom: 6),
                        child: ListTile(
                          dense: true,
                          leading: Icon(Icons.location_on,
                              color: colorScheme.primary),
                          title: Text('JRV: ${c.jrvId} — ${c.cargo}',
                              style: TextStyle(
                                  color: colorScheme.onSurface, fontSize: 13)),
                          subtitle: Text(
                              '${c.latitud.toStringAsFixed(6)}, ${c.longitud.toStringAsFixed(6)}',
                              style: TextStyle(
                                  color: colorScheme.onSurface.withOpacity(0.38), fontSize: 11)),
                          trailing: Text('${c.totalSufragantes}',
                              style: TextStyle(
                                  color: colorScheme.onSurface.withOpacity(0.54), fontSize: 12)),
                        ),
                      )),
              ], theme),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _seccion(String titulo, List<Widget> hijos, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(titulo,
            style: TextStyle(
                color: theme.colorScheme.onSurface.withOpacity(0.38),
                fontSize: 11,
                letterSpacing: 1.5,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ...hijos,
      ],
    );
  }

  static Widget _filaOrg(String nombre, int votos, ThemeData theme, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(nombre,
                style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 14)),
          ),
          Text('$votos',
              style: TextStyle(
                  color: color ?? theme.colorScheme.onSurface,
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final surfaceColor = theme.cardTheme.color ?? colorScheme.surface;

    return Card(
      color: surfaceColor,
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: colorScheme.primary, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(label,
                  style:
                      TextStyle(color: colorScheme.onSurface.withOpacity(0.7), fontSize: 13)),
            ),
            Text(valor,
                style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

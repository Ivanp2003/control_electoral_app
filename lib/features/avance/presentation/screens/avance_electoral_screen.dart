import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/avance_providers.dart';
import '../../../../core/presentation/widgets/theme_toggle_button.dart';

class AvanceElectoralScreen extends StatefulWidget {
  const AvanceElectoralScreen({super.key});

  @override
  State<AvanceElectoralScreen> createState() => _AvanceElectoralScreenState();
}

class _AvanceElectoralScreenState extends State<AvanceElectoralScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
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
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: colorScheme.primary,
              labelColor: colorScheme.primary,
              unselectedLabelColor: colorScheme.onSurface.withOpacity(0.6),
              tabs: const [
                Tab(icon: Icon(Icons.person), text: 'Alcalde'),
                Tab(icon: Icon(Icons.people), text: 'Prefecto'),
              ],
            ),
          ),
          body: avanceAsync.when(
            loading: () => Center(
              child: CircularProgressIndicator(color: colorScheme.primary),
            ),
            error: (e, _) => Center(
              child: Text('Error: $e',
                  style: const TextStyle(color: Colors.redAccent)),
            ),
            data: (data) {
              final coordenadasAlcalde = data.coordenadas.where((c) => c.cargo.toLowerCase() == 'alcalde').toList();
              final coordenadasPrefecto = data.coordenadas.where((c) => c.cargo.toLowerCase() == 'prefecto').toList();
              
              final actasAlcalde = data.coordenadas.where((c) => c.cargo.toLowerCase() == 'alcalde').length;
              final actasPrefecto = data.coordenadas.where((c) => c.cargo.toLowerCase() == 'prefecto').length;
              
              final pctAlcalde = data.totalJrv > 0 ? (actasAlcalde / data.totalJrv) * 100 : 0.0;
              final pctPrefecto = data.totalJrv > 0 ? (actasPrefecto / data.totalJrv) * 100 : 0.0;

              return TabBarView(
                controller: _tabController,
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeaderCard('Métricas de Avance', 'Alcalde', pctAlcalde, colorScheme, surfaceColor),
                        const SizedBox(height: 24),
                        _buildMetricsGrid(
                          totalJrv: data.totalJrv,
                          registradas: actasAlcalde,
                          faltantes: data.totalJrv - actasAlcalde,
                          colorScheme: colorScheme,
                          surfaceColor: surfaceColor,
                        ),
                        const SizedBox(height: 28),
                        _seccion('COORDENADAS GPS (ALCALDE)', [
                          if (coordenadasAlcalde.isEmpty)
                            _buildEmptyState('No hay coordenadas de alcalde registradas.', colorScheme)
                          else
                            ...coordenadasAlcalde.map((c) => _buildGpsCard(c, colorScheme, surfaceColor)),
                        ], theme),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeaderCard('Métricas de Avance', 'Prefecto', pctPrefecto, colorScheme, surfaceColor),
                        const SizedBox(height: 24),
                        _buildMetricsGrid(
                          totalJrv: data.totalJrv,
                          registradas: actasPrefecto,
                          faltantes: data.totalJrv - actasPrefecto,
                          colorScheme: colorScheme,
                          surfaceColor: surfaceColor,
                        ),
                        const SizedBox(height: 28),
                        _seccion('COORDENADAS GPS (PREFECTO)', [
                          if (coordenadasPrefecto.isEmpty)
                            _buildEmptyState('No hay coordenadas de prefecto registradas.', colorScheme)
                          else
                            ...coordenadasPrefecto.map((c) => _buildGpsCard(c, colorScheme, surfaceColor)),
                        ], theme),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        );
      }
    );
  }

  Widget _buildHeaderCard(String title, String dignidad, double porcentaje, ColorScheme colorScheme, Color surfaceColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colorScheme.primary, colorScheme.secondary.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 1.2),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  dignidad.toUpperCase(),
                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                porcentaje.toStringAsFixed(1),
                style: const TextStyle(color: Colors.white, fontSize: 44, fontWeight: FontWeight.w900),
              ),
              const SizedBox(width: 4),
              const Text(
                '%',
                style: TextStyle(color: Colors.white70, fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: porcentaje / 100,
              minHeight: 8,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsGrid({
    required int totalJrv,
    required int registradas,
    required int faltantes,
    required ColorScheme colorScheme,
    required Color surfaceColor,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = (constraints.maxWidth - 16) / 2;
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _buildMetricGridCard(
              width: width,
              icon: Icons.how_to_vote,
              label: 'Total de Mesas',
              value: '$totalJrv',
              iconColor: colorScheme.primary,
              surfaceColor: surfaceColor,
            ),
            _buildMetricGridCard(
              width: width,
              icon: Icons.assignment_turned_in,
              label: 'Registradas',
              value: '$registradas',
              iconColor: Colors.green,
              surfaceColor: surfaceColor,
            ),
            _buildMetricGridCard(
              width: width,
              icon: Icons.warning_amber_rounded,
              label: 'Faltantes',
              value: '$faltantes',
              iconColor: Colors.orange,
              surfaceColor: surfaceColor,
            ),
            _buildMetricGridCard(
              width: width,
              icon: Icons.lock_clock,
              label: 'Estado',
              value: faltantes == 0 ? 'Completo' : 'En Proceso',
              iconColor: faltantes == 0 ? Colors.green : Colors.blueGrey,
              surfaceColor: surfaceColor,
            ),
          ],
        );
      },
    );
  }

  Widget _buildMetricGridCard({
    required double width,
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
    required Color surfaceColor,
  }) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: iconColor.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildGpsCard(ActaGps c, ColorScheme colorScheme, Color surfaceColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.onSurface.withOpacity(0.05)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: colorScheme.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(Icons.location_on, color: colorScheme.primary),
        ),
        title: Text(
          'JRV: ${c.jrvId}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            '${c.latitud.toStringAsFixed(6)}, ${c.longitud.toStringAsFixed(6)}',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '${c.totalSufragantes} Votos',
            style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message, ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(Icons.map_outlined, size: 48, color: colorScheme.onSurface.withOpacity(0.15)),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: colorScheme.onSurface.withOpacity(0.4), fontSize: 14),
          ),
        ],
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

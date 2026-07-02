import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../database/app_database.dart';
import '../providers/dashboard_votos_providers.dart';
import '../../../../core/presentation/widgets/theme_toggle_button.dart';

class DashboardVotosScreen extends ConsumerStatefulWidget {
  const DashboardVotosScreen({super.key});

  @override
  ConsumerState<DashboardVotosScreen> createState() => _DashboardVotosScreenState();
}

class _DashboardVotosScreenState extends ConsumerState<DashboardVotosScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  RecintosLocalData? _recintoSeleccionado;
  List<RecintosLocalData> _recintos = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _cargarRecintos();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _cargarRecintos() async {
    final db = ref.read(appDatabaseProvider);
    final list = await db.obtenerTodasLasRecintos();
    setState(() {
      _recintos = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final surfaceColor = theme.cardTheme.color ?? colorScheme.surface;

    final votosAsync = ref.watch(dashboardVotosProvider(_recintoSeleccionado?.id));

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Dashboard de Votos', style: TextStyle(fontWeight: FontWeight.bold)),
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
      body: Column(
        children: [
          // Selector de Recinto
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: colorScheme.surface,
            child: DropdownButtonFormField<RecintosLocalData?>(
              value: _recintoSeleccionado,
              dropdownColor: surfaceColor,
              style: TextStyle(color: colorScheme.onSurface),
              decoration: InputDecoration(
                labelText: 'Filtrar por Recinto',
                labelStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.54)),
                filled: true,
                fillColor: theme.scaffoldBackgroundColor,
                border: const OutlineInputBorder(borderSide: BorderSide.none),
              ),
              items: [
                const DropdownMenuItem<RecintosLocalData?>(
                  value: null,
                  child: Text('Todos los Recintos (Provincial)'),
                ),
                ..._recintos.map((r) => DropdownMenuItem(
                      value: r,
                      child: Text(r.nombre),
                    )),
              ],
              onChanged: (val) {
                setState(() {
                  _recintoSeleccionado = val;
                });
              },
            ),
          ),
          const SizedBox(height: 8),
          
          Expanded(
            child: votosAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error al cargar votos: $e', style: TextStyle(color: colorScheme.error))),
              data: (data) {
                return TabBarView(
                  controller: _tabController,
                  children: [
                    _buildDignidadTab(
                      votos: data.votosAlcalde,
                      blancos: data.totalBlancosAlcalde,
                      nulos: data.totalNulosAlcalde,
                      sufragantes: data.totalSufragantesAlcalde,
                      colorScheme: colorScheme,
                      surfaceColor: surfaceColor,
                    ),
                    _buildDignidadTab(
                      votos: data.votosPrefecto,
                      blancos: data.totalBlancosPrefecto,
                      nulos: data.totalNulosPrefecto,
                      sufragantes: data.totalSufragantesPrefecto,
                      colorScheme: colorScheme,
                      surfaceColor: surfaceColor,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDignidadTab({
    required List<VotosOrg> votos,
    required int blancos,
    required int nulos,
    required int sufragantes,
    required ColorScheme colorScheme,
    required Color surfaceColor,
  }) {
    if (votos.isEmpty && blancos == 0 && nulos == 0) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.analytics_outlined, size: 64, color: colorScheme.onSurface.withOpacity(0.15)),
            const SizedBox(height: 16),
            Text('No hay actas registradas para esta dignidad', style: TextStyle(color: colorScheme.onSurface.withOpacity(0.5))),
          ],
        ),
      );
    }

    final totalVotosValidos = votos.fold(0, (s, v) => s + v.votos);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Consolidado numérico
        Card(
          color: surfaceColor,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _metricCol('Sufragantes', '$sufragantes', colorScheme.primary),
                _metricCol('Blancos', '$blancos', Colors.grey),
                _metricCol('Nulos', '$nulos', Colors.redAccent),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        Text(
          'VOTOS POR ORGANIZACIÓN POLÍTICA',
          style: TextStyle(
            color: colorScheme.onSurface.withOpacity(0.4),
            fontSize: 11,
            letterSpacing: 1.5,
            fontWeight: FontWeight.bold
          ),
        ),
        const SizedBox(height: 8),

        Card(
          color: surfaceColor,
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: votos.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final item = votos[index];
              final porcentaje = totalVotosValidos > 0 ? (item.votos / totalVotosValidos) * 100 : 0.0;
              
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            item.nombre,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ),
                        Text(
                          '${item.votos} votos',
                          style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: LinearProgressIndicator(
                            value: totalVotosValidos > 0 ? item.votos / totalVotosValidos : 0.0,
                            backgroundColor: colorScheme.onSurface.withOpacity(0.1),
                            color: colorScheme.primary,
                            minHeight: 6,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '${porcentaje.toStringAsFixed(1)}%',
                          style: TextStyle(fontSize: 12, color: colorScheme.onSurface.withOpacity(0.6)),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _metricCol(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: color.withOpacity(0.7))),
      ],
    );
  }
}

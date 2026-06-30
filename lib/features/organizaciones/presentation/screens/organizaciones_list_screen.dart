import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/organizaciones_providers.dart';
import '../../../../core/presentation/widgets/theme_toggle_button.dart';

/// organizaciones_list_screen.dart
///
/// Responsabilidad Única: Mostrar las organizaciones políticas agrupadas por
/// cargo (Alcalde / Prefecto) en tabs separados.
/// Estados: loading, success, error, empty.

class OrganizacionesListScreen extends ConsumerWidget {
  const OrganizacionesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: const Text(
            'Organizaciones Políticas',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: const [
            ThemeToggleButton(),
          ],
          bottom: TabBar(
            indicatorColor: colorScheme.primary,
            labelColor: colorScheme.primary,
            unselectedLabelColor: colorScheme.onSurface.withOpacity(0.54),
            tabs: const [
              Tab(text: 'Alcalde', icon: Icon(Icons.account_balance_outlined)),
              Tab(text: 'Prefecto', icon: Icon(Icons.domain_outlined)),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _OrganizacionesTab(cargo: 'alcalde'),
            _OrganizacionesTab(cargo: 'prefecto'),
          ],
        ),
      ),
    );
  }
}

class _OrganizacionesTab extends ConsumerWidget {
  final String cargo;
  const _OrganizacionesTab({required this.cargo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orgsAsync = ref.watch(organizacionesPorCargoProvider(cargo));
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final surfaceColor = theme.cardTheme.color ?? colorScheme.surface;

    return orgsAsync.when(
      loading: () => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: colorScheme.primary),
            const SizedBox(height: 16),
            Text('Cargando organizaciones...',
                style: TextStyle(color: colorScheme.onSurface.withOpacity(0.7))),
          ],
        ),
      ),
      error: (e, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.wifi_off_rounded,
                  size: 56, color: Colors.redAccent),
              const SizedBox(height: 16),
              Text('Error al cargar organizaciones',
                  style: TextStyle(
                      color: colorScheme.onSurface,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(e.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: colorScheme.onSurface.withOpacity(0.54), fontSize: 13)),
            ],
          ),
        ),
      ),
      data: (orgs) {
        if (orgs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.how_to_vote_outlined,
                    size: 64, color: colorScheme.onSurface.withOpacity(0.24)),
                const SizedBox(height: 16),
                Text('Sin organizaciones registradas.',
                    style: TextStyle(color: colorScheme.onSurface.withOpacity(0.54), fontSize: 15)),
                const SizedBox(height: 8),
                Text('Ejecuta el Seeder para cargar los datos iniciales.',
                    style: TextStyle(color: colorScheme.onSurface.withOpacity(0.38), fontSize: 12)),
              ],
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: orgs.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, i) {
            final org = orgs[i];
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colorScheme.onSurface.withOpacity(0.12)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        org.lista != null ? '${org.lista}' : '${i + 1}',
                        style: TextStyle(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          org.nombre,
                          style: TextStyle(
                              color: colorScheme.onSurface,
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                        if (org.candidatoPrincipal != null && org.candidatoPrincipal!.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Principal: ${org.candidatoPrincipal}',
                            style: TextStyle(
                                color: colorScheme.onSurface.withOpacity(0.6),
                                fontSize: 13),
                          ),
                        ],
                        if (org.candidatoSecundario != null && org.candidatoSecundario!.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            'Alterno: ${org.candidatoSecundario}',
                            style: TextStyle(
                                color: colorScheme.onSurface.withOpacity(0.5),
                                fontSize: 12),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

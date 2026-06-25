import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/organizaciones_providers.dart';

/// organizaciones_list_screen.dart
///
/// Responsabilidad Única: Mostrar las organizaciones políticas agrupadas por
/// cargo (Alcalde / Prefecto) en tabs separados.
/// Estados: loading, success, error, empty.

class OrganizacionesListScreen extends ConsumerWidget {
  const OrganizacionesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFF0A1628),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0F2442),
          title: const Text(
            'Organizaciones Políticas',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          bottom: const TabBar(
            indicatorColor: Color(0xFF4A90D9),
            labelColor: Color(0xFF4A90D9),
            unselectedLabelColor: Colors.white54,
            tabs: [
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

    return orgsAsync.when(
      loading: () => const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Color(0xFF4A90D9)),
            SizedBox(height: 16),
            Text('Cargando organizaciones...',
                style: TextStyle(color: Colors.white70)),
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
              const Text('Error al cargar organizaciones',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(e.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white54, fontSize: 13)),
            ],
          ),
        ),
      ),
      data: (orgs) {
        if (orgs.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.how_to_vote_outlined,
                    size: 64, color: Colors.white24),
                SizedBox(height: 16),
                Text('Sin organizaciones registradas.',
                    style: TextStyle(color: Colors.white54, fontSize: 15)),
                SizedBox(height: 8),
                Text('Ejecuta el Seeder para cargar los datos iniciales.',
                    style: TextStyle(color: Colors.white38, fontSize: 12)),
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
                color: const Color(0xFF0F2442),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4A90D9).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        '${i + 1}',
                        style: const TextStyle(
                            color: Color(0xFF4A90D9),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      org.nombre,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_roles.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../domain/entities/acta.dart';
import '../providers/actas_providers.dart';

class MisActasScreen extends ConsumerWidget {
  const MisActasScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usuario = ref.watch(currentUserProvider);
    if (usuario == null) {
      return const Scaffold(
        backgroundColor: Color(0xFF0A1628),
        body: Center(child: Text('No autenticado',
            style: TextStyle(color: Colors.white54))),
      );
    }

    final repository = ref.watch(actasRepositoryProvider);
    final future = usuario.rol == AppRole.coordinadorProvincial
        ? repository.obtenerPorRecinto('')
        : usuario.rol == AppRole.coordinadorRecinto
            ? repository.obtenerPorRecinto('')
            : repository.obtenerPorVeedor(usuario.id);

    return Scaffold(
      backgroundColor: const Color(0xFF0A1628),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F2442),
        title: const Text('Mis Actas',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(
                color: Color(0xFF4A90D9)));
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text('Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.redAccent)),
              ),
            );
          }
          final result = snapshot.data;
          if (result == null) {
            return const Center(child: Text('Sin datos',
                style: TextStyle(color: Colors.white54)));
          }
          return result.fold(
            (failure) => Center(
              child: Text(failure.message,
                  style: const TextStyle(color: Colors.redAccent)),
            ),
            (actas) {
              if (actas.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.description_outlined,
                          size: 64, color: Colors.white24),
                      SizedBox(height: 16),
                      Text('No hay actas registradas.',
                          style: TextStyle(
                              color: Colors.white54, fontSize: 16)),
                    ],
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: actas.length,
                itemBuilder: (context, index) =>
                    _ActaCard(acta: actas[index]),
              );
            },
          );
        },
      ),
    );
  }
}

class _ActaCard extends StatelessWidget {
  final Acta acta;
  const _ActaCard({required this.acta});

  @override
  Widget build(BuildContext context) {
    final cargoLabel =
        acta.cargoElectoral == 'alcalde' ? 'Alcalde' : 'Prefecto';
    return Card(
      color: const Color(0xFF0F2442),
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(cargoLabel,
                    style: const TextStyle(
                        color: Color(0xFF4A90D9),
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: acta.synced
                        ? Colors.green.withOpacity(0.15)
                        : Colors.orange.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    acta.synced ? 'Sincronizado' : 'Pendiente',
                    style: TextStyle(
                      color: acta.synced ? Colors.greenAccent : Colors.orange,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Total sufragantes: ${acta.totalSufragantes}',
                style: const TextStyle(color: Colors.white70, fontSize: 13)),
            if (acta.editadoPor != null)
              Text('Editado por: ${acta.editadoPor}',
                  style: const TextStyle(
                      color: Colors.white38, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

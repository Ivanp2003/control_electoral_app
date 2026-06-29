import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_roles.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../domain/entities/acta.dart';
import '../providers/actas_providers.dart';
import '../../../../database/app_database.dart';
import '../../../sync/presentation/widgets/sync_indicator.dart';

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

    final db = ref.watch(appDatabaseProvider);
    // Para la vista "Mis Actas", mostramos todas las actas registradas localmente.
    final future = db.select(db.actasLocal).get();

    return Scaffold(
      backgroundColor: const Color(0xFF0A1628),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F2442),
        title: const Text('Mis Actas',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: const [SyncIndicator()],
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
          final actas = snapshot.data;
          if (actas == null || actas.isEmpty) {
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
            itemBuilder: (context, index) {
              final actaLocal = actas[index];
              // Mapeo simple de ActaLocal a Acta para la tarjeta
              final acta = Acta(
                id: actaLocal.id,
                jrvId: actaLocal.jrvId,
                cargoElectoral: actaLocal.cargoElectoral,
                totalSufragantes: actaLocal.totalSufragantes,
                votosBlancos: actaLocal.votosBlancos,
                votosNulos: actaLocal.votosNulos,
                organizaciones: const [], // No se necesitan en la tarjeta
                latitud: actaLocal.latitud,
                longitud: actaLocal.longitud,
                creadoPor: actaLocal.creadoPor,
                synced: actaLocal.synced,
              );
              return _ActaCard(acta: acta);
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_roles.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../domain/entities/acta.dart';
import '../../domain/entities/organizacion_con_votos.dart';
import '../providers/actas_providers.dart';
import '../../../../database/app_database.dart';
import '../../../sync/presentation/widgets/sync_indicator.dart';
import '../../../../core/presentation/widgets/theme_toggle_button.dart';

import '../../../recintos/presentation/providers/jrv_context_provider.dart';

class MisActasScreen extends ConsumerWidget {
  const MisActasScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usuario = ref.watch(currentUserProvider);
    if (usuario == null) {
      return Scaffold(
        body: Center(child: Text('No autenticado',
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.54)))),
      );
    }

    final db = ref.watch(appDatabaseProvider);
    // Para la vista "Mis Actas", escuchamos los cambios en tiempo real
    final stream = db.select(db.actasLocal).watch();

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Mis Actas',
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: const [
          ThemeToggleButton(),
          SyncIndicator(),
        ],
      ),
      body: StreamBuilder(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(
                color: colorScheme.primary));
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
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.description_outlined,
                      size: 64, color: colorScheme.onSurface.withOpacity(0.24)),
                  const SizedBox(height: 16),
                  Text('No hay actas registradas.',
                      style: TextStyle(
                          color: colorScheme.onSurface.withOpacity(0.54), fontSize: 16)),
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

class _ActaCard extends ConsumerWidget {
  final Acta acta;
  const _ActaCard({required this.acta});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final surfaceColor = theme.cardTheme.color ?? colorScheme.surface;

    final cargoLabel =
        acta.cargoElectoral == 'alcalde' ? 'Alcalde' : 'Prefecto';
        
    final contextoAsync = ref.watch(jrvContextProvider(acta.jrvId));

    return Card(
      color: surfaceColor,
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () async {
          final db = ref.read(appDatabaseProvider);
          final detallesLocal = await db.obtenerDetallePorActa(acta.id);
          final organizacionesConVotos = detallesLocal.map((d) => OrganizacionConVotos(
            organizacionId: d.organizacionId,
            nombreOrganizacion: d.nombreOrganizacion,
            votos: d.votos,
          )).toList();

          final actaCompleta = acta.copyWith(organizaciones: organizacionesConVotos);
          if (context.mounted) {
            context.push('/actas/registrar', extra: actaCompleta);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(cargoLabel,
                      style: TextStyle(
                          color: colorScheme.primary,
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
              contextoAsync.when(
                data: (contexto) => Text(contexto,
                    style: TextStyle(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                        fontSize: 14)),
                loading: () => const Text('Cargando contexto...',
                    style: TextStyle(fontSize: 14)),
                error: (e, _) => const Text('Error al cargar contexto',
                    style: TextStyle(fontSize: 14, color: Colors.red)),
              ),
              const SizedBox(height: 8),
              Text('Total sufragantes: \${acta.totalSufragantes}',
                  style: TextStyle(color: colorScheme.onSurface.withOpacity(0.7), fontSize: 13)),
              if (acta.editadoPor != null)
                Text('Editado por: \${acta.editadoPor}',
                    style: TextStyle(
                        color: colorScheme.onSurface.withOpacity(0.38), fontSize: 11)),
            ],
          ),
        ),
      ),
    );
  }
}

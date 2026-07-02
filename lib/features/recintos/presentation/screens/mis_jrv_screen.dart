import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_roles.dart';
import '../../../../database/app_database.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../actas/domain/entities/acta.dart';
import '../../../actas/domain/entities/organizacion_con_votos.dart';
import '../../domain/entities/jrv.dart';
import '../../../../core/presentation/widgets/theme_toggle_button.dart';
import '../../../sync/presentation/widgets/sync_indicator.dart';

import '../../../usuarios/data/repositories/usuarios_repository_impl.dart';

// Provider para listar las JRVs asignadas al veedor con sincronización online
final _misJrvsProvider = FutureProvider.autoDispose<List<Jrv>>((ref) async {
  final usuario = ref.watch(currentUserProvider);
  if (usuario == null) return [];

  final userRepo = ref.watch(usuarioRepositoryProvider);
  final db = ref.watch(appDatabaseProvider);

  // 1. Sincronizar asignaciones online
  await userRepo.obtenerAsignacionesVeedor(usuario.id);

  // 2. Resolver asignaciones guardadas en Drift
  final asignaciones = await (db.select(db.veedorJrvLocal)
    ..where((t) => t.veedorId.equals(usuario.id)))
    .get();
    
  if (asignaciones.isEmpty) return [];
  
  final jrvIds = asignaciones.map((a) => a.jrvId).toList();
  
  final jrvsLocal = await (db.select(db.jrvLocal)
    ..where((t) => t.id.isIn(jrvIds)))
    .get();
    
  return jrvsLocal.map((j) => Jrv(id: j.id, codigo: j.codigo, recintoId: j.recintoId)).toList();
});

// Provider para obtener el nombre del recinto por id
final _nombreRecintoProvider = FutureProvider.family.autoDispose<String, String>((ref, recintoId) async {
  final db = ref.watch(appDatabaseProvider);
  final recinto = await (db.select(db.recintosLocal)
    ..where((t) => t.id.equals(recintoId)))
    .getSingleOrNull();
  return recinto?.nombre ?? 'Recinto desconocido';
});

// Provider para obtener actas de una JRV específica
final _actasPorJrvProvider = FutureProvider.family.autoDispose<List<ActasLocalData>, String>((ref, jrvId) async {
  final db = ref.watch(appDatabaseProvider);
  return await db.obtenerActasPorJrvLocal(jrvId);
});

class MisJrvsScreen extends ConsumerWidget {
  const MisJrvsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usuario = ref.watch(currentUserProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (usuario == null) {
      return Scaffold(
        body: Center(child: Text('No autenticado', style: TextStyle(color: colorScheme.onSurface.withOpacity(0.54)))),
      );
    }

    if (usuario.rol != AppRole.veedor) {
      return Scaffold(
        appBar: AppBar(title: const Text('Acceso Denegado')),
        body: Center(child: Text('Rol inválido para esta pantalla', style: TextStyle(color: colorScheme.onSurface.withOpacity(0.54)))),
      );
    }

    final jrvsAsync = ref.watch(_misJrvsProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Mis JRVs Asignadas', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualizar Asignaciones',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Actualizando mesas asignadas...')),
              );
              ref.invalidate(_misJrvsProvider);
            },
          ),
          const ThemeToggleButton(),
          const SyncIndicator(),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
              ]
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tus Mesas Electorales', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: colorScheme.primary)),
                const SizedBox(height: 8),
                Text('Aquí se muestran las JRV a las que has sido asignado como veedor.', 
                  style: TextStyle(fontSize: 14, color: colorScheme.onSurface.withOpacity(0.7))),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: jrvsAsync.when(
              data: (jrvs) {
                if (jrvs.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.how_to_vote_outlined, size: 64, color: colorScheme.onSurface.withOpacity(0.2)),
                          const SizedBox(height: 16),
                          Text('No tienes JRVs asignadas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
                          const SizedBox(height: 8),
                          Text('Contacta al Coordinador de Recinto para que te asigne a una mesa.',
                               textAlign: TextAlign.center,
                               style: TextStyle(color: colorScheme.onSurface.withOpacity(0.6))),
                        ],
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: jrvs.length,
                  itemBuilder: (context, index) {
                    final jrv = jrvs[index];
                    return _JrvCardVeedor(jrv: jrv);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error al cargar JRVs', style: TextStyle(color: colorScheme.error))),
            ),
          ),
        ],
      ),
    );
  }
}

class _JrvCardVeedor extends ConsumerWidget {
  final Jrv jrv;
  const _JrvCardVeedor({required this.jrv});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    final actasAsync = ref.watch(_actasPorJrvProvider(jrv.id));
    final nombreRecintoAsync = ref.watch(_nombreRecintoProvider(jrv.recintoId));

    return Card(
      elevation: 0,
      color: colorScheme.surface,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colorScheme.onSurface.withOpacity(0.1)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Cabecera: Código + Recinto + Badge ---
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: colorScheme.primary.withOpacity(0.1),
                  foregroundColor: colorScheme.primary,
                  child: const Icon(Icons.how_to_vote),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(jrv.codigo, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 2),
                      nombreRecintoAsync.when(
                        data: (nombre) => Text(
                          nombre,
                          style: TextStyle(fontSize: 12, color: colorScheme.onSurface.withOpacity(0.55)),
                        ),
                        loading: () => const SizedBox(height: 12, width: 80, child: LinearProgressIndicator()),
                        error: (_, __) => const SizedBox(),
                      ),
                    ],
                  ),
                ),
                actasAsync.when(
                  data: (actas) {
                    final completado = actas.any((a) => a.cargoElectoral == 'alcalde') &&
                                       actas.any((a) => a.cargoElectoral == 'prefecto');
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: completado
                            ? Colors.green.withOpacity(0.1)
                            : (actas.isNotEmpty ? Colors.orange.withOpacity(0.1) : Colors.grey.withOpacity(0.1)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        completado ? 'Completado' : '${actas.length}/2 Actas',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: completado ? Colors.green : (actas.isNotEmpty ? Colors.orange : colorScheme.onSurface.withOpacity(0.5)),
                        ),
                      ),
                    );
                  },
                  loading: () => const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                  error: (_, __) => const SizedBox(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 12),
            // --- Botones por cargo: Alcalde y Prefecto ---
            actasAsync.when(
              data: (actas) {
                final actaAlcalde = actas.where((a) => a.cargoElectoral == 'alcalde').firstOrNull;
                final actaPrefecto = actas.where((a) => a.cargoElectoral == 'prefecto').firstOrNull;
                return Column(
                  children: [
                    _ActaCargoButton(
                      label: 'Alcalde',
                      actaExistente: actaAlcalde,
                      colorScheme: colorScheme,
                    ),
                    const SizedBox(height: 8),
                    _ActaCargoButton(
                      label: 'Prefecto',
                      actaExistente: actaPrefecto,
                      colorScheme: colorScheme,
                    ),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActaCargoButton extends ConsumerWidget {
  final String label;
  final ActasLocalData? actaExistente;
  final ColorScheme colorScheme;

  const _ActaCargoButton({
    required this.label,
    required this.actaExistente,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool tiene = actaExistente != null;
    final color = tiene ? Colors.orange : colorScheme.primary;

    return SizedBox(
      width: double.infinity,
      height: 44,
      child: OutlinedButton.icon(
        onPressed: () async {
          Acta? extra;
          if (tiene) {
            final db = ref.read(appDatabaseProvider);
            final detallesLocal = await db.obtenerDetallePorActa(actaExistente!.id);
            final organizacionesConVotos = detallesLocal.map((d) => OrganizacionConVotos(
              organizacionId: d.organizacionId,
              nombreOrganizacion: d.nombreOrganizacion,
              votos: d.votos,
            )).toList();

            extra = Acta(
              id: actaExistente!.id,
              jrvId: actaExistente!.jrvId,
              cargoElectoral: actaExistente!.cargoElectoral,
              totalSufragantes: actaExistente!.totalSufragantes,
              votosBlancos: actaExistente!.votosBlancos,
              votosNulos: actaExistente!.votosNulos,
              organizaciones: organizacionesConVotos,
              latitud: actaExistente!.latitud,
              longitud: actaExistente!.longitud,
              creadoPor: actaExistente!.creadoPor,
              synced: actaExistente!.synced,
            );
          }
          if (context.mounted) {
            context.push('/actas/registrar', extra: extra);
          }
        },
        icon: Icon(tiene ? Icons.edit_outlined : Icons.add_a_photo, size: 18),
        label: Text(tiene ? 'Corregir acta de $label' : 'Registrar acta de $label'),
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          side: BorderSide(color: color),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}

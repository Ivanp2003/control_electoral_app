import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_roles.dart';
import '../../../../database/app_database.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../actas/presentation/providers/actas_providers.dart';
import '../../../actas/domain/entities/acta.dart';
import '../../../actas/domain/entities/organizacion_con_votos.dart';
import '../providers/recintos_providers.dart';
import '../../data/repositories/recintos_repository_impl.dart';
import '../../domain/entities/jrv.dart';
import '../../domain/entities/recinto.dart';
import '../../../../core/presentation/widgets/theme_toggle_button.dart';
import '../../../sync/presentation/widgets/sync_indicator.dart';



// Provider para listar las JRVs del recinto asignado
final _jrvsPorRecintoProvider = FutureProvider.family.autoDispose<List<Jrv>, String>((ref, recintoId) async {
  final repository = ref.watch(recintosRepositoryProvider);
  final result = await repository.obtenerJrvPorRecinto(recintoId);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (jrvs) => jrvs,
  );
});

// Provider para resolver el recinto asignado al coordinador actual de forma reactiva e infalible
final _miRecintoProvider = FutureProvider.autoDispose<Recinto?>((ref) async {
  final usuario = ref.watch(currentUserProvider);
  if (usuario == null || usuario.rol != AppRole.coordinadorRecinto) return null;

  final db = ref.watch(appDatabaseProvider);
  
  // 1. Intentar localmente en Drift por coordinadorId == usuario.id
  final recintoLocal = await (db.select(db.recintosLocal)..where((t) => t.coordinadorId.equals(usuario.id))).getSingleOrNull();
  if (recintoLocal != null) {
    return Recinto(
      id: recintoLocal.id,
      nombre: recintoLocal.nombre,
      parroquiaId: recintoLocal.parroquiaId,
      direccion: recintoLocal.direccion,
      latRef: recintoLocal.latRef,
      lonRef: recintoLocal.lonRef,
      coordinadorId: recintoLocal.coordinadorId,
    );
  }

  // 2. Si el usuario tiene recintoId en su perfil de la sesión, cargar ese directamente
  if (usuario.recintoId != null && usuario.recintoId!.isNotEmpty) {
    final repository = ref.watch(recintosRepositoryProvider);
    final result = await repository.obtenerRecintoPorId(usuario.recintoId!);
    return result.fold((l) => null, (r) => r);
  }

  return null;
});
// Provider para obtener actas de una JRV específica de forma reactiva y sincronizada online
final _actasPorJrvProvider = FutureProvider.family.autoDispose<List<Acta>, String>((ref, jrvId) async {
  final repo = ref.watch(actasRepositoryProvider);
  final result = await repo.obtenerActasPorJrv(jrvId);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (actas) => actas,
  );
});

final _veedorPorJrvProvider = FutureProvider.family.autoDispose<String?, String>((ref, jrvId) async {
  final db = ref.watch(appDatabaseProvider);
  final veedorJrv = await (db.select(db.veedorJrvLocal)..where((t) => t.jrvId.equals(jrvId))).getSingleOrNull();
  if (veedorJrv == null) return null;
  
  return 'Asignado (ID: ${veedorJrv.veedorId.substring(0, 5)}...)';
});

class MiRecintoScreen extends ConsumerWidget {
  const MiRecintoScreen({super.key});

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

    if (usuario.rol != AppRole.coordinadorRecinto) {
      return Scaffold(
        appBar: AppBar(title: const Text('Acceso Denegado')),
        body: Center(child: Text('Rol inválido para esta pantalla', style: TextStyle(color: colorScheme.onSurface.withOpacity(0.54)))),
      );
    }

    final miRecintoAsync = ref.watch(_miRecintoProvider);

    return miRecintoAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(
        appBar: AppBar(title: const Text('Mi Recinto')),
        body: Center(child: Text('Error al cargar recinto: $e', style: TextStyle(color: colorScheme.error))),
      ),
      data: (recinto) {
        if (recinto == null) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Mi Recinto'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Actualizar Datos',
                  onPressed: () async {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Actualizando información de tu usuario y recinto...')),
                    );
                    await ref.read(authNotifierProvider.notifier).verificarSesionActiva();
                    ref.invalidate(_miRecintoProvider);
                  },
                ),
              ],
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_off, size: 64, color: colorScheme.error.withOpacity(0.5)),
                    const SizedBox(height: 16),
                    Text('No tienes un recinto asignado.', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
                    const SizedBox(height: 8),
                    Text('Contacta al Coordinador Provincial para que te asigne a un Recinto.', 
                         textAlign: TextAlign.center,
                         style: TextStyle(color: colorScheme.onSurface.withOpacity(0.6))),
                  ],
                ),
              ),
            ),
          );
        }

        final jrvsAsync = ref.watch(_jrvsPorRecintoProvider(recinto.id));

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            title: const Text('Mi Recinto', style: TextStyle(fontWeight: FontWeight.bold)),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                tooltip: 'Actualizar Datos',
                onPressed: () async {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Actualizando información de tu usuario y recinto...')),
                  );
                  await ref.read(authNotifierProvider.notifier).verificarSesionActiva();
                  ref.invalidate(_miRecintoProvider);
                  ref.invalidate(_jrvsPorRecintoProvider(recinto.id));
                },
              ),
              const ThemeToggleButton(),
              const SyncIndicator(),
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header de Recinto
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
                    Text(recinto.nombre, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: colorScheme.primary)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.map, size: 16, color: colorScheme.onSurface.withOpacity(0.6)),
                        const SizedBox(width: 8),
                        Expanded(child: Text(recinto.direccion, style: TextStyle(fontSize: 14, color: colorScheme.onSurface.withOpacity(0.7)))),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text('Juntas Receptoras del Voto', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: colorScheme.onSurface.withOpacity(0.8))),
              ),
              const SizedBox(height: 8),
              // Lista de JRVs
              Expanded(
                child: jrvsAsync.when(
                  data: (jrvs) {
                    if (jrvs.isEmpty) {
                      return Center(child: Text('No hay JRVs en este recinto', style: TextStyle(color: colorScheme.onSurface.withOpacity(0.5))));
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: jrvs.length,
                      itemBuilder: (context, index) {
                        final jrv = jrvs[index];
                        return _JrvCard(jrv: jrv);
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
      },
    );
  }
}

class _JrvCard extends ConsumerWidget {
  final Jrv jrv;
  const _JrvCard({required this.jrv});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    // Obtenemos las actas para mostrar un resumen rápido
    final actasAsync = ref.watch(_actasPorJrvProvider(jrv.id));

    return Card(
      elevation: 0,
      color: colorScheme.surface,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colorScheme.onSurface.withOpacity(0.1)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _mostrarDetalleJrv(context, ref, jrv),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: colorScheme.primary.withOpacity(0.1),
                    foregroundColor: colorScheme.primary,
                    child: const Icon(Icons.how_to_vote),
                  ),
                  const SizedBox(width: 16),
                  Text(jrv.codigo, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
              actasAsync.when(
                data: (actas) {
                  final tieneAlcalde = actas.any((a) => a.cargoElectoral == 'alcalde');
                  final tienePrefecto = actas.any((a) => a.cargoElectoral == 'prefecto');
                  final completado = tieneAlcalde && tienePrefecto;
                  
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: completado ? Colors.green.withOpacity(0.1) : (actas.isNotEmpty ? Colors.orange.withOpacity(0.1) : Colors.grey.withOpacity(0.1)),
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
        ),
      ),
    );
  }

  void _mostrarDetalleJrv(BuildContext context, WidgetRef ref, Jrv jrv) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _JrvDetailSheet(jrv: jrv),
    );
  }
}

class _JrvDetailSheet extends ConsumerWidget {
  final Jrv jrv;
  const _JrvDetailSheet({required this.jrv});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    final actasAsync = ref.watch(_actasPorJrvProvider(jrv.id));
    final veedorAsync = ref.watch(_veedorPorJrvProvider(jrv.id)); // Opcional, dependiendo si existe la relación

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(24),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.onSurface.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text('Detalles: ${jrv.codigo}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: colorScheme.primary)),
            const SizedBox(height: 16),
            
            // Asignación de Veedor
            Text('Veedor Asignado', style: TextStyle(fontSize: 12, color: colorScheme.onSurface.withOpacity(0.5))),
            const SizedBox(height: 4),
            veedorAsync.when(
              data: (nombre) => Text(nombre ?? 'Ninguno', style: const TextStyle(fontSize: 16)),
              loading: () => const Text('Cargando...'),
              error: (_, __) => const Text('Error al cargar'),
            ),
            const Divider(height: 32),
            
            // Estado de Actas
            Text('Estado de Actas', style: TextStyle(fontSize: 12, color: colorScheme.onSurface.withOpacity(0.5))),
            const SizedBox(height: 12),
            actasAsync.when(
              data: (actas) {
                final actaAlcalde = actas.where((a) => a.cargoElectoral == 'alcalde').firstOrNull;
                final actaPrefecto = actas.where((a) => a.cargoElectoral == 'prefecto').firstOrNull;
                
                return Column(
                  children: [
                    _buildActaStatusRow(context, 'Alcalde', actaAlcalde != null),
                    if (actaAlcalde != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 36,
                              child: OutlinedButton.icon(
                                onPressed: () async {
                                  final db = ref.read(appDatabaseProvider);
                                  final detallesLocal = await db.obtenerDetallePorActa(actaAlcalde.id);
                                  final organizacionesConVotos = detallesLocal.map((d) => OrganizacionConVotos(
                                    organizacionId: d.organizacionId,
                                    nombreOrganizacion: d.nombreOrganizacion,
                                    votos: d.votos,
                                  )).toList();

                                  if (!context.mounted) return;
                                  Navigator.pop(context);

                                  final actaMapper = Acta(
                                    id: actaAlcalde.id,
                                    jrvId: actaAlcalde.jrvId,
                                    cargoElectoral: actaAlcalde.cargoElectoral,
                                    totalSufragantes: actaAlcalde.totalSufragantes,
                                    votosBlancos: actaAlcalde.votosBlancos,
                                    votosNulos: actaAlcalde.votosNulos,
                                    organizaciones: organizacionesConVotos,
                                    latitud: actaAlcalde.latitud,
                                    longitud: actaAlcalde.longitud,
                                    creadoPor: actaAlcalde.creadoPor,
                                    synced: actaAlcalde.synced,
                                  );
                                  context.push('/actas/detalle', extra: actaMapper);
                                },
                                icon: const Icon(Icons.visibility, size: 14),
                                label: const Text('Ver Detalle', style: TextStyle(fontSize: 11)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: SizedBox(
                              height: 36,
                              child: OutlinedButton.icon(
                                onPressed: () async {
                                  final db = ref.read(appDatabaseProvider);
                                  final detallesLocal = await db.obtenerDetallePorActa(actaAlcalde.id);
                                  final organizacionesConVotos = detallesLocal.map((d) => OrganizacionConVotos(
                                    organizacionId: d.organizacionId,
                                    nombreOrganizacion: d.nombreOrganizacion,
                                    votos: d.votos,
                                  )).toList();

                                  if (!context.mounted) return;
                                  Navigator.pop(context);

                                  final actaMapper = Acta(
                                    id: actaAlcalde.id,
                                    jrvId: actaAlcalde.jrvId,
                                    cargoElectoral: actaAlcalde.cargoElectoral,
                                    totalSufragantes: actaAlcalde.totalSufragantes,
                                    votosBlancos: actaAlcalde.votosBlancos,
                                    votosNulos: actaAlcalde.votosNulos,
                                    organizaciones: organizacionesConVotos,
                                    latitud: actaAlcalde.latitud,
                                    longitud: actaAlcalde.longitud,
                                    creadoPor: actaAlcalde.creadoPor,
                                    synced: actaAlcalde.synced,
                                  );
                                  context.push('/actas/registrar', extra: actaMapper);
                                },
                                icon: const Icon(Icons.edit, size: 14),
                                label: const Text('Corregir', style: TextStyle(fontSize: 11)),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.orange,
                                  side: const BorderSide(color: Colors.orange),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 12),
                    _buildActaStatusRow(context, 'Prefecto', actaPrefecto != null),
                    if (actaPrefecto != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 36,
                              child: OutlinedButton.icon(
                                onPressed: () async {
                                  final db = ref.read(appDatabaseProvider);
                                  final detallesLocal = await db.obtenerDetallePorActa(actaPrefecto.id);
                                  final organizacionesConVotos = detallesLocal.map((d) => OrganizacionConVotos(
                                    organizacionId: d.organizacionId,
                                    nombreOrganizacion: d.nombreOrganizacion,
                                    votos: d.votos,
                                  )).toList();

                                  if (!context.mounted) return;
                                  Navigator.pop(context);

                                  final actaMapper = Acta(
                                    id: actaPrefecto.id,
                                    jrvId: actaPrefecto.jrvId,
                                    cargoElectoral: actaPrefecto.cargoElectoral,
                                    totalSufragantes: actaPrefecto.totalSufragantes,
                                    votosBlancos: actaPrefecto.votosBlancos,
                                    votosNulos: actaPrefecto.votosNulos,
                                    organizaciones: organizacionesConVotos,
                                    latitud: actaPrefecto.latitud,
                                    longitud: actaPrefecto.longitud,
                                    creadoPor: actaPrefecto.creadoPor,
                                    synced: actaPrefecto.synced,
                                  );
                                  context.push('/actas/detalle', extra: actaMapper);
                                },
                                icon: const Icon(Icons.visibility, size: 14),
                                label: const Text('Ver Detalle', style: TextStyle(fontSize: 11)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: SizedBox(
                              height: 36,
                              child: OutlinedButton.icon(
                                onPressed: () async {
                                  final db = ref.read(appDatabaseProvider);
                                  final detallesLocal = await db.obtenerDetallePorActa(actaPrefecto.id);
                                  final organizacionesConVotos = detallesLocal.map((d) => OrganizacionConVotos(
                                    organizacionId: d.organizacionId,
                                    nombreOrganizacion: d.nombreOrganizacion,
                                    votos: d.votos,
                                  )).toList();

                                  if (!context.mounted) return;
                                  Navigator.pop(context);

                                  final actaMapper = Acta(
                                    id: actaPrefecto.id,
                                    jrvId: actaPrefecto.jrvId,
                                    cargoElectoral: actaPrefecto.cargoElectoral,
                                    totalSufragantes: actaPrefecto.totalSufragantes,
                                    votosBlancos: actaPrefecto.votosBlancos,
                                    votosNulos: actaPrefecto.votosNulos,
                                    organizaciones: organizacionesConVotos,
                                    latitud: actaPrefecto.latitud,
                                    longitud: actaPrefecto.longitud,
                                    creadoPor: actaPrefecto.creadoPor,
                                    synced: actaPrefecto.synced,
                                  );
                                  context.push('/actas/registrar', extra: actaMapper);
                                },
                                icon: const Icon(Icons.edit, size: 14),
                                label: const Text('Corregir', style: TextStyle(fontSize: 11)),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.orange,
                                  side: const BorderSide(color: Colors.orange),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => const Text('Error al cargar actas'),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildActaStatusRow(BuildContext context, String cargo, bool registrada) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(cargo, style: const TextStyle(fontSize: 16)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: registrada ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Icon(registrada ? Icons.check_circle : Icons.pending, 
                   size: 14, 
                   color: registrada ? Colors.green : Colors.orange),
              const SizedBox(width: 4),
              Text(
                registrada ? 'Registrada' : 'Pendiente',
                style: TextStyle(
                  fontSize: 12, 
                  fontWeight: FontWeight.bold,
                  color: registrada ? Colors.green : Colors.orange
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

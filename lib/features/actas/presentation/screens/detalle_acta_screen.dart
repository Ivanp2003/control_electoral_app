import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../database/app_database.dart';
import '../../domain/entities/acta.dart';
import '../../domain/entities/organizacion_con_votos.dart';
import '../../../../core/presentation/widgets/theme_toggle_button.dart';
import '../../../sync/presentation/widgets/sync_indicator.dart';

// Provider para obtener los votos de un acta desde ActaDetalleLocal
final _actaDetallesProvider = FutureProvider.family.autoDispose<List<ActaDetalleLocalData>, String>((ref, actaId) async {
  final db = ref.watch(appDatabaseProvider);
  return db.obtenerDetallePorActa(actaId);
});

class DetalleActaScreen extends ConsumerWidget {
  final Acta acta;
  const DetalleActaScreen({super.key, required this.acta});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final surfaceColor = theme.cardTheme.color ?? colorScheme.surface;
    
    final detallesAsync = ref.watch(_actaDetallesProvider(acta.id));
    final cargoLabel = acta.cargoElectoral == 'alcalde' ? 'Alcalde' : 'Prefecto';

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Detalle de Acta - $cargoLabel', style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: const [
          ThemeToggleButton(),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Resumen de la mesa
            Card(
              color: surfaceColor,
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Junta Receptora del Voto', style: TextStyle(fontSize: 12, color: colorScheme.onSurface.withOpacity(0.5))),
                    const SizedBox(height: 4),
                    Text('JRV ID: ${acta.jrvId}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _metricCol('Sufragantes', '${acta.totalSufragantes}', colorScheme),
                        _metricCol('Votos Blancos', '${acta.votosBlancos}', colorScheme),
                        _metricCol('Votos Nulos', '${acta.votosNulos}', colorScheme),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Evidencia fotográfica
            Text('FOTO DEL ACTA FÍSICA', 
                style: TextStyle(color: colorScheme.onSurface.withOpacity(0.5), fontSize: 11, letterSpacing: 1.5, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Card(
              color: surfaceColor,
              margin: const EdgeInsets.only(bottom: 16),
              clipBehavior: Clip.antiAlias,
              child: SizedBox(
                width: double.infinity,
                height: 220,
                child: acta.evidenciaFoto != null && acta.evidenciaFoto!.isNotEmpty
                    ? (acta.evidenciaFoto!.startsWith('http')
                        ? Image.network(acta.evidenciaFoto!, fit: BoxFit.cover)
                        : Image.file(File(acta.evidenciaFoto!), fit: BoxFit.cover))
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image_not_supported_outlined, size: 48, color: colorScheme.onSurface.withOpacity(0.3)),
                            const SizedBox(height: 8),
                            Text('No se adjuntó fotografía', style: TextStyle(color: colorScheme.onSurface.withOpacity(0.5))),
                          ],
                        ),
                      ),
              ),
            ),

            // Resultados por candidatos/organizaciones
            Text('VOTOS POR CANDIDATO', 
                style: TextStyle(color: colorScheme.onSurface.withOpacity(0.5), fontSize: 11, letterSpacing: 1.5, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            detallesAsync.when(
              data: (detalles) {
                if (detalles.isEmpty) {
                  return Card(
                    color: surfaceColor,
                    child: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('No hay detalles de votos disponibles.'),
                    ),
                  );
                }
                return Card(
                  color: surfaceColor,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: detalles.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final det = detalles[index];
                      return ListTile(
                        title: Text(det.nombreOrganizacion, style: const TextStyle(fontSize: 14)),
                        trailing: Text('${det.votos}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      );
                    },
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text('Error al cargar votos: $e', style: TextStyle(color: colorScheme.error)),
            ),

            // Auditoría y geolocalización
            Text('AUDITORÍA Y GEOLOCALIZACIÓN', 
                style: TextStyle(color: colorScheme.onSurface.withOpacity(0.5), fontSize: 11, letterSpacing: 1.5, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Card(
              color: surfaceColor,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _auditRow('Registrado por:', acta.creadoPor, Icons.person_outline, colorScheme),
                    const SizedBox(height: 12),
                    _auditRow(
                      'Ubicación GPS:', 
                      acta.latitud != 0.0 ? '${acta.latitud.toStringAsFixed(6)}, ${acta.longitud.toStringAsFixed(6)}' : 'No registrada', 
                      Icons.location_on_outlined, 
                      colorScheme
                    ),
                    if (acta.editadoPor != null) ...[
                      const Divider(height: 24),
                      _auditRow('Corregido por:', acta.editadoPor!, Icons.edit_note, colorScheme),
                      if (acta.fechaEdicion != null) ...[
                        const SizedBox(height: 12),
                        _auditRow('Fecha de corrección:', '${acta.fechaEdicion!.toLocal()}', Icons.calendar_today_outlined, colorScheme),
                      ]
                    ]
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _metricCol(String label, String value, ColorScheme colorScheme) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: colorScheme.primary)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: colorScheme.onSurface.withOpacity(0.6))),
      ],
    );
  }

  Widget _auditRow(String label, String value, IconData icon, ColorScheme colorScheme) {
    return Row(
      children: [
        Icon(icon, size: 20, color: colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 12, color: colorScheme.onSurface.withOpacity(0.5))),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ],
    );
  }
}

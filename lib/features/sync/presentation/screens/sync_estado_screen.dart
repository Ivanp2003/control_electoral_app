import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/sync_providers.dart';
import '../../../../database/app_database.dart';
import '../../../../core/presentation/widgets/theme_toggle_button.dart';

class SyncEstadoScreen extends ConsumerWidget {
  const SyncEstadoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final surfaceColor = theme.cardTheme.color ?? colorScheme.surface;

    final pendingAsync = ref.watch(pendingSyncTasksCountProvider);
    final failedAsync = ref.watch(failedSyncTasksCountProvider);
    final failedListAsync = ref.watch(failedSyncTasksListProvider);

    final pendingCount = pendingAsync.valueOrNull ?? 0;
    final failedCount = failedAsync.valueOrNull ?? 0;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Estado de Sincronización', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: const [
          ThemeToggleButton(),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tarjeta de estado consolidado
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
                Text(
                  pendingCount == 0 && failedCount == 0 
                      ? 'Todo Sincronizado' 
                      : (failedCount > 0 ? 'Atención Requerida' : 'Pendientes de Sincronizar'),
                  style: TextStyle(
                    fontSize: 20, 
                    fontWeight: FontWeight.bold, 
                    color: pendingCount == 0 && failedCount == 0 
                        ? Colors.greenAccent 
                        : (failedCount > 0 ? Colors.redAccent : Colors.amber)
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Cola de operaciones locales para cuando no tienes cobertura o conexión de red.',
                  style: TextStyle(fontSize: 14, color: colorScheme.onSurface.withOpacity(0.7)),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _metricCol('Pendientes', '$pendingCount', Colors.amber),
                    _metricCol('Fallidas', '$failedCount', Colors.redAccent),
                  ],
                ),
                if (pendingCount > 0 || failedCount > 0) ...[
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () async {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Procesando cola de sincronización...')),
                        );
                        final useCase = ref.read(procesarColaSyncUseCaseProvider);
                        await useCase();
                      },
                      icon: const Icon(Icons.sync),
                      label: const Text('Reintentar Todo'),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'OPERACIONES FALLIDAS',
              style: TextStyle(
                color: colorScheme.onSurface.withOpacity(0.4),
                fontSize: 11,
                letterSpacing: 1.5,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: failedListAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error al cargar cola: $e', style: TextStyle(color: colorScheme.error))),
              data: (list) {
                if (list.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.cloud_done_outlined, size: 64, color: colorScheme.onSurface.withOpacity(0.15)),
                        const SizedBox(height: 16),
                        Text('No hay tareas fallidas en cola', style: TextStyle(color: colorScheme.onSurface.withOpacity(0.4))),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final item = list[index];
                    return Card(
                      color: surfaceColor,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: colorScheme.onSurface.withOpacity(0.08)),
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.cloud_off, color: Colors.redAccent),
                        title: Text('Entidad: ${item.entityType.toUpperCase()}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(
                          'Operación: ${item.operation}\nID: ${item.id}\nIntentos: ${item.attempts}',
                          style: TextStyle(fontSize: 12, color: colorScheme.onSurface.withOpacity(0.6)),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.refresh, color: colorScheme.primary),
                          tooltip: 'Reintentar esta tarea',
                          onPressed: () async {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Reintentando tarea...')),
                            );
                            final useCase = ref.read(reintentarTareaFallidaUseCaseProvider);
                            await useCase(item.id);
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _metricCol(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
      ],
    );
  }
}

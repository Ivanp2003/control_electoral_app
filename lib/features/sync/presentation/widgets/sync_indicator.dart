import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/sync_providers.dart';
import '../providers/sync_orchestrator_provider.dart';
import '../../../../database/app_database.dart';

class SyncIndicator extends ConsumerWidget {
  const SyncIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Inicializar el orquestador global para que escuche si no se había instanciado
    ref.watch(syncOrchestratorProvider);
    
    final pendingAsync = ref.watch(pendingSyncTasksCountProvider);
    final failedAsync = ref.watch(failedSyncTasksCountProvider);

    final pendingCount = pendingAsync.valueOrNull ?? 0;
    final failedCount = failedAsync.valueOrNull ?? 0;

    if (pendingAsync.isLoading || failedAsync.isLoading) {
      return const Padding(
        padding: EdgeInsets.all(12.0),
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
        ),
      );
    }

    if (pendingCount == 0 && failedCount == 0) {
      return IconButton(
        icon: const Icon(Icons.cloud_done, color: Colors.greenAccent),
        tooltip: 'Sincronizado',
        onPressed: () {},
      );
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          icon: Icon(
            failedCount > 0 ? Icons.cloud_off : Icons.cloud_upload,
            color: failedCount > 0 ? Colors.redAccent : Colors.amber,
          ),
          tooltip: failedCount > 0
              ? '$failedCount fallidas, $pendingCount pendientes'
              : '$pendingCount pendientes (Sincronización en proceso o pausada)',
          onPressed: () async {
            if (failedCount > 0) {
              _mostrarOpcionesFallidas(context, ref);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Intentando sincronizar...')),
              );
              try {
                final useCase = ref.read(procesarColaSyncUseCaseProvider);
                final result = await useCase();
                result.fold(
                  (failure) {
                    if (context.mounted) {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Error de Sincronización'),
                          content: Text(failure.message),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))
                          ],
                        ),
                      );
                    }
                  },
                  (_) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Sincronización procesada')),
                      );
                    }
                  },
                );
              } catch (e) {
                if (context.mounted) {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Error Grave'),
                      content: Text(e.toString()),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))
                      ],
                    ),
                  );
                }
              }
            }
          },
        ),
        Positioned(
          right: 8,
          top: 8,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: failedCount > 0 ? Colors.red : Colors.orange,
              shape: BoxShape.circle,
            ),
            child: Text(
              (failedCount > 0 ? failedCount : pendingCount).toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        )
      ],
    );
  }

  void _mostrarOpcionesFallidas(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Tareas Fallidas'),
        content: const Text('Existen tareas de sincronización que han fallado permanentemente.'),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final db = ref.read(appDatabaseProvider);
              await db.delete(db.syncQueue).go(); // Limpia toda la cola por debug
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cola de sincronización limpiada (Solo Debug)')),
                );
              }
            },
            child: const Text('Limpiar Fallidas (Debug)', style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final list = await ref.read(failedSyncTasksListProvider.future);
              final reintentar = ref.read(reintentarTareaFallidaUseCaseProvider);
              for (var t in list) {
                await reintentar(t.id);
              }
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Tareas marcadas para reintento')),
                );
              }
            },
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }
}

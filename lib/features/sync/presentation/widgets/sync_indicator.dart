import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/sync_providers.dart';
import '../providers/sync_orchestrator_provider.dart';

class SyncIndicator extends ConsumerWidget {
  const SyncIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Inicializar el orquestador global para que escuche si no se había instanciado
    ref.watch(syncOrchestratorProvider);
    
    final countAsync = ref.watch(pendingSyncTasksCountProvider);

    return countAsync.when(
      data: (count) {
        if (count == 0) {
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
              icon: const Icon(Icons.cloud_upload, color: Colors.amber),
              tooltip: '$count pendientes (Sincronización en proceso o pausada)',
              onPressed: () {
                // Podría abrir una pantalla para forzar reintento
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$count tareas pendientes de sincronizar')),
                );
              },
            ),
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  count.toString(),
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
      },
      loading: () => const Padding(
        padding: EdgeInsets.all(12.0),
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
        ),
      ),
      error: (_, __) => const Icon(Icons.cloud_off, color: Colors.redAccent),
    );
  }
}

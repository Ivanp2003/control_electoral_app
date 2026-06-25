import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/sync_orchestrator.dart';
import '../../domain/entities/sync_state.dart';

class SyncIndicator extends ConsumerWidget {
  const SyncIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncState = ref.watch(syncOrchestratorProvider);

    return GestureDetector(
      onTap: () => ref.read(syncOrchestratorProvider.notifier).sincronizarAhora(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: _color(syncState.status).withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _icono(syncState),
            const SizedBox(width: 6),
            Text(
              _texto(syncState),
              style: TextStyle(
                color: _color(syncState.status),
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _icono(SyncState estado) {
    switch (estado.status) {
      case SyncStatus.idle:
        return Icon(Icons.cloud_done, size: 14, color: _color(estado.status));
      case SyncStatus.syncing:
        return SizedBox(
          width: 14,
          height: 14,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
            color: _color(estado.status),
          ),
        );
      case SyncStatus.error:
        return Icon(Icons.cloud_off, size: 14, color: _color(estado.status));
    }
  }

  String _texto(SyncState estado) {
    switch (estado.status) {
      case SyncStatus.idle:
        return 'Sincronizado';
      case SyncStatus.syncing:
        return estado.itemsPendientes > 0
            ? '${estado.itemsPendientes} pendientes...'
            : 'Sincronizando...';
      case SyncStatus.error:
        return 'Error de sync';
    }
  }

  Color _color(SyncStatus status) {
    switch (status) {
      case SyncStatus.idle:
        return Colors.greenAccent;
      case SyncStatus.syncing:
        return const Color(0xFF4A90D9);
      case SyncStatus.error:
        return Colors.redAccent;
    }
  }
}

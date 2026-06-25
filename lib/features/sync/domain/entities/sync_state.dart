import 'package:equatable/equatable.dart';

enum SyncStatus { idle, syncing, error }

class SyncState extends Equatable {
  final SyncStatus status;
  final int itemsPendientes;
  final String? mensajeError;

  const SyncState({
    this.status = SyncStatus.idle,
    this.itemsPendientes = 0,
    this.mensajeError,
  });

  SyncState copyWith({
    SyncStatus? status,
    int? itemsPendientes,
    String? mensajeError,
  }) {
    return SyncState(
      status: status ?? this.status,
      itemsPendientes: itemsPendientes ?? this.itemsPendientes,
      mensajeError: mensajeError,
    );
  }

  @override
  List<Object?> get props => [status, itemsPendientes, mensajeError];
}

import 'package:equatable/equatable.dart';

/// jrv.dart
///
/// Responsabilidad Única: Entidad de dominio pura que representa una
/// Junta Receptora del Voto (JRV) dentro de un Recinto Electoral.

class Jrv extends Equatable {
  final String id;

  /// Código identificador único de la JRV (ej. 'JRV 001').
  final String codigo;
  final String recintoId;

  const Jrv({
    required this.id,
    required this.codigo,
    required this.recintoId,
  });

  @override
  List<Object?> get props => [id, codigo, recintoId];
}

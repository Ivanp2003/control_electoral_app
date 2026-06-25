import 'package:equatable/equatable.dart';

/// canton.dart
///
/// Responsabilidad Única: Entidad de dominio pura que representa un Cantón
/// dentro de una Provincia en la jerarquía geográfica electoral.

class Canton extends Equatable {
  final String id;
  final String nombre;
  final String provinciaId;

  const Canton({
    required this.id,
    required this.nombre,
    required this.provinciaId,
  });

  @override
  List<Object?> get props => [id, nombre, provinciaId];
}

import 'package:equatable/equatable.dart';

/// parroquia.dart
///
/// Responsabilidad Única: Entidad de dominio pura que representa una Parroquia
/// dentro de un Cantón en la jerarquía geográfica electoral.

class Parroquia extends Equatable {
  final String id;
  final String nombre;
  final String cantonId;

  const Parroquia({
    required this.id,
    required this.nombre,
    required this.cantonId,
  });

  @override
  List<Object?> get props => [id, nombre, cantonId];
}

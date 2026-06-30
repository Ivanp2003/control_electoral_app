import 'package:equatable/equatable.dart';

/// recinto.dart
///
/// Responsabilidad Única: Entidad de dominio pura que representa un Recinto
/// Electoral dentro de una Parroquia.

class Recinto extends Equatable {
  final String id;
  final String nombre;
  final String parroquiaId;
  final String direccion;

  /// Latitud de referencia geográfica del recinto (opcional).
  final double? latRef;

  /// Longitud de referencia geográfica del recinto (opcional).
  final double? lonRef;

  /// ID del coordinador asignado al recinto (opcional).
  final String? coordinadorId;

  const Recinto({
    required this.id,
    required this.nombre,
    required this.parroquiaId,
    required this.direccion,
    this.latRef,
    this.lonRef,
    this.coordinadorId,
  });

  @override
  List<Object?> get props => [id, nombre, parroquiaId, direccion, latRef, lonRef, coordinadorId];
}

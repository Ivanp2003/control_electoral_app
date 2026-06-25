import 'package:equatable/equatable.dart';

/// provincia.dart
///
/// Responsabilidad Única: Entidad de dominio pura que representa una Provincia
/// del Ecuador en el sistema electoral. Sin dependencias de infraestructura.

class Provincia extends Equatable {
  final String id;
  final String nombre;

  const Provincia({required this.id, required this.nombre});

  @override
  List<Object?> get props => [id, nombre];
}

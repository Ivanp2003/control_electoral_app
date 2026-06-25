import 'package:equatable/equatable.dart';

/// organizacion_politica.dart
///
/// Responsabilidad Única: Entidad de dominio pura que representa una
/// Organización Política participante en el proceso electoral.

class OrganizacionPolitica extends Equatable {
  final String id;
  final String nombre;

  /// Cargo para el que participa esta organización: 'alcalde' o 'prefecto'.
  /// Se representa con el enum CargoElectoral definido en appwrite_config.dart.
  final String cargo;

  const OrganizacionPolitica({
    required this.id,
    required this.nombre,
    required this.cargo,
  });

  @override
  List<Object?> get props => [id, nombre, cargo];
}

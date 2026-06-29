import 'package:equatable/equatable.dart';
import 'organizacion_con_votos.dart';

/// acta.dart
///
/// Responsabilidad Única: Definir las entidades de dominio puro para las actas electorales
/// y sus organizaciones, sin depender de Flutter, Appwrite o persistencia local.

class Acta extends Equatable {
  final String id;
  final String jrvId;
  final String cargoElectoral;
  final int totalSufragantes;
  final int votosBlancos;
  final int votosNulos;
  final List<OrganizacionConVotos> organizaciones;
  final String? evidenciaFoto;
  final double latitud;
  final double longitud;
  final String creadoPor;
  final String? editadoPor;
  final DateTime? fechaEdicion;
  final bool synced;

  const Acta({
    required this.id,
    required this.jrvId,
    required this.cargoElectoral,
    required this.totalSufragantes,
    required this.votosBlancos,
    required this.votosNulos,
    required this.organizaciones,
    this.evidenciaFoto,
    required this.latitud,
    required this.longitud,
    required this.creadoPor,
    this.editadoPor,
    this.fechaEdicion,
    required this.synced,
  });

  @override
  List<Object?> get props => [
        id,
        jrvId,
        cargoElectoral,
        totalSufragantes,
        votosBlancos,
        votosNulos,
        organizaciones,
        evidenciaFoto,
        latitud,
        longitud,
        creadoPor,
        editadoPor,
        fechaEdicion,
        synced,
      ];
}

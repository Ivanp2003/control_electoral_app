import 'package:equatable/equatable.dart';
import 'organizacion_con_votos.dart';

/// acta.dart
///
/// Responsabilidad Única: Definir las entidades de dominio puro para las actas electorales
/// y sus organizaciones, sin depender de Flutter, Appwrite o persistencia local.

class Acta extends Equatable {
  final String id;
  final String jrvId;
  final String? recintoId;
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
    this.recintoId,
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
        recintoId,
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

  Acta copyWith({
    String? id,
    String? jrvId,
    String? recintoId,
    String? cargoElectoral,
    int? totalSufragantes,
    int? votosBlancos,
    int? votosNulos,
    List<OrganizacionConVotos>? organizaciones,
    String? evidenciaFoto,
    double? latitud,
    double? longitud,
    String? creadoPor,
    String? editadoPor,
    DateTime? fechaEdicion,
    bool? synced,
  }) {
    return Acta(
      id: id ?? this.id,
      jrvId: jrvId ?? this.jrvId,
      recintoId: recintoId ?? this.recintoId,
      cargoElectoral: cargoElectoral ?? this.cargoElectoral,
      totalSufragantes: totalSufragantes ?? this.totalSufragantes,
      votosBlancos: votosBlancos ?? this.votosBlancos,
      votosNulos: votosNulos ?? this.votosNulos,
      organizaciones: organizaciones ?? this.organizaciones,
      evidenciaFoto: evidenciaFoto ?? this.evidenciaFoto,
      latitud: latitud ?? this.latitud,
      longitud: longitud ?? this.longitud,
      creadoPor: creadoPor ?? this.creadoPor,
      editadoPor: editadoPor ?? this.editadoPor,
      fechaEdicion: fechaEdicion ?? this.fechaEdicion,
      synced: synced ?? this.synced,
    );
  }
}

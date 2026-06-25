import 'package:equatable/equatable.dart';
import 'organizacion_con_votos.dart';

class Acta extends Equatable {
  final String id;
  final String jrvId;
  final String cargoElectoral;
  final List<OrganizacionConVotos> votos;
  final int votosBlancos;
  final int votosNulos;
  final int totalSufragantes;
  final String? fotoUrl;
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
    required this.votos,
    required this.votosBlancos,
    required this.votosNulos,
    required this.totalSufragantes,
    this.fotoUrl,
    this.latitud = 0.0,
    this.longitud = 0.0,
    required this.creadoPor,
    this.editadoPor,
    this.fechaEdicion,
    this.synced = false,
  });

  Acta copyWith({
    String? id,
    String? jrvId,
    String? cargoElectoral,
    List<OrganizacionConVotos>? votos,
    int? votosBlancos,
    int? votosNulos,
    int? totalSufragantes,
    String? fotoUrl,
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
      cargoElectoral: cargoElectoral ?? this.cargoElectoral,
      votos: votos ?? this.votos,
      votosBlancos: votosBlancos ?? this.votosBlancos,
      votosNulos: votosNulos ?? this.votosNulos,
      totalSufragantes: totalSufragantes ?? this.totalSufragantes,
      fotoUrl: fotoUrl ?? this.fotoUrl,
      latitud: latitud ?? this.latitud,
      longitud: longitud ?? this.longitud,
      creadoPor: creadoPor ?? this.creadoPor,
      editadoPor: editadoPor ?? this.editadoPor,
      fechaEdicion: fechaEdicion ?? this.fechaEdicion,
      synced: synced ?? this.synced,
    );
  }

  @override
  List<Object?> get props => [
        id,
        jrvId,
        cargoElectoral,
        votos,
        votosBlancos,
        votosNulos,
        totalSufragantes,
        fotoUrl,
        latitud,
        longitud,
        creadoPor,
        editadoPor,
        fechaEdicion,
        synced,
      ];
}

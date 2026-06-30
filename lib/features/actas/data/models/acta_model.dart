import 'package:equatable/equatable.dart';
import '../../domain/entities/acta.dart';
import '../../domain/entities/organizacion_con_votos.dart';

class ActaModel extends Equatable {
  final String id;
  final String jrvId;
  final String cargoElectoral;
  final List<OrganizacionConVotos> organizaciones;
  final int votosBlancos;
  final int votosNulos;
  final int totalSufragantes;
  final String? evidenciaFoto;
  final double latitud;
  final double longitud;
  final String creadoPor;
  final String? editadoPor;
  final DateTime? fechaEdicion;
  final bool synced;

  const ActaModel({
    required this.id,
    required this.jrvId,
    required this.cargoElectoral,
    required this.organizaciones,
    required this.votosBlancos,
    required this.votosNulos,
    required this.totalSufragantes,
    this.evidenciaFoto,
    this.latitud = 0.0,
    this.longitud = 0.0,
    required this.creadoPor,
    this.editadoPor,
    this.fechaEdicion,
    this.synced = false,
  });

  factory ActaModel.fromEntity(Acta entity) {
    return ActaModel(
      id: entity.id,
      jrvId: entity.jrvId,
      cargoElectoral: entity.cargoElectoral,
      organizaciones: entity.organizaciones,
      votosBlancos: entity.votosBlancos,
      votosNulos: entity.votosNulos,
      totalSufragantes: entity.totalSufragantes,
      evidenciaFoto: entity.evidenciaFoto,
      latitud: entity.latitud,
      longitud: entity.longitud,
      creadoPor: entity.creadoPor,
      editadoPor: entity.editadoPor,
      fechaEdicion: entity.fechaEdicion,
      synced: entity.synced,
    );
  }

  Acta toEntity() {
    return Acta(
      id: id,
      jrvId: jrvId,
      cargoElectoral: cargoElectoral,
      organizaciones: organizaciones,
      votosBlancos: votosBlancos,
      votosNulos: votosNulos,
      totalSufragantes: totalSufragantes,
      evidenciaFoto: evidenciaFoto,
      latitud: latitud,
      longitud: longitud,
      creadoPor: creadoPor,
      editadoPor: editadoPor,
      fechaEdicion: fechaEdicion,
      synced: synced,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'jrvId': jrvId,
        'cargoElectoral': cargoElectoral,
        'votosBlancos': votosBlancos,
        'votosNulos': votosNulos,
        'totalSufragantes': totalSufragantes,
        'evidenciaFoto': evidenciaFoto,
        'latitud': latitud,
        'longitud': longitud,
        'creadoPor': creadoPor,
        'editadoPor': editadoPor,
        'fechaEdicion': fechaEdicion?.toIso8601String(),
        'synced': synced,
      };

  factory ActaModel.fromJson(Map<String, dynamic> json) {
    final votosJson = json['votos'] as List<dynamic>? ?? [];
    return ActaModel(
      id: json['id'] as String,
      jrvId: json['jrvId'] as String,
      cargoElectoral: json['cargoElectoral'] as String,
      organizaciones: votosJson
          .map((v) => OrganizacionConVotos(
                organizacionId: v['organizacionId'] as String,
                nombreOrganizacion: v['nombreOrganizacion'] as String? ?? v['nombre'] as String? ?? '',
                votos: (v['votos'] as num).toInt(),
              ))
          .toList(),
      votosBlancos: json['votosBlancos'] as int,
      votosNulos: json['votosNulos'] as int,
      totalSufragantes: json['totalSufragantes'] as int,
      evidenciaFoto: json['evidenciaFoto'] as String?,
      latitud: (json['latitud'] as num?)?.toDouble() ?? 0.0,
      longitud: (json['longitud'] as num?)?.toDouble() ?? 0.0,
      creadoPor: json['creadoPor'] as String,
      editadoPor: json['editadoPor'] as String?,
      fechaEdicion: json['fechaEdicion'] != null
          ? DateTime.parse(json['fechaEdicion'] as String)
          : null,
      synced: json['synced'] as bool? ?? false,
    );
  }

  ActaModel copyWith({
    String? id,
    String? jrvId,
    String? cargoElectoral,
    List<OrganizacionConVotos>? organizaciones,
    int? votosBlancos,
    int? votosNulos,
    int? totalSufragantes,
    String? evidenciaFoto,
    double? latitud,
    double? longitud,
    String? creadoPor,
    String? editadoPor,
    DateTime? fechaEdicion,
    bool? synced,
  }) {
    return ActaModel(
      id: id ?? this.id,
      jrvId: jrvId ?? this.jrvId,
      cargoElectoral: cargoElectoral ?? this.cargoElectoral,
      organizaciones: organizaciones ?? this.organizaciones,
      votosBlancos: votosBlancos ?? this.votosBlancos,
      votosNulos: votosNulos ?? this.votosNulos,
      totalSufragantes: totalSufragantes ?? this.totalSufragantes,
      evidenciaFoto: evidenciaFoto ?? this.evidenciaFoto,
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
        id, jrvId, cargoElectoral, organizaciones, votosBlancos, votosNulos,
        totalSufragantes, evidenciaFoto, latitud, longitud, creadoPor,
        editadoPor, fechaEdicion, synced,
      ];
}

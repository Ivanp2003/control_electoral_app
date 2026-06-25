import 'package:equatable/equatable.dart';

class OrganizacionConVotos extends Equatable {
  final String organizacionId;
  final String nombreOrganizacion;
  final int votos;

  const OrganizacionConVotos({
    required this.organizacionId,
    required this.nombreOrganizacion,
    required this.votos,
  });

  @override
  List<Object?> get props => [organizacionId, nombreOrganizacion, votos];
}

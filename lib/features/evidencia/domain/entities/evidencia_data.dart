import 'package:equatable/equatable.dart';

class EvidenciaData extends Equatable {
  final String fotoPath;
  final double latitud;
  final double longitud;
  final double? precision;

  const EvidenciaData({
    required this.fotoPath,
    required this.latitud,
    required this.longitud,
    this.precision,
  });

  @override
  List<Object?> get props => [fotoPath, latitud, longitud, precision];
}

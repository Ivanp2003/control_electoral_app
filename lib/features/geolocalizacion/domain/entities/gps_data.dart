import 'package:equatable/equatable.dart';

class GpsData extends Equatable {
  final double latitud;
  final double longitud;
  final double precision;

  const GpsData({
    required this.latitud,
    required this.longitud,
    this.precision = 0.0,
  });

  @override
  List<Object?> get props => [latitud, longitud, precision];
}

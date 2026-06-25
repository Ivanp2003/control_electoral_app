import '../../domain/entities/recinto.dart';

/// recinto_model.dart
///
/// Responsabilidad Única: Serialización/deserialización de Recinto
/// desde/hacia los formatos de Appwrite (Map) y Drift (RecintosLocalData).

class RecintoModel extends Recinto {
  const RecintoModel({
    required super.id,
    required super.nombre,
    required super.parroquiaId,
    required super.direccion,
    super.latRef,
    super.lonRef,
  });

  factory RecintoModel.fromAppwriteDoc(Map<String, dynamic> doc) {
    return RecintoModel(
      id: doc['\$id'] as String,
      nombre: doc['nombre'] as String,
      parroquiaId: doc['parroquiaId'] as String,
      direccion: doc['direccion'] as String,
      latRef: (doc['latRef'] as num?)?.toDouble(),
      lonRef: (doc['lonRef'] as num?)?.toDouble(),
    );
  }

  factory RecintoModel.fromLocalData(({
    String id,
    String nombre,
    String parroquiaId,
    String direccion,
    double? latRef,
    double? lonRef,
  }) data) {
    return RecintoModel(
      id: data.id,
      nombre: data.nombre,
      parroquiaId: data.parroquiaId,
      direccion: data.direccion,
      latRef: data.latRef,
      lonRef: data.lonRef,
    );
  }

  Map<String, dynamic> toAppwriteData() => {
        'nombre': nombre,
        'parroquiaId': parroquiaId,
        'direccion': direccion,
        if (latRef != null) 'latRef': latRef,
        if (lonRef != null) 'lonRef': lonRef,
      };
}

import '../../domain/entities/parroquia.dart';

/// parroquia_model.dart
///
/// Responsabilidad Única: Serialización/deserialización de Parroquia
/// desde/hacia los formatos de Appwrite (Map) y Drift (ParroquiasLocalData).

class ParroquiaModel extends Parroquia {
  const ParroquiaModel({
    required super.id,
    required super.nombre,
    required super.cantonId,
  });

  factory ParroquiaModel.fromAppwriteDoc(Map<String, dynamic> doc) {
    return ParroquiaModel(
      id: doc['\$id'] as String,
      nombre: doc['nombre'] as String,
      cantonId: doc['cantonId'] as String,
    );
  }

  factory ParroquiaModel.fromLocalData(
      ({String id, String nombre, String cantonId}) data) {
    return ParroquiaModel(
        id: data.id, nombre: data.nombre, cantonId: data.cantonId);
  }

  Map<String, dynamic> toAppwriteData() => {
        'nombre': nombre,
        'cantonId': cantonId,
      };
}

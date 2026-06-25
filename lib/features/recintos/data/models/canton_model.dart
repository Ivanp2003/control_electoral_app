import '../../domain/entities/canton.dart';

/// canton_model.dart
///
/// Responsabilidad Única: Serialización/deserialización de Canton
/// desde/hacia los formatos de Appwrite (Map) y Drift (CantonesLocalData).

class CantonModel extends Canton {
  const CantonModel({
    required super.id,
    required super.nombre,
    required super.provinciaId,
  });

  factory CantonModel.fromAppwriteDoc(Map<String, dynamic> doc) {
    return CantonModel(
      id: doc['\$id'] as String,
      nombre: doc['nombre'] as String,
      provinciaId: doc['provinciaId'] as String,
    );
  }

  factory CantonModel.fromLocalData(
      ({String id, String nombre, String provinciaId}) data) {
    return CantonModel(
        id: data.id, nombre: data.nombre, provinciaId: data.provinciaId);
  }

  Map<String, dynamic> toAppwriteData() => {
        'nombre': nombre,
        'provinciaId': provinciaId,
      };
}

import '../../domain/entities/provincia.dart';

/// provincia_model.dart
///
/// Responsabilidad Única: Serialización/deserialización de Provincia
/// desde/hacia los formatos de Appwrite (Map) y Drift (ProvinciasLocalData).

class ProvinciaModel extends Provincia {
  const ProvinciaModel({required super.id, required super.nombre});

  factory ProvinciaModel.fromAppwriteDoc(Map<String, dynamic> doc) {
    return ProvinciaModel(
      id: doc['\$id'] as String,
      nombre: doc['nombre'] as String,
    );
  }

  factory ProvinciaModel.fromLocalData(
      ({String id, String nombre}) data) {
    return ProvinciaModel(id: data.id, nombre: data.nombre);
  }

  Map<String, dynamic> toAppwriteData() => {'nombre': nombre};
}

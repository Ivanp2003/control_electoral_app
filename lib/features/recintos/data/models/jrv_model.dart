import '../../domain/entities/jrv.dart';

/// jrv_model.dart
///
/// Responsabilidad Única: Serialización/deserialización de Jrv
/// desde/hacia los formatos de Appwrite (Map) y Drift (JrvLocalData).

class JrvModel extends Jrv {
  const JrvModel({
    required super.id,
    required super.codigo,
    required super.recintoId,
  });

  factory JrvModel.fromAppwriteDoc(Map<String, dynamic> doc) {
    return JrvModel(
      id: doc['\$id'] as String,
      codigo: doc['codigo'] as String,
      recintoId: doc['recintoId'] as String,
    );
  }

  factory JrvModel.fromLocalData(
      ({String id, String codigo, String recintoId}) data) {
    return JrvModel(
        id: data.id, codigo: data.codigo, recintoId: data.recintoId);
  }

  Map<String, dynamic> toAppwriteData() => {
        'codigo': codigo,
        'recintoId': recintoId,
      };
}

import '../../domain/entities/organizacion_politica.dart';

/// organizacion_politica_model.dart
///
/// Responsabilidad Única: Serialización/deserialización de OrganizacionPolitica
/// desde/hacia los formatos de Appwrite (Map) y Drift (OrganizacionesLocalData).

class OrganizacionPoliticaModel extends OrganizacionPolitica {
  const OrganizacionPoliticaModel({
    required super.id,
    required super.nombre,
    required super.cargo,
    super.lista,
    super.candidatoPrincipal,
    super.candidatoSecundario,
  });

  factory OrganizacionPoliticaModel.fromAppwriteDoc(Map<String, dynamic> doc) {
    return OrganizacionPoliticaModel(
      id: doc['\$id'] as String,
      nombre: doc['nombre'] as String,
      cargo: doc['cargo'] as String,
      lista: doc['lista'] as int?,
      candidatoPrincipal: doc['candidatoPrincipal'] as String?,
      candidatoSecundario: doc['candidatoSecundario'] as String?,
    );
  }

  factory OrganizacionPoliticaModel.fromLocalData(
      ({String id, String nombre, String cargo, int? lista, String? candidatoPrincipal, String? candidatoSecundario}) data) {
    return OrganizacionPoliticaModel(
        id: data.id, 
        nombre: data.nombre, 
        cargo: data.cargo,
        lista: data.lista,
        candidatoPrincipal: data.candidatoPrincipal,
        candidatoSecundario: data.candidatoSecundario,
    );
  }

  Map<String, dynamic> toAppwriteData() => {
        'nombre': nombre,
        'cargo': cargo,
        'lista': lista,
        'candidatoPrincipal': candidatoPrincipal,
        'candidatoSecundario': candidatoSecundario,
      };
}

import 'package:appwrite/appwrite.dart';
import '../../../../core/constants/appwrite_config.dart';
import '../models/organizacion_politica_model.dart';

/// organizaciones_remote_datasource.dart
///
/// Responsabilidad Única: Comunicarse con la colección 'organizaciones_politicas'
/// de Appwrite para leer las organizaciones por cargo electoral.

abstract class OrganizacionesRemoteDatasource {
  Future<List<OrganizacionPoliticaModel>> obtenerOrganizaciones(String cargo);
}

class OrganizacionesRemoteDatasourceImpl
    implements OrganizacionesRemoteDatasource {
  final Databases _databases;

  OrganizacionesRemoteDatasourceImpl({required Databases databases})
      : _databases = databases;

  @override
  Future<List<OrganizacionPoliticaModel>> obtenerOrganizaciones(
      String cargo) async {
    final result = await _databases.listDocuments(
      databaseId: AppwriteConfig.databaseId,
      collectionId: AppwriteConfig.collectionOrganizacionesPoliticas,
      queries: [Query.equal('cargo', cargo)],
    );
    return result.documents
        .map((d) => OrganizacionPoliticaModel.fromAppwriteDoc(d.data))
        .toList();
  }
}

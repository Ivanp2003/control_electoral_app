import 'package:appwrite/appwrite.dart';
import '../../../../core/constants/appwrite_config.dart';
import '../../../../core/utils/appwrite_id_helper.dart';
import '../../../auth/data/models/usuario_model.dart';

class UsuariosRemoteDatasource {
  final Databases _databases;

  UsuariosRemoteDatasource({required Databases databases})
      : _databases = databases;

  Future<List<UsuarioModel>> listarUsuarios({String? rol}) async {
    final queries = <String>[];
    if (rol != null) {
      queries.add(Query.equal('rol', rol));
    }

    final response = await _databases.listDocuments(
      databaseId: AppwriteConfig.databaseId,
      collectionId: AppwriteConfig.collectionUsuarios,
      queries: queries,
    );

    return response.documents
        .map((doc) => UsuarioModel.fromJson(doc.data))
        .toList();
  }

  Future<void> asignarVeedorAJrv({
    required String veedorId,
    required String jrvId,
    required String recintoId,
  }) async {
    final docId = AppwriteIdHelper.veedorJrvId(
      veedorId: veedorId,
      jrvId: jrvId,
    );
    await _databases.createDocument(
      databaseId: AppwriteConfig.databaseId,
      collectionId: AppwriteConfig.collectionVeedorJrv,
      documentId: docId,
      data: {
        'veedorId': veedorId,
        'jrvId': jrvId,
        'recintoId': recintoId,
      },
    );
  }

  Future<void> asignarCoordinadorRecinto({
    required String recintoId,
    required String coordinadorId,
  }) async {
    await _databases.updateDocument(
      databaseId: AppwriteConfig.databaseId,
      collectionId: AppwriteConfig.collectionRecintos,
      documentId: recintoId,
      data: {'coordinadorId': coordinadorId},
    );
  }
}

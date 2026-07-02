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

  Future<UsuarioModel> buscarUsuarioPorCedula(String cedula) async {
    final response = await _databases.listDocuments(
      databaseId: AppwriteConfig.databaseId,
      collectionId: AppwriteConfig.collectionUsuarios,
      queries: [Query.equal('cedula', cedula), Query.limit(1)],
    );
    if (response.documents.isEmpty) {
      throw AppwriteException('Usuario no encontrado.', 404);
    }
    return UsuarioModel.fromJson(response.documents.first.data);
  }

  Future<void> desasignarCoordinadorDeCualquierRecinto(String coordinadorId) async {
    // Buscar recintos anteriores asociados a este coordinador y limpiar su coordinadorId
    final response = await _databases.listDocuments(
      databaseId: AppwriteConfig.databaseId,
      collectionId: AppwriteConfig.collectionRecintos,
      queries: [Query.equal('coordinadorId', coordinadorId), Query.limit(10)],
    );
    for (final doc in response.documents) {
      await _databases.updateDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.collectionRecintos,
        documentId: doc.$id,
        data: {'coordinadorId': null},
      );
    }
  }

  Future<List<Map<String, dynamic>>> obtenerAsignacionesVeedor(String veedorId) async {
    final response = await _databases.listDocuments(
      databaseId: AppwriteConfig.databaseId,
      collectionId: AppwriteConfig.collectionVeedorJrv,
      queries: [Query.equal('veedorId', veedorId)],
    );
    return response.documents.map((d) {
      final data = Map<String, dynamic>.from(d.data);
      data['\$id'] = d.$id;
      return data;
    }).toList();
  }
}

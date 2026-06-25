import 'dart:convert';
import 'package:appwrite/appwrite.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/appwrite_config.dart';
import '../models/acta_model.dart';

class ActasRemoteDatasource {
  final Databases _databases;
  final Storage _storage;
  final _uuid = const Uuid();

  ActasRemoteDatasource({
    required Databases databases,
    required Storage storage,
  })  : _databases = databases,
        _storage = storage;

  Future<ActaModel> create(String jrvId, ActaModel acta) async {
    final docId = _uuid.v4();
    final payload = acta.toJson();
    payload.remove('id');
    payload['jrvId'] = jrvId;

    await _databases.createDocument(
      databaseId: AppwriteConfig.databaseId,
      collectionId: AppwriteConfig.collectionActas,
      documentId: docId,
      data: payload,
    );

    return acta;
  }

  Future<ActaModel> update(String id, ActaModel acta) async {
    final payload = acta.toJson();
    payload.remove('id');

    await _databases.updateDocument(
      databaseId: AppwriteConfig.databaseId,
      collectionId: AppwriteConfig.collectionActas,
      documentId: id,
      data: payload,
    );

    return acta;
  }

  Future<ActaModel?> getById(String id) async {
    try {
      final response = await _databases.getDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.collectionActas,
        documentId: id,
      );
      return ActaModel.fromJson(response.data);
    } catch (_) {
      return null;
    }
  }

  Future<List<ActaModel>> getByJrv(String jrvId) async {
    final response = await _databases.listDocuments(
      databaseId: AppwriteConfig.databaseId,
      collectionId: AppwriteConfig.collectionActas,
      queries: [Query.equal('jrvId', jrvId)],
    );

    return response.documents
        .map((doc) => ActaModel.fromJson(doc.data))
        .toList();
  }

  Future<void> uploadFoto(String actaId, String filePath) async {
    await _storage.createFile(
      bucketId: AppwriteConfig.bucketEvidenciaFotografica,
      fileId: actaId,
      file: InputFile.fromPath(path: filePath),
    );
  }
}

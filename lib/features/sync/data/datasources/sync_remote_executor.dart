import 'dart:convert';
import 'dart:io';
import 'package:appwrite/appwrite.dart';
import '../../../../core/constants/appwrite_config.dart';
import '../../domain/entities/sync_task.dart';

class PermanentSyncFailureException implements Exception {
  final String message;
  PermanentSyncFailureException(this.message);
  @override
  String toString() => 'PermanentSyncFailureException: $message';
}

abstract class SyncRemoteExecutor {
  Future<void> execute(SyncTask task);
}

class SyncRemoteExecutorImpl implements SyncRemoteExecutor {
  final Databases _databases;
  final Storage _storage;

  SyncRemoteExecutorImpl({
    required Databases databases,
    required Storage storage,
  })  : _databases = databases,
        _storage = storage;

  Future<void> _executeUpsert({
    required String operation,
    required String collectionId,
    required String documentId,
    required Map<String, dynamic> data,
  }) async {
    if (operation == 'CREATE') {
      try {
        await _databases.createDocument(
          databaseId: AppwriteConfig.databaseId,
          collectionId: collectionId,
          documentId: documentId,
          data: data,
        );
      } on AppwriteException catch (e) {
        if (e.code == 409) {
          // El documento ya existe (ej. reintento tras fallo parcial). Actualizamos en su lugar.
          await _databases.updateDocument(
            databaseId: AppwriteConfig.databaseId,
            collectionId: collectionId,
            documentId: documentId,
            data: data,
          );
        } else {
          rethrow;
        }
      }
    } else {
      // operation == 'UPDATE'
      try {
        await _databases.updateDocument(
          databaseId: AppwriteConfig.databaseId,
          collectionId: collectionId,
          documentId: documentId,
          data: data,
        );
      } on AppwriteException catch (e) {
        if (e.code == 404) {
          // El documento no existe aunque era un UPDATE. Lo creamos para converger al estado deseado.
          await _databases.createDocument(
            databaseId: AppwriteConfig.databaseId,
            collectionId: collectionId,
            documentId: documentId,
            data: data,
          );
        } else {
          rethrow;
        }
      }
    }
  }

  @override
  Future<void> execute(SyncTask task) async {
    final payload = jsonDecode(task.payload) as Map<String, dynamic>;

    try {
      switch (task.entityType) {
        case 'actas':
          // 1. Upload photo if present and it's a local file path (idempotencia)
          String? photoId = payload['evidenciaFoto'] as String?;
          String? uploadedPhotoId;
          
          if (photoId != null && photoId.isNotEmpty && File(photoId).existsSync()) {
            final file = await _storage.createFile(
              bucketId: AppwriteConfig.bucketEvidenciaFotografica,
              fileId: ID.unique(),
              file: InputFile.fromPath(path: photoId),
            );
            uploadedPhotoId = file.$id;
            photoId = uploadedPhotoId; // Actualiza la referencia para el documento
          }

          // 2. Prepare header data
          final headerData = {
            'jrvId': payload['jrvId'],
            'cargoElectoral': payload['cargoElectoral'],
            'totalSufragantes': payload['totalSufragantes'],
            'votosBlancos': payload['votosBlancos'],
            'votosNulos': payload['votosNulos'],
            'evidenciaFoto': photoId,
            'latitud': payload['latitud'],
            'longitud': payload['longitud'],
            'creadoPor': payload['creadoPor'],
            'editadoPor': payload['editadoPor'],
            'fechaEdicion': payload['fechaEdicion'],
          };

          try {
            // 3. Upsert Acta Header
            await _executeUpsert(
              operation: task.operation,
              collectionId: AppwriteConfig.collectionActas,
              documentId: payload['id'] as String,
              data: headerData,
            );

            // 4. Upsert Detalles
            final organizaciones = payload['organizaciones'] as List<dynamic>? ?? [];
            for (final org in organizaciones) {
              await _executeUpsert(
                operation: task.operation,
                collectionId: AppwriteConfig.collectionActaDetalle,
                documentId: '${payload['id']}_${org['organizacionId']}',
                data: {
                  'actaId': payload['id'],
                  'organizacionId': org['organizacionId'],
                  'votos': org['votos'],
                },
              );
            }
          } catch (e) {
            // Rollback (compensation) de la foto en caso de error transitorio/permanente al crear documentos
            if (uploadedPhotoId != null) {
              try {
                await _storage.deleteFile(
                  bucketId: AppwriteConfig.bucketEvidenciaFotografica,
                  fileId: uploadedPhotoId,
                );
              } catch (_) {
                // Fallo silencioso en el rollback para no ocultar la excepción original
              }
            }
            rethrow;
          }
          break;
        case 'veedor_jrv':
          await _executeUpsert(
            operation: task.operation,
            collectionId: AppwriteConfig.collectionVeedorJrv,
            documentId: payload['id'] as String,
            data: payload,
          );
          break;
        default:
          throw Exception('Unknown entityType: ${task.entityType}');
      }
    } on AppwriteException catch (e) {
      // 409 y 404 ya fueron manejados por _executeUpsert si eran predecibles.
      // Si el código es 4xx, NO ES 408 (Timeout) ni 429 (Rate Limit) -> Error Permanente
      if (e.code != null && e.code! >= 400 && e.code! < 500 && e.code != 408 && e.code != 429) {
        throw PermanentSyncFailureException(e.message ?? 'Error 4xx permanente de Appwrite');
      }
      rethrow;
    }
  }
}


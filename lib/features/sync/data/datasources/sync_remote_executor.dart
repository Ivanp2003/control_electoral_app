import 'dart:convert';
import 'dart:io';
import 'package:appwrite/appwrite.dart';
import '../../../../core/constants/appwrite_config.dart';
import '../../../../core/utils/appwrite_id_helper.dart';
import '../../../../database/app_database.dart';
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
  final AppDatabase _db;

  SyncRemoteExecutorImpl({
    required Databases databases,
    required Storage storage,
    required AppDatabase db,
  })  : _databases = databases,
        _storage = storage,
        _db = db;

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
          throw AppwriteException(
            '${e.message} (CREATE for $collectionId doc $documentId)',
            e.code,
            e.type,
            e.response,
          );
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
          try {
            await _databases.createDocument(
              databaseId: AppwriteConfig.databaseId,
              collectionId: collectionId,
              documentId: documentId,
              data: data,
            );
          } on AppwriteException catch (e2) {
            throw AppwriteException(
              '${e2.message} (Fallback CREATE for $collectionId doc $documentId)',
              e2.code,
              e2.type,
              e2.response,
            );
          }
        } else {
          throw AppwriteException(
            '${e.message} (UPDATE for $collectionId doc $documentId)',
            e.code,
            e.type,
            e.response,
          );
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
          // El payload guarda la ruta local en 'evidenciaFoto' al serializar
          String? photoId = payload['evidenciaFoto'] as String?;
          String? uploadedPhotoId;
          
          if (photoId != null && photoId.isNotEmpty && File(photoId).existsSync()) {
            // Storage de Appwrite solo acepta: a-z, A-Z, 0-9, underscore. Sin guiones.
            final safeFileId = 'foto_${DateTime.now().millisecondsSinceEpoch}';
            final file = await _storage.createFile(
              bucketId: AppwriteConfig.bucketEvidenciaFotografica,
              fileId: safeFileId,
              file: InputFile.fromPath(path: photoId),
            );
            uploadedPhotoId = file.$id;
            photoId = uploadedPhotoId; // Actualiza la referencia para el documento
          }

          // 2. Prepare header data
          final jrvId = payload['jrvId'] as String;
          final jrv = await _db.obtenerJrvLocalPorId(jrvId);
          
          String? recintoId = jrv?.recintoId;
          if (recintoId == null) {
            final asignaciones = await (_db.select(_db.veedorJrvLocal)
                  ..where((t) => t.jrvId.equals(jrvId))
                  ..limit(1))
                .get();
            if (asignaciones.isNotEmpty) {
              recintoId = asignaciones.first.recintoId;
            }
          }

          final headerData = {
            'jrvId': jrvId,
            'recintoId': recintoId,
            'estado': 'pendiente',
            'cargoElectoral': payload['cargoElectoral'],
            'totalSufragantes': payload['totalSufragantes'],
            'votosBlancos': payload['votosBlancos'],
            'votosNulos': payload['votosNulos'],
            'fotoUrl': photoId,
            'latitud': payload['latitud'],
            'longitud': payload['longitud'],
            'veedorId': payload['creadoPor'],
            'editadoPor': payload['editadoPor'],
            'fechaEdicion': payload['fechaEdicion'],
          };

          try {
          // 3. Upsert Acta Header
          final rawActaId = payload['id'] as String;
          // Si el id guardado es invalido (de tareas antiguas), regenerarlo de forma segura
          final safeActaId = AppwriteIdHelper.isValidAppwriteId(rawActaId)
              ? rawActaId
              : AppwriteIdHelper.actaId(
                  jrvId: payload['jrvId'] as String,
                  cargoElectoral: payload['cargoElectoral'] as String,
                );
          await _executeUpsert(
            operation: task.operation,
            collectionId: AppwriteConfig.collectionActas,
            documentId: safeActaId,
            data: headerData,
          );

          // 4. Upsert Detalles
          final organizaciones = payload['organizaciones'] as List<dynamic>? ?? [];
          for (final org in organizaciones) {
            final detalleDocId = AppwriteIdHelper.actaDetalleId(
              actaId: safeActaId,
              organizacionId: org['organizacionId'] as String,
            );
            await _executeUpsert(
              operation: task.operation,
              collectionId: AppwriteConfig.collectionActaDetalle,
              documentId: detalleDocId,
              data: {
                'actaId': safeActaId,
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
          final rawDocId = payload['id'] as String;
          final docId = AppwriteIdHelper.isValidAppwriteId(rawDocId)
              ? rawDocId
              : AppwriteIdHelper.veedorJrvId(
                  veedorId: payload['veedorId'] as String,
                  jrvId: payload['jrvId'] as String,
                );
          await _executeUpsert(
            operation: task.operation,
            collectionId: AppwriteConfig.collectionVeedorJrv,
            documentId: docId,
            data: {
              'veedorId': payload['veedorId'],
              'jrvId': payload['jrvId'],
              'recintoId': payload['recintoId'],
            },
          );
          break;
        case 'recinto':
          if (task.operation == 'asignarCoordinador') {
            // Buscamos al usuario por cédula para obtener su documentId real
            final cedula = payload['cedulaCoordinador'] as String;
            final userDocs = await _databases.listDocuments(
              databaseId: AppwriteConfig.databaseId,
              collectionId: AppwriteConfig.collectionUsuarios,
              queries: [Query.equal('cedula', cedula), Query.limit(1)],
            );
            if (userDocs.documents.isEmpty) {
              throw PermanentSyncFailureException('No se encontró el usuario con cédula $cedula');
            }
            final coordinadorId = userDocs.documents.first.$id;
            await _executeUpsert(
              operation: 'UPDATE',
              collectionId: AppwriteConfig.collectionRecintos,
              documentId: payload['recintoId'] as String,
              data: {
                'coordinadorId': coordinadorId,
              },
            );
          } else {
            throw Exception('Unknown operation ${task.operation} for entityType recinto');
          }
          break;
        default:
          throw Exception('Unknown entityType: ${task.entityType}');
      }
    } on AppwriteException catch (e) {
      // 409 y 404 ya fueron manejados por _executeUpsert si eran predecibles.
      // Si el código es 4xx, NO ES 408 (Timeout) ni 429 (Rate Limit) -> Error Permanente
      if (e.code != null && e.code! >= 400 && e.code! < 500 && e.code != 408 && e.code != 429) {
        throw PermanentSyncFailureException(e.message ?? 'Error 4xx de Appwrite');
      }
      rethrow;
    }
  }
}


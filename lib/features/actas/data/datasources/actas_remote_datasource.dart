import 'dart:io' as java_io_file;
import 'package:flutter/foundation.dart';
import 'package:appwrite/appwrite.dart';
import '../../../../core/constants/appwrite_config.dart';
import '../../../../core/utils/appwrite_id_helper.dart';
import '../../domain/entities/acta.dart';

/// actas_remote_datasource.dart
///
/// Responsabilidad Única: Manejar la comunicación con el SDK de Appwrite para la
/// escritura y lectura de Actas.

class ActasRemoteDatasource {
  final Databases _databases;
  final Storage _storage;

  ActasRemoteDatasource(this._databases, this._storage);

  Future<void> registrarActa(Acta acta, String recintoId) async {
    // 1. Subir foto si es local y existe
    String? fotoUrl = acta.evidenciaFoto;
    if (fotoUrl != null && fotoUrl.isNotEmpty && !fotoUrl.startsWith('http')) {
      try {
        final ioFile = java_io_file.File(fotoUrl);
        if (ioFile.existsSync()) {
          final safeFileId = 'foto_${DateTime.now().millisecondsSinceEpoch}';
          final file = await _storage.createFile(
            bucketId: AppwriteConfig.bucketEvidenciaFotografica,
            fileId: safeFileId,
            file: InputFile.fromPath(path: fotoUrl),
          );
          fotoUrl = file.$id;
        }
      } catch (e) {
        // Ignorar o propagar error de subida si falla
        debugPrint('Error subiendo foto de acta a Appwrite Storage: $e');
      }
    }

    // 2. Guardar cabecera del acta
    await _databases.createDocument(
      databaseId: AppwriteConfig.databaseId,
      collectionId: AppwriteConfig.collectionActas,
      documentId: acta.id,
      data: {
        'jrvId': acta.jrvId,
        'recintoId': recintoId,
        'cargoElectoral': acta.cargoElectoral,
        'votosBlancos': acta.votosBlancos,
        'votosNulos': acta.votosNulos,
        'totalSufragantes': acta.totalSufragantes,
        'fotoUrl': fotoUrl,
        'latitud': acta.latitud,
        'longitud': acta.longitud,
        'veedorId': acta.creadoPor,
        'editadoPor': acta.editadoPor,
        'fechaEdicion': acta.fechaEdicion?.toIso8601String(),
        'estado': 'pendiente',
      },
      // Los permisos se inyectarán vía Appwrite Console / Collections default settings.
    );

    // 2. Guardar los detalles (votos de organizaciones)
    for (final org in acta.organizaciones) {
      final detalleDocId = AppwriteIdHelper.actaDetalleId(
        actaId: acta.id,
        organizacionId: org.organizacionId,
      );
      await _databases.createDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.collectionActaDetalle,
        documentId: detalleDocId,
        data: {
          'actaId': acta.id,
          'organizacionId': org.organizacionId,
          'votos': org.votos,
        },
      );
    }
  }

  Future<void> corregirActa(Acta acta, String recintoId) async {
    // Actualizar cabecera
    await _databases.updateDocument(
      databaseId: AppwriteConfig.databaseId,
      collectionId: AppwriteConfig.collectionActas,
      documentId: acta.id,
      data: {
        'jrvId': acta.jrvId,
        'recintoId': recintoId,
        'cargoElectoral': acta.cargoElectoral,
        'votosBlancos': acta.votosBlancos,
        'votosNulos': acta.votosNulos,
        'totalSufragantes': acta.totalSufragantes,
        'evidenciaFoto': acta.evidenciaFoto,
        'latitud': acta.latitud,
        'longitud': acta.longitud,
        'editadoPor': acta.editadoPor,
        'fechaEdicion': acta.fechaEdicion?.toIso8601String(),
      },
    );

    // Actualizar detalles
    for (final org in acta.organizaciones) {
      await _databases.updateDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.collectionActaDetalle,
        documentId: '${acta.id}_${org.organizacionId}',
        data: {
          'votos': org.votos,
        },
      );
    }
  }

  Future<List<Map<String, dynamic>>> obtenerActasPorJrv(String jrvId) async {
    final response = await _databases.listDocuments(
      databaseId: AppwriteConfig.databaseId,
      collectionId: AppwriteConfig.collectionActas,
      queries: [Query.equal('jrvId', jrvId)],
    );
    
    final List<Map<String, dynamic>> actasConDetalle = [];
    for (final doc in response.documents) {
      final actaId = doc.$id;
      final detallesRes = await _databases.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.collectionActaDetalle,
        queries: [Query.equal('actaId', actaId), Query.limit(100)],
      );
      
      final Map<String, dynamic> data = Map.from(doc.data);
      data['\$id'] = doc.$id;
      data['organizaciones'] = detallesRes.documents.map((d) => d.data).toList();
      actasConDetalle.add(data);
    }
    return actasConDetalle;
  }
}

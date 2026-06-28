import 'dart:convert';
import 'package:appwrite/appwrite.dart';
import '../../../../core/constants/appwrite_config.dart';
import '../domain/entities/acta.dart';

/// actas_remote_datasource.dart
///
/// Responsabilidad Única: Manejar la comunicación con el SDK de Appwrite para la
/// escritura y lectura de Actas.

class ActasRemoteDatasource {
  final Databases _databases;

  ActasRemoteDatasource(this._databases);

  Future<void> registrarActa(Acta acta) async {
    // 1. Guardar cabecera del acta
    await _databases.createDocument(
      databaseId: AppwriteConfig.databaseId,
      collectionId: AppwriteConfig.collectionActas,
      documentId: acta.id,
      data: {
        'jrvId': acta.jrvId,
        'cargoElectoral': acta.cargoElectoral,
        'votosBlancos': acta.votosBlancos,
        'votosNulos': acta.votosNulos,
        'totalSufragantes': acta.totalSufragantes,
        'evidenciaFoto': acta.evidenciaFoto,
        'latitud': acta.latitud,
        'longitud': acta.longitud,
        'creadoPor': acta.creadoPor,
        'editadoPor': acta.editadoPor,
        'fechaEdicion': acta.fechaEdicion?.toIso8601String(),
      },
      // Los permisos se inyectarán vía Appwrite Console / Collections default settings.
    );

    // 2. Guardar los detalles (votos de organizaciones)
    for (final org in acta.organizaciones) {
      await _databases.createDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.collectionActaDetalle,
        documentId: '${acta.id}_${org.organizacionId}',
        data: {
          'actaId': acta.id,
          'organizacionId': org.organizacionId,
          'votos': org.votos,
        },
      );
    }
  }

  Future<void> corregirActa(Acta acta) async {
    // Actualizar cabecera
    await _databases.updateDocument(
      databaseId: AppwriteConfig.databaseId,
      collectionId: AppwriteConfig.collectionActas,
      documentId: acta.id,
      data: {
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
}

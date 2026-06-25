import 'package:appwrite/appwrite.dart';
import '../../../../core/constants/appwrite_config.dart';
import '../models/canton_model.dart';
import '../models/jrv_model.dart';
import '../models/parroquia_model.dart';
import '../models/provincia_model.dart';
import '../models/recinto_model.dart';

/// recintos_remote_datasource.dart
///
/// Responsabilidad Única: Comunicarse directamente con las colecciones de Appwrite
/// para las operaciones CRUD de la jerarquía geográfica electoral.
/// No contiene lógica de negocio ni verificación de permisos.

abstract class RecintosRemoteDatasource {
  Future<List<ProvinciaModel>> obtenerProvincias();
  Future<List<CantonModel>> obtenerCantones(String provinciaId);
  Future<List<ParroquiaModel>> obtenerParroquias(String cantonId);
  Future<List<RecintoModel>> obtenerRecintos(String parroquiaId);
  Future<List<JrvModel>> obtenerJrvPorRecinto(String recintoId);
  Future<RecintoModel> crearRecinto({
    required String id,
    required String nombre,
    required String parroquiaId,
    required String direccion,
    double? latRef,
    double? lonRef,
  });
}

class RecintosRemoteDatasourceImpl implements RecintosRemoteDatasource {
  final Databases _databases;

  RecintosRemoteDatasourceImpl({required Databases databases})
      : _databases = databases;

  static const String _db = AppwriteConfig.databaseId;

  @override
  Future<List<ProvinciaModel>> obtenerProvincias() async {
    final result = await _databases.listDocuments(
      databaseId: _db,
      collectionId: AppwriteConfig.collectionProvincias,
    );
    return result.documents
        .map((d) => ProvinciaModel.fromAppwriteDoc(d.data))
        .toList();
  }

  @override
  Future<List<CantonModel>> obtenerCantones(String provinciaId) async {
    final result = await _databases.listDocuments(
      databaseId: _db,
      collectionId: AppwriteConfig.collectionCantones,
      queries: [Query.equal('provinciaId', provinciaId)],
    );
    return result.documents
        .map((d) => CantonModel.fromAppwriteDoc(d.data))
        .toList();
  }

  @override
  Future<List<ParroquiaModel>> obtenerParroquias(String cantonId) async {
    final result = await _databases.listDocuments(
      databaseId: _db,
      collectionId: AppwriteConfig.collectionParroquias,
      queries: [Query.equal('cantonId', cantonId)],
    );
    return result.documents
        .map((d) => ParroquiaModel.fromAppwriteDoc(d.data))
        .toList();
  }

  @override
  Future<List<RecintoModel>> obtenerRecintos(String parroquiaId) async {
    final result = await _databases.listDocuments(
      databaseId: _db,
      collectionId: AppwriteConfig.collectionRecintos,
      queries: [Query.equal('parroquiaId', parroquiaId)],
    );
    return result.documents
        .map((d) => RecintoModel.fromAppwriteDoc(d.data))
        .toList();
  }

  @override
  Future<List<JrvModel>> obtenerJrvPorRecinto(String recintoId) async {
    final result = await _databases.listDocuments(
      databaseId: _db,
      collectionId: AppwriteConfig.collectionJrv,
      queries: [Query.equal('recintoId', recintoId)],
    );
    return result.documents
        .map((d) => JrvModel.fromAppwriteDoc(d.data))
        .toList();
  }

  @override
  Future<RecintoModel> crearRecinto({
    required String id,
    required String nombre,
    required String parroquiaId,
    required String direccion,
    double? latRef,
    double? lonRef,
  }) async {
    final doc = await _databases.createDocument(
      databaseId: _db,
      collectionId: AppwriteConfig.collectionRecintos,
      documentId: id,
      data: {
        'nombre': nombre,
        'parroquiaId': parroquiaId,
        'direccion': direccion,
        if (latRef != null) 'latRef': latRef,
        if (lonRef != null) 'lonRef': lonRef,
      },
    );
    return RecintoModel.fromAppwriteDoc(doc.data);
  }
}

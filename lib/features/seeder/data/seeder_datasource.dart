import 'dart:convert';
import 'package:appwrite/appwrite.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import '../../../core/constants/appwrite_config.dart';
import '../domain/seeder_resultado.dart';

/// seeder_datasource.dart
///
/// Responsabilidad Única: Leer el archivo seed_data.json y ejecutar las inserciones
/// en Appwrite de forma idempotente (ignora errores 409 Document Already Exists).
/// Emite mensajes de progreso granular vía Stream para que la UI pueda mostrarlos.

class SeederDatasource {
  final Databases _databases;
  final _uuid = const Uuid();

  SeederDatasource({required Databases databases}) : _databases = databases;

  static const String _db = AppwriteConfig.databaseId;

  /// Ejecuta la inserción completa de datos del seed_data.json.
  /// Retorna un Stream<String> con mensajes de progreso y completa
  /// con el SeederResultado final.
  Stream<String> ejecutar(
      void Function(SeederResultado resultado) onCompleted) async* {
    // Cargar y parsear el JSON desde assets.
    final jsonString =
        await rootBundle.loadString('assets/seed/seed_data.json');
    final json = jsonDecode(jsonString) as Map<String, dynamic>;

    final nombreProvincia = json['provincia'] as String;
    final nombreCanton = json['canton'] as String;
    final parroquiasNombres =
        (json['parroquias'] as List).map((e) => e as String).toList();
    final recintosData = json['recintos'] as List;
    final jrvPorRecinto = json['jrv_por_recinto'] as int;
    final organizacionesAlcalde = (json['organizaciones_alcalde'] as List)
        .map((e) => e as String)
        .toList();
    final organizacionesPrefecto = (json['organizaciones_prefecto'] as List)
        .map((e) => e as String)
        .toList();

    var provinciasCreadas = 0;
    var cantonesCreados = 0;
    var parroquiasCreadas = 0;
    var recintosCreados = 0;
    var jrvCreadas = 0;
    var organizacionesCreadas = 0;

    // ------ Provincia ------
    yield 'Insertando provincia "$nombreProvincia"...';
    final provinciaId = _uuid.v4();
    await _insertarOIgnorar(
      collectionId: AppwriteConfig.collectionProvincias,
      documentId: provinciaId,
      data: {'nombre': nombreProvincia},
    );
    provinciasCreadas++;

    // ------ Cantón ------
    yield 'Insertando cantón "$nombreCanton"...';
    final cantonId = _uuid.v4();
    await _insertarOIgnorar(
      collectionId: AppwriteConfig.collectionCantones,
      documentId: cantonId,
      data: {'nombre': nombreCanton, 'provinciaId': provinciaId},
    );
    cantonesCreados++;

    // ------ Parroquias ------
    final parroquiaIds = <String, String>{};
    for (var i = 0; i < parroquiasNombres.length; i++) {
      final nombre = parroquiasNombres[i];
      yield 'Insertando parroquias... (${i + 1}/${parroquiasNombres.length})';
      final id = _uuid.v4();
      await _insertarOIgnorar(
        collectionId: AppwriteConfig.collectionParroquias,
        documentId: id,
        data: {'nombre': nombre, 'cantonId': cantonId},
      );
      parroquiaIds[nombre] = id;
      parroquiasCreadas++;
    }

    // ------ Recintos y JRV ------
    for (var i = 0; i < recintosData.length; i++) {
      final recintoJson = recintosData[i] as Map<String, dynamic>;
      final nombreRecinto = recintoJson['nombre'] as String;
      final parroquiaNombre = recintoJson['parroquia'] as String;
      final direccion = recintoJson['direccion'] as String;
      final parroquiaId = parroquiaIds[parroquiaNombre]!;

      yield 'Insertando recintos... (${i + 1}/${recintosData.length})';
      final recintoId = _uuid.v4();
      await _insertarOIgnorar(
        collectionId: AppwriteConfig.collectionRecintos,
        documentId: recintoId,
        data: {
          'nombre': nombreRecinto,
          'parroquiaId': parroquiaId,
          'direccion': direccion,
        },
      );
      recintosCreados++;

      // JRV para este recinto
      for (var j = 0; j < jrvPorRecinto; j++) {
        final jrvNum = (i * jrvPorRecinto + j + 1).toString().padLeft(3, '0');
        final codigo = 'JRV $jrvNum';
        yield 'Insertando JRV... ($codigo)';
        await _insertarOIgnorar(
          collectionId: AppwriteConfig.collectionJrv,
          documentId: _uuid.v4(),
          data: {'codigo': codigo, 'recintoId': recintoId},
        );
        jrvCreadas++;
      }
    }

    // ------ Organizaciones Políticas ------
    final totalOrgs =
        organizacionesAlcalde.length + organizacionesPrefecto.length;
    var orgCount = 0;
    for (final nombre in organizacionesAlcalde) {
      orgCount++;
      yield 'Insertando organizaciones... ($orgCount/$totalOrgs)';
      await _insertarOIgnorar(
        collectionId: AppwriteConfig.collectionOrganizacionesPoliticas,
        documentId: _uuid.v4(),
        data: {'nombre': nombre, 'cargo': 'alcalde'},
      );
      organizacionesCreadas++;
    }
    for (final nombre in organizacionesPrefecto) {
      orgCount++;
      yield 'Insertando organizaciones... ($orgCount/$totalOrgs)';
      await _insertarOIgnorar(
        collectionId: AppwriteConfig.collectionOrganizacionesPoliticas,
        documentId: _uuid.v4(),
        data: {'nombre': nombre, 'cargo': 'prefecto'},
      );
      organizacionesCreadas++;
    }

    yield 'Finalizando...';
    onCompleted(SeederResultado(
      provinciasCreadas: provinciasCreadas,
      cantonesCreados: cantonesCreados,
      parroquiasCreadas: parroquiasCreadas,
      recintosCreados: recintosCreados,
      jrvCreadas: jrvCreadas,
      organizacionesCreadas: organizacionesCreadas,
    ));
  }

  /// Inserta un documento ignorando el error 409 (ya existe).
  /// Esto garantiza idempotencia a nivel de documento individual,
  /// permitiendo reintentos seguros si el Seeder falló a mitad.
  Future<void> _insertarOIgnorar({
    required String collectionId,
    required String documentId,
    required Map<String, dynamic> data,
  }) async {
    try {
      await _databases.createDocument(
        databaseId: _db,
        collectionId: collectionId,
        documentId: documentId,
        data: data,
      );
    } on AppwriteException catch (e) {
      // 409 = document_already_exists — ignorar silenciosamente en reintentos.
      if (e.code != 409) rethrow;
    }
  }
}

import 'dart:convert';
import 'package:appwrite/appwrite.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/appwrite_config.dart';
import '../domain/seeder_resultado.dart';

/// seeder_datasource.dart
///
/// Responsabilidad Única: Leer el archivo seed_data.json y ejecutar las inserciones
/// en Appwrite de forma idempotente (ignora errores 409 Document Already Exists).
/// Emite mensajes de progreso granular vía Stream para que la UI pueda mostrarlos.

class SeederDatasource {
  final Databases _databases;

  SeederDatasource({required Databases databases}) : _databases = databases;

  static const String _db = AppwriteConfig.databaseId;

  String _toSlug(String text) {
    // Para asegurar que los IDs no excedan 36 caracteres, truncamos el slug y quitamos caracteres raros
    final slug = text.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '_');
    return slug.length > 25 ? slug.substring(0, 25) : slug;
  }

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
    final organizacionesAlcalde = json['organizaciones_alcalde'] as List;
    final organizacionesPrefecto = json['organizaciones_prefecto'] as List;

    var provinciasCreadas = 0;
    var cantonesCreados = 0;
    var parroquiasCreadas = 0;
    var recintosCreados = 0;
    var jrvCreadas = 0;
    var organizacionesCreadas = 0;

    // ------ Provincia ------
    yield 'Insertando provincia "$nombreProvincia"...';
    final provinciaId = 'prov_${_toSlug(nombreProvincia)}';
    await _insertarOIgnorar(
      collectionId: AppwriteConfig.collectionProvincias,
      documentId: provinciaId,
      data: {'nombre': nombreProvincia},
    );
    provinciasCreadas++;

    // ------ Cantón ------
    yield 'Insertando cantón "$nombreCanton"...';
    final cantonId = 'cant_${_toSlug(nombreCanton)}';
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
      final id = 'parr_$i'; // Usar index para garantizar longitud corta
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
      final recintoId = 'rec_$i'; // Índice para garantizar unicidad y longitud corta
      await _insertarOIgnorar(
        collectionId: AppwriteConfig.collectionRecintos,
        documentId: recintoId,
        data: {
          'nombre': nombreRecinto,
          'parroquiaId': parroquiaId,
          'direccion': direccion,
          'coordinadorId': '', // Inicialmente sin coordinador asignado
        },
      );
      recintosCreados++;

      // JRV para este recinto
      for (var j = 0; j < jrvPorRecinto; j++) {
        // Appwrite tiene una regla de validación de 1 a 10 para el campo "numero".
        // Usaremos numeración por recinto (1, 2, 3...)
        final jrvNum = j + 1;
        final codigo = 'JRV $jrvNum';
        yield 'Insertando JRV... ($codigo en $recintoId)';
        final jrvId = 'jrv_${recintoId}_$jrvNum'; // jrv_rec_0_1 -> cabe en 36 chars
        await _insertarOIgnorar(
          collectionId: AppwriteConfig.collectionJrv,
          documentId: jrvId,
          data: {
            'codigo': codigo, 
            'recintoId': recintoId,
            'numero': jrvNum, // Si requiere numero Integer según el user
          },
        );
        jrvCreadas++;
      }
    }

    // ------ Organizaciones Políticas ------
    final totalOrgs =
        organizacionesAlcalde.length + organizacionesPrefecto.length;
    var orgCount = 0;
    for (final orgJson in organizacionesAlcalde) {
      orgCount++;
      final nombre = orgJson['nombre'] as String;
      final lista = orgJson['lista'] as int;
      yield 'Insertando organizaciones... ($orgCount/$totalOrgs)';
      await _insertarOIgnorar(
        collectionId: AppwriteConfig.collectionOrganizacionesPoliticas,
        documentId: 'org_alcalde_$lista',
        data: {
          'lista': lista,
          'nombre': nombre, 
          'cargo': 'alcalde',
          'candidatoPrincipal': orgJson['candidatoPrincipal'] as String,
          'candidatoSecundario': orgJson['candidatoSecundario'] as String,
        },
      );
      organizacionesCreadas++;
    }
    for (final orgJson in organizacionesPrefecto) {
      orgCount++;
      final nombre = orgJson['nombre'] as String;
      final lista = orgJson['lista'] as int;
      yield 'Insertando organizaciones... ($orgCount/$totalOrgs)';
      await _insertarOIgnorar(
        collectionId: AppwriteConfig.collectionOrganizacionesPoliticas,
        documentId: 'org_prefecto_$lista',
        data: {
          'lista': lista,
          'nombre': nombre, 
          'cargo': 'prefecto',
          'candidatoPrincipal': orgJson['candidatoPrincipal'] as String,
          'candidatoSecundario': orgJson['candidatoSecundario'] as String,
        },
      );
      organizacionesCreadas++;
    }

    // ------ Config Sistema ------
    yield 'Marcando ejecución en config_sistema...';
    await _insertarOIgnorar(
      collectionId: AppwriteConfig.collectionConfigSistema,
      documentId: AppwriteConfig.seederFlagKey,
      data: {
        'clave': AppwriteConfig.seederFlagKey,
        'valor': 'true',
        'actualizadoEn': DateTime.now().toIso8601String(),
      },
    );

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

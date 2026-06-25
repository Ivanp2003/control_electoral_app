import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:control_electoral_app/core/constants/app_roles.dart';
import 'package:control_electoral_app/core/constants/appwrite_config.dart';
import 'package:control_electoral_app/core/errors/failures.dart';
import 'package:control_electoral_app/features/seeder/data/seeder_datasource.dart';
import 'package:control_electoral_app/features/seeder/domain/seeder_resultado.dart';
import 'package:control_electoral_app/database/app_database.dart';
import 'package:control_electoral_app/features/seeder/domain/usecases/ejecutar_seeder_usecase.dart';

// ---------------------------------------------------------------------------
// Mocks
// ---------------------------------------------------------------------------
class MockDatabases extends Mock implements Databases {}
class MockAppDatabase extends Mock implements AppDatabase {}
class MockSeederDatasource extends Mock implements SeederDatasource {}
class MockDocument extends Mock implements models.Document {}

void main() {
  late MockDatabases mockDatabases;
  late MockAppDatabase mockLocalDb;
  late MockSeederDatasource mockSeederDatasource;
  late EjecutarSeederUseCase useCase;

  setUp(() {
    mockDatabases = MockDatabases();
    mockLocalDb = MockAppDatabase();
    mockSeederDatasource = MockSeederDatasource();

    useCase = EjecutarSeederUseCase(
      datasource: mockSeederDatasource,
      databases: mockDatabases,
      localDb: mockLocalDb,
    );
    
    // Register fallback values for mocktail
    registerFallbackValue(ConfigSistemaLocalCompanion.insert(clave: '', valor: ''));
  });

  group('EjecutarSeederUseCase — Idempotencia', () {
    test(
        'Si seed_ejecutado == true en Appwrite, retorna Right(yaEjecutado) '
        'sin llamar a ningún método de inserción del datasource', () async {
      // Arrange: Appwrite devuelve el flag como "true"
      when(() => mockDatabases.getDocument(
            databaseId: AppwriteConfig.databaseId,
            collectionId: AppwriteConfig.collectionConfigSistema,
            documentId: AppwriteConfig.seederFlagKey,
          )).thenAnswer((_) async {
            final doc = MockDocument();
            when(() => doc.data).thenReturn({'clave': AppwriteConfig.seederFlagKey, 'valor': 'true'});
            return doc;
          });

      // Act
      final result = await useCase(
        rolUsuario: AppRole.coordinadorProvincial,
        onProgress: (_) {},
      );

      // Assert: retorna Right con yaEjecutado == true
      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Esperaba Right, recibió Left: ${l.message}'),
        (r) {
          expect(r.yaEjecutado, isTrue);
          expect(r.totalCreados, equals(0));
        },
      );

      // El datasource NO debe haber sido invocado.
      verifyNever(() => mockSeederDatasource.ejecutar(any()));
    });

    test(
        'Si seed_ejecutado no existe en Appwrite (404), llama al datasource '
        'y escribe el flag al finalizar', () async {
      // Arrange: Appwrite devuelve 404 (primera ejecución)
      when(() => mockDatabases.getDocument(
            databaseId: any(named: 'databaseId'),
            collectionId: any(named: 'collectionId'),
            documentId: any(named: 'documentId'),
          )).thenThrow(AppwriteException('Not found', 404));

      // Mock del datasource: emite un mensaje y completa con resultado
      when(() => mockSeederDatasource.ejecutar(any())).thenAnswer(
        (invocation) async* {
          yield 'Insertando provincia...';
          // Llamar al callback onCompleted con el resultado
          final callback = invocation.positionalArguments[0]
              as void Function(SeederResultado);
          callback(const SeederResultado(
            provinciasCreadas: 1,
            cantonesCreados: 1,
            parroquiasCreadas: 4,
            recintosCreados: 8,
            jrvCreadas: 24,
            organizacionesCreadas: 10,
          ));
        },
      );

      // Mock del createDocument para el flag y de guardarConfigLocal
      when(() => mockDatabases.createDocument(
            databaseId: any(named: 'databaseId'),
            collectionId: any(named: 'collectionId'),
            documentId: any(named: 'documentId'),
            data: any(named: 'data'),
          )).thenAnswer((_) async {
            final doc = MockDocument();
            when(() => doc.data).thenReturn({});
            return doc;
          });

      when(() => mockLocalDb.guardarConfigLocal(any()))
          .thenAnswer((_) async => 1);

      // Act
      final result = await useCase(
        rolUsuario: AppRole.coordinadorProvincial,
        onProgress: (_) {},
      );

      // Assert
      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Esperaba Right: ${l.message}'),
        (r) {
          expect(r.yaEjecutado, isFalse);
          expect(r.recintosCreados, equals(8));
          expect(r.jrvCreadas, equals(24));
          expect(r.totalCreados, equals(48)); // 1+1+4+8+24+10
        },
      );

      // El datasource SÍ debe haber sido invocado.
      verify(() => mockSeederDatasource.ejecutar(any())).called(1);

      // El flag debe haberse escrito en Appwrite y en local.
      verify(() => mockDatabases.createDocument(
            databaseId: AppwriteConfig.databaseId,
            collectionId: AppwriteConfig.collectionConfigSistema,
            documentId: AppwriteConfig.seederFlagKey,
            data: {'clave': AppwriteConfig.seederFlagKey, 'valor': 'true'},
          )).called(1);
      verify(() => mockLocalDb.guardarConfigLocal(any())).called(1);
    });

    test(
        'Si el rol no es Coordinador Provincial, retorna PermissionFailure '
        'sin llamar a Appwrite', () async {
      // Act
      final result = await useCase(
        rolUsuario: AppRole.veedor, // ← rol incorrecto
        onProgress: (_) {},
      );

      // Assert
      expect(result.isLeft(), isTrue);
      result.fold(
        (l) => expect(l.message, contains('Coordinador Provincial')),
        (r) => fail('Esperaba Left'),
      );

      // No debe haber tocado Appwrite.
      verifyNever(() => mockDatabases.getDocument(
            databaseId: any(named: 'databaseId'),
            collectionId: any(named: 'collectionId'),
            documentId: any(named: 'documentId'),
          ));
    });
  });
}

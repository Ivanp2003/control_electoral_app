import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:control_electoral_app/database/app_database.dart';
import 'package:control_electoral_app/features/actas/data/datasources/actas_local_datasource.dart';
import 'package:control_electoral_app/features/actas/data/datasources/actas_remote_datasource.dart';
import 'package:control_electoral_app/features/actas/data/models/acta_model.dart';
import 'package:control_electoral_app/features/sync/data/services/sync_processor_impl.dart';

class MockAppDatabase extends Mock implements AppDatabase {}

class MockActasRemoteDatasource extends Mock
    implements ActasRemoteDatasource {}

class MockActasLocalDatasource extends Mock
    implements ActasLocalDatasource {}

class _ActaModelFake extends Fake implements ActaModel {}

class _SyncQueueDataFake extends Fake implements SyncQueueData {}

void main() {
  late MockAppDatabase mockDb;
  late MockActasRemoteDatasource mockRemote;
  late MockActasLocalDatasource mockLocal;
  late SyncProcessorImpl processor;

  setUpAll(() {
    registerFallbackValue(_ActaModelFake());
    registerFallbackValue(_SyncQueueDataFake());
  });

  final actaPayload = jsonEncode({
    'id': 'acta-1',
    'jrvId': 'jrv-1',
    'cargoElectoral': 'alcalde',
    'votos': [
      {
        'organizacionId': 'org-1',
        'nombreOrganizacion': 'Test Org',
        'votos': 100,
      }
    ],
    'votosBlancos': 5,
    'votosNulos': 3,
    'totalSufragantes': 108,
    'creadoPor': 'user-1',
    'synced': false,
  });

  SyncQueueData buildQueueItem({
    int id = 1,
    String entityType = 'acta',
    String operation = 'create',
    String? payload,
    int attempts = 0,
    String status = 'pending',
  }) {
    return SyncQueueData(
      id: id,
      entityType: entityType,
      operation: operation,
      payload: payload ?? actaPayload,
      timestamp: DateTime.now(),
      attempts: attempts,
      status: status,
    );
  }

  setUp(() {
    mockDb = MockAppDatabase();
    mockRemote = MockActasRemoteDatasource();
    mockLocal = MockActasLocalDatasource();
    processor = SyncProcessorImpl(
      db: mockDb,
      remote: mockRemote,
      local: mockLocal,
    );
  });

  group('SyncProcessorImpl', () {
    test('procesa acta.create exitosamente → elimina de SyncQueue', () async {
      when(() => mockDb.obtenerColaPendiente())
          .thenAnswer((_) async => [buildQueueItem()]);

      when(() => mockRemote.create(any(), any())).thenAnswer((invocation) async {
        final acta = invocation.positionalArguments[1] as ActaModel;
        return acta;
      });

      when(() => mockLocal.marcarSynced(any())).thenAnswer((_) async {});
      when(() => mockDb.eliminarDeLaCola(any())).thenAnswer((_) async => 1);

      final result = await processor.procesarCola();

      expect(result.procesados, 1);
      expect(result.fallidos, 0);
      verify(() => mockRemote.create(any(), any())).called(1);
      verify(() => mockDb.eliminarDeLaCola(any())).called(1);
    });

    test('item con 3 attempts fallidos → marca failed, no reintenta', () async {
      when(() => mockDb.obtenerColaPendiente()).thenAnswer(
        (_) async => [
          buildQueueItem(attempts: 3, status: 'pending'),
        ],
      );

      when(() => mockDb.actualizarEstadoCola(any())).thenAnswer(
        (_) async => true,
      );

      final result = await processor.procesarCola();

      expect(result.procesados, 0);
      expect(result.fallidos, 1);
      verifyNever(() => mockRemote.create(any(), any()));
      verify(() => mockDb.actualizarEstadoCola(any())).called(1);
    });

    test('payload inválido → marca error sin crashear', () async {
      when(() => mockDb.obtenerColaPendiente()).thenAnswer(
        (_) async => [
          buildQueueItem(payload: '{"id": "bad-json-no-required-fields}'),
        ],
      );

      when(() => mockDb.actualizarEstadoCola(any())).thenAnswer(
        (_) async => true,
      );

      final result = await processor.procesarCola();

      expect(result.procesados, 0);
      expect(result.fallidos, 1);
      verify(() => mockDb.actualizarEstadoCola(any())).called(1);
    });

    test('error en obtenerColaPendiente → retorna SyncResult con error',
        () async {
      when(() => mockDb.obtenerColaPendiente())
          .thenThrow(Exception('DB error'));

      final result = await processor.procesarCola();

      expect(result.procesados, 0);
      expect(result.fallidos, 0);
      expect(result.error, contains('DB error'));
    });
  });
}

import 'dart:convert';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:control_electoral_app/core/constants/appwrite_config.dart';
import 'package:control_electoral_app/features/sync/data/datasources/sync_remote_executor.dart';
import 'package:control_electoral_app/features/sync/domain/entities/sync_task.dart';
import 'package:control_electoral_app/features/sync/domain/exceptions/sync_exceptions.dart';
import 'package:control_electoral_app/features/sync/data/datasources/local_db_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDatabases extends Mock implements Databases {}
class MockStorage extends Mock implements Storage {}
class MockAppDatabase extends Mock implements AppDatabase {}

void main() {
  late SyncRemoteExecutorImpl executor;
  late MockDatabases mockDatabases;
  late MockStorage mockStorage;
  late MockAppDatabase mockAppDatabase;

  setUp(() {
    mockDatabases = MockDatabases();
    mockStorage = MockStorage();
    mockAppDatabase = MockAppDatabase();
    
    executor = SyncRemoteExecutorImpl(
      databases: mockDatabases,
      storage: mockStorage,
      db: mockAppDatabase,
    );
  });

  group('SyncRemoteExecutor.execute', () {
    test('veedor_jrv CREATE usa docId de payload y no envia id en data', () async {
      when(() => mockDatabases.createDocument(
            databaseId: any(named: 'databaseId'),
            collectionId: any(named: 'collectionId'),
            documentId: any(named: 'documentId'),
            data: any(named: 'data'),
          )).thenAnswer((_) async => models.Document(
            $id: 'fake_id',
            $collectionId: 'fake',
            $databaseId: 'fake',
            $createdAt: '',
            $updatedAt: '',
            $permissions: [],
            data: {},
          ));

      final task = SyncTask(
        id: 1,
        entityType: 'veedor_jrv',
        operation: 'CREATE',
        payload: jsonEncode({
          'id': 'veedor123_jrv456',
          'veedorId': 'veedor123',
          'jrvId': 'jrv456',
          'recintoId': 'recinto789',
        }),
        status: 'pending',
        attempts: 0,
        timestamp: DateTime.now(),
      );

      await executor.execute(task);

      verify(() => mockDatabases.createDocument(
            databaseId: AppwriteConfig.databaseId,
            collectionId: AppwriteConfig.collectionVeedorJrv,
            documentId: 'veedor123_jrv456',
            data: {
              'veedorId': 'veedor123',
              'jrvId': 'jrv456',
              'recintoId': 'recinto789',
            },
          )).called(1);
    });

    test('veedor_jrv fallback a UPDATE en 409', () async {
      when(() => mockDatabases.createDocument(
            databaseId: any(named: 'databaseId'),
            collectionId: any(named: 'collectionId'),
            documentId: any(named: 'documentId'),
            data: any(named: 'data'),
          )).thenThrow(AppwriteException('Conflict', 409, 'conflict'));

      when(() => mockDatabases.updateDocument(
            databaseId: any(named: 'databaseId'),
            collectionId: any(named: 'collectionId'),
            documentId: any(named: 'documentId'),
            data: any(named: 'data'),
          )).thenAnswer((_) async => models.Document(
            $id: 'fake_id',
            $collectionId: 'fake',
            $databaseId: 'fake',
            $createdAt: '',
            $updatedAt: '',
            $permissions: [],
            data: {},
          ));

      final task = SyncTask(
        id: 1,
        entityType: 'veedor_jrv',
        operation: 'CREATE',
        payload: jsonEncode({
          'id': 'veedor123_jrv456',
          'veedorId': 'veedor123',
          'jrvId': 'jrv456',
          'recintoId': 'recinto789',
        }),
        status: 'pending',
        attempts: 0,
        timestamp: DateTime.now(),
      );

      await executor.execute(task);

      verify(() => mockDatabases.updateDocument(
            databaseId: AppwriteConfig.databaseId,
            collectionId: AppwriteConfig.collectionVeedorJrv,
            documentId: 'veedor123_jrv456',
            data: {
              'veedorId': 'veedor123',
              'jrvId': 'jrv456',
              'recintoId': 'recinto789',
            },
          )).called(1);
    });
    
    test('400 se convierte en PermanentSyncFailureException', () async {
      when(() => mockDatabases.createDocument(
            databaseId: any(named: 'databaseId'),
            collectionId: any(named: 'collectionId'),
            documentId: any(named: 'documentId'),
            data: any(named: 'data'),
          )).thenThrow(AppwriteException('Bad Request', 400, 'bad_request'));

      final task = SyncTask(
        id: 1,
        entityType: 'veedor_jrv',
        operation: 'CREATE',
        payload: jsonEncode({
          'id': 'veedor123_jrv456',
          'veedorId': 'veedor123',
          'jrvId': 'jrv456',
          'recintoId': 'recinto789',
        }),
        status: 'pending',
        attempts: 0,
        timestamp: DateTime.now(),
      );

      expect(
        () => executor.execute(task),
        throwsA(isA<PermanentSyncFailureException>()),
      );
    });
  });
}

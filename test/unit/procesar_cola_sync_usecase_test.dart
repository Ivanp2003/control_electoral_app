import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:control_electoral_app/features/sync/domain/entities/sync_task.dart';
import 'package:control_electoral_app/features/sync/domain/usecases/procesar_cola_sync_usecase.dart';
import 'package:control_electoral_app/features/sync/data/datasources/sync_remote_executor.dart';
import 'package:control_electoral_app/database/app_database.dart';

class MockAppDatabase extends Mock implements AppDatabase {}
class MockSyncRemoteExecutor extends Mock implements SyncRemoteExecutor {}
class _FakeSyncTask extends Fake implements SyncTask {}

void main() {
  late MockAppDatabase mockDb;
  late MockSyncRemoteExecutor mockExecutor;
  late ProcesarColaSyncUseCase usecase;

  setUpAll(() {
    registerFallbackValue(_FakeSyncTask());
  });

  setUp(() {
    mockDb = MockAppDatabase();
    mockExecutor = MockSyncRemoteExecutor();
    usecase = ProcesarColaSyncUseCase(db: mockDb, executor: mockExecutor);
  });

  final pendingTask = SyncQueueData(
    id: 1,
    entityType: 'actas',
    operation: 'CREATE',
    payload: '{}',
    timestamp: DateTime.now(),
    attempts: 0,
    status: 'pending',
  );

  test('1. Procesamiento exitoso de una tarea -> marca como completed', () async {
    when(() => mockDb.obtenerOperacionesPendientes())
        .thenAnswer((_) async => [pendingTask]);
    
    when(() => mockExecutor.execute(any()))
        .thenAnswer((_) async {});
    
    when(() => mockDb.actualizarEstadoSync(any(), any()))
        .thenAnswer((_) async => 1);

    final result = await usecase.call();

    expect(result, const Right(unit));
    verify(() => mockExecutor.execute(any())).called(1);
    verify(() => mockDb.actualizarEstadoSync(1, 'completed')).called(1);
    verifyNever(() => mockDb.incrementarIntentoSync(any(), any(), any()));
  });

  test('2. Incremento de attempts tras fallo simulado', () async {
    when(() => mockDb.obtenerOperacionesPendientes())
        .thenAnswer((_) async => [pendingTask]);
    
    when(() => mockExecutor.execute(any()))
        .thenThrow(Exception('Simulated network error'));
    
    when(() => mockDb.incrementarIntentoSync(any(), any(), any()))
        .thenAnswer((_) async => 1);

    final result = await usecase.call();

    expect(result, const Right(unit));
    verify(() => mockExecutor.execute(any())).called(1);
    verify(() => mockDb.incrementarIntentoSync(1, 1, 'pending')).called(1);
    verifyNever(() => mockDb.actualizarEstadoSync(any(), any()));
  });

  test('3. Paso a failed tras superar el máximo de intentos', () async {
    final almostFailedTask = pendingTask.copyWith(attempts: 4);
    when(() => mockDb.obtenerOperacionesPendientes())
        .thenAnswer((_) async => [almostFailedTask]);
    
    when(() => mockExecutor.execute(any()))
        .thenThrow(Exception('Simulated network error'));
    
    when(() => mockDb.incrementarIntentoSync(any(), any(), any()))
        .thenAnswer((_) async => 1);

    final result = await usecase.call();

    expect(result, const Right(unit));
    verify(() => mockExecutor.execute(any())).called(1);
    verify(() => mockDb.incrementarIntentoSync(1, 5, 'failed')).called(1);
    verifyNever(() => mockDb.actualizarEstadoSync(any(), any()));
  });

  test('4. Paso a failed inmediato tras PermanentSyncFailureException (ej. HTTP 400)', () async {
    when(() => mockDb.obtenerOperacionesPendientes())
        .thenAnswer((_) async => [pendingTask]);
    
    when(() => mockExecutor.execute(any()))
        .thenThrow(PermanentSyncFailureException('Dato inválido'));
    
    when(() => mockDb.actualizarEstadoSync(any(), any()))
        .thenAnswer((_) async => 1);

    final result = await usecase.call();

    expect(result, const Right(unit));
    verify(() => mockExecutor.execute(any())).called(1);
    verify(() => mockDb.actualizarEstadoSync(1, 'failed')).called(1);
    verifyNever(() => mockDb.incrementarIntentoSync(any(), any(), any()));
  });
}

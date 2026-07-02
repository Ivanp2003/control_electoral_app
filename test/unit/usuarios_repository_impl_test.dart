import 'dart:convert';
import 'package:control_electoral_app/core/network/connectivity_service.dart';
import 'package:control_electoral_app/database/app_database.dart';
import 'package:control_electoral_app/features/usuarios/data/datasources/usuarios_remote_datasource.dart';
import 'package:control_electoral_app/features/usuarios/data/repositories/usuarios_repository_impl.dart';
import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:appwrite/appwrite.dart';

class MockUsuariosRemoteDatasource extends Mock implements UsuariosRemoteDatasource {}
class MockConnectivityService extends Mock implements ConnectivityService {}
class MockAppDatabase extends Mock implements AppDatabase {}

void main() {
  late MockUsuariosRemoteDatasource mockRemote;
  late MockConnectivityService mockConnectivity;
  late MockAppDatabase mockDb;
  late UsuariosRepositoryImpl repository;

  setUp(() {
    mockRemote = MockUsuariosRemoteDatasource();
    mockConnectivity = MockConnectivityService();
    mockDb = MockAppDatabase();
    repository = UsuariosRepositoryImpl(
      remote: mockRemote,
      connectivity: mockConnectivity,
      db: mockDb,
    );
    
    registerFallbackValue(const VeedorJrvLocalCompanion());
    registerFallbackValue(const SyncQueueCompanion());
  });

  group('UsuariosRepositoryImpl.asignarVeedorAJrv', () {
    test('remoto exitoso: guarda local y NO encola', () async {
      when(() => mockConnectivity.isConnected).thenAnswer((_) async => true);
      when(() => mockRemote.asignarVeedorAJrv(
            veedorId: any(named: 'veedorId'),
            jrvId: any(named: 'jrvId'),
            recintoId: any(named: 'recintoId'),
          )).thenAnswer((_) async => {});

      when(() => mockDb.guardarAsignacionVeedor(any())).thenAnswer((_) async => 1);

      final result = await repository.asignarVeedorAJrv(
        veedorId: 'v1',
        jrvId: 'j1',
        recintoId: 'r1',
      );

      expect(result.isRight(), true);
      verify(() => mockRemote.asignarVeedorAJrv(
            veedorId: 'v1',
            jrvId: 'j1',
            recintoId: 'r1',
          )).called(1);
      verify(() => mockDb.guardarAsignacionVeedor(any())).called(1);
      verifyNever(() => mockDb.encolarOperacion(any()));
    });

    test('remoto falla: guarda local y encola veedor_jrv con operation CREATE', () async {
      when(() => mockConnectivity.isConnected).thenAnswer((_) async => true);
      when(() => mockRemote.asignarVeedorAJrv(
            veedorId: any(named: 'veedorId'),
            jrvId: any(named: 'jrvId'),
            recintoId: any(named: 'recintoId'),
          )).thenThrow(AppwriteException('Error', 500, 'server_error'));

      when(() => mockDb.guardarAsignacionVeedor(any())).thenAnswer((_) async => 1);
      when(() => mockDb.encolarOperacion(any())).thenAnswer((_) async => 1);

      final result = await repository.asignarVeedorAJrv(
        veedorId: 'v1',
        jrvId: 'j1',
        recintoId: 'r1',
      );

      expect(result.isRight(), true);
      
      final capturedDbCall = verify(() => mockDb.encolarOperacion(captureAny())).captured.first as SyncQueueCompanion;
      
      expect(capturedDbCall.entityType.value, 'veedor_jrv');
      expect(capturedDbCall.operation.value, 'CREATE');
      expect(capturedDbCall.status.value, 'pending');
      
      final payload = jsonDecode(capturedDbCall.payload.value) as Map<String, dynamic>;
      expect(payload['id'], 'v1_j1');
      expect(payload['veedorId'], 'v1');
    });
  });
}

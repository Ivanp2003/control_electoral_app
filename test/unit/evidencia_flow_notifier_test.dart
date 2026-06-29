import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:control_electoral_app/core/errors/failures.dart';
import 'package:control_electoral_app/core/constants/app_roles.dart';
import 'package:control_electoral_app/features/auth/domain/entities/usuario.dart';
import 'package:control_electoral_app/features/evidencia/presentation/providers/evidencia_flow_notifier.dart';
import 'package:control_electoral_app/features/geolocalizacion/domain/entities/gps_data.dart';
import 'package:control_electoral_app/features/geolocalizacion/domain/usecases/verificar_y_capturar_gps_usecase.dart';
import 'package:control_electoral_app/features/evidencia/domain/usecases/capturar_evidencia_usecase.dart';
import 'package:control_electoral_app/features/evidencia/domain/entities/evidencia_data.dart';

import 'package:camera/camera.dart';

class MockGpsUseCase extends Mock implements VerificarYCapturarGpsUseCase {}
class MockCapturarUseCase extends Mock implements CapturarEvidenciaUseCase {}
class MockCameraController extends Mock implements CameraController {}
class _FakeGpsData extends Fake implements GpsData {}

void main() {
  late MockGpsUseCase mockGpsUseCase;
  late MockCapturarUseCase mockCapturarUseCase;
  late EvidenciaFlowNotifier notifier;

  const veedorUser = Usuario(id: '1', nombres: 'Test', apellidos: 'A', telefono: '0', correo: 'a@a.com', passwordChanged: false, cedula: '123', rol: AppRole.veedor);
  const provincialUser = Usuario(id: '2', nombres: 'Test', apellidos: 'A', telefono: '0', correo: 'a@a.com', passwordChanged: false, cedula: '456', rol: AppRole.coordinadorProvincial);

  setUpAll(() {
    registerFallbackValue(_FakeGpsData());
  });

  setUp(() {
    mockGpsUseCase = MockGpsUseCase();
    mockCapturarUseCase = MockCapturarUseCase();
    notifier = EvidenciaFlowNotifier(
      gpsUseCase: mockGpsUseCase,
      capturarUseCase: mockCapturarUseCase,
    );
  });

  group('EvidenciaFlowNotifier - Máquina de Estados', () {
    test('inicializa en estado permisoGps', () {
      expect(notifier.state.step, EvidenciaStep.permisoGps);
      expect(notifier.state.error, null);
    });

    test('Transición correcta tras GPS denegado (clava en rechazo)', () async {
      when(() => mockGpsUseCase()).thenAnswer(
        (_) async => const Left(GpsGateFailure('Permiso de ubicación denegado.')),
      );

      await notifier.capturarGps(veedorUser);

      expect(notifier.state.step, EvidenciaStep.rechazado);
      expect(notifier.state.error, contains('denegado'));
    });

    test('Transición denegada por Rol incorrecto', () async {
      // El coordinadorProvincial no puede capturar fotos
      await notifier.capturarGps(provincialUser);

      expect(notifier.state.step, EvidenciaStep.rechazado);
      expect(notifier.state.error, contains('no tiene permiso'));
    });

    test('Transición correcta tras GPS exitoso (avanza a permisoCamara)', () async {
      when(() => mockGpsUseCase()).thenAnswer(
        (_) async => Right(GpsData(latitud: -0.18, longitud: -78.46)),
      );

      await notifier.capturarGps(veedorUser);

      expect(notifier.state.step, EvidenciaStep.permisoCamara);
      expect(notifier.state.gps, isNotNull);
      expect(notifier.state.gps!.latitud, -0.18);
    });

    test('Transición correcta tras rechazo de nitidez (vuelve a capturaFoto)', () async {
      // Configuramos estado previo
      notifier.state = notifier.state.copyWith(
        step: EvidenciaStep.capturaFoto,
        gps: GpsData(latitud: 0, longitud: 0),
      );

      // Usamos un FakeCamera para que takePicture retorne algo rápido
      final mockCamera = MockCameraController();
      when(() => mockCamera.takePicture()).thenAnswer((_) async => XFile('/dummy.jpg'));
      notifier.cameraController = mockCamera;

      // Hacemos que el UseCase de nitidez devuelva error (borrosa)
      when(() => mockCapturarUseCase(
        usuario: veedorUser, 
        fotoTemporalPath: any(named: 'fotoTemporalPath'),
        gpsData: any(named: 'gpsData'),
      )).thenAnswer(
        (_) async => const Left(EvidenciaInvalidaFailure('La imagen es demasiado borrosa.')),
      );

      await notifier.tomarFotoYAnalizar(veedorUser);

      // Debe haber retrocedido a capturaFoto con error
      expect(notifier.state.step, EvidenciaStep.capturaFoto);
      expect(notifier.state.error, contains('borrosa'));
    });
  });
}

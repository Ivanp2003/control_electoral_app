import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../../lib/core/errors/failures.dart';
import '../../lib/features/evidencia/domain/services/sharpness_analyzer.dart';
import '../../lib/features/evidencia/presentation/providers/evidencia_flow_notifier.dart';
import '../../lib/features/geolocalizacion/domain/entities/gps_data.dart';
import '../../lib/features/geolocalizacion/domain/services/gps_service.dart';

class MockGpsService extends Mock implements GpsService {}

class MockSharpnessAnalyzer extends Mock implements SharpnessAnalyzer {}

class _FileFake extends Fake implements File {}

void main() {
  late MockGpsService mockGps;
  late MockSharpnessAnalyzer mockSharpness;
  late EvidenciaFlowNotifier notifier;

  setUpAll(() {
    registerFallbackValue(_FileFake());
  });

  setUp(() {
    mockGps = MockGpsService();
    mockSharpness = MockSharpnessAnalyzer();
    notifier = EvidenciaFlowNotifier(
      gpsService: mockGps,
      sharpnessAnalyzer: mockSharpness,
    );
  });

  group('EvidenciaFlowNotifier', () {
    test('inicializa en estado gpsPermission', () {
      expect(notifier.state.step, EvidenciaStep.gpsPermission);
      expect(notifier.state.cargando, false);
      expect(notifier.state.error, null);
    });

    test('GPS denegado → estado rechazado', () async {
      when(() => mockGps.verificarYCapatutar())
          .thenAnswer((_) async => const Left(
                GpsGateFailure('Permiso de ubicación denegado.'),
              ));

      await notifier.verificarGps();

      expect(notifier.state.step, EvidenciaStep.rechazado);
      expect(notifier.state.error, contains('denegado'));
      expect(notifier.state.cargando, false);
    });

    test('GPS exitoso → transiciona a cameraPermission', () async {
      when(() => mockGps.verificarYCapatutar()).thenAnswer(
        (_) async => Right(GpsData(latitud: -0.18, longitud: -78.46)),
      );

      await notifier.verificarGps();

      expect(notifier.state.step, EvidenciaStep.cameraPermission);
      expect(notifier.state.gps, isNotNull);
      expect(notifier.state.gps!.latitud, -0.18);
    });

    test('foto borrosa → regresa a capturaFoto con error', () async {
      when(() => mockGps.verificarYCapatutar()).thenAnswer(
        (_) async => Right(GpsData(latitud: -0.18, longitud: -78.46)),
      );
      await notifier.verificarGps();

      when(() => mockSharpness.isSharp(any())).thenAnswer(
        (_) async => Right(SharpnessResult(esNitida: false, score: 2.0)),
      );

      notifier.fotoCapturada('/tmp/foto_borrosa.jpg');

      await Future.delayed(Duration.zero);

      expect(notifier.state.step, EvidenciaStep.capturaFoto);
      expect(notifier.state.error, contains('borrosa'));
    });

    test('foto nítida → estado completado con EvidenciaData', () async {
      when(() => mockGps.verificarYCapatutar()).thenAnswer(
        (_) async => Right(GpsData(latitud: -0.18, longitud: -78.46)),
      );
      await notifier.verificarGps();

      when(() => mockSharpness.isSharp(any())).thenAnswer(
        (_) async => Right(SharpnessResult(esNitida: true, score: 15.0)),
      );

      notifier.fotoCapturada('/tmp/foto.jpg');

      await Future.delayed(Duration.zero);

      expect(notifier.state.step, EvidenciaStep.completado);
      expect(notifier.state.evidencia, isNotNull);
      expect(notifier.state.evidencia!.fotoPath, '/tmp/foto.jpg');
      expect(notifier.state.evidencia!.latitud, -0.18);
      expect(notifier.state.evidencia!.longitud, -78.46);
    });

    test('GPS falla con excepción → estado rechazado con mensaje', () async {
      when(() => mockGps.verificarYCapatutar())
          .thenAnswer((_) async => Left(GpsGateFailure('Error de prueba')));

      await notifier.verificarGps();

      expect(notifier.state.step, EvidenciaStep.rechazado);
      expect(notifier.state.error, contains('Error de prueba'));
    });

    test('reintentar resetea el estado a gpsPermission', () async {
      when(() => mockGps.verificarYCapatutar())
          .thenAnswer((_) async => const Left(
                GpsGateFailure('Permiso de ubicación denegado.'),
              ));
      await notifier.verificarGps();

      expect(notifier.state.step, EvidenciaStep.rechazado);

      notifier.reintentar();

      expect(notifier.state.step, EvidenciaStep.gpsPermission);
      expect(notifier.state.cargando, false);
      expect(notifier.state.error, null);
    });
  });
}

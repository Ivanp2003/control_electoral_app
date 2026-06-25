import 'package:flutter_test/flutter_test.dart';
import 'package:control_electoral_app/core/validators/acta_validator.dart';
import 'package:control_electoral_app/core/errors/failures.dart';
import 'package:dartz/dartz.dart';

void main() {
  group('validarActa — validación matemática obligatoria', () {
    test('Caso exacto: suma correcta → Right(unit)', () {
      final result = validarActa(
        totalSufragantes: 100,
        votosOrganizaciones: [30, 25, 20, 15, 5],
        votosBlancos: 3,
        votosNulos: 2,
      );

      expect(result.isRight(), isTrue);
    });

    test('Sufragantes de más (total > suma): retorna Left con "Faltan X"', () {
      final result = validarActa(
        totalSufragantes: 110,
        votosOrganizaciones: [30, 25, 20, 15, 5],
        votosBlancos: 3,
        votosNulos: 2,
      );

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) {
          expect(failure, isA<ActaInconsistenteFailure>());
          expect(failure.message, contains('Faltan'));
          expect(failure.message, contains('10'));
        },
        (_) => fail('Esperaba Left'),
      );
    });

    test('Sufragantes de menos (suma > total): retorna Left con "Hay X de más"',
        () {
      final result = validarActa(
        totalSufragantes: 90,
        votosOrganizaciones: [30, 25, 20, 15, 5],
        votosBlancos: 3,
        votosNulos: 2,
      );

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) {
          expect(failure, isA<ActaInconsistenteFailure>());
          expect(failure.message, contains('de más'));
          expect(failure.message, contains('10'));
        },
        (_) => fail('Esperaba Left'),
      );
    });

    test(
        'Un candidato supera el total de sufragantes → retorna Left (inconsistente)',
        () {
      final result = validarActa(
        totalSufragantes: 50,
        votosOrganizaciones: [60, 10, 5, 3, 2],
        votosBlancos: 1,
        votosNulos: 1,
      );

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) {
          expect(failure, isA<ActaInconsistenteFailure>());
        },
        (_) => fail('Esperaba Left'),
      );
    });

    test('Caso válido con cero blancos y cero nulos', () {
      final result = validarActa(
        totalSufragantes: 90,
        votosOrganizaciones: [30, 25, 20, 10, 5],
        votosBlancos: 0,
        votosNulos: 0,
      );

      expect(result.isRight(), isTrue);
    });

    test('Caso límite: solo una organización con todos los votos', () {
      final result = validarActa(
        totalSufragantes: 100,
        votosOrganizaciones: [95],
        votosBlancos: 3,
        votosNulos: 2,
      );

      expect(result.isRight(), isTrue);
    });

    test('Todos los valores en cero excepto total → inconsistente', () {
      final result = validarActa(
        totalSufragantes: 100,
        votosOrganizaciones: [0, 0, 0, 0, 0],
        votosBlancos: 0,
        votosNulos: 0,
      );

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) {
          expect(failure, isA<ActaInconsistenteFailure>());
          expect(failure.message, contains('Faltan'));
          expect(failure.message, contains('100'));
        },
        (_) => fail('Esperaba Left'),
      );
    });
  });
}

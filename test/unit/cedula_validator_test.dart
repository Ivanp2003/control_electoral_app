import 'package:flutter_test/flutter_test.dart';
import 'package:control_electoral_app/core/validators/cedula_validator.dart';

void main() {
  group('Validador de Cédula Ecuatoriana', () {
    test('Debería retornar true para una cédula válida (caso real 1710034065)', () {
      expect(esCedulaValida('1710034065'), isTrue);
    });

    test('Debería retornar false para la cédula no válida 1234567890', () {
      expect(esCedulaValida('1234567890'), isFalse);
    });

    test('Debería retornar false si la longitud no es exactamente 10', () {
      expect(esCedulaValida('171003406'), isFalse);
      expect(esCedulaValida('17100340659'), isFalse);
    });

    test('Debería retornar false si contiene caracteres no numéricos', () {
      expect(esCedulaValida('171003406a'), isFalse);
      expect(esCedulaValida('1710-34065'), isFalse);
    });

    test('Debería retornar false si el código de provincia es menor a 01 o mayor a 24', () {
      // Provincia 00 no existe
      expect(esCedulaValida('0010034060'), isFalse);
      // Provincia 25 no existe en Ecuador
      expect(esCedulaValida('2510034066'), isFalse);
    });

    test('Debería retornar false si el tercer dígito es mayor o igual a 6 (personas jurídicas / extranjería no naturales)', () {
      // Tercer dígito es 6 (1760034065)
      expect(esCedulaValida('1760034065'), isFalse);
    });
  });
}

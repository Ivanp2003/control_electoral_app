import 'package:control_electoral_app/core/utils/appwrite_id_helper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppwriteIdHelper', () {
    final validIdRegex = RegExp(r'^[a-zA-Z0-9][a-zA-Z0-9_]{0,35}$');

    group('actaId', () {
      test('retorna <= 36 caracteres', () {
        final id = AppwriteIdHelper.actaId(
          jrvId: '6507ec4e-1234-5678-abcd-ef0123456789',
          cargoElectoral: 'alcalde',
        );
        expect(id.length, lessThanOrEqualTo(36));
      });

      test('no inicia con underscore', () {
        final id = AppwriteIdHelper.actaId(
          jrvId: '6507ec4e-1234-5678-abcd-ef0123456789',
          cargoElectoral: 'prefecto',
        );
        expect(id.startsWith('_'), isFalse);
      });

      test('solo contiene letras, numeros y underscore', () {
        final id = AppwriteIdHelper.actaId(
          jrvId: '6507ec4e-1234-5678-abcd-ef0123456789',
          cargoElectoral: 'alcalde',
        );
        expect(validIdRegex.hasMatch(id), isTrue);
      });

      test('es deterministico: el mismo input produce el mismo output', () {
        final id1 = AppwriteIdHelper.actaId(
          jrvId: 'same-jrv-id-123',
          cargoElectoral: 'alcalde',
        );
        final id2 = AppwriteIdHelper.actaId(
          jrvId: 'same-jrv-id-123',
          cargoElectoral: 'alcalde',
        );
        expect(id1, equals(id2));
      });
    });

    group('actaDetalleId', () {
      test('retorna <= 36 caracteres', () {
        final id = AppwriteIdHelper.actaDetalleId(
          actaId: 'acta_abcdef1234567890',
          organizacionId: '6507ec4e-1234-5678-abcd-ef0123456789',
        );
        expect(id.length, lessThanOrEqualTo(36));
      });

      test('es valido para Appwrite', () {
        final id = AppwriteIdHelper.actaDetalleId(
          actaId: 'acta_abcdef1234567890',
          organizacionId: '6507ec4e-1234-5678-abcd-ef0123456789',
        );
        expect(validIdRegex.hasMatch(id), isTrue);
      });

      test('es deterministico', () {
        final id1 = AppwriteIdHelper.actaDetalleId(
          actaId: 'acta_abcdef1234567890',
          organizacionId: 'org-id-1234',
        );
        final id2 = AppwriteIdHelper.actaDetalleId(
          actaId: 'acta_abcdef1234567890',
          organizacionId: 'org-id-1234',
        );
        expect(id1, equals(id2));
      });
    });

    group('veedorJrvId', () {
      test('retorna <= 36 caracteres', () {
        final id = AppwriteIdHelper.veedorJrvId(
          veedorId: '6507ec4e-1234-5678-abcd-ef0123456789',
          jrvId: '6a3deb26-0033-fbc8-be94-111111111111',
        );
        expect(id.length, lessThanOrEqualTo(36));
      });

      test('es valido para Appwrite', () {
        final id = AppwriteIdHelper.veedorJrvId(
          veedorId: '6507ec4e-1234-5678-abcd-ef0123456789',
          jrvId: '6a3deb26-0033-fbc8-be94-111111111111',
        );
        expect(validIdRegex.hasMatch(id), isTrue);
      });

      test('es deterministico', () {
        final id1 = AppwriteIdHelper.veedorJrvId(
          veedorId: 'veedor-abc-123',
          jrvId: 'jrv-xyz-456',
        );
        final id2 = AppwriteIdHelper.veedorJrvId(
          veedorId: 'veedor-abc-123',
          jrvId: 'jrv-xyz-456',
        );
        expect(id1, equals(id2));
      });
    });

    group('isValidAppwriteId', () {
      test('retorna true para ID valido', () {
        expect(AppwriteIdHelper.isValidAppwriteId('acta_abc123'), isTrue);
      });

      test('retorna false para ID con guion', () {
        expect(AppwriteIdHelper.isValidAppwriteId('acta-abc123'), isFalse);
      });

      test('retorna false para ID mayor a 36 chars', () {
        final longId = 'a' * 37;
        expect(AppwriteIdHelper.isValidAppwriteId(longId), isFalse);
      });

      test('retorna false para ID que empieza con underscore', () {
        expect(AppwriteIdHelper.isValidAppwriteId('_abc123'), isFalse);
      });

      test('retorna true para 36 chars exactos', () {
        final id36 = 'a' * 36;
        expect(AppwriteIdHelper.isValidAppwriteId(id36), isTrue);
      });
    });
  });
}

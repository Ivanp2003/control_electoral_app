import 'dart:convert';
import 'package:crypto/crypto.dart';

/// AppwriteIdHelper
///
/// Centraliza la generación de Document IDs seguros para Appwrite.
///
/// Reglas de Appwrite para documentId:
/// - Máximo 36 caracteres
/// - Solo: a-z, A-Z, 0-9, underscore (_)
/// - No puede empezar con underscore
class AppwriteIdHelper {
  AppwriteIdHelper._();

  /// Genera un ID determinístico y seguro para Appwrite a partir de un
  /// prefijo y una cadena raw (que puede contener guiones, tildes, etc.).
  ///
  /// El resultado siempre:
  /// - Es ≤ 36 caracteres
  /// - Contiene solo a-z, A-Z, 0-9, y _
  /// - No empieza con _
  /// - Es idempotente: el mismo input siempre produce el mismo output
  static String safeDeterministicId({
    required String prefix,
    required String raw,
  }) {
    // Limpiar el prefijo: solo alfanuméricos y _, sin guión inicial
    final normalizedPrefix = prefix
        .replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '_')
        .replaceFirst(RegExp(r'^_+'), '');

    final safePrefix = normalizedPrefix.isEmpty ? 'id' : normalizedPrefix;
    final hash = sha1.convert(utf8.encode(raw)).toString();

    // sha1 produce 40 chars hex (a-f, 0-9) — ya son válidos
    final maxHashLength = 36 - safePrefix.length - 1; // -1 por el '_' separador
    final safeHashLength = maxHashLength.clamp(8, 35);

    return '${safePrefix}_${hash.substring(0, safeHashLength)}';
  }

  /// ID para un acta. Determinístico por jrvId + cargoElectoral.
  /// Formato: acta_{sha1_truncado} → máx 36 chars.
  static String actaId({
    required String jrvId,
    required String cargoElectoral,
  }) {
    return safeDeterministicId(
      prefix: 'acta',
      raw: '${jrvId}_${cargoElectoral.toLowerCase()}',
    );
  }

  /// ID para un registro de acta_detalle. Determinístico por actaId + organizacionId.
  /// Formato: det_{sha1_truncado} → máx 36 chars.
  static String actaDetalleId({
    required String actaId,
    required String organizacionId,
  }) {
    return safeDeterministicId(
      prefix: 'det',
      raw: '${actaId}_$organizacionId',
    );
  }

  /// ID para una asignación veedor↔JRV. Determinístico por veedorId + jrvId.
  /// Formato: vj_{sha1_truncado} → máx 36 chars.
  static String veedorJrvId({
    required String veedorId,
    required String jrvId,
  }) {
    return safeDeterministicId(
      prefix: 'vj',
      raw: '${veedorId}_$jrvId',
    );
  }

  /// Valida que un ID cumpla las reglas de Appwrite.
  static bool isValidAppwriteId(String id) {
    final regex = RegExp(r'^[a-zA-Z0-9][a-zA-Z0-9_]{0,35}$');
    return regex.hasMatch(id);
  }
}

// cedula_validator.dart
// 
// Responsabilidad Única: Implementar el algoritmo oficial de validación de la 
// Cédula de Identidad Ecuatoriana (módulo 10).
// Cambios en esta clase ocurren si cambian las especificaciones oficiales del Registro Civil.

/// Valida si una cédula ecuatoriana cumple con los criterios oficiales del módulo 10.
/// 
/// - Debe tener exactamente 10 caracteres.
/// - Debe contener únicamente dígitos del 0 al 9.
/// - Los dos primeros dígitos (código de provincia) deben estar en el rango [01, 24].
/// - El tercer dígito debe ser menor a 6 (personas naturales).
/// - El dígito verificador (10mo dígito) debe coincidir con el resultado del algoritmo módulo 10.
bool esCedulaValida(String cedula) {
  // 1. Validar longitud exacta de 10 caracteres
  if (cedula.length != 10) {
    return false;
  }

  // 2. Validar que contenga solo números
  final isDigitsOnly = RegExp(r'^\d+$').hasMatch(cedula);
  if (!isDigitsOnly) {
    return false;
  }

  // 3. Validar código de provincia (dos primeros dígitos entre 01 y 24)
  final provinciaCode = int.tryParse(cedula.substring(0, 2)) ?? 0;
  if (provinciaCode < 1 || provinciaCode > 24) {
    return false;
  }

  // 4. Validar que el tercer dígito sea menor a 6 (persona natural)
  final tercerDigito = int.tryParse(cedula.substring(2, 3)) ?? 9;
  if (tercerDigito >= 6) {
    return false;
  }

  // 5. Aplicar algoritmo módulo 10
  final digitos = cedula.split('').map(int.parse).toList();
  int suma = 0;

  for (int i = 0; i < 9; i++) {
    int valor = digitos[i];
    if (i % 2 == 0) {
      // Posiciones impares de base 1 (0, 2, 4, 6, 8 en índice 0-indexed) se multiplican por 2
      valor *= 2;
      if (valor >= 9) {
        valor -= 9;
      }
    } else {
      // Posiciones pares de base 1 (1, 3, 5, 7 en índice 0-indexed) se multiplican por 1
      valor *= 1;
    }
    suma += valor;
  }

  // Obtener dígito verificador calculado
  final digitoVerificadorCalculado = (10 - (suma % 10)) % 10;
  final digitoVerificadorReal = digitos[9];

  return digitoVerificadorCalculado == digitoVerificadorReal;
}

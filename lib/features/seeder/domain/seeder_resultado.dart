/// seeder_resultado.dart
///
/// Responsabilidad Única: Modelo de resultado del Seeder de datos iniciales.
/// Encapsula los contadores de documentos creados y el estado de idempotencia.

class SeederResultado {
  final int provinciasCreadas;
  final int cantonesCreados;
  final int parroquiasCreadas;
  final int recintosCreados;
  final int jrvCreadas;
  final int organizacionesCreadas;

  /// true si el seeder ya había sido ejecutado anteriormente y no se insertó nada nuevo.
  final bool yaEjecutado;

  const SeederResultado({
    this.provinciasCreadas = 0,
    this.cantonesCreados = 0,
    this.parroquiasCreadas = 0,
    this.recintosCreados = 0,
    this.jrvCreadas = 0,
    this.organizacionesCreadas = 0,
    this.yaEjecutado = false,
  });

  /// Constructor de conveniencia para el caso ya-ejecutado.
  const SeederResultado.yaEjecutado()
      : provinciasCreadas = 0,
        cantonesCreados = 0,
        parroquiasCreadas = 0,
        recintosCreados = 0,
        jrvCreadas = 0,
        organizacionesCreadas = 0,
        yaEjecutado = true;

  /// Total de documentos creados en esta ejecución.
  int get totalCreados =>
      provinciasCreadas +
      cantonesCreados +
      parroquiasCreadas +
      recintosCreados +
      jrvCreadas +
      organizacionesCreadas;
}

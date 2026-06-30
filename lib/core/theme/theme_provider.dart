import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider que maneja el modo de tema actual (Claro u Oscuro).
/// Por defecto utiliza el tema del sistema (ThemeMode.system).
final themeNotifierProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.system);

  void toggleTheme() {
    if (state == ThemeMode.light) {
      state = ThemeMode.dark;
    } else if (state == ThemeMode.dark) {
      state = ThemeMode.light;
    } else {
      // Si está en system, lo forzamos a cambiar al opuesto asumiendo una base.
      // Aquí por simplicidad pasamos a oscuro (podría leer la preferencia de la plataforma).
      state = ThemeMode.dark;
    }
  }

  void setTheme(ThemeMode mode) {
    state = mode;
  }
}

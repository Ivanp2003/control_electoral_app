import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/network/appwrite_client.dart';
import 'database/app_database.dart';

import 'features/auth/presentation/providers/auth_providers.dart';

/// main.dart
/// 
/// Responsabilidad Única: Punto de entrada principal de la aplicación que coordina la
/// inicialización segura y secuencial de servicios persistentes antes del arranque de la UI.
/// Cambios en esta clase ocurren si cambian los requerimientos globales de arranque.

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final container = ProviderContainer();

  try {
    // 1. Forzar la inicialización y verificar la conexión a la base SQLite local (Drift).
    // Dado que Drift abre la base de datos de manera lazy, ejecutamos una consulta
    // de prueba para capturar errores de archivo cerrado o bloqueos de sqlite en el arranque.
    final db = container.read(appDatabaseProvider);
    await db.customSelect('SELECT 1').getSingle();

    // 2. Forzar la inicialización del cliente de Appwrite.
    // Lanzará un error si faltan las credenciales definidas en el entorno.
    container.read(appwriteServicesProvider);
  } catch (e) {
    // Si la inicialización falla, arrancamos con la vista de error directamente
    // evitando una pantalla en blanco o excepciones no controladas.
    runApp(_AppInitErrorView(error: e));
    return;
  }

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const MyApp(),
    ),
  );
}

/// Widget principal de la aplicación.
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      routerConfig: router,
      title: 'Control Electoral Ecuador',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0F4C81), // Azul clásico premium
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Inter',
      ),
    );
  }
}

/// Vista de fallback cuando falla la base de datos o validaciones críticas de entorno.
class _AppInitErrorView extends StatelessWidget {
  final Object error;

  const _AppInitErrorView({required this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFFFDF2F2), // Fondo rojo tenue de advertencia
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Color(0xFFDE3B3B),
                  size: 80,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Fallo Crítico de Inicialización',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFDE3B3B),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFF5B5B5)),
                  ),
                  child: Text(
                    error.toString(),
                    style: const TextStyle(
                      fontFamily: 'Courier',
                      fontSize: 13,
                      color: Color(0xFF4A4A4A),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Por favor corrija la configuración e inicie nuevamente la aplicación.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF7F7F7F),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

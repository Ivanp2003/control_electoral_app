import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/presentation/providers/auth_providers.dart';
import 'seeder_providers.dart';

/// seeder_screen.dart
///
/// Responsabilidad Única: Pantalla de ejecución manual del Seeder de datos iniciales.
/// Accesible únicamente para el Coordinador Provincial (guard en router + use case).
///
/// Estados:
///   idle     → Botón "Cargar datos iniciales" + descripción.
///   loading  → LinearProgressIndicator + mensaje de progreso granular.
///   success  → Resumen de documentos creados / banner "ya ejecutado".
///   error    → Mensaje + botón Reintentar.

class SeederScreen extends ConsumerWidget {
  const SeederScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seederState = ref.watch(seederNotifierProvider);
    final progress = ref.watch(seederProgressProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0A1628),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F2442),
        title: const Text(
          'Carga de Datos Iniciales',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: seederState.when(
          data: (resultado) {
            if (resultado == null) {
              // Estado idle
              return _IdleState(
                onExecute: () => _confirmarYEjecutar(context, ref),
              );
            }
            if (resultado.yaEjecutado) {
              return _YaEjecutadoState();
            }
            return _SuccessState(resultado: resultado);
          },
          loading: () => _LoadingState(mensaje: progress),
          error: (e, _) => _ErrorState(
            mensaje: e.toString(),
            onRetry: () => _confirmarYEjecutar(context, ref),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmarYEjecutar(
      BuildContext context, WidgetRef ref) async {
    final usuario = ref.read(currentUserProvider);
    if (usuario == null) return;

    final confirmado = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF0F2442),
        title: const Text('Confirmar carga de datos',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: const Text(
          'Se insertarán los datos iniciales de la jerarquía geográfica '
          '(provincia, cantón, parroquias, recintos y JRV) y las organizaciones '
          'políticas en el servidor de Appwrite.\n\n'
          'Esta operación puede tomar varios segundos. ¿Deseas continuar?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar',
                style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A90D9)),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Cargar datos',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmado == true) {
      ref.read(seederNotifierProvider.notifier).ejecutar(usuario.rol);
    }
  }
}

// ─── Estados ─────────────────────────────────────────────────────────────────

class _IdleState extends StatelessWidget {
  final VoidCallback onExecute;
  const _IdleState({required this.onExecute});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.cloud_upload_outlined,
            size: 80, color: Color(0xFF4A90D9)),
        const SizedBox(height: 24),
        const Text(
          'Carga de Datos Iniciales',
          style: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        const Text(
          'Este proceso insertará en Appwrite:\n'
          '• 1 Provincia (Pichincha)\n'
          '• 1 Cantón (Quito)\n'
          '• 4 Parroquias\n'
          '• 8 Recintos electorales\n'
          '• 24 Juntas Receptoras del Voto\n'
          '• 10 Organizaciones políticas',
          style: TextStyle(color: Colors.white60, fontSize: 14, height: 1.6),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.amber.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.amber.withOpacity(0.4)),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.info_outline, color: Colors.amber, size: 16),
              SizedBox(width: 8),
              Text('Solo debe ejecutarse una vez.',
                  style: TextStyle(color: Colors.amber, fontSize: 12)),
            ],
          ),
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4A90D9),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: onExecute,
            icon: const Icon(Icons.play_arrow_rounded),
            label: const Text('Cargar datos iniciales',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }
}

class _LoadingState extends StatelessWidget {
  final String mensaje;
  const _LoadingState({required this.mensaje});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.cloud_sync_outlined,
            size: 64, color: Color(0xFF4A90D9)),
        const SizedBox(height: 24),
        const Text('Cargando datos...',
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 24),
        const LinearProgressIndicator(
          color: Color(0xFF4A90D9),
          backgroundColor: Color(0xFF0F2442),
          minHeight: 6,
        ),
        const SizedBox(height: 16),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Text(
            mensaje.isEmpty ? 'Iniciando...' : mensaje,
            key: ValueKey(mensaje),
            style: const TextStyle(color: Colors.white60, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

class _SuccessState extends StatelessWidget {
  final dynamic resultado;
  const _SuccessState({required this.resultado});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.check_circle_rounded,
            size: 80, color: Colors.greenAccent),
        const SizedBox(height: 24),
        const Text(
          '¡Datos cargados exitosamente!',
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        _ResumenItem(icon: Icons.map_outlined,
            label: 'Provincias', count: resultado.provinciasCreadas),
        _ResumenItem(icon: Icons.location_city_outlined,
            label: 'Cantones', count: resultado.cantonesCreados),
        _ResumenItem(icon: Icons.business_outlined,
            label: 'Parroquias', count: resultado.parroquiasCreadas),
        _ResumenItem(icon: Icons.school_outlined,
            label: 'Recintos', count: resultado.recintosCreados),
        _ResumenItem(icon: Icons.how_to_vote_outlined,
            label: 'JRV', count: resultado.jrvCreadas),
        _ResumenItem(icon: Icons.account_balance_outlined,
            label: 'Organizaciones', count: resultado.organizacionesCreadas),
      ],
    );
  }
}

class _ResumenItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  const _ResumenItem(
      {required this.icon, required this.label, required this.count});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF4A90D9), size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(label,
              style: const TextStyle(color: Colors.white70))),
          Text('$count creados',
              style: const TextStyle(
                  color: Colors.greenAccent, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _YaEjecutadoState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.verified_outlined, size: 80, color: Colors.amber),
        const SizedBox(height: 24),
        const Text('Seeder ya ejecutado',
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        const Text(
          'Los datos iniciales ya fueron cargados previamente en el sistema. '
          'No es necesario ejecutar este proceso nuevamente.',
          style: TextStyle(color: Colors.white60, fontSize: 14, height: 1.5),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String mensaje;
  final VoidCallback onRetry;
  const _ErrorState({required this.mensaje, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.cloud_off_outlined, size: 80, color: Colors.redAccent),
        const SizedBox(height: 24),
        const Text('Error durante la carga',
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Text(mensaje,
            style: const TextStyle(color: Colors.white54, fontSize: 13),
            textAlign: TextAlign.center),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Reintentar',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/recintos_providers.dart';

/// recintos_list_screen.dart
///
/// Responsabilidad Única: Mostrar la lista de recintos electorales agrupados
/// por parroquia, con los cuatro estados: loading, success, error, empty.
/// La navegación a CrearRecintoScreen se muestra solo si el rol lo permite
/// (el router también aplica su guard independiente).

class RecintosListScreen extends ConsumerStatefulWidget {
  const RecintosListScreen({super.key});

  @override
  ConsumerState<RecintosListScreen> createState() => _RecintosListScreenState();
}

class _RecintosListScreenState extends ConsumerState<RecintosListScreen> {
  /// Para este MVP, cargamos la provincia/canton hardcodeada del seeder.
  /// En una versión futura esto se seleccionaría dinámicamente.
  static const String _cantonIdPlaceholder = '';

  @override
  Widget build(BuildContext context) {
    final provinciasAsync = ref.watch(provinciasProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0A1628),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F2442),
        title: const Text(
          'Recintos Electorales',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: provinciasAsync.when(
        loading: () => const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Color(0xFF4A90D9)),
              SizedBox(height: 16),
              Text('Cargando recintos...',
                  style: TextStyle(color: Colors.white70)),
            ],
          ),
        ),
        error: (e, _) => _ErrorState(mensaje: e.toString()),
        data: (provincias) {
          if (provincias.isEmpty) {
            return const _EmptyState();
          }
          // Mostrar la provincia y navegar a sus cantones/parroquias/recintos.
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provincias.length,
            itemBuilder: (context, index) {
              final provincia = provincias[index];
              return _ProvinciaCard(provinciaId: provincia.id, nombre: provincia.nombre);
            },
          );
        },
      ),
    );
  }
}

class _ProvinciaCard extends ConsumerWidget {
  final String provinciaId;
  final String nombre;
  const _ProvinciaCard({required this.provinciaId, required this.nombre});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cantonesAsync = ref.watch(cantonesProvider(provinciaId));
    return Card(
      color: const Color(0xFF0F2442),
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        iconColor: const Color(0xFF4A90D9),
        collapsedIconColor: Colors.white54,
        title: Text(nombre,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: const Text('Provincia', style: TextStyle(color: Colors.white54)),
        children: [
          cantonesAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(color: Color(0xFF4A90D9)),
            ),
            error: (e, _) => Padding(
              padding: const EdgeInsets.all(12),
              child: Text('Error: $e',
                  style: const TextStyle(color: Colors.redAccent)),
            ),
            data: (cantones) => Column(
              children: cantones
                  .map((c) => _CantonTile(cantonId: c.id, nombre: c.nombre))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _CantonTile extends ConsumerWidget {
  final String cantonId;
  final String nombre;
  const _CantonTile({required this.cantonId, required this.nombre});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final parroquiasAsync = ref.watch(parroquiasProvider(cantonId));
    return ExpansionTile(
      iconColor: const Color(0xFF4A90D9),
      collapsedIconColor: Colors.white54,
      tilePadding: const EdgeInsets.symmetric(horizontal: 24),
      title: Text(nombre, style: const TextStyle(color: Colors.white70)),
      subtitle: const Text('Cantón', style: TextStyle(color: Colors.white38, fontSize: 11)),
      children: [
        parroquiasAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.all(12),
            child: CircularProgressIndicator(color: Color(0xFF4A90D9)),
          ),
          error: (e, _) => Padding(
            padding: const EdgeInsets.all(12),
            child:
                Text('Error: $e', style: const TextStyle(color: Colors.redAccent)),
          ),
          data: (parroquias) => Column(
            children: parroquias
                .map((p) => _ParroquiaTile(parroquiaId: p.id, nombre: p.nombre))
                .toList(),
          ),
        ),
      ],
    );
  }
}

class _ParroquiaTile extends ConsumerWidget {
  final String parroquiaId;
  final String nombre;
  const _ParroquiaTile({required this.parroquiaId, required this.nombre});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recintosAsync = ref.watch(recintosProvider(parroquiaId));
    return ExpansionTile(
      iconColor: const Color(0xFF4A90D9),
      collapsedIconColor: Colors.white54,
      tilePadding: const EdgeInsets.symmetric(horizontal: 36),
      title: Text(nombre, style: const TextStyle(color: Colors.white60)),
      subtitle:
          const Text('Parroquia', style: TextStyle(color: Colors.white38, fontSize: 11)),
      children: [
        recintosAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.all(12),
            child: CircularProgressIndicator(color: Color(0xFF4A90D9)),
          ),
          error: (e, _) => Padding(
            padding: const EdgeInsets.all(12),
            child:
                Text('Error: $e', style: const TextStyle(color: Colors.redAccent)),
          ),
          data: (recintos) {
            if (recintos.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Text('Sin recintos registrados.',
                    style: TextStyle(color: Colors.white38)),
              );
            }
            return Column(
              children: recintos
                  .map((r) => ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 48),
                        leading: const Icon(Icons.location_on_outlined,
                            color: Color(0xFF4A90D9), size: 18),
                        title: Text(r.nombre,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 14)),
                        subtitle: Text(r.direccion,
                            style: const TextStyle(
                                color: Colors.white38, fontSize: 12)),
                      ))
                  .toList(),
            );
          },
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.map_outlined, size: 64, color: Colors.white24),
          SizedBox(height: 16),
          Text('No hay recintos registrados.',
              style: TextStyle(color: Colors.white54, fontSize: 16)),
          SizedBox(height: 8),
          Text('Ejecuta el Seeder para cargar los datos iniciales.',
              style: TextStyle(color: Colors.white38, fontSize: 13)),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String mensaje;
  const _ErrorState({required this.mensaje});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 64, color: Colors.redAccent),
            const SizedBox(height: 16),
            const Text('Error al cargar recintos',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(mensaje,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white54, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}

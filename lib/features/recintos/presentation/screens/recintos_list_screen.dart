import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/recintos_providers.dart';
import '../../../../core/presentation/widgets/theme_toggle_button.dart';

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

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Recintos Electorales',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: const [
          ThemeToggleButton(),
        ],
      ),
      body: provinciasAsync.when(
        loading: () => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: colorScheme.primary),
              const SizedBox(height: 16),
              Text('Cargando recintos...',
                  style: TextStyle(color: colorScheme.onSurface.withOpacity(0.7))),
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        iconColor: colorScheme.primary,
        collapsedIconColor: colorScheme.onSurface.withOpacity(0.54),
        title: Text(nombre,
            style: TextStyle(
                color: colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Text('Provincia', style: TextStyle(color: colorScheme.onSurface.withOpacity(0.54))),
        children: [
          cantonesAsync.when(
            loading: () => Padding(
              padding: const EdgeInsets.all(16),
              child: CircularProgressIndicator(color: colorScheme.primary),
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ExpansionTile(
      iconColor: colorScheme.primary,
      collapsedIconColor: colorScheme.onSurface.withOpacity(0.54),
      tilePadding: const EdgeInsets.symmetric(horizontal: 24),
      title: Text(nombre, style: TextStyle(color: colorScheme.onSurface.withOpacity(0.7))),
      subtitle: Text('Cantón', style: TextStyle(color: colorScheme.onSurface.withOpacity(0.38), fontSize: 11)),
      children: [
        parroquiasAsync.when(
          loading: () => Padding(
            padding: const EdgeInsets.all(12),
            child: CircularProgressIndicator(color: colorScheme.primary),
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ExpansionTile(
      iconColor: colorScheme.primary,
      collapsedIconColor: colorScheme.onSurface.withOpacity(0.54),
      tilePadding: const EdgeInsets.symmetric(horizontal: 36),
      title: Text(nombre, style: TextStyle(color: colorScheme.onSurface.withOpacity(0.6))),
      subtitle:
          Text('Parroquia', style: TextStyle(color: colorScheme.onSurface.withOpacity(0.38), fontSize: 11)),
      children: [
        recintosAsync.when(
          loading: () => Padding(
            padding: const EdgeInsets.all(12),
            child: CircularProgressIndicator(color: colorScheme.primary),
          ),
          error: (e, _) => Padding(
            padding: const EdgeInsets.all(12),
            child:
                Text('Error: $e', style: const TextStyle(color: Colors.redAccent)),
          ),
          data: (recintos) {
            if (recintos.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Sin recintos registrados.',
                    style: TextStyle(color: colorScheme.onSurface.withOpacity(0.38))),
              );
            }
            return Column(
              children: recintos
                  .map((r) => ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 48),
                        leading: Icon(Icons.location_on_outlined,
                            color: colorScheme.primary, size: 18),
                        title: Text(r.nombre,
                            style: TextStyle(
                                color: colorScheme.onSurface, fontSize: 14)),
                        subtitle: Text(r.direccion,
                            style: TextStyle(
                                color: colorScheme.onSurface.withOpacity(0.38), fontSize: 12)),
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
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.map_outlined, size: 64, color: theme.colorScheme.onSurface.withOpacity(0.24)),
          const SizedBox(height: 16),
          Text('No hay recintos registrados.',
              style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.54), fontSize: 16)),
          const SizedBox(height: 8),
          Text('Ejecuta el Seeder para cargar los datos iniciales.',
              style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.38), fontSize: 13)),
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
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 64, color: Colors.redAccent),
            const SizedBox(height: 16),
            Text('Error al cargar recintos',
                style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(mensaje,
                textAlign: TextAlign.center,
                style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.54), fontSize: 13)),
          ],
        ),
      ),
    );
  }
}

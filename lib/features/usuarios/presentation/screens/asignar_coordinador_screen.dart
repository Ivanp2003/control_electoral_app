import 'dart:convert';

import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/presentation/widgets/theme_toggle_button.dart';
import '../../../../core/validators/cedula_validator.dart';
import '../../../../database/app_database.dart';

class AsignarCoordinadorScreen extends ConsumerStatefulWidget {
  const AsignarCoordinadorScreen({super.key});

  @override
  ConsumerState<AsignarCoordinadorScreen> createState() =>
      _AsignarCoordinadorScreenState();
}

class _AsignarCoordinadorScreenState
    extends ConsumerState<AsignarCoordinadorScreen> {
  final _searchCtrl = TextEditingController();
  RecintosLocalData? _recintoSeleccionado;
  String? _mensaje;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final db = ref.read(appDatabaseProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final surfaceColor = theme.cardTheme.color ?? colorScheme.surface;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Asignar Coordinador',
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: const [
          ThemeToggleButton(),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchCtrl,
              style: TextStyle(color: colorScheme.onSurface),
              decoration: InputDecoration(
                hintText: 'Buscar recinto...',
                hintStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.38)),
                prefixIcon:
                    Icon(Icons.search, color: colorScheme.onSurface.withOpacity(0.38)),
                filled: true,
                fillColor: surfaceColor,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          if (_mensaje != null)
            Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: Colors.greenAccent.withOpacity(0.4)),
              ),
              child: Text(_mensaje!,
                  style:
                      const TextStyle(color: Colors.greenAccent)),
            ),
          Expanded(
            child: FutureBuilder<List<RecintosLocalData>>(
              future: db.obtenerTodasLasRecintos(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                      child: CircularProgressIndicator(
                          color: colorScheme.primary));
                }
                final filtro = _searchCtrl.text.toLowerCase();
                final recintos = snapshot.data!
                    .where((r) =>
                        r.nombre.toLowerCase().contains(filtro) ||
                        r.id.toLowerCase().contains(filtro))
                    .toList();

                if (recintos.isEmpty) {
                  return Center(
                    child: Text('No se encontraron recintos.',
                        style: TextStyle(color: colorScheme.onSurface.withOpacity(0.54))),
                  );
                }
                return ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: recintos.length,
                  itemBuilder: (_, i) {
                    final r = recintos[i];
                    final seleccionado =
                        _recintoSeleccionado?.id == r.id;
                    return Card(
                      color: seleccionado
                          ? colorScheme.primary.withOpacity(0.2)
                          : surfaceColor,
                      margin:
                          const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        title: Text(r.nombre,
                            style: TextStyle(
                                color: colorScheme.onSurface,
                                fontWeight: FontWeight.w500)),
                        subtitle: Text('ID: ${r.id}',
                            style: TextStyle(
                                color: colorScheme.onSurface.withOpacity(0.38),
                                fontSize: 12)),
                        trailing: seleccionado
                            ? Icon(Icons.check_circle,
                                color: colorScheme.primary)
                            : null,
                        onTap: () =>
                            _mostrarDialogoCedula(context, r, colorScheme, surfaceColor, theme.scaffoldBackgroundColor),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _mostrarDialogoCedula(
      BuildContext context, RecintosLocalData recinto, ColorScheme colorScheme, Color surfaceColor, Color scaffoldBg) {
    final cedulaCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: surfaceColor,
        title: Text('Asignar Coordinador',
            style: TextStyle(color: colorScheme.onSurface)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Recinto: ${recinto.nombre}',
                style: TextStyle(color: colorScheme.onSurface.withOpacity(0.7))),
            const SizedBox(height: 16),
            TextField(
              controller: cedulaCtrl,
              maxLength: 10,
              keyboardType: TextInputType.number,
              style: TextStyle(color: colorScheme.onSurface),
              decoration: InputDecoration(
                labelText: 'Cédula del coordinador',
                labelStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.54)),
                filled: true,
                fillColor: scaffoldBg,
                border: const OutlineInputBorder(
                    borderSide: BorderSide.none),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancelar',
                style: TextStyle(color: colorScheme.onSurface.withOpacity(0.54))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
            ),
            onPressed: () {
              final cedula = cedulaCtrl.text.trim();
              if (!esCedulaValida(cedula)) {
                ScaffoldMessenger.of(ctx).showSnackBar(
                  const SnackBar(
                      content:
                          Text('Cédula inválida')),
                );
                return;
              }
              Navigator.pop(ctx);
              _asignar(recinto, cedula);
            },
            child: const Text('Asignar'),
          ),
        ],
      ),
    );
  }

  Future<void> _asignar(
      RecintosLocalData recinto, String cedula) async {
    final db = ref.read(appDatabaseProvider);

    // 1. Local-write: Actualizar de inmediato el coordinadorId del recinto local en Drift
    // Nota: El usuario actual no se almacena en una tabla local usuariosLocal en Drift,
    // pero marcamos al recinto local con un marcador temporal de 'asignado' para indicar que se vinculó.
    await db.update(db.recintosLocal).replace(recinto.copyWith(coordinadorId: Value('cedula:$cedula')));

    // 2. Encolar la sincronización a Appwrite (que hará la vinculación bidireccional)
    await db.encolarOperacion(SyncQueueCompanion(
      entityType: const Value('recinto'),
      operation: const Value('asignarCoordinador'),
      payload: Value(jsonEncode({
        'recintoId': recinto.id,
        'cedulaCoordinador': cedula,
      })),
      status: const Value('pending'),
    ));

    setState(() {
      _recintoSeleccionado = recinto;
      _mensaje =
          'Asignación encolada para ${recinto.nombre} (pendiente de sincronización)';
    });
  }
}

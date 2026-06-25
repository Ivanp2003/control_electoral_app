import 'dart:convert';

import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

    return Scaffold(
      backgroundColor: const Color(0xFF0A1628),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F2442),
        title: const Text('Asignar Coordinador',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Buscar recinto...',
                hintStyle: const TextStyle(color: Colors.white38),
                prefixIcon:
                    const Icon(Icons.search, color: Colors.white38),
                filled: true,
                fillColor: const Color(0xFF0F2442),
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
                  return const Center(
                      child: CircularProgressIndicator(
                          color: Color(0xFF4A90D9)));
                }
                final filtro = _searchCtrl.text.toLowerCase();
                final recintos = snapshot.data!
                    .where((r) =>
                        r.nombre.toLowerCase().contains(filtro) ||
                        r.id.toLowerCase().contains(filtro))
                    .toList();

                if (recintos.isEmpty) {
                  return const Center(
                    child: Text('No se encontraron recintos.',
                        style: TextStyle(color: Colors.white54)),
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
                          ? const Color(0xFF1A3A5C)
                          : const Color(0xFF0F2442),
                      margin:
                          const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        title: Text(r.nombre,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500)),
                        subtitle: Text('ID: ${r.id}',
                            style: const TextStyle(
                                color: Colors.white38,
                                fontSize: 12)),
                        trailing: seleccionado
                            ? const Icon(Icons.check_circle,
                                color: Color(0xFF4A90D9))
                            : null,
                        onTap: () =>
                            _mostrarDialogoCedula(context, r),
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
      BuildContext context, RecintosLocalData recinto) {
    final cedulaCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF0F2442),
        title: const Text('Asignar Coordinador',
            style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Recinto: ${recinto.nombre}',
                style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 16),
            TextField(
              controller: cedulaCtrl,
              maxLength: 10,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Cédula del coordinador',
                labelStyle: TextStyle(color: Colors.white54),
                filled: true,
                fillColor: Color(0xFF0A1628),
                border: OutlineInputBorder(
                    borderSide: BorderSide.none),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar',
                style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4A90D9),
              foregroundColor: Colors.white,
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../database/app_database.dart';
import '../../../auth/domain/entities/usuario.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../providers/usuarios_providers.dart';

class AsignarVeedoresScreen extends ConsumerStatefulWidget {
  const AsignarVeedoresScreen({super.key});

  @override
  ConsumerState<AsignarVeedoresScreen> createState() =>
      _AsignarVeedoresScreenState();
}

class _AsignarVeedoresScreenState
    extends ConsumerState<AsignarVeedoresScreen> {
  RecintosLocalData? _recintoSeleccionado;
  JrvLocalData? _jrvSeleccionada;
  String? _mensaje;
  bool _asignando = false;

  @override
  Widget build(BuildContext context) {
    final usuario = ref.watch(currentUserProvider);
    final db = ref.read(appDatabaseProvider);
    final veedoresAsync = ref.watch(listarUsuariosProvider('veedor'));

    return Scaffold(
      backgroundColor: const Color(0xFF0A1628),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F2442),
        title: const Text('Asignar Veedores',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: _seleccionarRecinto(db),
          ),
          if (_recintoSeleccionado != null) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: _seleccionarJrv(db),
            ),
          ],
          if (_mensaje != null)
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.greenAccent.withOpacity(0.4)),
              ),
              child: Text(_mensaje!,
                  style: const TextStyle(color: Colors.greenAccent)),
            ),
          if (_jrvSeleccionada != null) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: _buildAsignarSeccion(veedoresAsync, usuario),
            ),
          ],
        ],
      ),
    );
  }

  Widget _seleccionarRecinto(AppDatabase db) {
    return FutureBuilder<List<RecintosLocalData>>(
      future: db.obtenerTodasLasRecintos(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No hay recintos disponibles.',
              style: TextStyle(color: Colors.white54));
        }
        return DropdownButtonFormField<RecintosLocalData>(
          value: _recintoSeleccionado,
          dropdownColor: const Color(0xFF0F2442),
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            labelText: 'Seleccionar Recinto',
            labelStyle: TextStyle(color: Colors.white54),
            filled: true,
            fillColor: Color(0xFF0F2442),
            border: OutlineInputBorder(borderSide: BorderSide.none),
          ),
          items: snapshot.data!.map((r) {
            return DropdownMenuItem(
                value: r, child: Text(r.nombre));
          }).toList(),
          onChanged: (r) => setState(() {
            _recintoSeleccionado = r;
            _jrvSeleccionada = null;
            _mensaje = null;
          }),
        );
      },
    );
  }

  Widget _seleccionarJrv(AppDatabase db) {
    return FutureBuilder<List<JrvLocalData>>(
      future: db.obtenerJrvLocal(_recintoSeleccionado!.id),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No hay JRV en este recinto.',
              style: TextStyle(color: Colors.white54));
        }
        return DropdownButtonFormField<JrvLocalData>(
          value: _jrvSeleccionada,
          dropdownColor: const Color(0xFF0F2442),
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            labelText: 'Seleccionar JRV',
            labelStyle: TextStyle(color: Colors.white54),
            filled: true,
            fillColor: Color(0xFF0F2442),
            border: OutlineInputBorder(borderSide: BorderSide.none),
          ),
          items: snapshot.data!.map((j) {
            return DropdownMenuItem(
                value: j, child: Text('${j.codigo} (${j.id})'));
          }).toList(),
          onChanged: (j) => setState(() {
            _jrvSeleccionada = j;
            _mensaje = null;
          }),
        );
      },
    );
  }

  Widget _buildAsignarSeccion(
      AsyncValue<List<Usuario>> veedoresAsync, Usuario? currentUser) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('VEEDORES DISPONIBLES',
            style: TextStyle(
                color: Colors.white38,
                fontSize: 11,
                letterSpacing: 1.5)),
        const SizedBox(height: 8),
        veedoresAsync.when(
          loading: () => const Center(
              child:
                  CircularProgressIndicator(color: Color(0xFF4A90D9))),
          error: (e, _) => Text('Error: $e',
              style: const TextStyle(color: Colors.redAccent)),
          data: (veedores) {
            if (veedores.isEmpty) {
              return const Text('No hay veedores registrados.',
                  style: TextStyle(color: Colors.white54));
            }
            return SizedBox(
              height: 300,
              child: ListView.builder(
                itemCount: veedores.length,
                itemBuilder: (_, i) {
                  final v = veedores[i];
                  return Card(
                    color: const Color(0xFF0F2442),
                    margin: const EdgeInsets.only(bottom: 6),
                    child: ListTile(
                      dense: true,
                      leading: const Icon(Icons.person_outline,
                          color: Color(0xFF4A90D9)),
                      title: Text('${v.nombres} ${v.apellidos}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14)),
                      subtitle: Text('C.I.: ${v.cedula}',
                          style: const TextStyle(
                              color: Colors.white38, fontSize: 12)),
                      trailing: _asignando
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Color(0xFF4A90D9)))
                          : IconButton(
                              icon: const Icon(Icons.person_add,
                                  color: Color(0xFF4A90D9)),
                              onPressed: () =>
                                  _asignarVeedor(v.id, currentUser),
                            ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Future<void> _asignarVeedor(
      String veedorId, Usuario? currentUser) async {
    if (_jrvSeleccionada == null || _recintoSeleccionado == null) return;

    setState(() {
      _asignando = true;
      _mensaje = null;
    });

    final useCase = ref.read(asignarVeedorJrvUseCaseProvider);
    final result = await useCase(
      veedorId: veedorId,
      jrvId: _jrvSeleccionada!.id,
      recintoId: _recintoSeleccionado!.id,
    );

    if (!mounted) return;

    result.fold(
      (failure) => setState(() {
        _mensaje = null;
        _asignando = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error: ${failure.message}'),
              backgroundColor: Colors.redAccent),
        );
      }),
      (_) => setState(() {
        _mensaje = 'Veedor asignado correctamente a ${_jrvSeleccionada!.codigo}';
        _asignando = false;
      }),
    );
  }
}

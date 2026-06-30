import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_roles.dart';
import '../../../../core/presentation/widgets/theme_toggle_button.dart';
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final surfaceColor = theme.cardTheme.color ?? colorScheme.surface;

    if (usuario == null || !AppPermissions.puedeAsignarVeedores(usuario.rol)) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Center(
          child: Text('No tienes permisos para asignar veedores.',
              style: TextStyle(color: colorScheme.error)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Asignar Veedores',
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: const [
          ThemeToggleButton(),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: _seleccionarRecinto(db, colorScheme, surfaceColor),
          ),
          if (_recintoSeleccionado != null) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: _seleccionarJrv(db, colorScheme, surfaceColor),
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
              child: _buildAsignarSeccion(veedoresAsync, usuario, colorScheme, surfaceColor),
            ),
          ],
        ],
      ),
    );
  }

  Widget _seleccionarRecinto(AppDatabase db, ColorScheme colorScheme, Color surfaceColor) {
    return FutureBuilder<List<RecintosLocalData>>(
      future: db.obtenerTodasLasRecintos(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('No hay recintos disponibles.',
              style: TextStyle(color: colorScheme.onSurface.withOpacity(0.54)));
        }
        return DropdownButtonFormField<RecintosLocalData>(
          value: _recintoSeleccionado,
          dropdownColor: surfaceColor,
          style: TextStyle(color: colorScheme.onSurface),
          decoration: InputDecoration(
            labelText: 'Seleccionar Recinto',
            labelStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.54)),
            filled: true,
            fillColor: surfaceColor,
            border: const OutlineInputBorder(borderSide: BorderSide.none),
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

  Widget _seleccionarJrv(AppDatabase db, ColorScheme colorScheme, Color surfaceColor) {
    return FutureBuilder<List<JrvLocalData>>(
      future: db.obtenerJrvLocal(_recintoSeleccionado!.id),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('No hay JRV en este recinto.',
              style: TextStyle(color: colorScheme.onSurface.withOpacity(0.54)));
        }
        return DropdownButtonFormField<JrvLocalData>(
          value: _jrvSeleccionada,
          dropdownColor: surfaceColor,
          style: TextStyle(color: colorScheme.onSurface),
          decoration: InputDecoration(
            labelText: 'Seleccionar JRV',
            labelStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.54)),
            filled: true,
            fillColor: surfaceColor,
            border: const OutlineInputBorder(borderSide: BorderSide.none),
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
      AsyncValue<List<Usuario>> veedoresAsync, Usuario? currentUser, ColorScheme colorScheme, Color surfaceColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('VEEDORES DISPONIBLES',
            style: TextStyle(
                color: colorScheme.onSurface.withOpacity(0.38),
                fontSize: 11,
                letterSpacing: 1.5)),
        const SizedBox(height: 8),
        veedoresAsync.when(
          loading: () => Center(
              child:
                  CircularProgressIndicator(color: colorScheme.primary)),
          error: (e, _) => Text('Error: $e',
              style: TextStyle(color: colorScheme.error)),
          data: (veedores) {
            if (veedores.isEmpty) {
              return Text('No hay veedores registrados.',
                  style: TextStyle(color: colorScheme.onSurface.withOpacity(0.54)));
            }
            return SizedBox(
              height: 300,
              child: ListView.builder(
                itemCount: veedores.length,
                itemBuilder: (_, i) {
                  final v = veedores[i];
                  return Card(
                    color: surfaceColor,
                    margin: const EdgeInsets.only(bottom: 6),
                    child: ListTile(
                      dense: true,
                      leading: Icon(Icons.person_outline,
                          color: colorScheme.primary),
                      title: Text('${v.nombres} ${v.apellidos}',
                          style: TextStyle(
                              color: colorScheme.onSurface, fontSize: 14)),
                      subtitle: Text('C.I.: ${v.cedula}',
                          style: TextStyle(
                              color: colorScheme.onSurface.withOpacity(0.38), fontSize: 12)),
                      trailing: _asignando
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: colorScheme.primary))
                          : IconButton(
                              icon: Icon(Icons.person_add,
                                  color: colorScheme.primary),
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

    final result = await ref.read(asignarVeedorJrvUseCaseProvider).call(
          veedorId: veedorId,
          jrvId: _jrvSeleccionada!.id,
          recintoId: _recintoSeleccionado!.id,
          usuarioEjecutor: currentUser!,
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

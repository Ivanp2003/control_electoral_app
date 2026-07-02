import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_roles.dart';
import '../../../../core/presentation/widgets/theme_toggle_button.dart';
import '../../../../database/app_database.dart';
import '../../../auth/domain/entities/usuario.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../providers/usuarios_providers.dart';
import '../../../recintos/domain/entities/jrv.dart';
import '../../../recintos/presentation/providers/recintos_providers.dart';

class AsignarVeedoresScreen extends ConsumerStatefulWidget {
  const AsignarVeedoresScreen({super.key});

  @override
  ConsumerState<AsignarVeedoresScreen> createState() =>
      _AsignarVeedoresScreenState();
}

class _AsignarVeedoresScreenState
    extends ConsumerState<AsignarVeedoresScreen> {
  RecintosLocalData? _recintoSeleccionado;
  Jrv? _jrvSeleccionada;
  String? _mensaje;
  bool _asignando = false;

  @override
  void initState() {
    super.initState();
    // Autoseleccionar recinto para el Coordinador de Recinto
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final usuario = ref.read(currentUserProvider);
      if (usuario != null && usuario.rol == AppRole.coordinadorRecinto && usuario.recintoId != null) {
        final db = ref.read(appDatabaseProvider);
        final recintoLocal = await (db.select(db.recintosLocal)
          ..where((t) => t.id.equals(usuario.recintoId!)))
          .getSingleOrNull();
        if (mounted && recintoLocal != null) {
          setState(() {
            _recintoSeleccionado = recintoLocal;
          });
        }
      }
    });
  }

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

    final esCoordinadorRecinto = usuario.rol == AppRole.coordinadorRecinto;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(esCoordinadorRecinto ? 'Asignar / Reasignar Veedor' : 'Asignar Veedores',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: const [
          ThemeToggleButton(),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!esCoordinadorRecinto)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: _seleccionarRecinto(db, colorScheme, surfaceColor),
            )
          else if (_recintoSeleccionado != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                color: surfaceColor,
                child: ListTile(
                  leading: Icon(Icons.apartment, color: colorScheme.primary),
                  title: Text(_recintoSeleccionado!.nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Tu Recinto Asignado - Parroquia: ${_recintoSeleccionado!.parroquiaId}'),
                ),
              ),
            ),
          if (_recintoSeleccionado != null) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: _seleccionarJrv(colorScheme, surfaceColor),
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
            _buildVeedorActualWidget(db, colorScheme, surfaceColor),
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

  Widget _seleccionarJrv(ColorScheme colorScheme, Color surfaceColor) {
    final jrvsAsync = ref.watch(jrvPorRecintoProvider(_recintoSeleccionado!.id));

    return jrvsAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(8.0),
        child: CircularProgressIndicator(),
      ),
      error: (e, _) => Text('Error al cargar JRVs: $e',
          style: TextStyle(color: colorScheme.error)),
      data: (jrvs) {
        if (jrvs.isEmpty) {
          return Text('No hay JRV en este recinto.',
              style: TextStyle(color: colorScheme.onSurface.withOpacity(0.54)));
        }
        return DropdownButtonFormField<Jrv>(
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
          items: jrvs.map((j) {
            return DropdownMenuItem(
                value: j, child: Text('${j.codigo}'));
          }).toList(),
          onChanged: (j) => setState(() {
            _jrvSeleccionada = j;
            _mensaje = null;
          }),
        );
      },
    );
  }

  Widget _buildVeedorActualWidget(AppDatabase db, ColorScheme colorScheme, Color surfaceColor) {
    return FutureBuilder<VeedorJrvLocalData?>(
      future: (db.select(db.veedorJrvLocal)..where((t) => t.jrvId.equals(_jrvSeleccionada!.id))).getSingleOrNull(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: LinearProgressIndicator(),
          );
        }
        final asignacion = snapshot.data;
        if (asignacion == null) {
          return const SizedBox.shrink();
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Card(
            color: Colors.orange.withOpacity(0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(color: Colors.orangeAccent, width: 1),
            ),
            child: ListTile(
              leading: const Icon(Icons.warning_amber, color: Colors.orangeAccent),
              title: const Text('JRV ya asignada', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orangeAccent)),
              subtitle: Text(
                'Veedor ID actual: ${asignacion.veedorId}\nAsignar un nuevo veedor reescribirá la asignación actual sin borrar sus actas.',
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAsignarSeccion(
      AsyncValue<List<Usuario>> veedoresAsync, Usuario? currentUser, ColorScheme colorScheme, Color surfaceColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('VEEDORES DISPONIBLES',
                style: TextStyle(
                    color: colorScheme.onSurface.withOpacity(0.38),
                    fontSize: 11,
                    letterSpacing: 1.5)),
            IconButton(
              icon: Icon(Icons.refresh, size: 20, color: colorScheme.primary),
              onPressed: () {
                ref.invalidate(listarUsuariosProvider('veedor'));
              },
              tooltip: 'Refrescar lista',
            ),
          ],
        ),
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
              height: 220,
              child: ListView.builder(
                itemCount: veedores.length,
                itemBuilder: (_, i) {
                  final v = veedores[i];
                  return FutureBuilder<VeedorJrvLocalData?>(
                    future: (ref.read(appDatabaseProvider).select(ref.read(appDatabaseProvider).veedorJrvLocal)
                      ..where((t) => t.jrvId.equals(_jrvSeleccionada!.id))).getSingleOrNull(),
                    builder: (context, snap) {
                      final yaAsignado = snap.data != null;
                      final esMismoVeedor = yaAsignado && snap.data!.veedorId == v.id;

                      return Card(
                        color: surfaceColor,
                        margin: const EdgeInsets.only(bottom: 6),
                        child: ListTile(
                          dense: true,
                          leading: Icon(Icons.person_outline,
                              color: esMismoVeedor ? Colors.green : colorScheme.primary),
                          title: Text('${v.nombres} ${v.apellidos}',
                              style: TextStyle(
                                  color: colorScheme.onSurface, fontSize: 14, fontWeight: esMismoVeedor ? FontWeight.bold : FontWeight.normal)),
                          subtitle: Text('C.I.: ${v.cedula}',
                              style: TextStyle(
                                  color: colorScheme.onSurface.withOpacity(0.38), fontSize: 12)),
                          trailing: esMismoVeedor
                              ? const Text('Asignado', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold))
                              : _asignando
                                  ? SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: colorScheme.primary))
                                  : IconButton(
                                      icon: Icon(yaAsignado ? Icons.swap_horiz : Icons.person_add,
                                          color: yaAsignado ? Colors.orange : colorScheme.primary),
                                      tooltip: yaAsignado ? 'Reasignar a esta mesa' : 'Asignar a esta mesa',
                                      onPressed: () =>
                                          _asignarVeedor(v.id, '${v.nombres} ${v.apellidos}', currentUser, yaAsignado),
                                    ),
                        ),
                      );
                    },
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
      String veedorId, String nombreVeedor, Usuario? currentUser, bool esReasignacion) async {
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
        _mensaje = esReasignacion
            ? 'Veedor reasignado correctamente: $nombreVeedor ahora está a cargo de la ${_jrvSeleccionada!.codigo}'
            : '$nombreVeedor asignado correctamente a la ${_jrvSeleccionada!.codigo}';
        _asignando = false;
      }),
    );
  }
}

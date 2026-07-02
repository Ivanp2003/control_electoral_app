import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_roles.dart';
import 'package:drift/drift.dart' hide Column;
import '../../../../core/presentation/widgets/theme_toggle_button.dart';
import '../../../../core/validators/cedula_validator.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../../database/app_database.dart';
import '../../../recintos/domain/entities/recinto.dart';

final _todosLosRecintosProvider = FutureProvider.autoDispose<List<Recinto>>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  final recintosData = await db.select(db.recintosLocal).get();
  return recintosData.map((e) => Recinto(
    id: e.id,
    nombre: e.nombre,
    parroquiaId: e.parroquiaId,
    direccion: e.direccion,
    latRef: e.latRef,
    lonRef: e.lonRef,
    coordinadorId: e.coordinadorId,
  )).toList();
});

class CrearUsuarioScreen extends ConsumerStatefulWidget {
  const CrearUsuarioScreen({super.key});

  @override
  ConsumerState<CrearUsuarioScreen> createState() => _CrearUsuarioScreenState();
}

class _CrearUsuarioScreenState extends ConsumerState<CrearUsuarioScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cedulaCtrl = TextEditingController();
  final _nombresCtrl = TextEditingController();
  final _apellidosCtrl = TextEditingController();
  final _telefonoCtrl = TextEditingController();
  final _correoCtrl = TextEditingController();
  String _rolSeleccionado = 'veedor';
  String? _recintoIdSeleccionado;
  bool _guardando = false;
  String? _error;

  @override
  void dispose() {
    _cedulaCtrl.dispose();
    _nombresCtrl.dispose();
    _apellidosCtrl.dispose();
    _telefonoCtrl.dispose();
    _correoCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final usuario = ref.watch(currentUserProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final surfaceColor = theme.cardTheme.color ?? colorScheme.surface;
    final recintosAsync = ref.watch(_todosLosRecintosProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Crear Usuario',
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: const [
          ThemeToggleButton(),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _campo(
                'Cédula',
                _cedulaCtrl,
                colorScheme,
                surfaceColor,
                keyboardType: TextInputType.number,
                maxLength: 10,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                suffixIcon: ValueListenableBuilder(
                  valueListenable: _cedulaCtrl,
                  builder: (context, value, child) {
                    if (value.text.isEmpty) return const SizedBox.shrink();
                    final isValid = esCedulaValida(value.text.trim());
                    return Icon(
                      isValid ? Icons.check_circle : Icons.cancel,
                      color: isValid ? Colors.green : Colors.red,
                    );
                  },
                ),
              ),
              _campo(
                'Nombres',
                _nombresCtrl,
                colorScheme,
                surfaceColor,
                textCapitalization: TextCapitalization.words,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]'))
                ],
              ),
              _campo(
                'Apellidos',
                _apellidosCtrl,
                colorScheme,
                surfaceColor,
                textCapitalization: TextCapitalization.words,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]'))
                ],
              ),
              _campo(
                'Teléfono',
                _telefonoCtrl,
                colorScheme,
                surfaceColor,
                keyboardType: TextInputType.phone,
                maxLength: 9,
                prefix: const Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Text('+593', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              _campo(
                'Correo Electrónico',
                _correoCtrl,
                colorScheme,
                surfaceColor,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              Text('ROL', style: TextStyle(color: colorScheme.onSurface.withOpacity(0.38), fontSize: 11, letterSpacing: 1.5)),
              const SizedBox(height: 8),
              Builder(
                builder: (context) {
                  final roles = _rolesDisponibles(usuario?.rol);
                  if (roles.isEmpty) {
                    return const SizedBox(); // Oculta mientras carga el usuario
                  }
                  return DropdownButtonFormField<String>(
                    value: roles.contains(_rolSeleccionado) ? _rolSeleccionado : roles.first,
                    dropdownColor: surfaceColor,
                    style: TextStyle(color: colorScheme.onSurface),
                    decoration: _inputDecor(surfaceColor),
                    items: roles.map((r) {
                      return DropdownMenuItem(value: r, child: Text(r == 'veedor' ? 'Veedor' : 'Coord. Recinto'));
                    }).toList(),
                    onChanged: (v) {
                      if (v != null) {
                        setState(() {
                          _rolSeleccionado = v;
                          if (v != 'coordinadorRecinto') {
                            _recintoIdSeleccionado = null;
                          }
                        });
                      }
                    },
                  );
                }
              ),
              
              if (_rolSeleccionado == AppRole.coordinadorRecinto.name) ...[
                const SizedBox(height: 16),
                Text('RECINTO ASIGNADO', style: TextStyle(color: colorScheme.onSurface.withOpacity(0.38), fontSize: 11, letterSpacing: 1.5)),
                const SizedBox(height: 8),
                recintosAsync.when(
                  data: (recintos) {
                    if (recintos.isEmpty) {
                      return Text('No hay recintos disponibles', style: TextStyle(color: colorScheme.error));
                    }
                    return DropdownButtonFormField<String>(
                      value: _recintoIdSeleccionado,
                      dropdownColor: surfaceColor,
                      style: TextStyle(color: colorScheme.onSurface),
                      decoration: _inputDecor(surfaceColor),
                      hint: const Text('Seleccionar recinto'),
                      items: recintos.map((r) {
                        return DropdownMenuItem(value: r.id, child: Text(r.nombre, overflow: TextOverflow.ellipsis));
                      }).toList(),
                      onChanged: (v) {
                        setState(() => _recintoIdSeleccionado = v);
                      },
                      validator: (v) => v == null ? 'Seleccione un recinto' : null,
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Text('Error cargando recintos: $e', style: TextStyle(color: colorScheme.error)),
                ),
              ],

              if (_error != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: colorScheme.error.withOpacity(0.4)),
                  ),
                  child: Text(_error!, style: TextStyle(color: colorScheme.error)),
                ),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _guardando ? null : _crearUsuario,
                  child: _guardando
                      ? SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: colorScheme.onPrimary))
                      : Text('Crear Usuario', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: colorScheme.onPrimary)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<String> _rolesDisponibles(AppRole? rolActual) {
    if (rolActual == null) return [];
    
    final roles = <String>[];
    if (AppPermissions.puedeCrearVeedores(rolActual)) {
      roles.add('veedor');
    }
    if (AppPermissions.puedeCrearCoordinadoresRecinto(rolActual)) {
      roles.add('coordinadorRecinto');
    }
    return roles;
  }

  InputDecoration _inputDecor(Color surfaceColor) {
    return InputDecoration(
      filled: true,
      fillColor: surfaceColor,
      border: const OutlineInputBorder(borderSide: BorderSide.none),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  Widget _campo(
    String label,
    TextEditingController ctrl,
    ColorScheme colorScheme,
    Color surfaceColor, {
    TextInputType? keyboardType,
    int? maxLength,
    Widget? prefix,
    Widget? suffixIcon,
    List<TextInputFormatter>? inputFormatters,
    TextCapitalization textCapitalization = TextCapitalization.none,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: ctrl,
        keyboardType: keyboardType,
        maxLength: maxLength,
        inputFormatters: inputFormatters,
        textCapitalization: textCapitalization,
        style: TextStyle(color: colorScheme.onSurface),
        decoration: _inputDecor(surfaceColor).copyWith(
          labelText: label,
          prefix: prefix,
          suffixIcon: suffixIcon,
          labelStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.54)),
          counterStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.38)),
        ),
        validator: (v) {
          if (v == null || v.trim().isEmpty) return 'Campo obligatorio';
          if (label == 'Cédula' && !esCedulaValida(v.trim())) return 'Cédula inválida';
          if (label == 'Correo Electrónico') {
            final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
            if (!regex.hasMatch(v.trim())) return 'Correo inválido';
          }
          if (label == 'Teléfono' && v.trim().length != 9) return 'Debe tener 9 dígitos numéricos';
          return null;
        },
      ),
    );
  }

  Future<void> _crearUsuario() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _guardando = true; _error = null; });

    final result = await ref.read(crearUsuarioUseCaseProvider).call(
      cedula: _cedulaCtrl.text.trim(),
      nombres: _nombresCtrl.text.trim(),
      apellidos: _apellidosCtrl.text.trim(),
      telefono: '+593${_telefonoCtrl.text.trim()}',
      correo: _correoCtrl.text.trim(),
      rol: _rolesDisponibles(ref.read(currentUserProvider)?.rol).contains(_rolSeleccionado) 
          ? _rolSeleccionado 
          : _rolesDisponibles(ref.read(currentUserProvider)?.rol).first,
      recintoId: _recintoIdSeleccionado,
    );

    if (!mounted) return;

    result.fold(
      (failure) => setState(() { _error = failure.message; _guardando = false; }),
      (userId) async {
        final rolFinal = _rolesDisponibles(ref.read(currentUserProvider)?.rol).contains(_rolSeleccionado) 
            ? _rolSeleccionado 
            : _rolesDisponibles(ref.read(currentUserProvider)?.rol).first;

        if (rolFinal == 'coordinadorRecinto' && _recintoIdSeleccionado != null) {
          final db = ref.read(appDatabaseProvider);
          // Vincular de inmediato de forma bidireccional localmente en Drift
          await db.transaction(() async {
            await (db.update(db.recintosLocal)
                  ..where((t) => t.coordinadorId.equals(userId)))
                .write(const RecintosLocalCompanion(coordinadorId: Value.absent()));

            // Vincular al nuevo recinto
            await (db.update(db.recintosLocal)
                  ..where((t) => t.id.equals(_recintoIdSeleccionado!)))
                .write(RecintosLocalCompanion(coordinadorId: Value(userId)));
          });
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario creado exitosamente'), backgroundColor: Colors.greenAccent),
        );
        Navigator.pop(context);
      },
    );
  }
}

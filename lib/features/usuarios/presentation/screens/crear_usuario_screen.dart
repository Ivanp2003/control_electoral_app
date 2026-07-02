import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_roles.dart';
import '../../../../core/presentation/widgets/theme_toggle_button.dart';
import '../../../../core/validators/cedula_validator.dart';
import '../../../auth/presentation/providers/auth_providers.dart';

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _campo('Cédula', _cedulaCtrl, colorScheme, surfaceColor, keyboardType: TextInputType.number, maxLength: 10),
              _campo('Nombres', _nombresCtrl, colorScheme, surfaceColor),
              _campo('Apellidos', _apellidosCtrl, colorScheme, surfaceColor),
              _campo('Teléfono', _telefonoCtrl, colorScheme, surfaceColor, keyboardType: TextInputType.phone),
              _campo('Correo Electrónico', _correoCtrl, colorScheme, surfaceColor, keyboardType: TextInputType.emailAddress),
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
                        setState(() => _rolSeleccionado = v);
                      }
                    },
                  );
                }
              ),
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

  Widget _campo(String label, TextEditingController ctrl, ColorScheme colorScheme, Color surfaceColor, {TextInputType? keyboardType, int? maxLength}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: ctrl,
        keyboardType: keyboardType,
        maxLength: maxLength,
        style: TextStyle(color: colorScheme.onSurface),
        decoration: _inputDecor(surfaceColor).copyWith(
          labelText: label,
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
      telefono: _telefonoCtrl.text.trim(),
      correo: _correoCtrl.text.trim(),
      rol: _rolesDisponibles(ref.read(currentUserProvider)?.rol).contains(_rolSeleccionado) 
          ? _rolSeleccionado 
          : _rolesDisponibles(ref.read(currentUserProvider)?.rol).first,
    );

    if (!mounted) return;

    result.fold(
      (failure) => setState(() { _error = failure.message; _guardando = false; }),
      (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario creado exitosamente'), backgroundColor: Colors.greenAccent),
        );
        Navigator.pop(context);
      },
    );
  }
}

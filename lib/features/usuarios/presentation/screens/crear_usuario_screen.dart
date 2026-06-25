import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_roles.dart';
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

    return Scaffold(
      backgroundColor: const Color(0xFF0A1628),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F2442),
        title: const Text('Crear Usuario',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _campo('Cédula', _cedulaCtrl, keyboardType: TextInputType.number, maxLength: 10),
              _campo('Nombres', _nombresCtrl),
              _campo('Apellidos', _apellidosCtrl),
              _campo('Teléfono', _telefonoCtrl, keyboardType: TextInputType.phone),
              _campo('Correo Electrónico', _correoCtrl, keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 16),
              const Text('ROL', style: TextStyle(color: Colors.white38, fontSize: 11, letterSpacing: 1.5)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _rolSeleccionado,
                dropdownColor: const Color(0xFF0F2442),
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecor(),
                items: _rolesDisponibles(usuario?.rol).map((r) {
                  return DropdownMenuItem(value: r, child: Text(r == 'veedor' ? 'Veedor' : 'Coord. Recinto'));
                }).toList(),
                onChanged: (v) => setState(() => _rolSeleccionado = v ?? 'veedor'),
              ),
              if (_error != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.withOpacity(0.4)),
                  ),
                  child: Text(_error!, style: const TextStyle(color: Colors.redAccent)),
                ),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A90D9),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _guardando ? null : _crearUsuario,
                  child: _guardando
                      ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text('Crear Usuario', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<String> _rolesDisponibles(AppRole? rolActual) {
    if (rolActual == AppRole.coordinadorProvincial) {
      return ['veedor', 'coordinadorRecinto'];
    }
    return ['veedor'];
  }

  InputDecoration _inputDecor() {
    return const InputDecoration(
      filled: true,
      fillColor: Color(0xFF0F2442),
      border: OutlineInputBorder(borderSide: BorderSide.none),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  Widget _campo(String label, TextEditingController ctrl, {TextInputType? keyboardType, int? maxLength}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: ctrl,
        keyboardType: keyboardType,
        maxLength: maxLength,
        style: const TextStyle(color: Colors.white),
        decoration: _inputDecor().copyWith(labelText: label, labelStyle: const TextStyle(color: Colors.white54), counterStyle: const TextStyle(color: Colors.white38)),
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
      rol: _rolSeleccionado,
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

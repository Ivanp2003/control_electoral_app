import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../providers/recintos_providers.dart';

/// crear_recinto_screen.dart
///
/// Responsabilidad Única: Formulario para que el Coordinador Provincial
/// cree un nuevo Recinto Electoral. El Use Case verifica el permiso
/// adicionalmente a la protección del router.

class CrearRecintoScreen extends ConsumerStatefulWidget {
  const CrearRecintoScreen({super.key});

  @override
  ConsumerState<CrearRecintoScreen> createState() => _CrearRecintoScreenState();
}

class _CrearRecintoScreenState extends ConsumerState<CrearRecintoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _direccionController = TextEditingController();

  String? _provinciaSeleccionadaId;
  String? _cantonSeleccionadoId;
  String? _parroquiaSeleccionadaId;

  @override
  void dispose() {
    _nombreController.dispose();
    _direccionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provinciasAsync = ref.watch(provinciasProvider);
    final notifierState = ref.watch(crearRecintoNotifierProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0A1628),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F2442),
        title: const Text('Nuevo Recinto Electoral',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSectionHeader('Información del Recinto'),
              const SizedBox(height: 16),

              // Nombre
              _buildTextField(
                id: 'campo_nombre_recinto',
                controller: _nombreController,
                label: 'Nombre del Recinto',
                hint: 'ej. Unidad Educativa Calderón',
                icon: Icons.school_outlined,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'El nombre es obligatorio'
                    : null,
              ),
              const SizedBox(height: 16),

              // Dirección
              _buildTextField(
                id: 'campo_direccion_recinto',
                controller: _direccionController,
                label: 'Dirección',
                hint: 'ej. Av. Interoceánica y Calle J',
                icon: Icons.location_on_outlined,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'La dirección es obligatoria'
                    : null,
              ),
              const SizedBox(height: 24),

              _buildSectionHeader('Ubicación Geográfica'),
              const SizedBox(height: 16),

              // Dropdown Provincia
              provinciasAsync.when(
                loading: () => const LinearProgressIndicator(
                    color: Color(0xFF4A90D9)),
                error: (e, _) => Text('Error cargando provincias: $e',
                    style: const TextStyle(color: Colors.redAccent)),
                data: (provincias) => _buildDropdown<String>(
                  id: 'dropdown_provincia',
                  label: 'Provincia',
                  value: _provinciaSeleccionadaId,
                  items: provincias
                      .map((p) =>
                          DropdownMenuItem(value: p.id, child: Text(p.nombre)))
                      .toList(),
                  onChanged: (v) => setState(() {
                    _provinciaSeleccionadaId = v;
                    _cantonSeleccionadoId = null;
                    _parroquiaSeleccionadaId = null;
                  }),
                  validator: (v) =>
                      v == null ? 'Seleccione una provincia' : null,
                ),
              ),
              const SizedBox(height: 16),

              // Dropdown Cantón — aparece solo si hay provincia seleccionada
              if (_provinciaSeleccionadaId != null) ...[
                Consumer(builder: (context, ref, _) {
                  final cantonesAsync =
                      ref.watch(cantonesProvider(_provinciaSeleccionadaId!));
                  return cantonesAsync.when(
                    loading: () => const LinearProgressIndicator(
                        color: Color(0xFF4A90D9)),
                    error: (e, _) => Text('Error: $e',
                        style: const TextStyle(color: Colors.redAccent)),
                    data: (cantones) => _buildDropdown<String>(
                      id: 'dropdown_canton',
                      label: 'Cantón',
                      value: _cantonSeleccionadoId,
                      items: cantones
                          .map((c) => DropdownMenuItem(
                              value: c.id, child: Text(c.nombre)))
                          .toList(),
                      onChanged: (v) => setState(() {
                        _cantonSeleccionadoId = v;
                        _parroquiaSeleccionadaId = null;
                      }),
                      validator: (v) =>
                          v == null ? 'Seleccione un cantón' : null,
                    ),
                  );
                }),
                const SizedBox(height: 16),
              ],

              // Dropdown Parroquia — aparece solo si hay cantón seleccionado
              if (_cantonSeleccionadoId != null) ...[
                Consumer(builder: (context, ref, _) {
                  final parroquiasAsync =
                      ref.watch(parroquiasProvider(_cantonSeleccionadoId!));
                  return parroquiasAsync.when(
                    loading: () => const LinearProgressIndicator(
                        color: Color(0xFF4A90D9)),
                    error: (e, _) => Text('Error: $e',
                        style: const TextStyle(color: Colors.redAccent)),
                    data: (parroquias) => _buildDropdown<String>(
                      id: 'dropdown_parroquia',
                      label: 'Parroquia',
                      value: _parroquiaSeleccionadaId,
                      items: parroquias
                          .map((p) => DropdownMenuItem(
                              value: p.id, child: Text(p.nombre)))
                          .toList(),
                      onChanged: (v) =>
                          setState(() => _parroquiaSeleccionadaId = v),
                      validator: (v) =>
                          v == null ? 'Seleccione una parroquia' : null,
                    ),
                  );
                }),
                const SizedBox(height: 24),
              ],

              // Error del notifier
              if (notifierState is AsyncError)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.redAccent),
                  ),
                  child: Text(
                    notifierState.error.toString(),
                    style: const TextStyle(color: Colors.redAccent),
                  ),
                ),

              if (notifierState is AsyncError) const SizedBox(height: 16),

              // Botón Guardar
              SizedBox(
                height: 52,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A90D9),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed:
                      notifierState is AsyncLoading ? null : _guardarRecinto,
                  icon: notifierState is AsyncLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2))
                      : const Icon(Icons.save_outlined),
                  label: Text(
                    notifierState is AsyncLoading ? 'Guardando...' : 'Guardar Recinto',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              // Éxito
              if (notifierState is AsyncData && notifierState.value != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.greenAccent),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle_outline,
                            color: Colors.greenAccent),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Recinto "${notifierState.value!.nombre}" creado exitosamente.',
                            style: const TextStyle(color: Colors.greenAccent),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _guardarRecinto() {
    if (!_formKey.currentState!.validate()) return;
    if (_parroquiaSeleccionadaId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Seleccione una parroquia.')),
      );
      return;
    }
    final usuario = ref.read(currentUserProvider);
    if (usuario == null) return;

    ref.read(crearRecintoNotifierProvider.notifier).crearRecinto(
          rolUsuario: usuario.rol,
          nombre: _nombreController.text.trim(),
          parroquiaId: _parroquiaSeleccionadaId!,
          direccion: _direccionController.text.trim(),
        );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
          color: Color(0xFF4A90D9),
          fontSize: 14,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2),
    );
  }

  Widget _buildTextField({
    required String id,
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      key: Key(id),
      controller: controller,
      style: const TextStyle(color: Colors.white),
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: const TextStyle(color: Colors.white54),
        hintStyle: const TextStyle(color: Colors.white24),
        prefixIcon: Icon(icon, color: const Color(0xFF4A90D9)),
        filled: true,
        fillColor: const Color(0xFF0F2442),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.white12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.white12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF4A90D9)),
        ),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required String id,
    required String label,
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required void Function(T?) onChanged,
    String? Function(T?)? validator,
  }) {
    return DropdownButtonFormField<T>(
      key: Key(id),
      value: value,
      items: items,
      onChanged: onChanged,
      validator: validator,
      style: const TextStyle(color: Colors.white),
      dropdownColor: const Color(0xFF0F2442),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white54),
        filled: true,
        fillColor: const Color(0xFF0F2442),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.white12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.white12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF4A90D9)),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../providers/recintos_providers.dart';
import '../../../../core/presentation/widgets/theme_toggle_button.dart';
import '../../domain/entities/recinto.dart';
import '../../domain/entities/jrv.dart';

/// crear_recinto_screen.dart
///
/// Responsabilidad Única: Formulario para que el Coordinador Provincial
/// cree un nuevo Recinto Electoral y, opcionalmente, le agregue sus JRV en un
/// solo flujo.

class CrearRecintoScreen extends ConsumerStatefulWidget {
  const CrearRecintoScreen({super.key});

  @override
  ConsumerState<CrearRecintoScreen> createState() => _CrearRecintoScreenState();
}

class _CrearRecintoScreenState extends ConsumerState<CrearRecintoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _jrvFormKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _direccionController = TextEditingController();
  final _jrvCodigoController = TextEditingController();

  String? _provinciaSeleccionadaId;
  String? _cantonSeleccionadoId;
  String? _parroquiaSeleccionadaId;

  // Estado del flujo de dos pasos
  Recinto? _recintoCreado;
  final List<Jrv> _jrvsAgregadas = [];

  @override
  void dispose() {
    _nombreController.dispose();
    _direccionController.dispose();
    _jrvCodigoController.dispose();
    super.dispose();
  }

  void _autocompletarPrefijoJrv() {
    final text = _jrvCodigoController.text.trim();
    if (text.isNotEmpty && !text.toUpperCase().startsWith('JRV ')) {
      // Si el usuario pone "001", lo cambiamos a "JRV 001"
      _jrvCodigoController.text = 'JRV $text';
    }
  }

  Future<void> _guardarRecinto() async {
    if (_formKey.currentState?.validate() ?? false) {
      final user = ref.read(currentUserProvider);
      if (user == null) return;

      await ref.read(crearRecintoNotifierProvider.notifier).crearRecinto(
            rolUsuario: user.rol,
            nombre: _nombreController.text,
            parroquiaId: _parroquiaSeleccionadaId!,
            direccion: _direccionController.text,
          );

      final state = ref.read(crearRecintoNotifierProvider);
      if (!state.hasError && state.value != null) {
        setState(() {
          _recintoCreado = state.value;
        });
      }
    }
  }

  Future<void> _agregarJrv() async {
    _autocompletarPrefijoJrv();
    if (_jrvFormKey.currentState?.validate() ?? false) {
      if (_recintoCreado == null) return;

      final user = ref.read(currentUserProvider);
      if (user == null) return;

      final jrvAgregada = await ref.read(crearJrvNotifierProvider.notifier).crearJrv(
            rolUsuario: user.rol,
            codigo: _jrvCodigoController.text,
            recintoId: _recintoCreado!.id,
          );

      if (jrvAgregada != null) {
        setState(() {
          _jrvsAgregadas.add(jrvAgregada);
          _jrvCodigoController.clear();
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('JRV agregada exitosamente'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Nuevo Recinto Electoral',
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: const [
          ThemeToggleButton(),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Paso 1: Formulario de Recinto (solo si no se ha creado)
            if (_recintoCreado == null) _buildPaso1Recinto(colorScheme, theme),

            // Paso 2: Formulario de JRV (solo si ya se creó el recinto)
            if (_recintoCreado != null) _buildPaso2Jrv(colorScheme, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildPaso1Recinto(ColorScheme colorScheme, ThemeData theme) {
    final provinciasAsync = ref.watch(provinciasProvider);
    final notifierState = ref.watch(crearRecintoNotifierProvider);

    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
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
            loading: () => LinearProgressIndicator(color: colorScheme.primary),
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
              theme: theme,
            ),
          ),
          const SizedBox(height: 16),

          // Dropdown Cantón
          if (_provinciaSeleccionadaId != null) ...[
            Consumer(builder: (context, ref, _) {
              final cantonesAsync =
                  ref.watch(cantonesProvider(_provinciaSeleccionadaId!));
              return cantonesAsync.when(
                loading: () => LinearProgressIndicator(color: colorScheme.primary),
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
                  theme: theme,
                ),
              );
            }),
            const SizedBox(height: 16),
          ],

          // Dropdown Parroquia
          if (_cantonSeleccionadoId != null) ...[
            Consumer(builder: (context, ref, _) {
              final parroquiasAsync =
                  ref.watch(parroquiasProvider(_cantonSeleccionadoId!));
              return parroquiasAsync.when(
                loading: () => LinearProgressIndicator(color: colorScheme.primary),
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
                  theme: theme,
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
                color: colorScheme.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: colorScheme.error.withOpacity(0.4)),
              ),
              child: Text(
                notifierState.error.toString(),
                style: TextStyle(color: colorScheme.error),
              ),
            ),

          if (notifierState is AsyncError) const SizedBox(height: 16),

          // Botón Guardar
          SizedBox(
            height: 52,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: notifierState.isLoading ? null : _guardarRecinto,
              icon: notifierState.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2))
                  : const Icon(Icons.save_outlined),
              label: Text(
                notifierState.isLoading ? 'Guardando...' : 'Guardar Recinto',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaso2Jrv(ColorScheme colorScheme, ThemeData theme) {
    final jrvNotifierState = ref.watch(crearJrvNotifierProvider);

    return Form(
      key: _jrvFormKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colorScheme.primaryContainer),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.check_circle, color: colorScheme.primary),
                    const SizedBox(width: 8),
                    Text(
                      'Recinto Creado',
                      style: TextStyle(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _recintoCreado!.nombre,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  _recintoCreado!.direccion,
                  style: TextStyle(color: colorScheme.onSurface.withOpacity(0.7)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          
          _buildSectionHeader('Agregar JRV a este recinto'),
          const SizedBox(height: 16),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Focus(
                  onFocusChange: (hasFocus) {
                    if (!hasFocus) {
                      _autocompletarPrefijoJrv();
                    }
                  },
                  child: _buildTextField(
                    id: 'campo_codigo_jrv',
                    controller: _jrvCodigoController,
                    label: 'Código de JRV',
                    hint: 'ej. 001',
                    icon: Icons.how_to_vote_outlined,
                    onEditingComplete: () {
                      _autocompletarPrefijoJrv();
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Requerido'
                        : null,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.secondary,
                      foregroundColor: colorScheme.onSecondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: jrvNotifierState.isLoading ? null : _agregarJrv,
                    child: jrvNotifierState.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2))
                        : const Text('Agregar', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),

          if (jrvNotifierState is AsyncError)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                jrvNotifierState.error.toString(),
                style: TextStyle(color: colorScheme.error),
              ),
            ),

          const SizedBox(height: 24),

          if (_jrvsAgregadas.isNotEmpty) ...[
            const Text(
              'JRV Agregadas:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _jrvsAgregadas.length,
              itemBuilder: (context, index) {
                final jrv = _jrvsAgregadas[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: colorScheme.primaryContainer,
                      child: Icon(Icons.how_to_vote, color: colorScheme.primary),
                    ),
                    title: Text(jrv.codigo, style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                );
              },
            ),
          ],
          
          const SizedBox(height: 32),

          SizedBox(
            height: 52,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                if (context.canPop()) context.pop();
              },
              child: const Text('Finalizar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.blueGrey,
      ),
    );
  }

  Widget _buildTextField({
    required String id,
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    VoidCallback? onEditingComplete,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: validator,
      onEditingComplete: onEditingComplete,
    );
  }

  Widget _buildDropdown<T>({
    required String id,
    required String label,
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required void Function(T?) onChanged,
    required String? Function(T?) validator,
    required ThemeData theme,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

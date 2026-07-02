import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_providers.dart';
import '../providers/auth_state.dart';
import '../../../../core/presentation/widgets/theme_toggle_button.dart';

/// recuperar_password_screen.dart
/// 
/// Responsabilidad Única: Renderizar el formulario de solicitud de enlace de recuperación
/// por correo, así como el formulario de confirmación con nueva clave si detecta tokens de Appwrite en la URL.
/// Cambios en esta clase ocurren si cambian los flujos o validaciones de restablecimiento.

class RecuperarPasswordScreen extends ConsumerStatefulWidget {
  const RecuperarPasswordScreen({super.key});

  @override
  ConsumerState<RecuperarPasswordScreen> createState() => _RecuperarPasswordScreenState();
}

class _RecuperarPasswordScreenState extends ConsumerState<RecuperarPasswordScreen> {
  final _requestFormKey = GlobalKey<FormState>();
  final _confirmFormKey = GlobalKey<FormState>();
  
  final _emailController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _linkRequestSent = false;
  bool _resetSuccess = false;

  @override
  void dispose() {
    _emailController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submitRequest() async {
    if (_requestFormKey.currentState?.validate() ?? false) {
      final success = await ref.read(authNotifierProvider.notifier).solicitarRecuperacion(
        _emailController.text.trim(),
      );

      if (success && mounted) {
        setState(() {
          _linkRequestSent = true;
        });
      }
    }
  }

  void _submitConfirmation(String userId, String secret) async {
    if (_confirmFormKey.currentState?.validate() ?? false) {
      final success = await ref.read(authNotifierProvider.notifier).confirmarRecuperacion(
        userId: userId,
        secret: secret,
        newPassword: _newPasswordController.text,
      );

      if (success && mounted) {
        setState(() {
          _resetSuccess = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final routerState = GoRouterState.of(context);
    
    // Capturar tokens pasados por Appwrite en la redirección web
    final userId = routerState.uri.queryParameters['userId'];
    final secret = routerState.uri.queryParameters['secret'];
    
    final isConfirming = userId != null && secret != null;

    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      next.maybeWhen(
        error: (message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        },
        orElse: () {},
      );
    });

    final isLoading = authState.maybeWhen(
      loading: () => true,
      orElse: () => false,
    );

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final surfaceColor = theme.cardTheme.color ?? colorScheme.surface;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Recuperación de Cuenta'),
        actions: const [
          ThemeToggleButton(),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 16.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(
                  isConfirming ? Icons.lock_reset : Icons.email_outlined,
                  size: 64,
                  color: colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  isConfirming ? 'Defina su Nueva Contraseña' : 'Recuperar Contraseña',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isConfirming
                      ? 'Ingrese y confirme su nueva clave de acceso de 8 caracteres mínimo.'
                      : 'Ingrese su cédula o correo electrónico registrado. Le enviaremos un enlace oficial para restablecer su clave.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: colorScheme.onSurface.withOpacity(0.54)),
                ),
                const SizedBox(height: 28),

                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: isConfirming
                      ? _buildConfirmForm(userId, secret, isLoading)
                      : _buildRequestForm(isLoading),
                ),
                const SizedBox(height: 16),

                TextButton(
                  onPressed: isLoading ? null : () => context.go('/login'),
                  child: Text(
                    'Volver al inicio de sesión',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRequestForm(bool isLoading) {
    if (_linkRequestSent) {
      return Column(
        children: [
          const Icon(Icons.mark_email_read_outlined, color: Colors.green, size: 48),
          const SizedBox(height: 16),
          const Text(
            'Enlace Enviado',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            'Revise su bandeja de entrada. Siga las instrucciones del correo para restablecer su clave.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.54)),
          ),
        ],
      );
    }

    return Form(
      key: _requestFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.text,
            enabled: !isLoading,
            decoration: const InputDecoration(
              labelText: 'Cédula o Correo Electrónico',
              prefixIcon: Icon(Icons.person_search),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Ingrese su cédula o correo electrónico.';
              }
              
              final val = value.trim();
              final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
              final isEmail = emailRegex.hasMatch(val);
              
              // Simplistic check for cedula format here, full validation happens in usecase
              final isCedula = val.length == 10 && RegExp(r'^[0-9]+$').hasMatch(val);

              if (!isEmail && !isCedula) {
                return 'Ingrese un formato de correo o cédula válido.';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: _submitRequest,
                  child: const Text('Enviar Enlace de Recuperación'),
                ),
        ],
      ),
    );
  }

  Widget _buildConfirmForm(String userId, String secret, bool isLoading) {
    if (_resetSuccess) {
      return Column(
        children: [
          const Icon(Icons.check_circle_outline, color: Colors.green, size: 48),
          const SizedBox(height: 16),
          const Text(
            'Contraseña Reestablecida',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            'Su clave ha sido actualizada con éxito. Ya puede iniciar sesión.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.54)),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.go('/login'),
            child: const Text('Ir al Login'),
          ),
        ],
      );
    }

    return Form(
      key: _confirmFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Nueva Contraseña
          TextFormField(
            controller: _newPasswordController,
            obscureText: _obscureNew,
            enabled: !isLoading,
            decoration: InputDecoration(
              labelText: 'Nueva Contraseña',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureNew
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
                onPressed: () {
                  setState(() {
                    _obscureNew = !_obscureNew;
                  });
                },
              ),
              border: const OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Ingrese su nueva contraseña.';
              }
              if (value.length < 8) {
                return 'Debe tener al menos 8 caracteres.';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          // Confirmar Contraseña
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: _obscureConfirm,
            enabled: !isLoading,
            decoration: InputDecoration(
              labelText: 'Confirmar Contraseña',
              prefixIcon: const Icon(Icons.check_circle_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirm
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
                onPressed: () {
                  setState(() {
                    _obscureConfirm = !_obscureConfirm;
                  });
                },
              ),
              border: const OutlineInputBorder(),
            ),
            validator: (value) {
              if (value != _newPasswordController.text) {
                return 'Las contraseñas no coinciden.';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),

          isLoading
              ? const Center(child: CircularProgressIndicator())
              : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () => _submitConfirmation(userId, secret),
                  child: const Text('Restablecer y Guardar'),
                ),
        ],
      ),
    );
  }
}

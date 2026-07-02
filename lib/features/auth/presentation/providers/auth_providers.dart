import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/constants/app_roles.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/usuario.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/cambiar_password_usecase.dart';
import '../../domain/usecases/solicitar_recuperacion_usecase.dart';
import '../../domain/usecases/confirmar_recuperacion_usecase.dart';
import '../../domain/usecases/crear_usuario_usecase.dart';
import '../screens/login_screen.dart';
import '../screens/cambiar_password_screen.dart';
import '../screens/recuperar_password_screen.dart';
import '../../../recintos/presentation/screens/recintos_list_screen.dart';
import '../../../recintos/presentation/screens/crear_recinto_screen.dart';
import '../../../recintos/presentation/screens/mi_recinto_screen.dart';
import '../../../recintos/presentation/screens/mis_jrv_screen.dart';
import '../../../usuarios/presentation/screens/crear_usuario_screen.dart';
import '../../../organizaciones/presentation/screens/organizaciones_list_screen.dart';
import '../../../seeder/presentation/seeder_screen.dart';
import '../../../actas/presentation/screens/registrar_acta_screen.dart';
import '../../../actas/presentation/screens/mis_actas_screen.dart';
import '../../../actas/presentation/screens/detalle_acta_screen.dart';
import '../../../actas/domain/entities/acta.dart';

import '../../../avance/presentation/screens/avance_electoral_screen.dart';
import '../../../avance/presentation/screens/dashboard_votos_screen.dart';
import '../../../usuarios/presentation/screens/asignar_coordinador_screen.dart';
import '../../../usuarios/presentation/screens/asignar_veedores_screen.dart';
import '../../../usuarios/presentation/screens/crear_usuario_screen.dart';
import '../../../../core/presentation/widgets/theme_toggle_button.dart';
import '../../../sync/presentation/screens/sync_estado_screen.dart';
import 'auth_state.dart';

part 'auth_providers.g.dart';

/// auth_providers.dart
/// 
/// Responsabilidad Única: Exponer los proveedores globales de Riverpod para el estado de
/// sesión del usuario, los casos de uso, el enrutamiento (GoRouter) y la lógica de redirección.
/// Cambios en esta clase ocurren si cambian los flujos de navegación globales o los requerimientos de estado.

@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() {
    // Al construirse el notifier por primera vez, verificamos si existe una sesión activa
    Future.microtask(() => verificarSesionActiva());
    return const AuthState.initial();
  }

  /// Verifica si el usuario ya cuenta con una sesión válida persistente en Appwrite.
  Future<void> verificarSesionActiva() async {
    state = const AuthState.loading();
    final repository = ref.read(authRepositoryProvider);
    final result = await repository.obtenerUsuarioActual();
    
    result.fold(
      (failure) => state = const AuthState.initial(),
      (user) {
        if (!user.passwordChanged) {
          state = AuthState.passwordChangeRequired(user);
        } else {
          state = AuthState.authenticated(user);
        }
      },
    );
  }

  /// Inicia sesión utilizando cédula y contraseña.
  Future<void> login(String cedula, String password) async {
    state = const AuthState.loading();
    final useCase = ref.read(loginUseCaseProvider);
    final result = await useCase(cedula, password);

    result.fold(
      (failure) => state = AuthState.error(failure.message),
      (user) {
        if (!user.passwordChanged) {
          state = AuthState.passwordChangeRequired(user);
        } else {
          state = AuthState.authenticated(user);
        }
      },
    );
  }

  /// Cierra la sesión activa en el servidor y limpia el estado local.
  Future<void> logout() async {
    state = const AuthState.loading();
    // En Fase 2 no se requiere persistencia compleja, solo limpiar localmente y forzar redir.
    // En Fase posterior se puede invocar account.deleteSession(sessionId: 'current')
    state = const AuthState.initial();
  }

  /// Realiza el cambio de contraseña obligatorio o voluntario.
  Future<bool> cambiarPassword(String currentPassword, String newPassword) async {
    state = const AuthState.loading();
    final useCase = ref.read(cambiarPasswordUseCaseProvider);
    final result = await useCase(currentPassword, newPassword);

    return result.fold(
      (failure) {
        state = AuthState.error(failure.message);
        return false;
      },
      (_) {
        // Al cambiar de contraseña con éxito, recargamos el estado para habilitar navegación.
        verificarSesionActiva();
        return true;
      },
    );
  }

  /// Solicita el envío de un correo con enlace de recuperación.
  Future<bool> solicitarRecuperacion(String identificador) async {
    state = const AuthState.loading();
    final useCase = ref.read(solicitarRecuperacionUseCaseProvider);
    final result = await useCase(identificador);

    return result.fold(
      (failure) {
        state = AuthState.error(failure.message);
        return false;
      },
      (_) {
        state = const AuthState.initial();
        return true;
      },
    );
  }

  /// Confirma el restablecimiento de clave utilizando el token y la nueva clave.
  Future<bool> confirmarRecuperacion({
    required String userId,
    required String secret,
    required String newPassword,
  }) async {
    state = const AuthState.loading();
    final useCase = ref.read(confirmarRecuperacionUseCaseProvider);
    final result = await useCase(userId: userId, secret: secret, newPassword: newPassword);

    return result.fold(
      (failure) {
        state = AuthState.error(failure.message);
        return false;
      },
      (_) {
        state = const AuthState.initial();
        return true;
      },
    );
  }
}

/// Expone el usuario autenticado actual (si existe).
@Riverpod(keepAlive: true)
Usuario? currentUser(CurrentUserRef ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.maybeWhen(
    authenticated: (user) => user,
    passwordChangeRequired: (user) => user,
    orElse: () => null,
  );
}

/// Proveedor centralizado de GoRouter para manejar las pantallas y guards de redirección.
@Riverpod(keepAlive: true)
GoRouter goRouter(GoRouterRef ref) {
  final authState = ref.watch(authNotifierProvider);

  return GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/cambiar-password',
        builder: (context, state) => const CambiarPasswordScreen(),
      ),
      GoRoute(
        path: '/recuperar-password',
        builder: (context, state) => const RecuperarPasswordScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const _HomeScreen(),
      ),
      // ── Fase 3: Recintos ──────────────────────────────────────────────
      GoRoute(
        path: '/recintos',
        builder: (context, state) => const RecintosListScreen(),
      ),
      GoRoute(
        path: '/recintos/crear',
        builder: (context, state) => const CrearRecintoScreen(),
      ),
      GoRoute(
        path: '/mi-recinto',
        builder: (context, state) => const MiRecintoScreen(),
      ),
      GoRoute(
        path: '/mis-jrvs',
        builder: (context, state) => const MisJrvsScreen(),
      ),
      // ── Fase 3: Organizaciones ────────────────────────────────────────
      GoRoute(
        path: '/organizaciones',
        builder: (context, state) => const OrganizacionesListScreen(),
      ),
      // ── Fase 3: Seeder ────────────────────────────────────────────────
      GoRoute(
        path: '/seeder',
        builder: (context, state) => const SeederScreen(),
      ),
      // ── Fase 4: Actas ──────────────────────────────────────────────────
      GoRoute(
        path: '/actas/registrar',
        builder: (context, state) {
          final acta = state.extra as Acta?;
          return RegistrarActaScreen(actaExistente: acta);
        },
      ),
      GoRoute(
        path: '/actas/mis-actas',
        builder: (context, state) => const MisActasScreen(),
      ),
      GoRoute(
        path: '/actas/detalle',
        builder: (context, state) {
          final acta = state.extra as Acta;
          return DetalleActaScreen(acta: acta);
        },
      ),
      GoRoute(
        path: '/actas/asignar-veedores',
        builder: (context, state) => const AsignarVeedoresScreen(),
      ),
      GoRoute(
        path: '/sync/estado',
        builder: (context, state) => const SyncEstadoScreen(),
      ),
      GoRoute(
        path: '/avance',
        builder: (context, state) => const AvanceElectoralScreen(),
      ),
      GoRoute(
        path: '/avance/dashboard',
        builder: (context, state) => const DashboardVotosScreen(),
      ),
      // ── Gap: Usuarios ────────────────────────────────────────────────
      GoRoute(
        path: '/usuarios/crear',
        builder: (context, state) => const CrearUsuarioScreen(),
      ),
      GoRoute(
        path: '/usuarios/asignar-coordinador',
        builder: (context, state) => const AsignarCoordinadorScreen(),
      ),
    ],
    redirect: (context, state) {
      final isLoggedIn = authState.maybeWhen(
        authenticated: (_) => true,
        passwordChangeRequired: (_) => true,
        orElse: () => false,
      );

      final mustChangePassword = authState.maybeWhen(
        passwordChangeRequired: (_) => true,
        orElse: () => false,
      );

      final matchedPath = state.matchedLocation;

      // 1. Usuarios no autenticados: solo login y recuperación son libres.
      if (!isLoggedIn) {
        if (matchedPath == '/login' || matchedPath == '/recuperar-password') {
          return null;
        }
        return '/login';
      }

      // 2. Obligar cambio de contraseña si no lo ha hecho.
      if (mustChangePassword) {
        return '/cambiar-password';
      }

      // 3. Si ya completó el flujo, evitar que vuelva a login/recuperar/cambiar.
      if (matchedPath == '/login' ||
          matchedPath == '/recuperar-password' ||
          matchedPath == '/cambiar-password') {
        return '/home';
      }

      // 4. Guard de rol: pantallas solo para Coordinador Provincial.
      final esCoordinadorProvincial = authState.maybeWhen(
        authenticated: (user) =>
            user.rol == AppRole.coordinadorProvincial,
        orElse: () => false,
      );
      final esCoordinadorRecinto = authState.maybeWhen(
        authenticated: (user) =>
            user.rol == AppRole.coordinadorRecinto,
        orElse: () => false,
      );
      final pathsProvincial = [
        '/recintos/crear', '/seeder',
        '/avance', '/usuarios/asignar-coordinador',
      ];
      if (pathsProvincial.contains(matchedPath) && !esCoordinadorProvincial) {
        return '/home';
      }
      // /usuarios/crear: coordProvincial puede crear cualquiera, coordRecinto solo veedores.
      if (matchedPath == '/usuarios/crear' &&
          !esCoordinadorProvincial &&
          !esCoordinadorRecinto) {
        return '/home';
      }
      // /actas/asignar-veedores: coordRecinto y coordProvincial.
      if (matchedPath == '/actas/asignar-veedores' && 
          !esCoordinadorRecinto && 
          !esCoordinadorProvincial) {
        return '/home';
      }

      return null;
    },
  );
}

// --- Proveedores de Casos de Uso del Dominio ---

@Riverpod(keepAlive: true)
LoginUseCase loginUseCase(LoginUseCaseRef ref) {
  return LoginUseCase(repository: ref.watch(authRepositoryProvider));
}

@Riverpod(keepAlive: true)
CambiarPasswordUseCase cambiarPasswordUseCase(CambiarPasswordUseCaseRef ref) {
  return CambiarPasswordUseCase(repository: ref.watch(authRepositoryProvider));
}

@Riverpod(keepAlive: true)
SolicitarRecuperacionUseCase solicitarRecuperacionUseCase(SolicitarRecuperacionUseCaseRef ref) {
  return SolicitarRecuperacionUseCase(repository: ref.watch(authRepositoryProvider));
}

@Riverpod(keepAlive: true)
ConfirmarRecuperacionUseCase confirmarRecuperacionUseCase(ConfirmarRecuperacionUseCaseRef ref) {
  return ConfirmarRecuperacionUseCase(repository: ref.watch(authRepositoryProvider));
}

@Riverpod(keepAlive: true)
CrearUsuarioUseCase crearUsuarioUseCase(CrearUsuarioUseCaseRef ref) {
  return CrearUsuarioUseCase(repository: ref.watch(authRepositoryProvider));
}

// ---------------------------------------------------------------------------
// Home Screen — navegación según rol
// ---------------------------------------------------------------------------

/// Pantalla de inicio con accesos rápidos según el rol del usuario autenticado.
class _HomeScreen extends ConsumerWidget {
  const _HomeScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usuario = ref.watch(currentUserProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Control Electoral Ecuador',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          const ThemeToggleButton(),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () =>
                ref.read(authNotifierProvider.notifier).logout(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Saludo
            Text(
              'Bienvenido,',
              style: TextStyle(color: colorScheme.onSurface.withOpacity(0.6), fontSize: 14),
            ),
            Text(
              '${usuario?.nombres ?? "Usuario"} ${usuario?.apellidos ?? ""}',
              style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                usuario?.rol.name ?? '',
                style: TextStyle(
                    color: colorScheme.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 32),
            // Accesos rápidos comunes según rol
            Text(
              'ACCESOS RÁPIDOS',
              style: TextStyle(
                  color: colorScheme.onSurface.withOpacity(0.4),
                  fontSize: 11,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            
            // Recintos Electorales - Solo Provincial
            if (usuario?.rol == AppRole.coordinadorProvincial)
              _NavCard(
                icon: Icons.map_outlined,
                label: 'Recintos Electorales',
                subtitle: 'Ver jerarquía provincial',
                onTap: () => context.push('/recintos'),
              ),
            
            _NavCard(
              icon: Icons.how_to_vote_outlined,
              label: 'Organizaciones Políticas',
              subtitle: 'Listas por cargo electoral',
              onTap: () => context.push('/organizaciones'),
            ),

            // Módulo Veedor
            if (usuario?.rol == AppRole.veedor) ...[
              _NavCard(
                icon: Icons.how_to_vote_outlined,
                label: 'Mis JRVs',
                subtitle: 'Mesas asignadas a tu cargo',
                onTap: () => context.push('/mis-jrvs'),
              ),
              _NavCard(
                icon: Icons.how_to_vote_rounded,
                label: 'Registrar Acta',
                subtitle: 'Capturar resultados de una JRV',
                onTap: () => context.push('/actas/registrar'),
              ),
              _NavCard(
                icon: Icons.description_outlined,
                label: 'Mis Actas',
                subtitle: 'Ver actas registradas',
                onTap: () => context.push('/actas/mis-actas'),
              ),
              _NavCard(
                icon: Icons.cloud_sync_outlined,
                label: 'Estado de Sincronización',
                subtitle: 'Ver cola y reintentar pendientes',
                onTap: () => context.push('/sync/estado'),
              ),
            ],

            // Módulo Coordinador de Recinto
            if (usuario?.rol == AppRole.coordinadorRecinto) ...[
              _NavCard(
                icon: Icons.account_balance_outlined,
                label: 'Mi Recinto',
                subtitle: 'Ver información del recinto asignado',
                onTap: () => context.push('/mi-recinto'),
              ),
              _NavCard(
                icon: Icons.assignment_outlined,
                label: 'Estado de Actas',
                subtitle: 'Revisar actas de tu recinto',
                onTap: () => context.push('/mi-recinto'),
              ),
              _NavCard(
                icon: Icons.edit_note_outlined,
                label: 'Corregir Actas',
                subtitle: 'Editar datos o foto de actas del recinto',
                onTap: () => context.push('/mi-recinto'),
              ),
              if (AppPermissions.puedeCrearVeedores(usuario!.rol))
                _NavCard(
                  icon: Icons.person_add_outlined,
                  label: 'Crear Veedor',
                  subtitle: 'Registrar nuevo veedor en el sistema',
                  onTap: () => context.push('/usuarios/crear'),
                ),
              if (AppPermissions.puedeAsignarVeedores(usuario.rol))
                _NavCard(
                  icon: Icons.swap_horiz_outlined,
                  label: 'Asignar/Reasignar Veedores',
                  subtitle: 'Vincular o cambiar veedores por mesa',
                  onTap: () => context.push('/actas/asignar-veedores'),
                ),
            ],

            // Solo Coordinador Provincial
            if (usuario?.rol == AppRole.coordinadorProvincial) ...[
              _NavCard(
                icon: Icons.add_location_alt_outlined,
                label: 'Crear Recinto',
                subtitle: 'Registrar nuevo recinto electoral',
                onTap: () => context.push('/recintos/crear'),
              ),
              _NavCard(
                icon: Icons.cloud_upload_outlined,
                label: 'Carga de Datos Iniciales',
                subtitle: 'Seeder de jerarquía geográfica',
                accentColor: Colors.amber,
                onTap: () => context.push('/seeder'),
              ),
              if (AppPermissions.puedeConsultarAvance(usuario!.rol)) ...[
                _NavCard(
                  icon: Icons.pie_chart_outline,
                  label: 'Avance Electoral',
                  subtitle: 'Progreso y coordenadas GPS',
                  onTap: () => context.push('/avance'),
                ),
                _NavCard(
                  icon: Icons.analytics_outlined,
                  label: 'Dashboard de Votos',
                  subtitle: 'Votos por organización y dignidad',
                  onTap: () => context.push('/avance/dashboard'),
                ),
              ],
              _NavCard(
                icon: Icons.people_outline,
                label: 'Asignar Coordinador de Recinto',
                subtitle: 'Vincular un coordinador a un recinto',
                onTap: () => context.push('/usuarios/asignar-coordinador'),
              ),
              _NavCard(
                icon: Icons.person_add_outlined,
                label: 'Crear Coordinador de Recinto',
                subtitle: 'Registrar coordinadores para recintos',
                onTap: () => context.push('/usuarios/crear'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _NavCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;
  final Color? accentColor;

  const _NavCard({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final cardColor = theme.cardTheme.color ?? colorScheme.surface;
    final effectiveAccent = accentColor ?? colorScheme.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: effectiveAccent.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: effectiveAccent),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(label,
                          style: TextStyle(
                              color: colorScheme.onSurface,
                              fontSize: 15,
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 2),
                      Text(subtitle,
                          style: TextStyle(
                              color: colorScheme.onSurface.withOpacity(0.6), fontSize: 12)),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: colorScheme.onSurface.withOpacity(0.3)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

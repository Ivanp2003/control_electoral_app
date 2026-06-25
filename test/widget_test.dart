import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:control_electoral_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:control_electoral_app/features/auth/presentation/providers/auth_state.dart';
import 'package:control_electoral_app/features/auth/presentation/screens/login_screen.dart';

class FakeAuthNotifier extends AuthNotifier {
  @override
  AuthState build() {
    return const AuthState.initial();
  }
  
  @override
  Future<void> verificarSesionActiva() async {
    // No operation for tests to avoid network calls
  }
}

void main() {
  testWidgets('Login screen elements are displayed correctly smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authNotifierProvider.overrideWith(() => FakeAuthNotifier()),
        ],
        child: const MaterialApp(
          home: LoginScreen(),
        ),
      ),
    );

    await tester.pump();

    // Verify that the login header text and components are present when not loading.
    expect(find.text('Control Electoral Ecuador'), findsOneWidget);
    expect(find.text('Fase 2: Autenticación de Operadores'), findsOneWidget);
    expect(find.text('Iniciar Sesión'), findsOneWidget);
    expect(find.text('Cédula de Identidad'), findsOneWidget);
  });
}

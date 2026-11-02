import 'package:computacion_movil/features/auth/presentation/providers/auth_state_provider.dart';
import 'package:computacion_movil/features/auth/presentation/screens/login_screen.dart';
import 'package:computacion_movil/features/auth/presentation/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Rutas de la aplicación
abstract final class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String dashboard = '/';
  static const String home = '/home';
}

@visibleForTesting
String? appRouterRedirect({
  required bool isAuthenticated,
  required String path,
}) {
  final isLoginRoute = path == AppRoutes.login;
  final isRegisterRoute = path == AppRoutes.register;
  final isAuthRoute = isLoginRoute || isRegisterRoute;

  if (!isAuthenticated && !isAuthRoute) {
    return AppRoutes.login;
  }

  if (isAuthenticated && isAuthRoute) {
    return AppRoutes.dashboard;
  }

  return null;
}

class AppRouter {
  AppRouter._();

  @visibleForTesting
  static String? evaluateRedirect({
    required bool isAuthenticated,
    required String path,
  }) {
    final isLoginRoute = path == AppRoutes.login;
    final isRegisterRoute = path == AppRoutes.register;
    final isAuthRoute = isLoginRoute || isRegisterRoute;

    if (!isAuthenticated && !isAuthRoute) {
      return AppRoutes.login;
    }

    if (isAuthenticated && isAuthRoute) {
      return AppRoutes.dashboard;
    }

    return null;
  }

  static GoRouter createRouter(WidgetRef ref) {
    return GoRouter(
      initialLocation: AppRoutes.dashboard,
      debugLogDiagnostics: false,
      redirect: (BuildContext context, GoRouterState routerState) {
        final authState = ref.read(authStateProvider);
        final isAuthenticated = authState is AuthAuthenticated;
        final path = routerState.uri.path;
        final isLoginRoute = path == AppRoutes.login;
        final isRegisterRoute = path == AppRoutes.register;
        final isAuthRoute = isLoginRoute || isRegisterRoute;

        if (!isAuthenticated && !isAuthRoute) {
          return AppRoutes.login;
        }

        if (isAuthenticated && isAuthRoute) {
          return AppRoutes.dashboard;
        }

        return null;
      },
      routes: <RouteBase>[
        // Login
        GoRoute(
          path: AppRoutes.login,
          builder: (context, state) => const LoginScreen(),
        ),

        // Register
        GoRoute(
          path: AppRoutes.register,
          builder: (context, state) => const RegisterScreen(),
        ),

        // Dashboard / Home
        GoRoute(
          path: AppRoutes.dashboard,
          builder: (context, state) => _buildDashboardPage(),
        ),
      ],
      errorBuilder: (ctx, state) => _buildNotFoundPage(state.uri.path),
    );
  }

  static Widget _buildDashboardPage() {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: const Center(child: Text('Dashboard - En construcción')),
    );
  }

  static Widget _buildNotFoundPage(String path) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '404',
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Página no encontrada: $path', textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

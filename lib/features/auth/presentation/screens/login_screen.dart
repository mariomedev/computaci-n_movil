import 'package:computacion_movil/core/core.dart';
import 'package:computacion_movil/features/auth/presentation/atoms/atoms.dart';
import 'package:computacion_movil/features/auth/presentation/organisms/organisms.dart';
import 'package:computacion_movil/features/auth/presentation/providers/auth_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Escuchar cambios en el estado de autenticación
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.listenManual(authStateProvider, (previous, next) {
        if (next is AuthAuthenticated) {
          // Navegar al dashboard cuando se autentique
          context.go(AppRoutes.dashboard);
        }
      });
    });
  }

  Future<void> _submit() async {
    // Limpiar error anterior
    ref.read(authStateProvider.notifier).clearError();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    await ref
        .read(authStateProvider.notifier)
        .login(email: email, password: password);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final authState = ref.watch(authStateProvider);
    final isLoading = authState is AuthLoading;
    final errorMessage = authState is AuthError ? authState.message : null;

    return Scaffold(
      backgroundColor: colors.background,
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenHorizontalPadding,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: LoginForm(
                  formKey: _formKey,
                  emailController: _emailController,
                  passwordController: _passwordController,
                  onSubmit: _submit,
                  onNavigateToRegister: () => context.go(AppRoutes.register),
                  isLoading: isLoading,
                  errorMessage: errorMessage,
                ),
              ),
            ),
          ),

          // Theme toggle button
          const Positioned(
            top: AppSpacing.lg,
            right: AppSpacing.lg,
            child: ThemeToggleButton(),
          ),
        ],
      ),
    );
  }
}

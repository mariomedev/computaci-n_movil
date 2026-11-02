import 'package:computacion_movil/core/core.dart';
import 'package:computacion_movil/features/auth/presentation/atoms/atoms.dart';
import 'package:computacion_movil/features/auth/presentation/organisms/organisms.dart';
import 'package:computacion_movil/features/auth/presentation/providers/auth_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _nacionalidadController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nombreController.dispose();
    _apellidoController.dispose();
    _telefonoController.dispose();
    _nacionalidadController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Escuchar cambios en el estado de autenticación
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.listenManual(authStateProvider, (previous, next) {
        if (next is AuthAuthenticated) {
          // Navegar al dashboard cuando se registre
          context.go(AppRoutes.dashboard);
        }
      });
    });
  }

  Future<void> _submit({
    required String email,
    required String password,
    required String nombre,
    required String apellido,
    required String telefono,
    required String nacionalidad,
  }) async {
    // Limpiar error anterior
    ref.read(authStateProvider.notifier).clearError();

    await ref
        .read(authStateProvider.notifier)
        .signUp(
          email: email,
          password: password,
          nombre: nombre,
          apellido: apellido,
          telefono: telefono,
          nacionalidad: nacionalidad,
        );
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
                child: RegisterForm(
                  formKey: _formKey,
                  emailController: _emailController,
                  passwordController: _passwordController,
                  confirmPasswordController: _confirmPasswordController,
                  nombreController: _nombreController,
                  apellidoController: _apellidoController,
                  telefonoController: _telefonoController,
                  nacionalidadController: _nacionalidadController,
                  onSubmit: _submit,
                  onNavigateToLogin: () => context.go(AppRoutes.login),
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

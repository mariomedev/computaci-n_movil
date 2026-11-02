import 'package:computacion_movil/core/core.dart';
import 'package:computacion_movil/features/auth/constants/auth_strings.dart';
import 'package:computacion_movil/features/auth/presentation/molecules/molecules.dart';
import 'package:flutter/material.dart';

/// Register form organism that composes form fields, manages password visibility states,
/// and handles phone number sanitization before submission.
class RegisterForm extends StatefulWidget {
  const RegisterForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.nombreController,
    required this.apellidoController,
    required this.telefonoController,
    required this.nacionalidadController,
    required this.onSubmit,
    required this.onNavigateToLogin,
    required this.isLoading,
    this.errorMessage,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final TextEditingController nombreController;
  final TextEditingController apellidoController;
  final TextEditingController telefonoController;
  final TextEditingController nacionalidadController;
  final Future<void> Function({
    required String email,
    required String password,
    required String nombre,
    required String apellido,
    required String telefono,
    required String nacionalidad,
  })
  onSubmit;
  final VoidCallback onNavigateToLogin;
  final bool isLoading;
  final String? errorMessage;

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  Future<void> _handleSubmit() async {
    if (!widget.formKey.currentState!.validate()) {
      return;
    }

    final email = widget.emailController.text.trim();
    final password = widget.passwordController.text;
    final nombre = widget.nombreController.text.trim();
    final apellido = widget.apellidoController.text.trim();
    // Sanitize phone: strip formatting characters, keep only digits and plus sign
    final telefono = widget.telefonoController.text.trim().replaceAll(
      RegExp(r'[^\d+]'),
      '',
    );
    final nacionalidad = widget.nacionalidadController.text.trim();

    await widget.onSubmit(
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

    return Form(
      key: widget.formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AuthLogoHeader(subtitle: AuthStrings.registerSubtitle),
          const SizedBox(height: AppSpacing.sectionSpacing),

          AuthFormField(
            labelText: AuthStrings.emailLabel,
            prefixIcon: Icons.email_outlined,
            type: AuthFormFieldType.email,
            controller: widget.emailController,
            enabled: !widget.isLoading,
          ),
          const SizedBox(height: AppSpacing.lg),

          AuthFormField(
            labelText: AuthStrings.passwordLabel,
            prefixIcon: Icons.lock_outlined,
            type: AuthFormFieldType.password,
            controller: widget.passwordController,
            enabled: !widget.isLoading,
            requirePasswordLength: true,
            obscureText: _obscurePassword,
            onToggleObscureText: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
          const SizedBox(height: AppSpacing.lg),

          AuthFormField(
            labelText: AuthStrings.confirmPasswordLabel,
            prefixIcon: Icons.lock_outlined,
            type: AuthFormFieldType.confirmPassword,
            controller: widget.confirmPasswordController,
            passwordController: widget.passwordController,
            enabled: !widget.isLoading,
            obscureText: _obscureConfirmPassword,
            onToggleObscureText: () {
              setState(() {
                _obscureConfirmPassword = !_obscureConfirmPassword;
              });
            },
          ),
          const SizedBox(height: AppSpacing.lg),

          AuthFormField(
            labelText: AuthStrings.nombreLabel,
            prefixIcon: Icons.person_outlined,
            type: AuthFormFieldType.text,
            controller: widget.nombreController,
            enabled: !widget.isLoading,
            fieldName: AuthStrings.nombreLabel,
          ),
          const SizedBox(height: AppSpacing.lg),

          AuthFormField(
            labelText: AuthStrings.apellidoLabel,
            prefixIcon: Icons.person_outlined,
            type: AuthFormFieldType.text,
            controller: widget.apellidoController,
            enabled: !widget.isLoading,
            fieldName: AuthStrings.apellidoLabel,
          ),
          const SizedBox(height: AppSpacing.lg),

          AuthFormField(
            labelText: AuthStrings.telefonoLabel,
            prefixIcon: Icons.phone_outlined,
            type: AuthFormFieldType.phone,
            controller: widget.telefonoController,
            enabled: !widget.isLoading,
          ),
          const SizedBox(height: AppSpacing.lg),

          AuthFormField(
            labelText: AuthStrings.nacionalidadLabel,
            prefixIcon: Icons.flag_outlined,
            type: AuthFormFieldType.text,
            controller: widget.nacionalidadController,
            enabled: !widget.isLoading,
            fieldName: AuthStrings.nacionalidadLabel,
          ),
          const SizedBox(height: AppSpacing.xl),

          ErrorMessageBanner(errorMessage: widget.errorMessage),
          if (widget.errorMessage != null)
            const SizedBox(height: AppSpacing.lg),

          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: widget.isLoading ? null : _handleSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                disabledBackgroundColor: colors.primary.withValues(alpha: 0.6),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: AppRadius.borderMd),
                elevation: 0,
              ),
              child: widget.isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      AuthStrings.registerButton,
                      style: AppTextStyles.labelLg.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          TextButton(
            onPressed: widget.isLoading ? null : widget.onNavigateToLogin,
            child: Text(
              AuthStrings.hasAccountQuestion,
              style: AppTextStyles.bodyMd.copyWith(color: colors.primary),
            ),
          ),
        ],
      ),
    );
  }
}

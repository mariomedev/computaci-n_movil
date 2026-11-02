import 'package:computacion_movil/core/core.dart';
import 'package:computacion_movil/features/auth/constants/auth_strings.dart';
import 'package:computacion_movil/features/auth/presentation/molecules/molecules.dart';
import 'package:flutter/material.dart';

/// Login form organism that composes form fields and manages password visibility state.
class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.onSubmit,
    required this.onNavigateToRegister,
    required this.isLoading,
    this.errorMessage,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onSubmit;
  final VoidCallback onNavigateToRegister;
  final bool isLoading;
  final String? errorMessage;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Form(
      key: widget.formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AuthLogoHeader(subtitle: AuthStrings.loginSubtitle),
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
            obscureText: _obscurePassword,
            onToggleObscureText: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
          const SizedBox(height: AppSpacing.xl),

          ErrorMessageBanner(errorMessage: widget.errorMessage),
          if (widget.errorMessage != null)
            const SizedBox(height: AppSpacing.lg),

          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: widget.isLoading ? null : widget.onSubmit,
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
                      AuthStrings.loginButton,
                      style: AppTextStyles.labelLg.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          TextButton(
            onPressed: widget.isLoading ? null : widget.onNavigateToRegister,
            child: Text(
              AuthStrings.noAccountQuestion,
              style: AppTextStyles.bodyMd.copyWith(color: colors.primary),
            ),
          ),
        ],
      ),
    );
  }
}

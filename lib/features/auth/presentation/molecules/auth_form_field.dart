import 'package:computacion_movil/features/auth/constants/auth_strings.dart';
import 'package:computacion_movil/features/auth/presentation/atoms/atoms.dart';
import 'package:flutter/material.dart';

enum AuthFormFieldType { email, password, confirmPassword, text, phone }

/// A molecule component that combines an [AuthTextField] with validation logic.
///
/// Provides type-based configuration for common form fields (email, password, text, phone)
/// with client-side format validation for immediate user feedback before domain validation.
///
/// Password visibility state is managed by the parent (organism or screen level).
class AuthFormField extends StatelessWidget {
  const AuthFormField({
    super.key,
    required this.labelText,
    required this.prefixIcon,
    required this.type,
    this.controller,
    this.enabled = true,
    this.passwordController,
    this.fieldName,
    this.requirePasswordLength = false,
    this.obscureText = false,
    this.onToggleObscureText,
  });

  final String labelText;
  final IconData prefixIcon;
  final AuthFormFieldType type;
  final TextEditingController? controller;
  final bool enabled;
  final TextEditingController? passwordController;
  final String? fieldName;
  final bool requirePasswordLength;
  final bool obscureText;
  final VoidCallback? onToggleObscureText;

  String? _validate(String? value) {
    switch (type) {
      case AuthFormFieldType.email:
        if (value == null || value.trim().isEmpty) {
          return AuthStrings.emailRequired;
        }
        // Client-side format validation for immediate feedback (aligned with domain)
        final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
        if (!regex.hasMatch(value.trim())) {
          return AuthStrings.emailInvalidFormat;
        }
        return null;

      case AuthFormFieldType.password:
        if (value == null || value.trim().isEmpty) {
          return AuthStrings.passwordRequired;
        }
        // Client-side length validation for immediate feedback (aligned with domain)
        if (requirePasswordLength && value.length < 6) {
          return AuthStrings.passwordMinLength;
        }
        return null;

      case AuthFormFieldType.confirmPassword:
        if (value == null || value.trim().isEmpty) {
          return AuthStrings.confirmPasswordRequired;
        }
        if (passwordController != null && value != passwordController!.text) {
          return AuthStrings.passwordsNotMatch;
        }
        return null;

      case AuthFormFieldType.text:
        if (value == null || value.trim().isEmpty) {
          return AuthStrings.fieldRequired(fieldName ?? 'Campo');
        }
        return null;

      case AuthFormFieldType.phone:
        if (value == null || value.trim().isEmpty) {
          return AuthStrings.phoneRequired;
        }
        // Client-side format validation for immediate feedback
        final regex = RegExp(r'^[0-9+\s()-]{7,20}$');
        if (!regex.hasMatch(value.trim())) {
          return AuthStrings.phoneInvalidFormat;
        }
        return null;
    }
  }

  TextInputType? _getKeyboardType() {
    switch (type) {
      case AuthFormFieldType.email:
        return TextInputType.emailAddress;
      case AuthFormFieldType.phone:
        return TextInputType.phone;
      case AuthFormFieldType.text:
        return TextInputType.name;
      case AuthFormFieldType.password:
      case AuthFormFieldType.confirmPassword:
        return null;
    }
  }

  List<String>? _getAutofillHints() {
    switch (type) {
      case AuthFormFieldType.email:
        return const [AutofillHints.email];
      case AuthFormFieldType.password:
        return const [AutofillHints.password];
      case AuthFormFieldType.confirmPassword:
        return const [AutofillHints.newPassword];
      case AuthFormFieldType.phone:
        return const [AutofillHints.telephoneNumber];
      case AuthFormFieldType.text:
        if (labelText == AuthStrings.nombreLabel) {
          return const [AutofillHints.givenName];
        } else if (labelText == AuthStrings.apellidoLabel) {
          return const [AutofillHints.familyName];
        }
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final needsVisibilityToggle =
        type == AuthFormFieldType.password ||
        type == AuthFormFieldType.confirmPassword;

    return AuthTextField(
      labelText: labelText,
      controller: controller,
      prefixIcon: prefixIcon,
      suffixIcon: needsVisibilityToggle && onToggleObscureText != null
          ? PasswordVisibilityButton(
              isObscured: obscureText,
              onPressed: onToggleObscureText!,
            )
          : null,
      obscureText: needsVisibilityToggle && obscureText,
      enabled: enabled,
      validator: _validate,
      keyboardType: _getKeyboardType(),
      autofillHints: _getAutofillHints(),
    );
  }
}

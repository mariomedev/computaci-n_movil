import 'package:computacion_movil/core/core.dart';
import 'package:computacion_movil/features/auth/constants/auth_strings.dart';
import 'package:flutter/material.dart';

class AuthLogoHeader extends StatelessWidget {
  const AuthLogoHeader({super.key, required this.subtitle});

  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.local_shipping_outlined,
              size: 50,
              color: colors.primary,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),

        Text(
          AuthStrings.appName,
          style: AppTextStyles.headingLg.copyWith(
            color: colors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          subtitle,
          style: AppTextStyles.bodyMd.copyWith(color: colors.textSecondary),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

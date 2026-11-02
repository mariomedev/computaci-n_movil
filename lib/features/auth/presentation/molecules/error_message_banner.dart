import 'package:computacion_movil/core/core.dart';
import 'package:flutter/material.dart';

class ErrorMessageBanner extends StatelessWidget {
  const ErrorMessageBanner({super.key, this.errorMessage});

  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    if (errorMessage == null) {
      return const SizedBox.shrink();
    }

    final colors = context.appColors;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.error.withValues(alpha: 0.1),
        borderRadius: AppRadius.borderSm,
        border: Border.all(color: colors.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: colors.error,
            size: AppSpacing.iconSize,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              errorMessage!,
              style: AppTextStyles.bodySm.copyWith(color: colors.error),
            ),
          ),
        ],
      ),
    );
  }
}

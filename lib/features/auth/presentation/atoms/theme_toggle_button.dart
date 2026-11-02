import 'package:computacion_movil/core/core.dart';
import 'package:computacion_movil/features/auth/constants/auth_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeToggleButton extends ConsumerWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final themeMode = ref.watch(themeNotifierProvider);
    final isDark = themeMode != ThemeMode.light;

    return IconButton(
      onPressed: () {
        final next = isDark ? ThemeMode.light : ThemeMode.dark;
        ref.read(themeNotifierProvider.notifier).setThemeMode(next);
      },
      icon: Icon(
        isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
        color: colors.textSecondary,
      ),
      tooltip: isDark
          ? AuthStrings.themeLightTooltip
          : AuthStrings.themeDarkTooltip,
    );
  }
}

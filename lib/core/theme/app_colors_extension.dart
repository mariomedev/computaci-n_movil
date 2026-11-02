import 'package:flutter/material.dart';

class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  final Color primary;
  final Color primaryLight;
  final Color primaryMid;
  final Color primaryDark;

  final Color background;
  final Color backgroundDeep;
  final Color surface;
  final Color surfaceElevated;
  final Color surfaceTag;

  final Color border;
  final Color borderFocus;

  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color textMuted;
  final Color textMutedAlt;
  final Color textOnPrimary;
  final Color textDisabled;

  final Color success;
  final Color warning;
  final Color error;
  final Color info;
  final Color live;
  final Color liveGold;

  const AppColorsExtension({
    required this.primary,
    required this.primaryLight,
    required this.primaryMid,
    required this.primaryDark,
    required this.background,
    required this.backgroundDeep,
    required this.surface,
    required this.surfaceElevated,
    required this.surfaceTag,
    required this.border,
    required this.borderFocus,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.textMuted,
    required this.textMutedAlt,
    required this.textOnPrimary,
    required this.textDisabled,
    required this.success,
    required this.warning,
    required this.error,
    required this.info,
    required this.live,
    required this.liveGold,
  });

  // ─── Dark Mode ──────────────────────────────────────────────────────────────

  static const dark = AppColorsExtension(
    primary: Color(0xFFBA007D),
    primaryLight: Color(0xFFED77C3),
    primaryMid: Color(0xFF9A295C),
    primaryDark: Color(0xFF7E0A57),
    background: Color(0xFF0A0A0A),
    backgroundDeep: Color(0xFF0D030B),
    surface: Color(0xFF141319),
    surfaceElevated: Color(0xFF1A1A1A),
    surfaceTag: Color(0xFF1D181C),
    border: Color(0xFF313131),
    borderFocus: Color(0xFFBA007D),
    textPrimary: Color(0xFFF5F5F5),
    textSecondary: Color(0xFF78787A),
    textTertiary: Color(0xFFA1A1A1),
    textMuted: Color(0xFF3E3D42),
    textMutedAlt: Color(0xFF3F3E43),
    textOnPrimary: Color(0xFFFFFFFF),
    textDisabled: Color(0xFF3E3D42),
    success: Color(0xFF22C55E),
    warning: Color(0xFFFFCE00),
    error: Color(0xFFEF4444),
    info: Color(0xFF3B82F6),
    live: Color(0xFFFFCE00),
    liveGold: Color(0xFFF7D378),
  );

  // ─── Light Mode ─────────────────────────────────────────────────────────────

  static const light = AppColorsExtension(
    primary: Color(0xFFBA007D),
    primaryLight: Color(0xFFFCE4F2),
    primaryMid: Color(0xFF9A295C),
    primaryDark: Color(0xFF7E0A57),
    background: Color(0xFFFAFAFA),
    backgroundDeep: Color(0xFFFFFFFF),
    surface: Color(0xFFFFFFFF),
    surfaceElevated: Color(0xFFF5F5F5),
    surfaceTag: Color(0xFFEEEEEE),
    border: Color(0xFFE0E0E0),
    borderFocus: Color(0xFFBA007D),
    textPrimary: Color(0xFF1A1A1A),
    textSecondary: Color(0xFF6B6B6B),
    textTertiary: Color(0xFF9E9E9E),
    textMuted: Color(0xFFBDBDBD),
    textMutedAlt: Color(0xFFC2C2C2),
    textOnPrimary: Color(0xFFFFFFFF),
    textDisabled: Color(0xFFBDBDBD),
    success: Color(0xFF16A34A),
    warning: Color(0xFFF59E0B),
    error: Color(0xFFDC2626),
    info: Color(0xFF2563EB),
    live: Color(0xFFF59E0B),
    liveGold: Color(0xFFD4A017),
  );

  @override
  AppColorsExtension copyWith({
    Color? primary,
    Color? primaryLight,
    Color? primaryMid,
    Color? primaryDark,
    Color? background,
    Color? backgroundDeep,
    Color? surface,
    Color? surfaceElevated,
    Color? surfaceTag,
    Color? border,
    Color? borderFocus,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? textMuted,
    Color? textMutedAlt,
    Color? textOnPrimary,
    Color? textDisabled,
    Color? success,
    Color? warning,
    Color? error,
    Color? info,
    Color? live,
    Color? liveGold,
  }) {
    return AppColorsExtension(
      primary: primary ?? this.primary,
      primaryLight: primaryLight ?? this.primaryLight,
      primaryMid: primaryMid ?? this.primaryMid,
      primaryDark: primaryDark ?? this.primaryDark,
      background: background ?? this.background,
      backgroundDeep: backgroundDeep ?? this.backgroundDeep,
      surface: surface ?? this.surface,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      surfaceTag: surfaceTag ?? this.surfaceTag,
      border: border ?? this.border,
      borderFocus: borderFocus ?? this.borderFocus,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      textMuted: textMuted ?? this.textMuted,
      textMutedAlt: textMutedAlt ?? this.textMutedAlt,
      textOnPrimary: textOnPrimary ?? this.textOnPrimary,
      textDisabled: textDisabled ?? this.textDisabled,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      error: error ?? this.error,
      info: info ?? this.info,
      live: live ?? this.live,
      liveGold: liveGold ?? this.liveGold,
    );
  }

  @override
  AppColorsExtension lerp(AppColorsExtension? other, double t) {
    if (other is! AppColorsExtension) return this;
    return AppColorsExtension(
      primary: Color.lerp(primary, other.primary, t)!,
      primaryLight: Color.lerp(primaryLight, other.primaryLight, t)!,
      primaryMid: Color.lerp(primaryMid, other.primaryMid, t)!,
      primaryDark: Color.lerp(primaryDark, other.primaryDark, t)!,
      background: Color.lerp(background, other.background, t)!,
      backgroundDeep: Color.lerp(backgroundDeep, other.backgroundDeep, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceElevated: Color.lerp(surfaceElevated, other.surfaceElevated, t)!,
      surfaceTag: Color.lerp(surfaceTag, other.surfaceTag, t)!,
      border: Color.lerp(border, other.border, t)!,
      borderFocus: Color.lerp(borderFocus, other.borderFocus, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      textMutedAlt: Color.lerp(textMutedAlt, other.textMutedAlt, t)!,
      textOnPrimary: Color.lerp(textOnPrimary, other.textOnPrimary, t)!,
      textDisabled: Color.lerp(textDisabled, other.textDisabled, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      error: Color.lerp(error, other.error, t)!,
      info: Color.lerp(info, other.info, t)!,
      live: Color.lerp(live, other.live, t)!,
      liveGold: Color.lerp(liveGold, other.liveGold, t)!,
    );
  }
}

extension AppColorsContext on BuildContext {
  AppColorsExtension get appColors =>
      Theme.of(this).extension<AppColorsExtension>() ?? AppColorsExtension.dark;
}

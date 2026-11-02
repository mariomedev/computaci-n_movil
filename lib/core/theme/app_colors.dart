import 'package:flutter/material.dart';

class _AppColorPrimitives {
  _AppColorPrimitives._();

  static const pink500 = Color(0xFFBA007D);
  static const pink400 = Color(0xFFED77C3);
  static const pink700 = Color(0xFF9A295C);
  static const pink900 = Color(0xFF7E0A57);

  static const neutral0 = Color(0xFF0D030B);
  static const neutral50 = Color(0xFF0A0A0A);
  static const neutral100 = Color(0xFF141319);
  static const neutral150 = Color(0xFF1A1A1A);
  static const neutral200 = Color(0xFF1D181C);
  static const neutral300 = Color(0xFF313131);
  static const neutral400 = Color(0xFF3E3D42);
  static const neutral450 = Color(0xFF3F3E43);
  static const neutral500 = Color(0xFF78787A);
  static const neutral600 = Color(0xFFA1A1A1);
  static const neutral900 = Color(0xFFF5F5F5);

  static const yellow = Color(0xFFFFCE00);
  static const gold = Color(0xFFF7D378);
}

class AppColors {
  AppColors._();

  static const primary = _AppColorPrimitives.pink500;
  static const primaryLight = _AppColorPrimitives.pink400;
  static const primaryMid = _AppColorPrimitives.pink700;
  static const primaryDark = _AppColorPrimitives.pink900;

  static const background = _AppColorPrimitives.neutral50;
  static const backgroundDeep = _AppColorPrimitives.neutral0;
  static const surface = _AppColorPrimitives.neutral100;
  static const surfaceElevated = _AppColorPrimitives.neutral150;
  static const surfaceTag = _AppColorPrimitives.neutral200;

  static const border = _AppColorPrimitives.neutral300;
  static const borderFocus = _AppColorPrimitives.pink500;

  static const textPrimary = _AppColorPrimitives.neutral900;
  static const textSecondary = _AppColorPrimitives.neutral500;
  static const textTertiary = _AppColorPrimitives.neutral600;
  static const textMuted = _AppColorPrimitives.neutral400;
  static const textMutedAlt = _AppColorPrimitives.neutral450;
  static const textOnPrimary = Color(0xFFFFFFFF);
  static const textDisabled = _AppColorPrimitives.neutral400;

  static const success = Color(0xFF22C55E);
  static const warning = _AppColorPrimitives.yellow;
  static const error = Color(0xFFEF4444);
  static const info = Color(0xFF3B82F6);
  static const live = _AppColorPrimitives.yellow;
  static const liveGold = _AppColorPrimitives.gold;

  static const vibeRomantico = _AppColorPrimitives.pink500;
  static const vibeRumba = _AppColorPrimitives.pink400;
  static const vibeChill = _AppColorPrimitives.pink700;
  static const vibeFoodie = _AppColorPrimitives.gold;
}

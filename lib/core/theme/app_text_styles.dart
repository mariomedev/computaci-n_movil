import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

class AppTextStyles {
  AppTextStyles._();

  static final _base = GoogleFonts.inter;

  static final TextStyle displayLg = _base(
    fontSize: 48,
    fontWeight: FontWeight.w700,
    height: 1.1,
  );
  static final TextStyle displayMd = _base(
    fontSize: 36,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );
  static final TextStyle displaySm = _base(
    fontSize: 30,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  static final TextStyle headingLg = _base(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );
  static final TextStyle headingMd = _base(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );
  static final TextStyle headingSm = _base(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static final TextStyle bodyLg = _base(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );
  static final TextStyle bodyMd = _base(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );
  static final TextStyle bodySm = _base(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static final TextStyle labelLg = _base(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );
  static final TextStyle labelMd = _base(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );
  static final TextStyle labelSm = _base(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  static final TextStyle caption = _base(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );
}

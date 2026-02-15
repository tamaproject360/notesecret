import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notesecret/app/theme/color_scheme.dart';

class AppTypography {
  // Headings (Note titles, Section headers)
  static TextStyle get headingLarge => GoogleFonts.lora(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.02,
        height: 1.2,
      );

  static TextStyle get headingMedium => GoogleFonts.lora(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.02,
        height: 1.2,
      );

  // Body (Note content, descriptions)
  static TextStyle get bodyLarge => GoogleFonts.merriweather(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        height: 1.6,
      );

  static TextStyle get bodyMedium => GoogleFonts.merriweather(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        height: 1.6,
      );

  // UI Labels (Tab bar, timestamps, tags, buttons)
  static TextStyle get labelLarge => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600, // SemiBold
        letterSpacing: 0.02,
      );

  static TextStyle get labelMedium => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500, // Medium
        letterSpacing: 0.02,
      );

  static TextStyle get labelSmall => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500, // Medium
        letterSpacing: 0.02,
      );

  // Editor Toolbar Icons Labels
  static TextStyle get toolbarLabel => GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.normal,
      );

  // Monospace (Markdown preview/code blocks)
  static TextStyle get monospace => GoogleFonts.robotoMono(
        fontSize: 14,
      );
}

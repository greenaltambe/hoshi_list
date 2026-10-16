import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class AppTheme {
  static const _seedColor = Colors.deepPurple;

  static ThemeData light([ColorScheme? dynamicScheme]) =>
      _build(Brightness.light, dynamicScheme);

  static ThemeData dark([ColorScheme? dynamicScheme]) =>
      _build(Brightness.dark, dynamicScheme);

  static ThemeData _build(Brightness brightness, ColorScheme? dynamicScheme) {
    final colorScheme =
        dynamicScheme ??
        ColorScheme.fromSeed(seedColor: _seedColor, brightness: brightness);
    final base = ThemeData(colorScheme: colorScheme, useMaterial3: true);
    return base.copyWith(
      textTheme: GoogleFonts.robotoTextTheme(base.textTheme),
    );
  }

  /// Derives a scheme from a device (Material You) accent colour.
  static ColorScheme fromAccent(ColorScheme source, Brightness brightness) =>
      ColorScheme.fromSeed(seedColor: source.primary, brightness: brightness);
}

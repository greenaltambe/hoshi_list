import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// If brightness is light, use light text theme, else use dark text theme
TextTheme buildTextTheme(Brightness brightness) {
  final baseTextTheme = brightness == Brightness.light
      ? ThemeData.light().textTheme
      : ThemeData.dark().textTheme;

  return GoogleFonts.notoSansTextTheme(baseTextTheme).copyWith(
    titleLarge: TextStyle(fontWeight: FontWeight.bold),
    titleMedium: TextStyle(fontWeight: FontWeight.w600),
    titleSmall: TextStyle(fontWeight: FontWeight.w500),
  ); // Using Noto Sans font and passing base text theme with current brightness
}

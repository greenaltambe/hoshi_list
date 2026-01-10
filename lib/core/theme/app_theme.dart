import 'package:flutter/material.dart';
import 'color_schemes.dart';
import 'text_theme.dart';

ThemeData buildAppTheme(
  Brightness brightness,
  ColorScheme? dynamicColorScheme,
) {
  final colorScheme =
      dynamicColorScheme ??
      (brightness == Brightness.light
          ? lightFallbackColorScheme
          : darkFallbackColorScheme);

  final textTheme = buildTextTheme(brightness);
  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    textTheme: textTheme,
  );
}

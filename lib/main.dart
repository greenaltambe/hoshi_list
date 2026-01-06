import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoshi_list/theme/app_theme.dart';
import 'package:hoshi_list/theme/color_schemes.dart';

final colorScheme = ColorScheme.fromSeed(seedColor: Colors.deepPurple);
final textTheme = GoogleFonts.notoSansTextTheme();

final theme = ThemeData(colorScheme: colorScheme, textTheme: textTheme);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        final lightTheme = lightDynamic ?? lightFallbackColorScheme;
        final darkTheme = darkDynamic ?? darkFallbackColorScheme;

        return MaterialApp(
          theme: buildAppTheme(
            Brightness.light,
            lightTheme,
          ), // buolds the light theme from app_theme.dart
          darkTheme: buildAppTheme(
            Brightness.dark,
            darkTheme,
          ), // builds the dark theme from app_theme.dart
          themeMode: ThemeMode.system,
          home: const Scaffold(body: Center(child: Text('Hello, Hoshi List!'))),
        );
      },
    );
  }
}

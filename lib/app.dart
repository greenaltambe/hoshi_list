import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:hoshi_list/core/theme/app_theme.dart';
import 'package:hoshi_list/core/theme/color_schemes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoshi_list/features/navigation/tabs_screen.dart';

final colorScheme = ColorScheme.fromSeed(seedColor: Colors.deepPurple);
final textTheme = GoogleFonts.notoSansTextTheme();

final theme = ThemeData(colorScheme: colorScheme, textTheme: textTheme);

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        if (lightDynamic != null && darkDynamic != null) {
          lightDynamic = ColorScheme.fromSeed(
            seedColor: Color(lightDynamic.primary.toARGB32()),
            brightness: Brightness.light,
          );
          darkDynamic = ColorScheme.fromSeed(
            seedColor: Color(darkDynamic.primary.toARGB32()),
            brightness: Brightness.dark,
          );
        }
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
          home: const TabsScreen(),
        );
      },
    );
  }
}

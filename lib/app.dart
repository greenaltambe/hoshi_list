import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hoshi_list/core/theme/app_theme.dart';
import 'package:hoshi_list/core/theme/color_schemes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoshi_list/features/auth/login_screen.dart';
import 'package:hoshi_list/features/navigation/tabs_screen.dart';
import 'package:hoshi_list/services/anilist/auth/auth_provider.dart';

final colorScheme = ColorScheme.fromSeed(seedColor: Colors.deepPurple);
final textTheme = GoogleFonts.notoSansTextTheme();

final theme = ThemeData(colorScheme: colorScheme, textTheme: textTheme);

class App extends ConsumerWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authTokenProvider); // get token

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
          home: authState.when(
            data: (data) {
              if (data != null) {
                return TabsScreen();
              } else {
                return const LoginScreen();
              }
            },
            error: (err, stack) => Center(
              child: Column(
                children: [
                  Text(
                    'Error while loading, $err',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
              ),
            ),
            loading: () => const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          ),
        );
      },
    );
  }
}

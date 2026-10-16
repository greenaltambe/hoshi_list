import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hoshi_list/core/auth/auth_controller.dart';
import 'package:hoshi_list/core/theme/app_theme.dart';
import 'package:hoshi_list/core/widgets/async_value_view.dart';
import 'package:hoshi_list/features/auth/presentation/login_screen.dart';
import 'package:hoshi_list/features/shell/presentation/app_shell.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authControllerProvider);

    return DynamicColorBuilder(
      builder: (light, dark) => MaterialApp(
        title: 'HoshiList',
        theme: AppTheme.light(
          light == null ? null : AppTheme.fromAccent(light, Brightness.light),
        ),
        darkTheme: AppTheme.dark(
          dark == null ? null : AppTheme.fromAccent(dark, Brightness.dark),
        ),
        home: auth.when(
          loading: () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
          error: (error, _) => Scaffold(body: ErrorView(error: error)),
          data: (token) =>
              token == null ? const LoginScreen() : const AppShell(),
        ),
      ),
    );
  }
}

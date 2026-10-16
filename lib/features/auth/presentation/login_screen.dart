import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hoshi_list/core/auth/auth_controller.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.star_outline_rounded,
              size: 80,
              color: Colors.orange,
            ),
            const SizedBox(height: 20),
            Text(
              'Welcome to HoshiList',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            FilledButton.icon(
              onPressed: ref.read(authControllerProvider.notifier).login,
              icon: const Icon(Icons.login),
              label: const Text('Login with AniList'),
            ),
          ],
        ),
      ),
    );
  }
}

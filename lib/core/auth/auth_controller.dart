import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hoshi_list/core/auth/auth_repository.dart';

/// Holds the current access token: `null` means logged out.
class AuthController extends AsyncNotifier<String?> {
  @override
  Future<String?> build() async {
    final repository = ref.watch(authRepositoryProvider);

    final subscription = repository.redirectedTokens().listen((token) async {
      await repository.saveToken(token);
      if (ref.mounted) state = AsyncData(token);
    });
    ref.onDispose(subscription.cancel);

    return repository.readToken();
  }

  Future<void> login() => ref.read(authRepositoryProvider).openLogin();

  Future<void> logout() async {
    await ref.read(authRepositoryProvider).clearToken();
    if (ref.mounted) state = const AsyncData(null);
  }
}

final authControllerProvider = AsyncNotifierProvider<AuthController, String?>(
  AuthController.new,
);

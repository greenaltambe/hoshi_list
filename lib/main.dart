import 'package:flutter/material.dart';
import 'package:hoshi_list/app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hoshi_list/services/anilist/auth/auth_provider.dart';
import 'package:hoshi_list/services/anilist/auth/auth_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final authService = AuthService();
  authService.initDeepLinkListener();

  runApp(
    ProviderScope(
      overrides: [authServiceProvider.overrideWithValue(authService)],
      child: App(),
    ),
  );
}

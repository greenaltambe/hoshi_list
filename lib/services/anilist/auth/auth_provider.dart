import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hoshi_list/services/anilist/auth/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  throw UnimplementedError();
});

final authTokenProvider = StreamProvider<String?>((ref) async* {
  final authService = ref.watch(authServiceProvider);

  final storedToken = await authService.getToken();
  yield storedToken;

  yield* authService.authStateChanges;
});

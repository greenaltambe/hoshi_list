import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hoshi_list/services/anilist/anilist_client.dart';
import 'package:hoshi_list/services/anilist/auth/auth_provider.dart';

/// Provides an instance of AnilistClient with the current auth token.
/// If no token is available, it provides an unauthenticated client.
final anilistProvider = Provider<AnilistClient>((ref) {
  final tokenAsync = ref.watch(authTokenProvider);

  return tokenAsync.maybeWhen(
    data: (token) => AnilistClient(token),
    orElse: () => AnilistClient(null),
  );
});

import 'package:app_links/app_links.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hoshi_list/core/config/app_config.dart';
import 'package:url_launcher/url_launcher.dart';

/// Talks to the platform: secure storage, the browser and deep links.
class AuthRepository {
  AuthRepository({FlutterSecureStorage? storage, AppLinks? appLinks})
    : _storage = storage ?? const FlutterSecureStorage(),
      _appLinks = appLinks ?? AppLinks();

  final FlutterSecureStorage _storage;
  final AppLinks _appLinks;

  Future<String?> readToken() => _storage.read(key: AppConfig.tokenStorageKey);

  Future<void> saveToken(String token) =>
      _storage.write(key: AppConfig.tokenStorageKey, value: token);

  Future<void> clearToken() => _storage.delete(key: AppConfig.tokenStorageKey);

  /// Opens AniList's authorize page in the browser. The result arrives later
  /// through [redirectedTokens].
  Future<void> openLogin() {
    final uri = Uri.https(
      AppConfig.anilistAuthorizeHost,
      AppConfig.anilistAuthorizePath,
      {'client_id': AppConfig.anilistClientId, 'response_type': 'token'},
    );
    return launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  /// Access tokens delivered by `hoshilist://auth#access_token=...` links.
  Stream<String> redirectedTokens() async* {
    await for (final uri in _appLinks.uriLinkStream) {
      if (uri.scheme != AppConfig.redirectScheme ||
          uri.host != AppConfig.redirectHost) {
        continue;
      }
      final token = Uri.splitQueryString(uri.fragment)['access_token'];
      if (token != null && token.isNotEmpty) yield token;
    }
  }
}

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(),
);

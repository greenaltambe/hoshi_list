/// Compile-time configuration. Override with `--dart-define=NAME=value`.
abstract final class AppConfig {
  static const anilistGraphqlUrl = 'https://graphql.anilist.co';
  static const anilistAuthorizeHost = 'anilist.co';
  static const anilistAuthorizePath = '/api/v2/oauth/authorize';

  /// Public OAuth client id (implicit grant, so there is no secret).
  static const anilistClientId = String.fromEnvironment(
    'ANILIST_CLIENT_ID',
    defaultValue: '34559',
  );

  /// Must match the intent filter / URL scheme registered in the platform
  /// projects and the redirect URL configured on the AniList developer page.
  static const redirectScheme = 'hoshilist';
  static const redirectHost = 'auth';

  static const tokenStorageKey = 'anilist_access_token';

  static const requestTimeout = Duration(seconds: 20);
}

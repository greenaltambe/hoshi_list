import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthService {
  final String _clientId = '34559';
  final String _redirectHost = 'auth';
  final String _redirectScheme = 'hoshilist';

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final AppLinks _appLinks = AppLinks();

  // Stream controller to manage authentication state changes
  // StreamController is used as we need to broadcast changes to multiple listeners
  final _authStateController =
      StreamController<
        String?
      >.broadcast(); // notifies the ui about auth state changes
  Stream<String?> get authStateChanges =>
      _authStateController.stream; // expose the stream

  // Opens the browser for login
  Future<void> login() async {
    // Let Dart build the URL properly
    final authUrl = Uri.https('anilist.co', '/api/v2/oauth/authorize', {
      'client_id': _clientId,
      'response_type': 'token',
    });

    // Verify the output in your debug console

    await launchUrl(authUrl, mode: LaunchMode.externalApplication);
  }

  void initDeepLinkListener() {
    _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null &&
          uri.scheme == _redirectScheme &&
          uri.host == _redirectHost) {
        _handleAuthRedirect(uri);
      }
    });
  }

  Future<void> _handleAuthRedirect(Uri uri) async {
    // Obtain the access token
    final fragment = uri.fragment;
    final params = Uri.splitQueryString(fragment);
    final accessToken = params['access_token'];
    print('Access Token: $accessToken');
    print('Access token length: ${accessToken?.length}');

    // save access token in storagge securely
    if (accessToken != null) {
      await _secureStorage.write(
        key: 'anilist_access_token',
        value: accessToken,
      );
      _authStateController.add(accessToken);
    }
  }

  Future<String?> getToken() async {
    final token = await _secureStorage.read(key: 'anilist_access_token');

    if (token != null) {
      print('--- START FULL TOKEN ---');
      printFullText(token);
      print('--- END FULL TOKEN ---');
      print('Token length: ${token.length}');
    }

    return token;
  }

  void printFullText(String text) {
    final pattern = RegExp('.{1,800}'); // 800 is size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  Future<void> logout() async {
    await _secureStorage.delete(key: 'anilist_access_token');
    _authStateController.add(null);
  }
}

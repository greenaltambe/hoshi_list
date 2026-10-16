import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hoshi_list/core/auth/auth_controller.dart';
import 'package:hoshi_list/core/config/app_config.dart';
import 'package:hoshi_list/core/error/app_exception.dart';
import 'package:hoshi_list/core/utils/json.dart';
import 'package:http/http.dart' as http;

/// Thin GraphQL transport for AniList. It knows nothing about the app's
/// models: it sends a document and returns the `data` object, or throws an
/// [AppException].
class AnilistClient {
  AnilistClient({
    required http.Client httpClient,
    required String? Function() readToken,
    void Function()? onUnauthorized,
    Uri? endpoint,
    Duration timeout = AppConfig.requestTimeout,
  }) : _http = httpClient,
       _readToken = readToken,
       _onUnauthorized = onUnauthorized,
       _endpoint = endpoint ?? Uri.parse(AppConfig.anilistGraphqlUrl),
       _timeout = timeout;

  final http.Client _http;
  final String? Function() _readToken;
  final void Function()? _onUnauthorized;
  final Uri _endpoint;
  final Duration _timeout;

  Future<Json> query(String document, [Json variables = const {}]) async {
    final token = _readToken();

    final http.Response response;
    try {
      response = await _http
          .post(
            _endpoint,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              if (token != null) 'Authorization': 'Bearer $token',
            },
            body: jsonEncode({'query': document, 'variables': variables}),
          )
          .timeout(_timeout);
    } on TimeoutException {
      throw const NetworkException('AniList took too long to respond.');
    } on http.ClientException {
      throw const NetworkException();
    }

    final body = _decode(response.body);
    final errors = body?['errors'];
    final firstError = errors is List && errors.isNotEmpty
        ? errors.first as Object?
        : null;

    if (response.statusCode == 401) {
      // Only a rejected *token* means the session is dead.
      if (token != null) _onUnauthorized?.call();
      throw const UnauthorizedException();
    }

    if (firstError != null || response.statusCode >= 400) {
      final message = firstError is Map ? firstError['message'] : null;
      throw ApiException(
        message is String ? message : 'AniList request failed.',
        statusCode: response.statusCode,
      );
    }

    final data = body?['data'];
    if (data is! Map<String, dynamic>) throw const ParsingException();
    return data;
  }

  Json? _decode(String body) {
    try {
      final decoded = jsonDecode(body);
      return decoded is Map<String, dynamic> ? decoded : null;
    } on FormatException {
      return null;
    }
  }
}

final httpClientProvider = Provider<http.Client>((ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  return client;
});

final anilistClientProvider = Provider<AnilistClient>((ref) {
  return AnilistClient(
    httpClient: ref.watch(httpClientProvider),
    // Read lazily so public requests don't re-run when the user logs in/out.
    readToken: () => ref.read(authControllerProvider).value,
    onUnauthorized: () => ref.read(authControllerProvider.notifier).logout(),
  );
});

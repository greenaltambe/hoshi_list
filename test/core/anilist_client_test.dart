import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:hoshi_list/core/error/app_exception.dart';
import 'package:hoshi_list/core/network/anilist_client.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

AnilistClient clientFor(
  MockClientHandler handler, {
  String? token,
  void Function()? onUnauthorized,
}) {
  return AnilistClient(
    httpClient: MockClient(handler),
    readToken: () => token,
    onUnauthorized: onUnauthorized,
  );
}

http.Response json(Object body, [int status = 200]) =>
    http.Response(jsonEncode(body), status);

void main() {
  test('returns the data object and sends the bearer token', () async {
    late http.Request sent;
    final client = clientFor((request) async {
      sent = request;
      return json({
        'data': {'ok': true},
      });
    }, token: 'abc');

    final data = await client.query('query { ok }', {'a': 1});

    expect(data, {'ok': true});
    expect(sent.headers['Authorization'], 'Bearer abc');
    expect(jsonDecode(sent.body), {
      'query': 'query { ok }',
      'variables': {'a': 1},
    });
  });

  test('does not send an Authorization header when logged out', () async {
    late http.Request sent;
    final client = clientFor((request) async {
      sent = request;
      return json({'data': <String, dynamic>{}});
    });

    await client.query('query { ok }');

    expect(sent.headers.containsKey('Authorization'), isFalse);
  });

  test('GraphQL errors become ApiException with AniList message', () async {
    final client = clientFor(
      (_) async => json({
        'errors': [
          {'message': 'Not Found.', 'status': 404},
        ],
        'data': null,
      }, 404),
    );

    await expectLater(
      client.query('q'),
      throwsA(
        isA<ApiException>()
            .having((e) => e.message, 'message', 'Not Found.')
            .having((e) => e.statusCode, 'statusCode', 404),
      ),
    );
  });

  test('401 with a token reports the session as expired', () async {
    var loggedOut = false;
    final client = clientFor(
      (_) async => json({
        'errors': [
          {'message': 'Invalid token'},
        ],
      }, 401),
      token: 'stale',
      onUnauthorized: () => loggedOut = true,
    );

    await expectLater(client.query('q'), throwsA(isA<UnauthorizedException>()));
    expect(loggedOut, isTrue);
  });

  test('network failures become NetworkException', () async {
    final client = clientFor((_) async => throw http.ClientException('boom'));

    await expectLater(client.query('q'), throwsA(isA<NetworkException>()));
  });

  test('a non-JSON body is an error, not a crash', () async {
    final client = clientFor((_) async => http.Response('<html>', 502));

    await expectLater(client.query('q'), throwsA(isA<ApiException>()));
  });
}

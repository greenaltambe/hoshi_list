import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hoshi_list/app/app.dart';
import 'package:hoshi_list/core/auth/auth_repository.dart';
import 'package:hoshi_list/core/network/anilist_client.dart';
import 'package:hoshi_list/features/home/presentation/home_providers.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import '../helpers/fakes.dart';

/// One canned response containing every root field the shell's screens ask
/// for, all empty, so no network images are involved.
final _emptyAniList = jsonEncode({
  'data': {
    'Viewer': {
      'id': 1,
      'name': 'Tester',
      'about': null,
      'avatar': {'large': 'https://example.invalid/a.png'},
    },
    'Page': {
      'pageInfo': {'hasNextPage': false},
      'media': <Object>[],
    },
    'MediaListCollection': {'lists': <Object>[]},
  },
});

void main() {
  testWidgets('logged-in shell renders every tab and navigates', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(
            FakeAuthRepository(token: 'token'),
          ),
          // The placeholder feed points at remote images.
          activityProvider.overrideWith((ref, feed) => []),
          anilistClientProvider.overrideWithValue(
            AnilistClient(
              httpClient: MockClient(
                (_) async => http.Response(_emptyAniList, 200),
              ),
              readToken: () => 'token',
            ),
          ),
        ],
        child: const App(),
      ),
    );
    await tester.pumpAndSettle();

    // Home
    expect(find.text('Anime in progress'), findsOneWidget);

    await tester.tap(find.text('Browse'));
    await tester.pumpAndSettle();
    expect(find.text('Trending Anime'), findsOneWidget);

    await tester.tap(find.text('List'));
    await tester.pumpAndSettle();
    expect(
      find.text('Your list is empty. Start adding some media!'),
      findsOneWidget,
    );

    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();
    expect(find.text('Search for something to watch or read.'), findsOneWidget);
  });
}

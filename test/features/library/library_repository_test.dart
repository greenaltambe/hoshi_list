import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:hoshi_list/core/network/anilist_client.dart';
import 'package:hoshi_list/features/library/data/library_repository.dart';
import 'package:hoshi_list/features/library/domain/library_models.dart';
import 'package:hoshi_list/features/library/domain/media_list_status.dart';
import 'package:hoshi_list/features/library/presentation/widgets/library_entry_card.dart';
import 'package:hoshi_list/features/media/domain/media_enums.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

LibraryRepository repositoryFor(
  Object body, {
  void Function(Map<String, dynamic> variables)? onRequest,
}) {
  return LibraryRepository(
    AnilistClient(
      httpClient: MockClient((request) async {
        onRequest?.call(
          (jsonDecode(request.body) as Map<String, dynamic>)['variables']
              as Map<String, dynamic>,
        );
        return http.Response(jsonEncode(body), 200);
      }),
      readToken: () => 'token',
    ),
  );
}

void main() {
  test('an entry that is not on the list maps to null', () async {
    final repo = repositoryFor({
      'data': {
        'Media': {'mediaListEntry': null},
      },
    });

    expect(await repo.entry(1), isNull);
  });

  test('maps an existing entry including partial dates', () async {
    final repo = repositoryFor({
      'data': {
        'Media': {
          'mediaListEntry': {
            'mediaId': 1,
            'status': 'CURRENT',
            'progress': 4,
            'score': 85,
            'repeat': 0,
            'notes': 'hi',
            'startedAt': {'year': 2024, 'month': 5, 'day': 6},
            'completedAt': {'year': null, 'month': null, 'day': null},
          },
        },
      },
    });

    final entry = (await repo.entry(1))!;

    expect(entry.status, MediaListStatus.current);
    expect(entry.score, 85);
    expect(entry.startedAt, DateTime(2024, 5, 6));
    expect(entry.completedAt, isNull);
  });

  test('save sends every field so cleared values are cleared', () async {
    late Map<String, dynamic> sent;
    final repo = repositoryFor({
      'data': {
        'SaveMediaListEntry': {'id': 1},
      },
    }, onRequest: (v) => sent = v);

    await repo.save(
      const MediaListEntryInput(
        mediaId: 9,
        status: MediaListStatus.completed,
        progress: 12,
      ),
    );

    expect(sent['status'], 'COMPLETED');
    expect(sent['progress'], 12);
    expect(sent['scoreRaw'], 0);
    expect(sent['notes'], '');
    expect(sent['startedAt'], {'year': null, 'month': null, 'day': null});
  });

  test('collection maps groups and entries', () {
    final groups = LibraryRepository.mapCollection({
      'MediaListCollection': {
        'lists': [
          {
            'name': 'Watching',
            'isCustomList': false,
            'status': 'CURRENT',
            'entries': [
              {
                'id': 1,
                'score': 90.0,
                'progress': 3,
                'media': {
                  'id': 2,
                  'type': 'ANIME',
                  'averageScore': null,
                  'title': {'romaji': 'R', 'english': null},
                  'coverImage': {'large': 'c'},
                  'genres': <String>[],
                },
              },
            ],
          },
        ],
      },
    });

    expect(groups.single.status, MediaListStatus.current);
    expect(groups.single.entries.single.score, 90);
    expect(groups.single.entries.single.media.averageScore, 0);
  });

  group('status labels', () {
    test('depend on the media type', () {
      expect(MediaListStatus.current.label(MediaType.anime), 'Watching');
      expect(MediaListStatus.current.label(MediaType.manga), 'Reading');
      expect(MediaListStatus.completed.label(MediaType.manga), 'Completed');
    });
  });

  group('progress bar fraction', () {
    test('uses the real total when known and never exceeds 1', () {
      expect(LibraryEntryCard.progressFraction(6, 12), 0.5);
      expect(LibraryEntryCard.progressFraction(20, 12), 1);
    });

    test('stays below 85% for ongoing series with unknown total', () {
      expect(LibraryEntryCard.progressFraction(0, null), 0);
      expect(LibraryEntryCard.progressFraction(10000, null), 0.85);
    });
  });
}

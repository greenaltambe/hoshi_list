import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:hoshi_list/core/error/app_exception.dart';
import 'package:hoshi_list/core/network/anilist_client.dart';
import 'package:hoshi_list/features/media/data/media_repository.dart';
import 'package:hoshi_list/features/media/domain/media_browse_query.dart';
import 'package:hoshi_list/features/media/domain/media_enums.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

MediaRepository repositoryReturning(Object body) {
  return MediaRepository(
    AnilistClient(
      httpClient: MockClient((_) async => http.Response(jsonEncode(body), 200)),
      readToken: () => null,
    ),
  );
}

Map<String, dynamic> mediaJson({int id = 1, String? english = 'English'}) => {
  'id': id,
  'type': 'ANIME',
  'averageScore': 85,
  'bannerImage': null,
  'description': 'desc',
  'genres': ['Action', 'Sci-Fi', 'Not A Real Genre'],
  'episodes': 12,
  'chapters': null,
  'title': {'romaji': 'Romaji', 'english': english, 'native': 'Native'},
  'coverImage': {'large': 'https://img/$id.jpg'},
};

void main() {
  group('browse', () {
    test('maps a page of media and pageInfo', () async {
      final repo = repositoryReturning({
        'data': {
          'Page': {
            'pageInfo': {'hasNextPage': true},
            'media': [mediaJson(), mediaJson(id: 2, english: null)],
          },
        },
      });

      final page = await repo.browse(
        const MediaBrowseQuery(type: MediaType.anime),
        1,
      );

      expect(page.hasNextPage, isTrue);
      expect(page.items.map((m) => m.title), ['English', 'Romaji']);
      expect(page.items.first.type, MediaType.anime);
      expect(page.items.first.genres, [Genre.action, Genre.sciFi, Genre.other]);
      expect(page.items.first.totalUnits, 12);
    });

    test('malformed payloads surface as ParsingException', () async {
      final repo = repositoryReturning({
        'data': {
          'Page': {'media': 'nope'},
        },
      });

      await expectLater(
        repo.browse(const MediaBrowseQuery(type: MediaType.anime), 1),
        throwsA(isA<ParsingException>()),
      );
    });

    test('variables use real AniList enum values and keep filters', () {
      final vars = MediaRepository.browseVariables(
        MediaBrowseQuery(
          type: MediaType.manga,
          sort: MediaSort.favouritesDesc,
          searchText: 'berserk',
          filters: MediaFilters(
            format: MediaFormat.oneShot,
            status: MediaStatus.notYetReleased,
            minimumReleaseDate: DateTime(2020, 3, 5),
          ),
        ),
        3,
      );

      expect(vars, {
        'page': 3,
        'perPage': 10,
        'type': 'MANGA',
        'sort': ['FAVOURITES_DESC'],
        'search': 'berserk',
        'format': 'ONE_SHOT',
        'status': 'NOT_YET_RELEASED',
        'minimumReleaseDate': 20200305,
      });
    });
  });

  group('recommendations', () {
    test('skips recommendations whose media was deleted', () async {
      final repo = repositoryReturning({
        'data': {
          'Media': {
            'recommendations': {
              'pageInfo': {'hasNextPage': false},
              'nodes': [
                {'mediaRecommendation': mediaJson()},
                {'mediaRecommendation': null},
              ],
            },
          },
        },
      });

      final page = await repo.recommendations(1, 1);

      expect(page.items, hasLength(1));
      expect(page.hasNextPage, isFalse);
    });
  });

  group('details', () {
    test('maps enums, partial dates and external links', () async {
      final repo = repositoryReturning({
        'data': {
          'Media': {
            'id': 7,
            'type': 'MANGA',
            'title': {'romaji': 'R', 'english': null, 'native': null},
            'coverImage': {'large': 'c'},
            'bannerImage': null,
            'description': null,
            'format': 'ONE_SHOT',
            'status': 'NOT_YET_RELEASED',
            'startDate': {'year': 2021, 'month': null, 'day': null},
            'episodes': null,
            'chapters': 1,
            'averageScore': null,
            'genres': [],
            'season': 'FALL',
            'favourites': 3,
            'externalLinks': [
              {'url': 'u', 'site': 's', 'icon': null, 'color': '#ff0000'},
            ],
          },
        },
      });

      final media = await repo.details(7);

      expect(media.type, MediaType.manga);
      expect(media.format, MediaFormat.oneShot);
      expect(media.status, MediaStatus.notYetReleased);
      expect(media.startDate, DateTime(2021));
      expect(media.season, MediaSeason.fall);
      expect(media.description, '');
      expect(media.totalUnits, 1);
      expect(media.externalLinks.single.colorHex, '#ff0000');
    });
  });

  group('people and reviews', () {
    test('character edges get a capitalised role', () async {
      final repo = repositoryReturning({
        'data': {
          'Media': {
            'characters': {
              'pageInfo': {'hasNextPage': true},
              'edges': [
                {
                  'role': 'MAIN',
                  'node': {
                    'id': 1,
                    'name': {'full': 'Luffy'},
                    'image': {'medium': 'm'},
                  },
                },
              ],
            },
          },
        },
      });

      final page = await repo.characters(1, 1);

      expect(page.items.single.name, 'Luffy');
      expect(page.items.single.role, 'Main');
    });

    test('reviews map their author', () async {
      final repo = repositoryReturning({
        'data': {
          'Media': {
            'reviews': {
              'pageInfo': {'hasNextPage': false},
              'nodes': [
                {
                  'id': 5,
                  'body': 'b',
                  'summary': 's',
                  'score': 90,
                  'rating': 4,
                  'user': {
                    'id': 2,
                    'name': 'Ann',
                    'avatar': {'medium': 'a'},
                  },
                },
              ],
            },
          },
        },
      });

      final page = await repo.reviews(1, 1);

      expect(page.items.single.author.name, 'Ann');
      expect(page.items.single.score, 90);
    });
  });
}

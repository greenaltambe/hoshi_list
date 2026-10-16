import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hoshi_list/core/network/anilist_client.dart';
import 'package:hoshi_list/core/pagination/paged.dart';
import 'package:hoshi_list/core/utils/json.dart';
import 'package:hoshi_list/features/media/data/media_mappers.dart';
import 'package:hoshi_list/features/media/data/media_queries.dart';
import 'package:hoshi_list/features/media/domain/media.dart';
import 'package:hoshi_list/features/media/domain/media_browse_query.dart';
import 'package:hoshi_list/features/media/domain/media_person.dart';
import 'package:hoshi_list/features/media/domain/media_review.dart';

class MediaRepository {
  const MediaRepository(this._client);

  final AnilistClient _client;

  static const pageSize = 10;

  Future<PageResult<MediaSummary>> browse(
    MediaBrowseQuery query,
    int page,
  ) async {
    final data = await _client.query(
      mediaPageQuery,
      browseVariables(query, page),
    );
    return guardParse(() {
      final result = data['Page'] as Json;
      return PageResult(
        items: [
          for (final media in (result['media'] as List<dynamic>).cast<Json>())
            mapMediaSummary(media),
        ],
        hasNextPage: result['pageInfo']['hasNextPage'] as bool,
      );
    });
  }

  Future<MediaDetails> details(int mediaId) async {
    final data = await _client.query(mediaDetailsQuery, {'id': mediaId});
    return guardParse(() => mapMediaDetails(data['Media'] as Json));
  }

  Future<List<MediaRelation>> relations(int mediaId) async {
    final data = await _client.query(mediaRelationsQuery, {'mediaId': mediaId});
    return guardParse(() => mapMediaRelations(data));
  }

  Future<PageResult<MediaSummary>> recommendations(
    int mediaId,
    int page,
  ) async {
    final data = await _client.query(mediaRecommendationsQuery, {
      'mediaId': mediaId,
      'page': page,
      'perPage': pageSize,
    });
    return guardParse(() {
      final connection = data['Media']['recommendations'] as Json;
      return PageResult(
        items: [
          for (final node
              in (connection['nodes'] as List<dynamic>).cast<Json>())
            // A recommended media can have been deleted since.
            if (node['mediaRecommendation'] != null)
              mapMediaSummary(node['mediaRecommendation'] as Json),
        ],
        hasNextPage: connection['pageInfo']['hasNextPage'] as bool,
      );
    });
  }

  Future<PageResult<MediaPerson>> characters(
    int mediaId,
    int page, {
    PersonSort sort = PersonSort.role,
  }) => _people(mediaCharactersQuery, 'characters', mediaId, page, sort);

  Future<PageResult<MediaPerson>> staff(
    int mediaId,
    int page, {
    PersonSort sort = PersonSort.relevance,
  }) => _people(mediaStaffQuery, 'staff', mediaId, page, sort);

  Future<MediaPerson> characterDetails(int id) async {
    final data = await _client.query(characterDetailsQuery, {'id': id});
    return guardParse(() => mapPersonDetails(data['Character'] as Json));
  }

  Future<MediaPerson> staffDetails(int id) async {
    final data = await _client.query(staffDetailsQuery, {'id': id});
    return guardParse(() => mapPersonDetails(data['Staff'] as Json));
  }

  Future<PageResult<MediaReview>> reviews(
    int mediaId,
    int page, {
    ReviewSort sort = ReviewSort.ratingDesc,
  }) async {
    final data = await _client.query(mediaReviewsQuery, {
      'mediaId': mediaId,
      'page': page,
      'perPage': pageSize,
      'sort': [sort.apiValue],
    });
    return guardParse(() {
      final connection = data['Media']['reviews'] as Json;
      return PageResult(
        items: mapReviews(connection['nodes'] as List<dynamic>),
        hasNextPage: connection['pageInfo']['hasNextPage'] as bool,
      );
    });
  }

  Future<PageResult<MediaPerson>> _people(
    String document,
    String field,
    int mediaId,
    int page,
    PersonSort sort,
  ) async {
    final data = await _client.query(document, {
      'mediaId': mediaId,
      'page': page,
      'perPage': pageSize,
      'sort': [sort.apiValue],
    });
    return guardParse(() {
      final connection = data['Media'][field] as Json;
      return PageResult(
        items: mapPersonEdges(connection['edges'] as List<dynamic>),
        hasNextPage: connection['pageInfo']['hasNextPage'] as bool,
      );
    });
  }

  /// GraphQL variables for a browse request. Exposed for testing.
  static Json browseVariables(MediaBrowseQuery query, int page) {
    final f = query.filters;
    return {
      'page': page,
      'perPage': pageSize,
      'type': query.type.apiValue,
      'sort': [query.sort.apiValue],
      if (query.searchText.isNotEmpty) 'search': query.searchText,
      if (f.format != null) 'format': f.format!.apiValue,
      if (f.status != null) 'status': f.status!.apiValue,
      if (f.countryOfOrigin != null)
        'countryOfOrigin': f.countryOfOrigin!.apiValue,
      if (f.season != null) 'season': f.season!.apiValue,
      if (f.minimumReleaseDate != null)
        'minimumReleaseDate': dateToFuzzyInt(f.minimumReleaseDate!),
      if (f.maximumReleaseDate != null)
        'maximumReleaseDate': dateToFuzzyInt(f.maximumReleaseDate!),
      if (f.minimumEpisodes != null) 'minimumEpisodes': f.minimumEpisodes,
      if (f.maximumEpisodes != null) 'maximumEpisodes': f.maximumEpisodes,
      if (f.minimumChapters != null) 'minimumChapters': f.minimumChapters,
      if (f.maximumChapters != null) 'maximumChapters': f.maximumChapters,
      if (f.minimumAverageScore != null)
        'minimumAverageScore': f.minimumAverageScore,
      if (f.maximumAverageScore != null)
        'maximumAverageScore': f.maximumAverageScore,
    };
  }
}

final mediaRepositoryProvider = Provider<MediaRepository>(
  (ref) => MediaRepository(ref.watch(anilistClientProvider)),
);

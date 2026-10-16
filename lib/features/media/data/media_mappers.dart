import 'package:hoshi_list/core/utils/json.dart';
import 'package:hoshi_list/features/media/domain/media.dart';
import 'package:hoshi_list/features/media/domain/media_enums.dart';
import 'package:hoshi_list/features/media/domain/media_person.dart';
import 'package:hoshi_list/features/media/domain/media_review.dart';
import 'package:hoshi_list/features/profile/domain/user.dart';

/// Pure functions from AniList JSON to domain models. They throw the usual
/// cast errors on malformed input; callers wrap them in `guardParse`.

MediaSummary mapMediaSummary(Json json) {
  final title = json['title'] as Json;
  return MediaSummary(
    id: json['id'] as int,
    type: MediaType.fromApi(json['type'] as String?),
    title:
        title['english'] as String? ?? title['romaji'] as String? ?? 'No Title',
    coverImageUrl: (json['coverImage'] as Json)['large'] as String,
    averageScore: json['averageScore'] as int? ?? 0,
    bannerImageUrl: json['bannerImage'] as String?,
    description: json['description'] as String?,
    genres: _genres(json['genres']),
    episodes: json['episodes'] as int?,
    chapters: json['chapters'] as int?,
  );
}

MediaDetails mapMediaDetails(Json json) {
  final title = json['title'] as Json;
  final links = json['externalLinks'] as List<dynamic>? ?? const [];
  return MediaDetails(
    id: json['id'] as int,
    type: MediaType.fromApi(json['type'] as String?) ?? MediaType.anime,
    romajiTitle: title['romaji'] as String,
    englishTitle: title['english'] as String?,
    nativeTitle: title['native'] as String?,
    coverImageUrl: (json['coverImage'] as Json)['large'] as String,
    bannerImageUrl: json['bannerImage'] as String?,
    description: json['description'] as String? ?? '',
    format: MediaFormat.fromApi(json['format'] as String?),
    status: MediaStatus.fromApi(json['status'] as String?),
    startDate: dateFromJson(json['startDate'] as Json?),
    episodes: json['episodes'] as int?,
    chapters: json['chapters'] as int?,
    averageScore: json['averageScore'] as int?,
    season: MediaSeason.fromApi(json['season'] as String?),
    favourites: json['favourites'] as int?,
    genres: _genres(json['genres']),
    externalLinks: [
      for (final link in links.cast<Json>())
        ExternalLink(
          url: link['url'] as String,
          siteName: link['site'] as String,
          iconUrl: link['icon'] as String?,
          colorHex: link['color'] as String?,
        ),
    ],
  );
}

List<MediaRelation> mapMediaRelations(Json data) {
  final edges = (data['Media'] as Json)['relations']['edges'] as List<dynamic>;
  return [
    for (final edge in edges.cast<Json>())
      MediaRelation(
        media: mapMediaSummary(edge['node'] as Json),
        type: MediaRelationType.fromApi(edge['relationType'] as String?),
      ),
  ];
}

/// Maps a `characters`/`staff` connection's edges to people with a role.
List<MediaPerson> mapPersonEdges(List<dynamic> edges) {
  return [
    for (final edge in edges.cast<Json>())
      _mapPerson(
        edge['node'] as Json,
        role: _capitalize(edge['role'] as String?),
        imageSize: 'medium',
      ),
  ];
}

/// Maps a `Character`/`Staff` details object.
MediaPerson mapPersonDetails(Json json) => _mapPerson(json, imageSize: 'large');

MediaPerson _mapPerson(Json node, {String? role, required String imageSize}) {
  return MediaPerson(
    id: node['id'] as int,
    name: (node['name'] as Json)['full'] as String? ?? 'Unknown',
    imageUrl: (node['image'] as Json?)?[imageSize] as String? ?? '',
    role: role,
    description: node['description'] as String?,
    favourites: node['favourites'] as int?,
    dateOfBirth: dateFromJson(node['dateOfBirth'] as Json?),
  );
}

List<MediaReview> mapReviews(List<dynamic> nodes) {
  return [
    for (final node in nodes.cast<Json>())
      MediaReview(
        id: node['id'] as int,
        summary: node['summary'] as String? ?? '',
        body: node['body'] as String?,
        score: node['score'] as int? ?? 0,
        rating: node['rating'] as int? ?? 0,
        author: User(
          id: (node['user'] as Json)['id'] as int,
          name: (node['user'] as Json)['name'] as String,
          avatarUrl: (node['user']['avatar'] as Json)['medium'] as String,
        ),
      ),
  ];
}

List<Genre> _genres(Object? raw) => [
  for (final genre in (raw as List<dynamic>? ?? const []).cast<String>())
    Genre.fromApi(genre),
];

String? _capitalize(String? value) {
  if (value == null || value.isEmpty) return value;
  return value[0].toUpperCase() + value.substring(1).toLowerCase();
}

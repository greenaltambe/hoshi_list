import 'package:hoshi_list/models/constants/external_links.dart';
import 'package:hoshi_list/models/constants/genre_list.dart';
import 'package:hoshi_list/models/constants/media_format.dart';
import 'package:hoshi_list/models/constants/media_status.dart';
import 'package:hoshi_list/models/constants/media_type.dart';
import 'package:hoshi_list/models/media.dart';

class MediaDetailsMapper {
  const MediaDetailsMapper();

  MediaDetails fromJson(Map<String, dynamic> json) {
    if (json['errors'] != null) {
      throw Exception('Error from Anilist API: ${json['errors']}');
    }

    if (json['data'] == null || json['data']['Media'] == null) {
      throw Exception('Invalid data format from Anilist API');
    }

    final mediaJson = json['data']['Media'];

    final id = mediaJson['id'] as int;
    final romajiTitle = mediaJson['title']['romaji'] as String;
    final englishTitle = mediaJson['title']['english'] as String?;
    final nativeTitle = mediaJson['title']['native'] as String?;
    final coverImageUrl = mediaJson['coverImage']['large'] as String;
    final bannerImageUrl = mediaJson['bannerImage'] as String?;
    final description = mediaJson['description'] as String? ?? '';
    final format = mediaJson['format'] as String? ?? 'UNKNOWN';
    final status = mediaJson['status'] as String? ?? 'UNKNOWN';
    final startDateJson = mediaJson['startDate'];
    DateTime? startDate;
    if (startDateJson != null && startDateJson['year'] != null) {
      final year = startDateJson['year'] as int;
      final month = startDateJson['month'] as int? ?? 1;
      final day = startDateJson['day'] as int? ?? 1;
      startDate = DateTime(year, month, day);
    }
    final episodes = mediaJson['episodes'] as int?;
    final chapters = mediaJson['chapters'] as int?;
    final averageScore = (mediaJson['averageScore'] as int?)?.toDouble();
    final season = mediaJson['season'] as String?;
    final favourites = mediaJson['favourites'] as int?;
    final genreJson = (mediaJson['genres'] as List<dynamic>?)?.cast<String>();
    MediaTypeAL type =
        stringToMediaTypeAL[mediaJson['type'] as String] ?? MediaTypeAL.anime;
    final externalLinksJson = mediaJson['externalLinks'] as List<dynamic>?;
    List<ExternalLinks>? externalLinks;
    if (externalLinksJson != null) {
      externalLinks = externalLinksJson.map((linkJson) {
        return ExternalLinks(
          url: linkJson['url'] as String,
          siteName: linkJson['site'] as String,
          iconUrl: linkJson['icon'] as String?,
          colorHex: linkJson['color'] as String?,
        );
      }).toList();
    }

    final genres = genreJson != null
        ? genreJson.map((genre) {
            return stringToGenre[genre] ?? Genre.other;
          }).toList()
        : <Genre>[];

    return MediaDetails(
      id: id,
      type: type,
      romajiTitle: romajiTitle,
      englishTitle: englishTitle,
      nativeTitle: nativeTitle,
      coverImageUrl: coverImageUrl,
      bannerImageUrl: bannerImageUrl,
      description: description,
      format: MediaFormat.values.firstWhere(
        (e) => e.toString().split('.').last.toUpperCase() == format,
        orElse: () => MediaFormat.tv,
      ),
      status: MediaStatus.values.firstWhere(
        (e) => e.toString().split('.').last.toUpperCase() == status,
        orElse: () => MediaStatus.releasing,
      ),
      startDate: startDate,
      episodes: episodes,
      chapters: chapters,
      averageScore: averageScore,
      season: season,
      favourites: favourites,
      genres: genres,
      externalLinks: externalLinks,
    );
  }
}

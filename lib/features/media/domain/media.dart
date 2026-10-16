import 'package:hoshi_list/features/media/domain/media_enums.dart';

/// What list cards and carousels need to know about a media item.
class MediaSummary {
  const MediaSummary({
    required this.id,
    required this.title,
    required this.coverImageUrl,
    required this.averageScore,
    this.type,
    this.bannerImageUrl,
    this.description,
    this.genres = const [],
    this.episodes,
    this.chapters,
  });

  final int id;
  final String title;
  final String coverImageUrl;
  final int averageScore;
  final MediaType? type;
  final String? bannerImageUrl;
  final String? description;
  final List<Genre> genres;
  final int? episodes;
  final int? chapters;

  /// Episodes for anime, chapters for manga; null when unknown/ongoing.
  int? get totalUnits => type == MediaType.manga ? chapters : episodes;
}

class ExternalLink {
  const ExternalLink({
    required this.url,
    required this.siteName,
    this.iconUrl,
    this.colorHex,
  });

  final String url;
  final String siteName;
  final String? iconUrl;
  final String? colorHex;
}

class MediaDetails {
  const MediaDetails({
    required this.id,
    required this.type,
    required this.romajiTitle,
    required this.coverImageUrl,
    required this.description,
    required this.genres,
    this.englishTitle,
    this.nativeTitle,
    this.bannerImageUrl,
    this.format,
    this.status,
    this.startDate,
    this.episodes,
    this.chapters,
    this.averageScore,
    this.season,
    this.favourites,
    this.externalLinks = const [],
  });

  final int id;
  final MediaType type;
  final String romajiTitle;
  final String? englishTitle;
  final String? nativeTitle;
  final String coverImageUrl;
  final String? bannerImageUrl;
  final String description;
  final MediaFormat? format;
  final MediaStatus? status;
  final DateTime? startDate;
  final int? episodes;
  final int? chapters;
  final int? averageScore;
  final MediaSeason? season;
  final int? favourites;
  final List<Genre> genres;
  final List<ExternalLink> externalLinks;

  int? get totalUnits => type == MediaType.manga ? chapters : episodes;
}

class MediaRelation {
  const MediaRelation({required this.media, required this.type});

  final MediaSummary media;
  final MediaRelationType type;
}

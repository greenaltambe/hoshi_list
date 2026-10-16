import 'package:flutter/foundation.dart';
import 'package:hoshi_list/features/media/domain/media_enums.dart';

/// A search/browse request. Used as a provider family key, so it has value
/// equality.
@immutable
class MediaBrowseQuery {
  const MediaBrowseQuery({
    required this.type,
    this.sort = MediaSort.popularityDesc,
    this.searchText = '',
    this.filters = const MediaFilters(),
  });

  final MediaType type;
  final MediaSort sort;
  final String searchText;
  final MediaFilters filters;

  MediaBrowseQuery copyWith({
    MediaSort? sort,
    String? searchText,
    MediaFilters? filters,
  }) {
    return MediaBrowseQuery(
      type: type,
      sort: sort ?? this.sort,
      searchText: searchText ?? this.searchText,
      filters: filters ?? this.filters,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is MediaBrowseQuery &&
      other.type == type &&
      other.sort == sort &&
      other.searchText == searchText &&
      other.filters == filters;

  @override
  int get hashCode => Object.hash(type, sort, searchText, filters);
}

/// Optional narrowing criteria. A `null` field means "don't filter on this".
@immutable
class MediaFilters {
  const MediaFilters({
    this.format,
    this.status,
    this.countryOfOrigin,
    this.season,
    this.minimumReleaseDate,
    this.maximumReleaseDate,
    this.minimumEpisodes,
    this.maximumEpisodes,
    this.minimumChapters,
    this.maximumChapters,
    this.minimumAverageScore,
    this.maximumAverageScore,
  });

  final MediaFormat? format;
  final MediaStatus? status;
  final CountryOfOrigin? countryOfOrigin;
  final MediaSeason? season;
  final DateTime? minimumReleaseDate;
  final DateTime? maximumReleaseDate;
  final int? minimumEpisodes;
  final int? maximumEpisodes;
  final int? minimumChapters;
  final int? maximumChapters;
  final int? minimumAverageScore;
  final int? maximumAverageScore;

  @override
  bool operator ==(Object other) =>
      other is MediaFilters &&
      other.format == format &&
      other.status == status &&
      other.countryOfOrigin == countryOfOrigin &&
      other.season == season &&
      other.minimumReleaseDate == minimumReleaseDate &&
      other.maximumReleaseDate == maximumReleaseDate &&
      other.minimumEpisodes == minimumEpisodes &&
      other.maximumEpisodes == maximumEpisodes &&
      other.minimumChapters == minimumChapters &&
      other.maximumChapters == maximumChapters &&
      other.minimumAverageScore == minimumAverageScore &&
      other.maximumAverageScore == maximumAverageScore;

  @override
  int get hashCode => Object.hash(
    format,
    status,
    countryOfOrigin,
    season,
    minimumReleaseDate,
    maximumReleaseDate,
    minimumEpisodes,
    maximumEpisodes,
    minimumChapters,
    maximumChapters,
    minimumAverageScore,
    maximumAverageScore,
  );
}

import 'package:flutter/foundation.dart';
import 'package:hoshi_list/models/constants/media_country_of_origin.dart';
import 'package:hoshi_list/models/constants/media_format.dart';
import 'package:hoshi_list/models/constants/media_season.dart';
import 'package:hoshi_list/models/constants/media_sort.dart';
import 'package:hoshi_list/models/constants/media_status.dart';
import 'package:hoshi_list/models/constants/media_type.dart';

// This model will have the format of how the media query will be structured
@immutable
class MediaQueryAL {
  final MediaTypeAL type;
  final MediaSort sort;
  final int page;
  final int perPage;
  final String searchString;

  final MediaFormat? format;
  final MediaStatus? status;
  final MediaCountryOrigin? countryOfOrigin;
  final MediaSeason? season;
  final DateTime? minimumReleaseYear;
  final DateTime? maximumReleaseYear;
  final int? minimumEpisodes;
  final int? maximumEpisodes;
  final int? minimumChapters;
  final int? maximumChapters;
  final int? minimumAverageScore;
  final int? maximumAverageScore;

  const MediaQueryAL({
    required this.type,
    this.sort = MediaSort.popularityDesc,
    this.page = 1,
    this.perPage = 10,
    this.searchString = '',
    this.format,
    this.status,
    this.countryOfOrigin,
    this.season,
    this.minimumReleaseYear,
    this.maximumReleaseYear,
    this.minimumEpisodes,
    this.maximumEpisodes,
    this.minimumChapters,
    this.maximumChapters,
    this.minimumAverageScore,
    this.maximumAverageScore,
  });

  MediaQueryAL copyWith({
    MediaSort? sort,
    int? page,
    int? perPage,
    String? searchString,
    MediaFormat? format,
    MediaStatus? status,
    MediaCountryOrigin? countryOfOrigin,
    MediaSeason? season,
    DateTime? minimumReleaseYear,
    DateTime? maximumReleaseYear,
    int? minimumEpisodes,
    int? maximumEpisodes,
    int? minimumChapters,
    int? maximumChapters,
    int? minimumAverageScore,
    int? maximumAverageScore,
  }) {
    return MediaQueryAL(
      type: type,
      sort: sort ?? this.sort,
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
      searchString: searchString ?? this.searchString,
      format: format,
      status: status,
      countryOfOrigin: countryOfOrigin,
      season: season,
      minimumReleaseYear: minimumReleaseYear,
      maximumReleaseYear: maximumReleaseYear,
      minimumEpisodes: minimumEpisodes,
      maximumEpisodes: maximumEpisodes,
      minimumChapters: minimumChapters,
      maximumChapters: maximumChapters,
      minimumAverageScore: minimumAverageScore,
      maximumAverageScore: maximumAverageScore,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is MediaQueryAL &&
            other.type == type &&
            other.sort == sort &&
            other.page == page &&
            other.perPage == perPage &&
            other.searchString == searchString &&
            other.format == format &&
            other.status == status &&
            other.countryOfOrigin == countryOfOrigin &&
            other.season == season &&
            other.minimumReleaseYear == minimumReleaseYear &&
            other.maximumReleaseYear == maximumReleaseYear &&
            other.minimumEpisodes == minimumEpisodes &&
            other.maximumEpisodes == maximumEpisodes &&
            other.minimumChapters == minimumChapters &&
            other.maximumChapters == maximumChapters &&
            other.minimumAverageScore == minimumAverageScore &&
            other.maximumAverageScore == maximumAverageScore;
  }

  @override
  int get hashCode => Object.hash(
    type,
    sort,
    page,
    perPage,
    searchString,
    format,
    status,
    countryOfOrigin,
    season,
    minimumReleaseYear,
    maximumReleaseYear,
    minimumEpisodes,
    maximumEpisodes,
    minimumChapters,
    maximumChapters,
    minimumAverageScore,
    maximumAverageScore,
  );
}

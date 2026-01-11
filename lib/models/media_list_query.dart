import 'package:flutter/foundation.dart';

// This model will have the format of how the media query will be structured

// This is the  main model to build queries for Anilist API, will change as needed
enum MediaSort {
  trending,
  trendingDesc,
  popularityDesc,
  popularity,
  score,
  scoreDesc,
  startDate,
  startDateDesc,
  endDate,
  endDateDesc,
  favourites,
  favouritesDesc,
  titleRomaji,
  titleRomajiDesc,
  titleEnglish,
  titleEnglishDesc,
}

final Map<MediaSort, Map<String, String>> mediaSortToString = {
  MediaSort.trending: {"query_name": "TRENDING", "name": "Trending"},
  MediaSort.trendingDesc: {
    "query_name": "TRENDING_DESC",
    "name": "Trending Descending",
  },
  MediaSort.popularityDesc: {
    "query_name": "POPULARITY_DESC",
    "name": "Popularity Descending",
  },
  MediaSort.popularity: {"query_name": "POPULARITY", "name": "Popularity"},
  MediaSort.score: {"query_name": "SCORE", "name": "Score"},
  MediaSort.scoreDesc: {"query_name": "SCORE_DESC", "name": "Score Descending"},
  MediaSort.startDate: {"query_name": "START_DATE", "name": "Start Date"},
  MediaSort.startDateDesc: {
    "query_name": "START_DATE_DESC",
    "name": "Start Date Descending",
  },
  MediaSort.endDate: {"query_name": "END_DATE", "name": "End Date"},
  MediaSort.endDateDesc: {
    "query_name": "END_DATE_DESC",
    "name": "End Date Descending",
  },
  MediaSort.favourites: {"query_name": "FAVOURITES", "name": "Favourites"},
  MediaSort.favouritesDesc: {
    "query_name": "FAVOURITES_DESC",
    "name": "Favourites Descending",
  },
  MediaSort.titleRomaji: {"query_name": "TITLE_ROMAJI", "name": "Title Romaji"},
  MediaSort.titleRomajiDesc: {
    "query_name": "TITLE_ROMAJI_DESC",
    "name": "Title Romaji Descending",
  },
  MediaSort.titleEnglish: {
    "query_name": "TITLE_ENGLISH",
    "name": "Title English",
  },
  MediaSort.titleEnglishDesc: {
    "query_name": "TITLE_ENGLISH_DESC",
    "name": "Title English Descending",
  },
};

enum MediaTypeAL { anime, manga }

@immutable
class MediaQueryAL {
  final MediaTypeAL type;
  final MediaSort sort;
  final int page;
  final int perPage;
  final String searchString;

  const MediaQueryAL({
    required this.type,
    this.sort = MediaSort.popularityDesc,
    this.page = 1,
    this.perPage = 10,
    this.searchString = '',
  });

  MediaQueryAL copyWith({
    MediaSort? sort,
    int? page,
    int? perPage,
    String? searchString,
  }) {
    return MediaQueryAL(
      type: type,
      sort: sort ?? this.sort,
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
      searchString: searchString ?? this.searchString,
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
            other.searchString == searchString;
  }

  @override
  int get hashCode => Object.hash(type, sort, page, perPage, searchString);
}

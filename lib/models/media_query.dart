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

enum MediaTypeAL { anime, manga }

@immutable
class MediaQueryAL {
  final MediaTypeAL type;
  final MediaSort sort;
  final int page;
  final int perPage;

  const MediaQueryAL({
    required this.type,
    this.sort = MediaSort.trending,
    this.page = 1,
    this.perPage = 10,
  });

  MediaQueryAL copyWith({int? page}) {
    return MediaQueryAL(
      type: type,
      sort: sort,
      page: page ?? this.page,
      perPage: perPage,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is MediaQueryAL &&
            other.type == type &&
            other.sort == sort &&
            other.page == page &&
            other.perPage == perPage;
  }

  @override
  int get hashCode => Object.hash(type, sort, page, perPage);
}

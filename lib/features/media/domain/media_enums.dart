import 'package:hoshi_list/core/utils/api_enum.dart';

enum MediaType implements ApiEnum {
  anime('ANIME', 'Anime'),
  manga('MANGA', 'Manga');

  const MediaType(this.apiValue, this.label);

  @override
  final String apiValue;
  final String label;

  static MediaType? fromApi(String? raw) => parseApiEnum(values, raw);
}

enum MediaFormat implements ApiEnum {
  tv('TV', 'TV'),
  tvShort('TV_SHORT', 'TV Short'),
  movie('MOVIE', 'Movie'),
  special('SPECIAL', 'Special'),
  ova('OVA', 'OVA'),
  ona('ONA', 'ONA'),
  music('MUSIC', 'Music'),
  manga('MANGA', 'Manga'),
  novel('NOVEL', 'Novel'),
  oneShot('ONE_SHOT', 'One Shot');

  const MediaFormat(this.apiValue, this.label);

  @override
  final String apiValue;
  final String label;

  static MediaFormat? fromApi(String? raw) => parseApiEnum(values, raw);
}

/// Release status of the media itself (not to be confused with
/// `MediaListStatus`, which is the status in a user's list).
enum MediaStatus implements ApiEnum {
  finished('FINISHED', 'Finished'),
  releasing('RELEASING', 'Releasing'),
  notYetReleased('NOT_YET_RELEASED', 'Not Yet Released'),
  cancelled('CANCELLED', 'Cancelled'),
  hiatus('HIATUS', 'Hiatus');

  const MediaStatus(this.apiValue, this.label);

  @override
  final String apiValue;
  final String label;

  static MediaStatus? fromApi(String? raw) => parseApiEnum(values, raw);
}

enum MediaSeason implements ApiEnum {
  winter('WINTER', 'Winter'),
  spring('SPRING', 'Spring'),
  summer('SUMMER', 'Summer'),
  fall('FALL', 'Fall');

  const MediaSeason(this.apiValue, this.label);

  @override
  final String apiValue;
  final String label;

  static MediaSeason? fromApi(String? raw) => parseApiEnum(values, raw);
}

enum CountryOfOrigin implements ApiEnum {
  jp('JP', 'Japan'),
  kr('KR', 'South Korea'),
  tw('TW', 'Taiwan'),
  cn('CN', 'China');

  const CountryOfOrigin(this.apiValue, this.label);

  @override
  final String apiValue;
  final String label;
}

enum MediaSort implements ApiEnum {
  trendingDesc('TRENDING_DESC', 'Trending'),
  trending('TRENDING', 'Trending (ascending)'),
  popularityDesc('POPULARITY_DESC', 'Popularity'),
  popularity('POPULARITY', 'Popularity (ascending)'),
  scoreDesc('SCORE_DESC', 'Score'),
  score('SCORE', 'Score (ascending)'),
  startDateDesc('START_DATE_DESC', 'Start date'),
  startDate('START_DATE', 'Start date (ascending)'),
  endDateDesc('END_DATE_DESC', 'End date'),
  endDate('END_DATE', 'End date (ascending)'),
  favouritesDesc('FAVOURITES_DESC', 'Favourites'),
  favourites('FAVOURITES', 'Favourites (ascending)'),
  titleRomaji('TITLE_ROMAJI', 'Title (romaji)'),
  titleRomajiDesc('TITLE_ROMAJI_DESC', 'Title (romaji, descending)'),
  titleEnglish('TITLE_ENGLISH', 'Title (English)'),
  titleEnglishDesc('TITLE_ENGLISH_DESC', 'Title (English, descending)');

  const MediaSort(this.apiValue, this.label);

  @override
  final String apiValue;
  final String label;
}

enum MediaRelationType implements ApiEnum {
  adaptation('ADAPTATION', 'Adaptation'),
  alternative('ALTERNATIVE', 'Alternative'),
  character('CHARACTER', 'Character'),
  compilation('COMPILATION', 'Compilation'),
  contains('CONTAINS', 'Contains'),
  other('OTHER', 'Other'),
  parent('PARENT', 'Parent'),
  prequel('PREQUEL', 'Prequel'),
  sequel('SEQUEL', 'Sequel'),
  sideStory('SIDE_STORY', 'Side Story'),
  source('SOURCE', 'Source'),
  spinOff('SPIN_OFF', 'Spin Off'),
  summary('SUMMARY', 'Summary');

  const MediaRelationType(this.apiValue, this.label);

  @override
  final String apiValue;
  final String label;

  static MediaRelationType fromApi(String? raw) =>
      parseApiEnum(values, raw) ?? MediaRelationType.other;
}

enum Genre implements ApiEnum {
  action('Action'),
  adventure('Adventure'),
  comedy('Comedy'),
  drama('Drama'),
  ecchi('Ecchi'),
  fantasy('Fantasy'),
  hentai('Hentai'),
  horror('Horror'),
  mahouShoujo('Mahou Shoujo'),
  mecha('Mecha'),
  music('Music'),
  mystery('Mystery'),
  psychological('Psychological'),
  romance('Romance'),
  sciFi('Sci-Fi'),
  sliceOfLife('Slice of Life'),
  sports('Sports'),
  supernatural('Supernatural'),
  thriller('Thriller'),
  other('Other');

  const Genre(this.apiValue);

  /// AniList genre names double as display names.
  @override
  final String apiValue;

  String get label => apiValue;

  static Genre fromApi(String? raw) => parseApiEnum(values, raw) ?? Genre.other;
}

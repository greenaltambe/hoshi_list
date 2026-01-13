enum MediaSeason { winter, spring, summer, fall }

Map<MediaSeason, String> mediaSeasonToString = {
  MediaSeason.winter: 'WINTER',
  MediaSeason.spring: 'SPRING',
  MediaSeason.summer: 'SUMMER',
  MediaSeason.fall: 'FALL',
};

Map<String, MediaSeason> stringToMediaSeason = {
  'WINTER': MediaSeason.winter,
  'SPRING': MediaSeason.spring,
  'SUMMER': MediaSeason.summer,
  'FALL': MediaSeason.fall,
};

enum MediaTypeAL { anime, manga }

Map<MediaTypeAL, String> mediaTypeALToString = {
  MediaTypeAL.anime: 'ANIME',
  MediaTypeAL.manga: 'MANGA',
};

Map<String, MediaTypeAL> stringToMediaTypeAL = {
  'ANIME': MediaTypeAL.anime,
  'MANGA': MediaTypeAL.manga,
};

final mediaQueryString = r'''
query ($page: Int, $perPage: Int, $type: MediaType, $sort: [MediaSort], $search: String, $format: MediaFormat, $status: MediaStatus, $countryOfOrigin: CountryCode, $season: MediaSeason, $minimumReleaseYear: FuzzyDateInt, $maximumReleaseYear: FuzzyDateInt, $minimumEpisodes: Int, $maximumEpisodes: Int, $minimumChapters: Int, $maximumChapters: Int, $minimumAverageScore: Int, $maximumAverageScore: Int) {
  Page(page: $page, perPage: $perPage) {
    pageInfo {
      perPage
      currentPage
      hasNextPage
    }
    media(type: $type, sort: $sort, search: $search, format: $format, status: $status, countryOfOrigin: $countryOfOrigin, season: $season, startDate_greater: $minimumReleaseYear, startDate_lesser: $maximumReleaseYear, episodes_greater: $minimumEpisodes, episodes_lesser: $maximumEpisodes, chapters_greater: $minimumChapters, chapters_lesser: $maximumChapters, averageScore_greater: $minimumAverageScore, averageScore_lesser: $maximumAverageScore) {
      id
      averageScore
      bannerImage
      description
      title {
        romaji
        english
        native
      }
      coverImage {
        large
      }
    }
  }
}
''';

/**
 * query (
  $page: Int,
  $perPage: Int,
  $type: MediaType,
  $sort: [MediaSort],
  $search: String,
) {
  Page(page: $page, perPage: $perPage) {
    pageInfo {
      currentPage
      hasNextPage
    }
    media(
      type: $type,
      sort: $sort,
      search: $search,
      format: TV,
      status: FINISHED,
      season: FALL,
      countryOfOrigin: CN,
      startDate_greater: 20050101,
      startDate_lesser: 20240101,
      episodes_lesser: 100,
      episodes_greater: 150,
      averageScore_lesser: 88,
      averageScore_greater: 12
      ) {
      id
      title {
        romaji
        english
        native
      }
      coverImage {
        large
      }
    }
  }
}

 */

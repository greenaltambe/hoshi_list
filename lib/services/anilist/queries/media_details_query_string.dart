final mediaDetailsQueryString = r'''
  query ($id: Int) {
  Media (id: $id) {
    id
    type
    title {
      romaji
      english
      native
    }
    coverImage {
      large
    }
    bannerImage
    description
    format
    status
    startDate {
      day
      month
      year
    }
    episodes
    chapters
    averageScore
    genres
    season
    favourites
    externalLinks {
      url
      icon
      color
      site
    }
  }
}
''';

final mediaDetailsQueryString = r'''
  query ($id: Int) {
  Media (id: $id) {
    id
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
  }
}
''';

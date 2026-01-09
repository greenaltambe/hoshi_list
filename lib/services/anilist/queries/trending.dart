final trendingAnimeQuery = r'''
query {
  Page(page: 1, perPage: 10) {
    media(type: ANIME, sort: TRENDING_DESC) {
      id
      title {
        romaji
        english
        native
      }
      coverImage {
        medium
      }
    }
  }
}
''';

final trendingMangaQuery = r'''
query {
  Page(page: 1, perPage: 10) {
    media(type: MANGA, sort: TRENDING_DESC) {
      id
      title {
        romaji
        english
        native
      }
      coverImage {
        medium
      }
    }
  }
}
''';

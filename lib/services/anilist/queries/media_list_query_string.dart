final mediaQueryString = r'''
query ($page: Int, $perPage: Int, $type: MediaType, $sort: [MediaSort]) {
  Page(page: $page, perPage: $perPage) {
    pageInfo {
      perPage
      currentPage
      hasNextPage
    }
    media(type: $type, sort: $sort) {
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

final mediaQueryString = r'''
query ($page: Int, $perPage: Int, $type: MediaType, $sort: [MediaSort], $search: String) {
  Page(page: $page, perPage: $perPage) {
    pageInfo {
      perPage
      currentPage
      hasNextPage
    }
    media(type: $type, sort: $sort, search: $search) {
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
''';

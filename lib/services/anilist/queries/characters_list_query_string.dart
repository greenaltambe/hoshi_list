// This is a GraphQL query string used to fetch a list of characters for a specific media item from the AniList API.

final charactersListQueryString = r'''
query MediaCharacters($mediaId: Int!, $page: Int!, $perPage: Int!, $sort: [CharacterSort!]) {
  Media(id: $mediaId) {
    characters(page: $page, perPage: $perPage, sort: $sort) {
      pageInfo {
        currentPage
        hasNextPage
      }
      edges {
        role
        node {
          id
          name {
            full
          }
          image {
            medium
          }
        }
      }
    }
  }
}
''';

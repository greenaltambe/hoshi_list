final mediaRecommendationListQueryString = r'''
query MediaRecommendation($mediaId: Int!, $page: Int!, $perPage: Int!) {
  Media(id: $mediaId) {
    recommendations (page: $page, perPage: $perPage, sort: [RATING]) {
      pageInfo {
        hasNextPage
      }
      nodes {
        mediaRecommendation {
          id
          averageScore
          bannerImage
          description 
          genres
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
  }
}
''';

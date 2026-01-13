final mediaRelationsQueryString = r'''
query MediaRelations($mediaId: Int!) {
  Media(id: $mediaId) {
    relations {
      edges {
        relationType
        node {
          id 
          averageScore
          coverImage {
            large
          }
          bannerImage
          title {
            english
            native
            romaji
          }
        }
      }
    }
  }
}
''';

/**
 * 
 * query MediaRecommendation($mediaId: Int!) {
  Media(id: $mediaId) {
    relations {
      edges {
        relationType
        node {
          id 
          averageScore
          coverImage {
            large
          }
          bannerImage
          title {
            english
            native
            romaji
          }
        }
      }
    }
  }
}

 */

final mediaReviewListQueryString = r'''
query MediaReview($mediaId: Int!, $page: Int!, $perPage: Int!, $sort: [ReviewSort]) {
  Media(id: $mediaId) {
    reviews(page: $page, perPage: $perPage, sort: $sort) {
      pageInfo {
        hasNextPage
      }
      nodes {
        id
        user {
          id
          name
          avatar {
            medium
          }
        }
        body
        summary
        score
        rating
      }
    }
  }
}
''';

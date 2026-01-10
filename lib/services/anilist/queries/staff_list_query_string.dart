final staffListQueryString = r'''
query MediaStaff($mediaId: Int!, $page: Int!, $perPage: Int!, $sort: [StaffSort!]) {
  Media(id: $mediaId) {
    staff(page: $page, perPage: $perPage, sort: $sort) {
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

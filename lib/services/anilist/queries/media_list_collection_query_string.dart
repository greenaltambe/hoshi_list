final mediaListCollectionQueryString = r'''
query ($type: MediaType!, $userId: Int!) {
  MediaListCollection(type: $type, userId: $userId) {
    lists {
      name
      isCustomList
      status
      entries {
        id
        score
        progress
        media {
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
          averageScore
          description
          genres
          episodes
          chapters
        }
      }
    }
  }
}
''';

/// GraphQL documents for the media feature. Kept as plain strings (raw, so
/// `$variables` need no escaping).
library;

const mediaSummaryFragment = r'''
fragment MediaSummaryFields on Media {
  id
  type
  averageScore
  bannerImage
  description
  genres
  episodes
  chapters
  title { romaji english native }
  coverImage { large }
}
''';

const mediaPageQuery =
    r'''
query MediaPage(
  $page: Int, $perPage: Int, $type: MediaType, $sort: [MediaSort], $search: String,
  $format: MediaFormat, $status: MediaStatus, $countryOfOrigin: CountryCode,
  $season: MediaSeason, $minimumReleaseDate: FuzzyDateInt, $maximumReleaseDate: FuzzyDateInt,
  $minimumEpisodes: Int, $maximumEpisodes: Int, $minimumChapters: Int, $maximumChapters: Int,
  $minimumAverageScore: Int, $maximumAverageScore: Int
) {
  Page(page: $page, perPage: $perPage) {
    pageInfo { hasNextPage }
    media(
      type: $type, sort: $sort, search: $search, format: $format, status: $status,
      countryOfOrigin: $countryOfOrigin, season: $season,
      startDate_greater: $minimumReleaseDate, startDate_lesser: $maximumReleaseDate,
      episodes_greater: $minimumEpisodes, episodes_lesser: $maximumEpisodes,
      chapters_greater: $minimumChapters, chapters_lesser: $maximumChapters,
      averageScore_greater: $minimumAverageScore, averageScore_lesser: $maximumAverageScore
    ) {
      ...MediaSummaryFields
    }
  }
}
''' +
    mediaSummaryFragment;

const mediaDetailsQuery = r'''
query MediaDetails($id: Int!) {
  Media(id: $id) {
    id
    type
    title { romaji english native }
    coverImage { large }
    bannerImage
    description
    format
    status
    startDate { day month year }
    episodes
    chapters
    averageScore
    genres
    season
    favourites
    externalLinks { url icon color site }
  }
}
''';

const mediaCharactersQuery = r'''
query MediaCharacters($mediaId: Int!, $page: Int!, $perPage: Int!, $sort: [CharacterSort!]) {
  Media(id: $mediaId) {
    characters(page: $page, perPage: $perPage, sort: $sort) {
      pageInfo { hasNextPage }
      edges {
        role
        node { id name { full } image { medium } }
      }
    }
  }
}
''';

const mediaStaffQuery = r'''
query MediaStaff($mediaId: Int!, $page: Int!, $perPage: Int!, $sort: [StaffSort!]) {
  Media(id: $mediaId) {
    staff(page: $page, perPage: $perPage, sort: $sort) {
      pageInfo { hasNextPage }
      edges {
        role
        node { id name { full } image { medium } }
      }
    }
  }
}
''';

const characterDetailsQuery = r'''
query CharacterDetails($id: Int!) {
  Character(id: $id) {
    id
    name { full }
    dateOfBirth { day month year }
    description
    favourites
    image { large }
  }
}
''';

const staffDetailsQuery = r'''
query StaffDetails($id: Int!) {
  Staff(id: $id) {
    id
    name { full }
    dateOfBirth { day month year }
    description
    favourites
    image { large }
  }
}
''';

const mediaReviewsQuery = r'''
query MediaReviews($mediaId: Int!, $page: Int!, $perPage: Int!, $sort: [ReviewSort]) {
  Media(id: $mediaId) {
    reviews(page: $page, perPage: $perPage, sort: $sort) {
      pageInfo { hasNextPage }
      nodes {
        id
        body
        summary
        score
        rating
        user { id name avatar { medium } }
      }
    }
  }
}
''';

const mediaRecommendationsQuery =
    r'''
query MediaRecommendations($mediaId: Int!, $page: Int!, $perPage: Int!) {
  Media(id: $mediaId) {
    recommendations(page: $page, perPage: $perPage, sort: [RATING_DESC]) {
      pageInfo { hasNextPage }
      nodes { mediaRecommendation { ...MediaSummaryFields } }
    }
  }
}
''' +
    mediaSummaryFragment;

const mediaRelationsQuery =
    r'''
query MediaRelations($mediaId: Int!) {
  Media(id: $mediaId) {
    relations {
      edges {
        relationType
        node { ...MediaSummaryFields }
      }
    }
  }
}
''' +
    mediaSummaryFragment;

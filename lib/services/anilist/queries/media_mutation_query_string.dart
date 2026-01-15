final saveMediaMutationQueryString = r'''
mutation SaveMedia(
  $mediaId: Int!,
  $status: MediaListStatus,
  $progress: Int,
  $score: Float,
  $scoreRaw: Int,
  $repeat: Int,
  $notes: String,
  $startedAt: FuzzyDateInput,
  $completedAt: FuzzyDateInput,
  $customLists: [String]
) {
  SaveMediaListEntry(
    mediaId: $mediaId,
    status: $status,
    progress: $progress,
    score: $score,
    scoreRaw: $scoreRaw,
    repeat: $repeat,
    notes: $notes,
    startedAt: $startedAt,
    completedAt: $completedAt,
    customLists: $customLists
  ) {
    id
    status
    progress
    score
  }
}
''';

/**
 * mutation SaveMedia(
  $mediaId: Int!,
  $status: MediaListStatus,
  $progress: Int,
  $score: Float,
  $scoreRaw: Int,
  $repeat: Int,
  $notes: String,
  $startedAt: FuzzyDateInput,
  $completedAt: FuzzyDateInput,
  $customLists: [String]
) {
  SaveMediaListEntry(
    mediaId: $mediaId,
    status: $status,
    progress: $progress,
    score: $score,
    scoreRaw: $scoreRaw,
    repeat: $repeat,
    notes: $notes,
    startedAt: $startedAt,
    completedAt: $completedAt,
    customLists: $customLists
  ) {
    id
    status
    progress
    score
  }
}

 */

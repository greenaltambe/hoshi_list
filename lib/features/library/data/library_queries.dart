import 'package:hoshi_list/features/media/data/media_queries.dart';

/// `score(format: POINT_100)` makes scores independent of the user's chosen
/// display format (10-point, stars...), matching what the edit form expects.
const mediaListCollectionQuery =
    r'''
query MediaListCollection($type: MediaType!, $userId: Int!) {
  MediaListCollection(type: $type, userId: $userId) {
    lists {
      name
      isCustomList
      status
      entries {
        id
        score(format: POINT_100)
        progress
        media { ...MediaSummaryFields }
      }
    }
  }
}
''' +
    mediaSummaryFragment;

const mediaListEntryQuery = r'''
query MediaListEntry($id: Int!) {
  Media(id: $id) {
    mediaListEntry {
      mediaId
      status
      progress
      score(format: POINT_100)
      repeat
      notes
      startedAt { day month year }
      completedAt { day month year }
    }
  }
}
''';

const saveMediaListEntryMutation = r'''
mutation SaveMediaListEntry(
  $mediaId: Int!, $status: MediaListStatus, $progress: Int, $scoreRaw: Int,
  $repeat: Int, $notes: String, $startedAt: FuzzyDateInput, $completedAt: FuzzyDateInput
) {
  SaveMediaListEntry(
    mediaId: $mediaId, status: $status, progress: $progress, scoreRaw: $scoreRaw,
    repeat: $repeat, notes: $notes, startedAt: $startedAt, completedAt: $completedAt
  ) {
    id
  }
}
''';

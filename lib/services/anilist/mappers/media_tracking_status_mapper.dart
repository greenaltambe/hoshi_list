import 'package:hoshi_list/models/constants/media_list_status.dart';
import 'package:hoshi_list/models/media_tracking_status.dart';

class MediaTrackingStatusMapper {
  MediaTrackingStatus fromJson(Map<String, dynamic> json) {
    if (json['errors'] != null) {
      throw Exception('Invalid JSON data for MediaTrackingStatus');
    }

    if (json['data'] == null ||
        json['data']['Media'] == null ||
        json['data']['Media']['mediaListEntry'] == null) {
      throw Exception('Invalid JSON data for MediaTrackingStatus');
    }

    final mediaEntry = json['data']['Media']['mediaListEntry'];

    final MediaListStatus? status;
    if (mediaEntry['status'] is String) {
      status = stringToMediaListStatus[mediaEntry['status'] as String];
    } else {
      status = null;
    }

    final mediaId = mediaEntry['mediaId'];
    final progress = mediaEntry['progress'] as int?;
    final scoreRaw = mediaEntry['score'] as int?;
    final repeat = mediaEntry['repeat'] as int?;
    final notes = mediaEntry['notes'] as String?;
    final startedAtJson = mediaEntry['startedAt'];
    final dateStartedAt =
        startedAtJson != null &&
            startedAtJson['year'] != null &&
            startedAtJson['month'] != null &&
            startedAtJson['day'] != null
        ? DateTime(
            startedAtJson['year'],
            startedAtJson['month'],
            startedAtJson['day'],
          )
        : null;
    final completedAtJson = mediaEntry['completedAt'];
    final dateCompletedAt =
        completedAtJson != null &&
            completedAtJson['year'] != null &&
            completedAtJson['month'] != null &&
            completedAtJson['day'] != null
        ? DateTime(
            completedAtJson['year'],
            completedAtJson['month'],
            completedAtJson['day'],
          )
        : null;

    return MediaTrackingStatus(
      mediaId: mediaId,
      mediaListStatus: status,
      progress: progress,
      scoreRaw: scoreRaw,
      repeat: repeat,
      notes: notes,
      startedAt: dateStartedAt,
      completedAt: dateCompletedAt,
    );
  }
}

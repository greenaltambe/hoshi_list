import 'package:hoshi_list/models/constants/media_list_status.dart';

class MediaTrackingStatus {
  final int mediaId;
  final MediaListStatus? mediaListStatus;
  final int? progress;
  final double? score;
  final int? scoreRaw;
  final int? repeat;
  final String? notes;
  final DateTime? startedAt;
  final DateTime? completedAt;

  MediaTrackingStatus({
    required this.mediaId,
    this.mediaListStatus,
    this.progress,
    this.score,
    this.scoreRaw,
    this.repeat,
    this.notes,
    this.startedAt,
    this.completedAt,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MediaTrackingStatus &&
        other.mediaId == mediaId &&
        other.mediaListStatus == mediaListStatus &&
        other.progress == progress &&
        other.score == score &&
        other.scoreRaw == scoreRaw &&
        other.repeat == repeat &&
        other.notes == notes &&
        other.startedAt == startedAt &&
        other.completedAt == completedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      mediaId,
      mediaListStatus,
      progress,
      score,
      scoreRaw,
      repeat,
      notes,
      startedAt,
      completedAt,
    );
  }
}

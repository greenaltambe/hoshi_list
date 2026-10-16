import 'package:flutter/foundation.dart';
import 'package:hoshi_list/features/library/domain/media_list_status.dart';
import 'package:hoshi_list/features/media/domain/media.dart';

/// A named list in the user's library ("Watching", a custom list...).
class MediaListGroup {
  const MediaListGroup({
    required this.name,
    required this.isCustomList,
    required this.entries,
    this.status,
  });

  final String name;
  final bool isCustomList;
  final MediaListStatus? status;
  final List<MediaListEntry> entries;
}

class MediaListEntry {
  const MediaListEntry({
    required this.entryId,
    required this.score,
    required this.progress,
    required this.media,
  });

  final int entryId;

  /// 0-100, 0 meaning "not scored".
  final int score;
  final int progress;
  final MediaSummary media;
}

/// The user's saved data for one media item (what the edit sheet shows).
@immutable
class MediaListEntryDetails {
  const MediaListEntryDetails({
    required this.mediaId,
    this.status,
    this.progress,
    this.score,
    this.repeat,
    this.notes,
    this.startedAt,
    this.completedAt,
  });

  final int mediaId;
  final MediaListStatus? status;
  final int? progress;

  /// 0-100.
  final int? score;
  final int? repeat;
  final String? notes;
  final DateTime? startedAt;
  final DateTime? completedAt;
}

/// What the edit sheet submits. Every field is sent, so a cleared field
/// clears the value on AniList.
@immutable
class MediaListEntryInput {
  const MediaListEntryInput({
    required this.mediaId,
    required this.status,
    this.progress = 0,
    this.score = 0,
    this.repeat = 0,
    this.notes = '',
    this.startedAt,
    this.completedAt,
  });

  final int mediaId;
  final MediaListStatus status;
  final int progress;

  /// 0-100.
  final int score;
  final int repeat;
  final String notes;
  final DateTime? startedAt;
  final DateTime? completedAt;
}

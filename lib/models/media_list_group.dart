import 'package:hoshi_list/models/constants/media_list_status.dart';
import 'package:hoshi_list/models/media.dart';

class MediaListGroup {
  final String name;
  final bool isCustomList;
  final MediaListStatus? mediaStatus;
  final List<MediaListEntry> entries;

  MediaListGroup({
    required this.name,
    required this.isCustomList,
    this.mediaStatus,
    required this.entries,
  });

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is MediaListGroup &&
            other.name == name &&
            other.isCustomList == isCustomList &&
            other.mediaStatus == mediaStatus &&
            other.entries == entries;
  }

  @override
  int get hashCode => Object.hash(name, isCustomList, mediaStatus, entries);
}

class MediaListEntry {
  final int entryId; // anilsit list entry id
  final int userScore;
  final int userProgress;
  final Media media;

  MediaListEntry({
    required this.entryId,
    required this.userScore,
    required this.userProgress,
    required this.media,
  });
}

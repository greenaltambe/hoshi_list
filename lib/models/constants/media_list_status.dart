import 'package:flutter/material.dart';

enum MediaListStatus {
  completed,
  current,
  dropped,
  paused,
  planning,
  repeating,
}

Map<MediaListStatus, Icon> mediaListStatusToIcon = {
  MediaListStatus.completed: Icon(Icons.check_circle, color: Color(0xFF4CAF50)),
  MediaListStatus.current: Icon(
    Icons.play_circle_fill,
    color: Color(0xFF2196F3),
  ),
  MediaListStatus.dropped: Icon(Icons.cancel, color: Color(0xFFF44336)),
  MediaListStatus.paused: Icon(
    Icons.pause_circle_filled,
    color: Color(0xFFFFC107),
  ),
  MediaListStatus.planning: Icon(Icons.schedule, color: Color(0xFF9E9E9E)),
  MediaListStatus.repeating: Icon(Icons.repeat, color: Color(0xFF673AB7)),
};

Map<String, MediaListStatus> stringToMediaListStatus = {
  "Completed": MediaListStatus.completed,
  "Current": MediaListStatus.current,
  "Dropped": MediaListStatus.dropped,
  "Paused": MediaListStatus.paused,
  "Planning": MediaListStatus.planning,
  "Repeating": MediaListStatus.repeating,
};

Map<MediaListStatus, String> mediaListStatusToString = {
  MediaListStatus.completed: "Completed",
  MediaListStatus.current: "Current",
  MediaListStatus.dropped: "Dropped",
  MediaListStatus.paused: "Paused",
  MediaListStatus.planning: "Planning",
  MediaListStatus.repeating: "Repeating",
};

Map<MediaListStatus, String> mediaListStatusToAnimeString = {
  MediaListStatus.completed: "Completed",
  MediaListStatus.current: "Watching",
  MediaListStatus.dropped: "Dropped",
  MediaListStatus.paused: "Paused",
  MediaListStatus.planning: "Plan to Watch",
  MediaListStatus.repeating: "Rewatching",
};

Map<MediaListStatus, String> mediaListStatusToMangaString = {
  MediaListStatus.completed: "Completed",
  MediaListStatus.current: "Reading",
  MediaListStatus.dropped: "Dropped",
  MediaListStatus.paused: "Paused",
  MediaListStatus.planning: "Plan to Read",
  MediaListStatus.repeating: "Rereading",
};

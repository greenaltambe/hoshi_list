enum MediaStatus { cancelled, finished, hiatus, notYetReleased, releasing }

Map<MediaStatus, String> mediaStatusToString = {
  MediaStatus.cancelled: "Cancelled",
  MediaStatus.finished: "Finished",
  MediaStatus.hiatus: "Hiatus",
  MediaStatus.notYetReleased: "Not Yet Released",
  MediaStatus.releasing: "Releasing",
};

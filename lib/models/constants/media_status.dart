// This status is different from MediaListStatus, media status is like releasing, finished etc of the media itesls
/// whereas MediaListStatus is the status of the media in the user's list like completed, planning etc
enum MediaStatus { cancelled, finished, hiatus, notYetReleased, releasing }

Map<MediaStatus, String> mediaStatusToString = {
  MediaStatus.cancelled: "Cancelled",
  MediaStatus.finished: "Finished",
  MediaStatus.hiatus: "Hiatus",
  MediaStatus.notYetReleased: "Not Yet Released",
  MediaStatus.releasing: "Releasing",
};

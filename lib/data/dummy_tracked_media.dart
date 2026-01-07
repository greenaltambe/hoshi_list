import 'package:hoshi_list/models/tracked_media.dart';

final dummyTrackedMedia = <TrackedMedia>[
  TrackedMedia(
    mediaId: 1,
    type: MediaType.anime,
    status: TrackStatus.inProgress,
    progress: 12,
    updatedAt: DateTime.now(),
  ),
  TrackedMedia(
    mediaId: 2,
    type: MediaType.anime,
    status: TrackStatus.completed,
    progress: 64,
    updatedAt: DateTime.now(),
  ),
  TrackedMedia(
    mediaId: 3,
    type: MediaType.manga,
    status: TrackStatus.planned,
    progress: 0,
    updatedAt: DateTime.now(),
  ),
];

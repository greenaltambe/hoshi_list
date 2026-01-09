import 'package:hoshi_list/models/media_list_query.dart';

enum TrackStatus { planned, inProgress, completed, onHold }

class TrackedMedia {
  final int mediaId; // links to Media
  final MediaTypeAL type;
  final TrackStatus status;

  final int progress; // episodes watched / chapters read
  final DateTime updatedAt;

  const TrackedMedia({
    required this.mediaId,
    required this.type,
    required this.status,
    required this.progress,
    required this.updatedAt,
  });
}

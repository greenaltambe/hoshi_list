import 'package:hoshi_list/models/constants/media_list_status.dart';

class MediaListUpdateResult {
  final int? id;
  final MediaListStatus? status;
  final int? progress;
  final double? score;

  MediaListUpdateResult({this.id, this.status, this.progress, this.score});
}

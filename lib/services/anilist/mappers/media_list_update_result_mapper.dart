import 'package:hoshi_list/models/constants/media_list_status.dart';
import 'package:hoshi_list/models/media_list_update_result.dart';

class MediaListUpdateResultMapper {
  const MediaListUpdateResultMapper();

  MediaListUpdateResult fromJson(Map<String, dynamic> json) {
    if (json['errors'] != null) {
      throw Exception('Error in MediaListUpdateResult JSON: ${json['errors']}');
    }

    if (json['data'] == null || json['data']['SaveMediaListEntry'] == null) {
      throw Exception('Invalid MediaListUpdateResult JSON structure');
    }

    final entry = json['data']['SaveMediaListEntry'] as Map<String, dynamic>;
    final id = entry['id'] as int?;
    final status = stringToMediaListStatus[entry['status'] as String?];
    final progress = entry['progress'] as int?;
    final score = (entry['score'] as num?)?.toDouble();
    return MediaListUpdateResult(
      id: id,
      status: status,
      progress: progress,
      score: score,
    );
  }
}

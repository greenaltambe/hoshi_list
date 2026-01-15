import 'package:hoshi_list/models/media.dart';
import 'package:hoshi_list/services/anilist/mappers/media_mapper.dart';

class MediaListMapper {
  const MediaListMapper();

  List<Media> mapMediaList(Map<String, dynamic> data) {
    // Decoded data object consists of error field if there was an error
    if (data['errors'] != null) {
      throw Exception('Error from Anilist API: ${data['errors']}');
    }

    // Check for expected data structure
    if (data['data'] == null ||
        data['data']['Page'] == null ||
        data['data']['Page']['media'] == null ||
        data['data']['Page']['pageInfo'] == null) {
      throw Exception('Invalid data format from Anilist API');
    }

    final mediaList = data['data']['Page']['media'] as List;
    // Map each media item to Media model
    if (mediaList.isEmpty) {
      return [];
    }

    return mediaList.map((entry) {
      return MediaMapper().fromJson(entry);
    }).toList();
  }
}

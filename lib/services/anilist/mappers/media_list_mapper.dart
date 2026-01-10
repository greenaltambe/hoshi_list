import 'dart:convert';

import 'package:hoshi_list/models/media.dart';
import 'package:http/http.dart' as http;

class MediaMapper {
  const MediaMapper();

  List<Media> mapMediaList(http.Response data) {
    final decodedData = json.decode(data.body);

    // Decoded data object consists of error field if there was an error
    if (decodedData['errors'] != null) {
      throw Exception('Error from Anilist API: ${decodedData['errors']}');
    }

    // Check for expected data structure
    if (decodedData['data'] == null ||
        decodedData['data']['Page'] == null ||
        decodedData['data']['Page']['media'] == null ||
        decodedData['data']['Page']['pageInfo'] == null) {
      throw Exception('Invalid data format from Anilist API');
    }

    final mediaList = decodedData['data']['Page']['media'] as List;

    // Map each media item to Media model
    if (mediaList.isEmpty) {
      return [];
    }

    return mediaList.map((mediaJson) {
      final id = mediaJson['id'] as int;
      final title =
          mediaJson['title']['english'] as String? ??
          mediaJson['title']['romaji'] as String? ??
          'No Title';
      final imageUrl = mediaJson['coverImage']['large'] as String;
      return Media(id: id, title: title, imageUrl: imageUrl);
    }).toList();
  }
}

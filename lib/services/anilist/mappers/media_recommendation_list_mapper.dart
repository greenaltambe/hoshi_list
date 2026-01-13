import 'dart:convert';

import 'package:hoshi_list/models/media.dart';
import 'package:http/http.dart' as http;

class MediaRecommendationListMapper {
  const MediaRecommendationListMapper();

  List<Media> mapMediaList(http.Response data) {
    final decodedData = json.decode(data.body);

    // Decoded data object consists of error field if there was an error
    if (decodedData['errors'] != null) {
      throw Exception('Error from Anilist API: ${decodedData['errors']}');
    }

    // Check for expected data structure
    if (decodedData['data'] == null ||
        decodedData['data']['Media'] == null ||
        decodedData['data']['Media']['recommendations'] == null ||
        decodedData['data']['Media']['recommendations']['pageInfo'] == null ||
        decodedData['data']['Media']['recommendations']['nodes'] == null) {
      throw Exception('Invalid data format from Anilist API');
    }

    final mediaList =
        decodedData['data']['Media']['recommendations']['nodes'] as List;
    // Map each media item to Media model
    if (mediaList.isEmpty) {
      return [];
    }

    return mediaList.map((node) {
      final mediaJson = node['mediaRecommendation'];

      final id = mediaJson['id'] as int;

      final title =
          mediaJson['title']['english'] as String? ??
          mediaJson['title']['romaji'] as String? ??
          'No Title';

      final imageUrl = mediaJson['coverImage']['large'] as String;

      final avgScore = mediaJson['averageScore'] as int? ?? 0;

      final bannerImageUrl = mediaJson['bannerImage'] as String?;

      final description = mediaJson['description'] as String?;

      return Media(
        id: id,
        title: title,
        imageUrl: imageUrl,
        avgScore: avgScore,
        bannerImageUrl: bannerImageUrl,
        description: description,
        genres: const [], // recommendations query doesn't return genres
      );
    }).toList();
  }
}

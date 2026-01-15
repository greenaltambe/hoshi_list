import 'package:hoshi_list/models/constants/genre_list.dart';
import 'package:hoshi_list/models/media.dart';

class MediaMapper {
  const MediaMapper();

  Media fromJson(Map<String, dynamic> json) {
    final id = json['id'] as int;
    final title =
        json['title']['english'] as String? ??
        json['title']['romaji'] as String? ??
        'No Title';
    final imageUrl = json['coverImage']['large'] as String;
    final avgScore = json['averageScore'] as int? ?? 0;
    final bannerImageUrl = json['bannerImage'] as String?;
    final description = json['description'] as String?;
    final genresJson = json['genres'] as List<dynamic>?;
    final genres = genresJson != null
        ? genresJson.map((genre) {
            return stringToGenre[genre as String] ?? Genre.other;
          }).toList()
        : <Genre>[];
    return Media(
      id: id,
      title: title,
      imageUrl: imageUrl,
      avgScore: avgScore,
      bannerImageUrl: bannerImageUrl,
      description: description,
      genres: genres,
    );
  }
}

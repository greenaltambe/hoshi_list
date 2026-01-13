import 'package:hoshi_list/models/constants/media_relations.dart';
import 'package:hoshi_list/models/media_card_item.dart';

class RelatedMedia implements MediaCardItem {
  @override
  final int id;
  final String romajiTitle;
  final String coverImageUrl;
  final MediaRelations relationType;
  final int averageScore;

  @override
  String get title => romajiTitle;

  @override
  String get imageUrl => coverImageUrl;

  @override
  int get avgScore => averageScore;

  @override
  String? bannerImageUrl;

  RelatedMedia({
    required this.id,
    required this.romajiTitle,
    required this.coverImageUrl,
    required this.relationType,
    required this.averageScore,
    this.bannerImageUrl,
  });

  factory RelatedMedia.fromJson(Map<String, dynamic> edgesJson) {
    // Validate JSON structure
    if (edgesJson['relationType'] == null || edgesJson['node'] == null) {
      throw Exception('Invalid RelatedMedia JSON structure');
    }

    final relationType =
        stringToMediaRelations[edgesJson['relationType'] as String];

    if (relationType == null) {
      throw Exception('Unknown relation type: ${edgesJson['relationType']}');
    }

    final node = edgesJson['node'] as Map<String, dynamic>;

    final id = node['id'] as int;
    final title = node['title']['romaji'] as String? ?? 'No Title';
    final coverImageUrl = node['coverImage']['large'] as String;
    final averageScore = node['averageScore'] as int? ?? 0;
    final bannerImageUrl = node['bannerImage'] as String?;

    return RelatedMedia(
      id: id,
      romajiTitle: title,
      coverImageUrl: coverImageUrl,
      relationType: relationType,
      averageScore: averageScore,
      bannerImageUrl: bannerImageUrl,
    );
  }
}

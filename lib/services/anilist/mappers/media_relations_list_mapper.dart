import 'package:hoshi_list/models/related_media.dart';

class MediaRelationsListMapper {
  const MediaRelationsListMapper();

  List<RelatedMedia> mapMediaRelationsList(Map<String, dynamic> data) {
    if (data['data'] == null ||
        data['data']['Media'] == null ||
        data['data']['Media']['relations'] == null ||
        data['data']['Media']['relations']['edges'] == null) {
      throw Exception('Invalid data format from Anilist API');
    }

    final edges = data['data']['Media']['relations']['edges'] as List<dynamic>;
    final mappedEdges = edges.map((edge) {
      return RelatedMedia.fromJson(edge as Map<String, dynamic>);
    }).toList();

    if (mappedEdges.isEmpty) {
      return [];
    }
    return mappedEdges;
  }
}

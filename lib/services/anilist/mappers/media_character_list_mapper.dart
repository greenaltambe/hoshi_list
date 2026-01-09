import 'package:hoshi_list/models/media_character.dart';

class MediaCharacterListMapper {
  const MediaCharacterListMapper();

  List<MediaCharacter> fromJson(Map<String, dynamic>? characterListResponse) {
    if (characterListResponse == null) {
      return [];
    }

    if (characterListResponse['errors'] != null) {
      throw Exception(
        'Error from Anilist API: ${characterListResponse['errors']}',
      );
    }

    if (characterListResponse['data'] == null ||
        characterListResponse['data']['Media'] == null ||
        characterListResponse['data']['Media']['characters'] == null ||
        characterListResponse['data']['Media']['characters']['edges'] == null) {
      throw Exception('Invalid data format from Anilist API');
    }

    final characterEdges =
        characterListResponse['data']['Media']['characters']['edges'] as List;

    if (characterEdges.isEmpty) {
      return [];
    }

    if (characterEdges[0]['node'] == null ||
        characterEdges[0]['node']['name'] == null) {
      throw Exception('Invalid character data format from Anilist API');
    }

    return characterEdges.map((edge) {
      final node = edge['node'];
      final id = node['id'] as int;
      final role = edge['role'] as String;
      final name = node['name']['full'] as String;
      final imageUrl = node['image']['medium'] as String;
      return MediaCharacter(id: id, name: name, role: role, imageUrl: imageUrl);
    }).toList();
  }
}

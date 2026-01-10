import 'package:hoshi_list/models/media_character.dart';

class MediaCharacterMapper {
  const MediaCharacterMapper();

  MediaCharacter toMediaCharacter(Map<String, dynamic> json) {
    if (json['errors'] != null) {
      throw Exception('Error from Anilist API: ${json['errors']}');
    }

    if (json['data'] == null || json['data']['Character'] == null) {
      throw Exception('Invalid data format from Anilist API');
    }

    final characterJson = json['data']['Character'];

    final id = characterJson['id'] as int;

    final nameMap = characterJson['name'] as Map<String, dynamic>?;
    final fullName = nameMap?['full'] as String? ?? 'Unknown';

    final dateOfBirthJson = characterJson['dateOfBirth'];
    DateTime? dateOfBirth;
    if (dateOfBirthJson != null && dateOfBirthJson['year'] != null) {
      final year = dateOfBirthJson['year'] as int;
      final month = dateOfBirthJson['month'] as int? ?? 1;
      final day = dateOfBirthJson['day'] as int? ?? 1;
      dateOfBirth = DateTime(year, month, day);
    }

    final description = characterJson['description'] as String? ?? '';
    final favourites = characterJson['favourites'] as int? ?? 0;

    final imageUrl = (characterJson['image']?['large'] as String?) ?? '';

    String role = 'Unknown';
    final edges = characterJson['media']?['edges'] as List<dynamic>?;

    if (edges != null && edges.isNotEmpty) {
      role = edges[0]['characterRole'] as String? ?? 'Unknown';
    }

    return MediaCharacter(
      id: id,
      name: fullName,
      role: role,
      imageUrl: imageUrl,
      dateOfBirth: dateOfBirth,
      description: description,
      favourites: favourites,
    );
  }
}

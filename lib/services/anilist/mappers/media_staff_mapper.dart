import 'package:hoshi_list/models/staff.dart';

class MediaStaffMapper {
  const MediaStaffMapper();

  MediaStaff toStaff(Map<String, dynamic> json) {
    if (json['errors'] != null) {
      throw Exception('Error from Anilist API: ${json['errors']}');
    }

    if (json['data'] == null || json['data']['Staff'] == null) {
      throw Exception('Invalid data format from Anilist API');
    }

    final staffJson = json['data']['Staff'];
    final id = staffJson['id'] as int;

    final nameMap = staffJson['name'] as Map<String, dynamic>?;
    final fullName = nameMap?['full'] as String? ?? 'Unknown';

    final dateOfBirthJson = staffJson['dateOfBirth'];
    DateTime? dateOfBirth;
    if (dateOfBirthJson != null && dateOfBirthJson['year'] != null) {
      final year = dateOfBirthJson['year'] as int;
      final month = dateOfBirthJson['month'] as int? ?? 1;
      final day = dateOfBirthJson['day'] as int? ?? 1;
      dateOfBirth = DateTime(year, month, day);
    }

    final description = staffJson['description'] as String? ?? '';
    final favourites = staffJson['favourites'] as int? ?? 0;

    final imageUrl = (staffJson['image']?['large'] as String?) ?? '';

    String role = 'Unknown';
    final edges = staffJson['media']?['edges'] as List<dynamic>?;

    if (edges != null && edges.isNotEmpty) {
      role = edges[0]['characterRole'] as String? ?? 'Unknown';
    }

    return MediaStaff(
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

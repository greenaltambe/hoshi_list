import 'package:hoshi_list/models/staff.dart';

class MediaStaffListMapper {
  const MediaStaffListMapper();

  List<MediaStaff> toMediaStaffList(Map<String, dynamic>? staffListResponse) {
    if (staffListResponse == null) {
      return [];
    }

    if (staffListResponse['errors'] != null) {
      throw Exception('Error from Anilist API: ${staffListResponse['errors']}');
    }

    if (staffListResponse['data'] == null ||
        staffListResponse['data']['Media'] == null ||
        staffListResponse['data']['Media']['staff'] == null ||
        staffListResponse['data']['Media']['staff']['edges'] == null) {
      throw Exception('Invalid data format from Anilist API');
    }

    final staffEdges =
        staffListResponse['data']['Media']['staff']['edges'] as List;

    if (staffEdges.isEmpty) {
      return [];
    }

    if (staffEdges[0]['node'] == null ||
        staffEdges[0]['node']['name'] == null) {
      throw Exception('Invalid staff data format from Anilist API');
    }

    return staffEdges.map((edge) {
      final node = edge['node'];
      final id = node['id'] as int;
      final role = edge['role'] as String;
      final name = node['name']['full'] as String;
      final imageUrl = node['image']['medium'] as String;
      return MediaStaff(id: id, name: name, role: role, imageUrl: imageUrl);
    }).toList();
  }
}

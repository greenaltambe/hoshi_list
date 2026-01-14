import 'package:hoshi_list/models/user.dart';

class UserDetailsMapper {
  const UserDetailsMapper();

  User fromJson(Map<String, dynamic> json) {
    if (json['data'] == null || json['data']['Viewer'] == null) {
      throw Exception('Invalid JSON data');
    }

    final viewer = json['data']['Viewer'];
    final id = viewer['id'] as int;
    final name = viewer['name'] as String;
    final avatarUrl =
        viewer['avatar'] != null && viewer['avatar']['large'] != null
        ? viewer['avatar']['large'] as String
        : '';
    return User(id: id, name: name, avatarUrl: avatarUrl);
  }
}

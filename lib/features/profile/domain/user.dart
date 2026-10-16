import 'package:flutter/foundation.dart';

@immutable
class User {
  const User({
    required this.id,
    required this.name,
    required this.avatarUrl,
    this.about,
  });

  final int id;
  final String name;
  final String avatarUrl;
  final String? about;

  @override
  bool operator ==(Object other) =>
      other is User &&
      other.id == id &&
      other.name == name &&
      other.avatarUrl == avatarUrl &&
      other.about == about;

  @override
  int get hashCode => Object.hash(id, name, avatarUrl, about);
}

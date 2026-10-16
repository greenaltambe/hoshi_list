import 'package:hoshi_list/core/utils/api_enum.dart';

/// A character or a staff member: both have the same shape on AniList.
class MediaPerson {
  const MediaPerson({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.role,
    this.description,
    this.favourites,
    this.dateOfBirth,
  });

  final int id;
  final String name;
  final String imageUrl;

  /// Role in the media being viewed (e.g. "Main", "Director").
  final String? role;
  final String? description;
  final int? favourites;
  final DateTime? dateOfBirth;
}

enum PersonSort implements ApiEnum {
  relevance('RELEVANCE'),
  role('ROLE'),
  roleDesc('ROLE_DESC'),
  favourites('FAVOURITES'),
  favouritesDesc('FAVOURITES_DESC');

  const PersonSort(this.apiValue);

  @override
  final String apiValue;
}

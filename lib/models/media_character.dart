enum MediaCharacterSort { favorites, favoritesDesc, relevance, role, roleDesc }

class MediaCharacter {
  final int id;
  final String name;
  final String imageUrl;
  final String role; // MAIN / SUPPORTING / BACKGROUND

  final int page;
  final int perPage;

  final String? description;
  final int? favourites;

  final DateTime? dateOfBirth;

  final MediaCharacterSort sort;

  const MediaCharacter({
    required this.id,
    required this.name,
    required this.role,
    required this.imageUrl,
    this.dateOfBirth,
    this.description,
    this.favourites,
    this.page = 1,
    this.perPage = 10,
    this.sort = MediaCharacterSort.relevance,
  });
}

class MediaCharacterQueryAL {
  final int mediaId;
  final int page;
  final int perPage;
  final List<MediaCharacterSort> sort;

  const MediaCharacterQueryAL({
    required this.mediaId,
    this.page = 1,
    this.perPage = 10,
    this.sort = const [MediaCharacterSort.relevance],
  });

  MediaCharacterQueryAL copyWith({
    int? mediaId,
    int? page,
    int? perPage,
    List<MediaCharacterSort>? sort,
  }) {
    return MediaCharacterQueryAL(
      mediaId: mediaId ?? this.mediaId,
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
      sort: sort ?? this.sort,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is MediaCharacterQueryAL &&
            other.mediaId == mediaId &&
            other.page == page &&
            other.perPage == perPage &&
            other.sort == sort;
  }

  @override
  int get hashCode => Object.hash(mediaId, page, perPage, sort);
}

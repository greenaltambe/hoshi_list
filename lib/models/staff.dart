enum MediaStaffSort { favorites, favoritesDesc, relevance, role, roleDesc }

class MediaStaff {
  final int id;
  final String name;
  final String imageUrl;
  final String role;

  final int page;
  final int perPage;

  final String? description;
  final int? favourites;

  final DateTime? dateOfBirth;

  final MediaStaffSort sort;

  const MediaStaff({
    required this.id,
    required this.name,
    required this.role,
    required this.imageUrl,
    this.dateOfBirth,
    this.description,
    this.favourites,
    this.page = 1,
    this.perPage = 10,
    this.sort = MediaStaffSort.relevance,
  });
}

class MediaStaffQueryAL {
  final int mediaId;
  final int page;
  final int perPage;
  final List<MediaStaffSort> sort;

  const MediaStaffQueryAL({
    required this.mediaId,
    this.page = 1,
    this.perPage = 10,
    this.sort = const [MediaStaffSort.relevance],
  });

  MediaStaffQueryAL copyWith({
    int? mediaId,
    int? page,
    int? perPage,
    List<MediaStaffSort>? sort,
  }) {
    return MediaStaffQueryAL(
      mediaId: mediaId ?? this.mediaId,
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
      sort: sort ?? this.sort,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is MediaStaffQueryAL &&
            other.mediaId == mediaId &&
            other.page == page &&
            other.perPage == perPage &&
            other.sort == sort;
  }

  @override
  int get hashCode => Object.hash(mediaId, page, perPage, sort);
}

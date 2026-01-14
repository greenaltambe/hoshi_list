class User {
  final int id;
  final String name;
  final String avatarUrl;
  final String? about;

  User({
    required this.id,
    required this.name,
    required this.avatarUrl,
    this.about,
  });

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is User &&
            other.id == id &&
            other.name == name &&
            other.avatarUrl == avatarUrl &&
            other.about == about;
  }

  @override
  int get hashCode {
    return Object.hash(id, name, avatarUrl, about);
  }
}

// class AnimeStats {
//   final int count;
//   final int episodesWatched;
//   final double meanScore;

//   AnimeStats({
//     required this.count,
//     required this.episodesWatched,
//     required this.meanScore,
//   });
// }

// class MangaStats {
//   final int count;
//   final int chaptersRead;
//   final double meanScore;

//   MangaStats({
//     required this.count,
//     required this.chaptersRead,
//     required this.meanScore,
//   });
// }

class User {
  final int id;
  final String name;
  final String avatarUrl;

  final AnimeStats? animeStatistics;
  final MangaStats? mangaStatistics;

  User({
    required this.id,
    required this.name,
    required this.avatarUrl,
    this.animeStatistics,
    this.mangaStatistics,
  });

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is User &&
            other.id == id &&
            other.name == name &&
            other.avatarUrl == avatarUrl &&
            other.animeStatistics == animeStatistics &&
            other.mangaStatistics == mangaStatistics;
  }

  @override
  int get hashCode {
    return Object.hash(id, name, avatarUrl, animeStatistics, mangaStatistics);
  }
}

class AnimeStats {
  final int count;
  final int episodesWatched;
  final double meanScore;

  AnimeStats({
    required this.count,
    required this.episodesWatched,
    required this.meanScore,
  });
}

class MangaStats {
  final int count;
  final int chaptersRead;
  final double meanScore;

  MangaStats({
    required this.count,
    required this.chaptersRead,
    required this.meanScore,
  });
}

class UserProfile {
  final String username;
  final String avatarUrl;

  final AnimeStats animeStats;
  final MangaStats mangaStats;

  const UserProfile({
    required this.username,
    required this.avatarUrl,
    required this.animeStats,
    required this.mangaStats,
  });
}

class AnimeStats {
  final int total;
  final double daysWatched;
  final double meanScore;

  const AnimeStats({
    required this.total,
    required this.daysWatched,
    required this.meanScore,
  });
}

class MangaStats {
  final int total;
  final int chaptersRead;
  final double meanScore;

  const MangaStats({
    required this.total,
    required this.chaptersRead,
    required this.meanScore,
  });
}

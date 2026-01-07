class Media {
  Media({required this.id, required this.title, required this.imageUrl});

  final int id;
  final String title;
  final String imageUrl;
}

enum MediaFormat { tv, movie, ova, manga, novel }

enum MediaStatus { airing, finished, notYetReleased }

class MediaDetails {
  final int id;
  final String title;
  final String imageUrl;
  final String coverImageUrl;
  final String description;

  final MediaFormat format;
  final MediaStatus status;

  final DateTime? startDate;
  final int? episodes; // anime only
  final double? averageScore;

  final List<String> genres;

  MediaDetails({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.coverImageUrl,
    required this.description,
    required this.format,
    required this.status,
    this.startDate,
    this.episodes,
    this.averageScore,
    required this.genres,
  });
}

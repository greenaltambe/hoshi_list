import 'package:hoshi_list/models/media_list_query.dart';
import 'package:http/http.dart';

class Media {
  Media({required this.id, required this.title, required this.imageUrl});

  final int id;
  final String title;
  final String imageUrl;
}

enum MediaFormat {
  anime,
  manga,
  movie,
  music,
  novel,
  ona,
  oneShot,
  ova,
  special,
  tv,
  tvShort,
}

enum MediaStatus { cancelled, finished, hiatus, notYetReleased, releasing }

class MediaDetails {
  final int id;
  final String romajiTitle;
  final String? englishTitle;
  final String? nativeTitle;
  final String coverImageUrl;
  final String? bannerImageUrl;
  final String description;

  final MediaFormat format;
  final MediaStatus status;

  final DateTime? startDate;
  final int? episodes; // anime only
  final int? chapters; // manga only
  final double? averageScore;

  final List<String> genres;

  MediaDetails({
    required this.id,
    required this.romajiTitle,
    this.englishTitle,
    this.nativeTitle,
    required this.coverImageUrl,
    required this.description,
    required this.format,
    required this.status,
    this.bannerImageUrl,
    this.startDate,
    this.episodes,
    this.chapters,
    this.averageScore,
    required this.genres,
  });
}

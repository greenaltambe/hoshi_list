import 'package:hoshi_list/models/constants/external_links.dart';
import 'package:hoshi_list/models/constants/genre_list.dart';
import 'package:hoshi_list/models/constants/media_format.dart';
import 'package:hoshi_list/models/constants/media_status.dart';
import 'package:hoshi_list/models/constants/media_type.dart';

class Media {
  Media({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.avgScore,
    this.bannerImageUrl,
    this.description,
    this.genres,
  });

  final int id;
  final String title;
  final String imageUrl;
  final int avgScore;
  final String? bannerImageUrl;
  final String? description;
  final List<Genre>? genres;
}

class MediaDetails {
  final int id;
  final MediaTypeAL type;
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
  final String? season;
  final int? favourites;

  final List<Genre> genres;
  final List<ExternalLinks>? externalLinks;

  MediaDetails({
    required this.id,
    required this.type,
    required this.romajiTitle,
    this.englishTitle,
    this.nativeTitle,
    required this.coverImageUrl,
    required this.description,
    required this.format,
    required this.status,
    required this.genres,
    this.externalLinks,
    this.bannerImageUrl,
    this.startDate,
    this.episodes,
    this.chapters,
    this.averageScore,
    this.season,
    this.favourites,
  });
}

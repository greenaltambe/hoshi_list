import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hoshi_list/models/media.dart';
import 'package:hoshi_list/models/tracked_media.dart';
import 'package:hoshi_list/services/anilist/anilist_client.dart';
import 'package:hoshi_list/services/anilist/mappers/media_mapper.dart';

final alClient = AnilistClient();
final mediaMapper = MediaMapper();

// Provider to fetch trending media based on MediaType (anime or manga)
// The notifier provider is async and family to accept MediaType as a parameter
final trendingMediaProvider =
    AsyncNotifierProvider.family<MediaNotifier, List<Media>, MediaType>(
      MediaNotifier.new,
    );

// Here the MediaNotifier handles fetching and mapping the trending media
// Params are passed via the family provider and accepted in the constructor
class MediaNotifier extends AsyncNotifier<List<Media>> {
  MediaNotifier(this.mediaType);
  final MediaType mediaType;

  @override
  Future<List<Media>> build() async {
    final response = mediaType == MediaType.anime
        ? await alClient.fetchTrendingAnime()
        : await alClient.fetchTrendingManga();
    return mediaMapper.mapMediaList(response);
  }
}

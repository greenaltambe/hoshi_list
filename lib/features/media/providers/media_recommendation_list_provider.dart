import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hoshi_list/models/media.dart';
import 'package:hoshi_list/services/anilist/anilist_client.dart';
import 'package:hoshi_list/services/anilist/mappers/media_recommendation_list_mapper.dart';

final alClient = AnilistClient();
final mediaMapper = MediaRecommendationListMapper();

final mediaRecommendationListProvider =
    AsyncNotifierProvider.family<
      MediaRecommendationListProvider,
      List<Media>,
      int
    >(MediaRecommendationListProvider.new);

class MediaRecommendationListProvider extends AsyncNotifier<List<Media>> {
  MediaRecommendationListProvider(this.mediaId);
  final int mediaId;

  int _currentPage = 1;
  bool _hasNextPage = true;
  bool _isLoadingMore = false;

  @override
  Future<List<Media>> build() async {
    final response = await alClient.getMediaRecommendations(mediaId);
    final result = mediaMapper.mapMediaList(response);

    _currentPage++;
    _hasNextPage = result.isNotEmpty;

    return result;
  }

  Future<void> loadNextPage() async {
    if (_isLoadingMore || !_hasNextPage) return;

    _isLoadingMore = true;

    try {
      final response = await alClient.getMediaRecommendations(
        mediaId,
        page: _currentPage,
      );
      final nextItems = mediaMapper.mapMediaList(response);

      if (nextItems.isEmpty) {
        _hasNextPage = false;
        return;
      }

      _currentPage++;
      state = AsyncData([...state.value!, ...nextItems]);
    } catch (e, st) {
      state = AsyncError(e, st);
    } finally {
      _isLoadingMore = false;
    }
  }
}

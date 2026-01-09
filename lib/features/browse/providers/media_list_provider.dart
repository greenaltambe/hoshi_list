import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hoshi_list/models/media.dart';
import 'package:hoshi_list/models/media_query.dart';
import 'package:hoshi_list/services/anilist/anilist_client.dart';
import 'package:hoshi_list/services/anilist/mappers/media_mapper.dart';

final alClient = AnilistClient();
final mediaMapper = MediaMapper();

final mediaListProvider =
    AsyncNotifierProvider.family<MediaListNotifier, List<Media>, MediaQueryAL>(
      MediaListNotifier.new,
    );

class MediaListNotifier extends AsyncNotifier<List<Media>> {
  MediaListNotifier(this.mediaQuery);
  final MediaQueryAL mediaQuery;

  int _currentPage = 1;
  bool _hasNextPage = true;
  bool _isLoadingMore = false;

  @override
  Future<List<Media>> build() async {
    final response = await alClient.fetchMedia(mediaQuery);
    final result = mediaMapper.mapMediaList(response);

    _currentPage++;
    _hasNextPage = result.isNotEmpty;

    return result;
  }

  Future<void> loadNextPage() async {
    if (_isLoadingMore || !_hasNextPage) return;

    _isLoadingMore = true;

    try {
      final nextQuery = mediaQuery.copyWith(page: _currentPage);
      final response = await alClient.fetchMedia(nextQuery);
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

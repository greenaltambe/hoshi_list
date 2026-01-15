import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hoshi_list/models/media.dart';
import 'package:hoshi_list/models/media_list_query.dart';
import 'package:hoshi_list/services/anilist/anilist_client.dart';
import 'package:hoshi_list/services/anilist/anilist_provider.dart';
import 'package:hoshi_list/services/anilist/mappers/media_list_mapper.dart';

final mediaMapper = MediaListMapper();

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

  late final AnilistClient _alClient;

  @override
  Future<List<Media>> build() async {
    _alClient = ref.watch(anilistProvider);
    final response = await _alClient.fetchMedia(mediaQuery);
    final decodedData = jsonDecode(response.body) as Map<String, dynamic>;
    final result = mediaMapper.mapMediaList(decodedData);

    _currentPage++;
    _hasNextPage = result.isNotEmpty;

    return result;
  }

  Future<void> loadNextPage() async {
    if (_isLoadingMore || !_hasNextPage) return;

    _isLoadingMore = true;

    try {
      final nextQuery = mediaQuery.copyWith(page: _currentPage);
      final response = await _alClient.fetchMedia(nextQuery);
      final decodedData = jsonDecode(response.body) as Map<String, dynamic>;
      final nextItems = mediaMapper.mapMediaList(decodedData);

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

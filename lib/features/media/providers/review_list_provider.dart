import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hoshi_list/models/review.dart';
import 'package:hoshi_list/services/anilist/anilist_client.dart';
import 'package:hoshi_list/services/anilist/mappers/media_review_list_mapper.dart';

final alClient = AnilistClient();
final mediaReviewListMapper = MediaReviewListMapper();

final mediaReviewListProvider =
    AsyncNotifierProvider.family<
      MediaReviewListNotifier,
      List<MediaReview>,
      int
    >(MediaReviewListNotifier.new);

class MediaReviewListNotifier extends AsyncNotifier<List<MediaReview>> {
  MediaReviewListNotifier(this.id);

  final int id;

  int _currentPage = 1;
  bool _hasNextPage = true;
  bool _isLoadingMore = false;

  @override
  Future<List<MediaReview>> build() async {
    final response = await alClient.fetchMediaReviewList(
      MediaReviewQueryAL(
        mediaId: id,
        page: 1,
        perPage: 10,
        sort: [MediaReviewSort.scoreDesc],
      ),
    );

    final decodedResponse = jsonDecode(response.body);
    final result = mediaReviewListMapper.toMediaReviewList(decodedResponse);

    _currentPage++;
    _hasNextPage = result.isNotEmpty;

    return result;
  }

  Future<void> loadNextPage() async {
    if (_isLoadingMore || !_hasNextPage) return;

    _isLoadingMore = true;

    try {
      final nextQuery = MediaReviewQueryAL(
        mediaId: id,
        page: _currentPage,
        perPage: 10,
        sort: [MediaReviewSort.scoreDesc],
      );
      final response = await alClient.fetchMediaReviewList(nextQuery);
      final decodedResponse = jsonDecode(response.body);
      final nextItems = mediaReviewListMapper.toMediaReviewList(
        decodedResponse,
      );

      if (decodedResponse['data']['Media']['reviews']['pageInfo']['hasNextPage']
              as bool ==
          false) {
        _hasNextPage = false;
      } else {
        state = AsyncValue.data([...state.value!, ...nextItems]);
        _currentPage++;
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    } finally {
      _isLoadingMore = false;
    }
  }
}

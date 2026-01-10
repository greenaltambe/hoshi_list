import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hoshi_list/models/staff.dart';
import 'package:hoshi_list/services/anilist/anilist_client.dart';
import 'package:hoshi_list/services/anilist/mappers/media_staff_list_mapper.dart';

final alClient = AnilistClient();
final mediaStaffListMapper = MediaStaffListMapper();

final mediaStaffListProvider =
    AsyncNotifierProvider.family<MediaStaffListNotifier, List<MediaStaff>, int>(
      MediaStaffListNotifier.new,
    );

class MediaStaffListNotifier extends AsyncNotifier<List<MediaStaff>> {
  MediaStaffListNotifier(this.id);

  final int id;

  int _currentPage = 1;
  bool _hasNextPage = true;
  bool _isLoadingMore = false;

  @override
  Future<List<MediaStaff>> build() async {
    final response = await alClient.fetchMediaStaff(
      MediaStaffQueryAL(
        mediaId: id,
        page: _currentPage,
        sort: [MediaStaffSort.relevance],
      ),
    );

    final decodedResponse = jsonDecode(response.body);
    final result = mediaStaffListMapper.toMediaStaffList(decodedResponse);

    _currentPage++;
    _hasNextPage = result.isNotEmpty;

    return result;
  }

  Future<void> loadNextPage() async {
    if (_isLoadingMore || !_hasNextPage) return;

    _isLoadingMore = true;

    try {
      final nextQuery = MediaStaffQueryAL(
        mediaId: id,
        page: _currentPage,
        sort: [MediaStaffSort.relevance],
      );
      final response = await alClient.fetchMediaStaff(nextQuery);
      final decodedResponse = jsonDecode(response.body);
      final nextItems = mediaStaffListMapper.toMediaStaffList(decodedResponse);

      final pageInfo = decodedResponse['data']['Media']['staff']['pageInfo'];

      _hasNextPage = pageInfo['hasNextPage'] as bool;

      _currentPage++;
      state = AsyncData([...state.value!, ...nextItems]);
    } catch (e, st) {
      state = AsyncError(e, st);
    } finally {
      _isLoadingMore = false;
    }
  }
}

import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hoshi_list/models/media_character.dart';
import 'package:hoshi_list/services/anilist/anilist_client.dart';
import 'package:hoshi_list/services/anilist/anilist_provider.dart';
import 'package:hoshi_list/services/anilist/mappers/media_character_list_mapper.dart';

final mediaCharacterListMapper = MediaCharacterListMapper();

final mediaCharacterListProvider =
    AsyncNotifierProvider.family<
      MediaCharacterListNotifier,
      List<MediaCharacter>,
      int
    >(MediaCharacterListNotifier.new);

class MediaCharacterListNotifier extends AsyncNotifier<List<MediaCharacter>> {
  MediaCharacterListNotifier(this.id);

  final int id;

  int _currentPage = 1;
  bool _hasNextPage = true;
  bool _isLoadingMore = false;

  late final AnilistClient _alClient;

  @override
  Future<List<MediaCharacter>> build() async {
    _alClient = ref.watch(anilistProvider);
    final response = await _alClient.fetchMediaCharacters(
      MediaCharacterQueryAL(
        mediaId: id,
        page: _currentPage,
        sort: [MediaCharacterSort.role],
      ),
    );

    final decodedResponse = jsonDecode(response.body);
    final result = mediaCharacterListMapper.fromJson(decodedResponse);

    _currentPage++;
    _hasNextPage = result.isNotEmpty;

    return result;
  }

  Future<void> loadNextPage() async {
    if (_isLoadingMore || !_hasNextPage) return;

    _isLoadingMore = true;

    try {
      final nextQuery = MediaCharacterQueryAL(
        mediaId: id,
        page: _currentPage,
        sort: [MediaCharacterSort.relevance],
      );
      final response = await _alClient.fetchMediaCharacters(nextQuery);
      final decodedResponse = jsonDecode(response.body);
      final nextItems = mediaCharacterListMapper.fromJson(decodedResponse);

      final pageInfo =
          decodedResponse['data']['Media']['characters']['pageInfo'];

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

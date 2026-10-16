import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hoshi_list/core/network/anilist_client.dart';
import 'package:hoshi_list/core/utils/json.dart';
import 'package:hoshi_list/features/library/data/library_queries.dart';
import 'package:hoshi_list/features/library/domain/library_models.dart';
import 'package:hoshi_list/features/library/domain/media_list_status.dart';
import 'package:hoshi_list/features/media/data/media_mappers.dart';
import 'package:hoshi_list/features/media/domain/media_enums.dart';

class LibraryRepository {
  const LibraryRepository(this._client);

  final AnilistClient _client;

  Future<List<MediaListGroup>> collection(MediaType type, int userId) async {
    final data = await _client.query(mediaListCollectionQuery, {
      'type': type.apiValue,
      'userId': userId,
    });
    return guardParse(() => mapCollection(data));
  }

  /// The user's entry for [mediaId], or null if it isn't on their list.
  Future<MediaListEntryDetails?> entry(int mediaId) async {
    final data = await _client.query(mediaListEntryQuery, {'id': mediaId});
    return guardParse(() {
      final entry = data['Media']['mediaListEntry'] as Json?;
      return entry == null ? null : mapEntryDetails(entry);
    });
  }

  Future<void> save(MediaListEntryInput input) async {
    await _client.query(saveMediaListEntryMutation, {
      'mediaId': input.mediaId,
      'status': input.status.apiValue,
      'progress': input.progress,
      'scoreRaw': input.score,
      'repeat': input.repeat,
      'notes': input.notes,
      'startedAt': dateToJson(input.startedAt),
      'completedAt': dateToJson(input.completedAt),
    });
  }

  static List<MediaListGroup> mapCollection(Json data) {
    final lists =
        (data['MediaListCollection'] as Json)['lists'] as List<dynamic>;
    return [
      for (final list in lists.cast<Json>())
        MediaListGroup(
          name: list['name'] as String? ?? 'Unknown',
          isCustomList: list['isCustomList'] as bool? ?? false,
          status: MediaListStatus.fromApi(list['status'] as String?),
          entries: [
            for (final entry in (list['entries'] as List<dynamic>).cast<Json>())
              MediaListEntry(
                entryId: entry['id'] as int,
                score: (entry['score'] as num?)?.round() ?? 0,
                progress: entry['progress'] as int? ?? 0,
                media: mapMediaSummary(entry['media'] as Json),
              ),
          ],
        ),
    ];
  }

  static MediaListEntryDetails mapEntryDetails(Json entry) {
    return MediaListEntryDetails(
      mediaId: entry['mediaId'] as int,
      status: MediaListStatus.fromApi(entry['status'] as String?),
      progress: entry['progress'] as int?,
      score: (entry['score'] as num?)?.round(),
      repeat: entry['repeat'] as int?,
      notes: entry['notes'] as String?,
      startedAt: dateFromJson(entry['startedAt'] as Json?),
      completedAt: dateFromJson(entry['completedAt'] as Json?),
    );
  }
}

final libraryRepositoryProvider = Provider<LibraryRepository>(
  (ref) => LibraryRepository(ref.watch(anilistClientProvider)),
);

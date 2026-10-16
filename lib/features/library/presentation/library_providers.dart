import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hoshi_list/core/error/app_exception.dart';
import 'package:hoshi_list/features/library/data/library_repository.dart';
import 'package:hoshi_list/features/library/domain/library_models.dart';
import 'package:hoshi_list/features/media/domain/media_enums.dart';
import 'package:hoshi_list/features/profile/presentation/profile_providers.dart';

/// All of the current user's lists for one media type.
final libraryProvider = FutureProvider.family<List<MediaListGroup>, MediaType>((
  ref,
  type,
) async {
  final user = await ref.watch(currentUserProvider.future);
  if (user == null) throw const UnauthorizedException();
  return ref.watch(libraryRepositoryProvider).collection(type, user.id);
});

/// The user's saved data for one media item. Auto-disposed so the edit sheet
/// always opens with fresh data.
final mediaListEntryProvider = FutureProvider.autoDispose
    .family<MediaListEntryDetails?, int>(
      (ref, mediaId) => ref.watch(libraryRepositoryProvider).entry(mediaId),
    );

/// Writes to the user's library and refreshes everything that shows it.
class LibraryActions {
  const LibraryActions(this._ref);

  final Ref _ref;

  Future<void> save(MediaListEntryInput input, MediaType type) async {
    await _ref.read(libraryRepositoryProvider).save(input);
    _ref.invalidate(mediaListEntryProvider(input.mediaId));
    _ref.invalidate(libraryProvider(type));
  }
}

final libraryActionsProvider = Provider<LibraryActions>(LibraryActions.new);

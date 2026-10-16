import 'package:hoshi_list/core/utils/api_enum.dart';
import 'package:hoshi_list/features/media/domain/media_enums.dart';

/// The status of a media item in a user's list.
enum MediaListStatus implements ApiEnum {
  current('CURRENT'),
  planning('PLANNING'),
  completed('COMPLETED'),
  dropped('DROPPED'),
  paused('PAUSED'),
  repeating('REPEATING');

  const MediaListStatus(this.apiValue);

  @override
  final String apiValue;

  static MediaListStatus? fromApi(String? raw) => parseApiEnum(values, raw);

  /// "Watching" for anime, "Reading" for manga, etc.
  String label(MediaType type) {
    final isAnime = type == MediaType.anime;
    return switch (this) {
      current => isAnime ? 'Watching' : 'Reading',
      planning => isAnime ? 'Plan to Watch' : 'Plan to Read',
      completed => 'Completed',
      dropped => 'Dropped',
      paused => 'Paused',
      repeating => isAnime ? 'Rewatching' : 'Rereading',
    };
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hoshi_list/core/network/anilist_client.dart';
import 'package:hoshi_list/core/utils/json.dart';
import 'package:hoshi_list/features/profile/domain/user.dart';

const _viewerQuery = r'''
query Viewer {
  Viewer { id name about avatar { large } }
}
''';

class ProfileRepository {
  const ProfileRepository(this._client);

  final AnilistClient _client;

  /// The user the current access token belongs to.
  Future<User> viewer() async {
    final data = await _client.query(_viewerQuery);
    return guardParse(() => mapViewer(data['Viewer'] as Json));
  }

  static User mapViewer(Json viewer) => User(
    id: viewer['id'] as int,
    name: viewer['name'] as String,
    about: viewer['about'] as String?,
    avatarUrl: (viewer['avatar'] as Json?)?['large'] as String? ?? '',
  );
}

final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => ProfileRepository(ref.watch(anilistClientProvider)),
);

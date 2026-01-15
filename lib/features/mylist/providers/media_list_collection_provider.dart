import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hoshi_list/models/constants/media_type.dart';
import 'package:hoshi_list/services/anilist/anilist_provider.dart';
import 'package:hoshi_list/services/anilist/mappers/media_list_collection_mapper.dart';

class MediaCollectionArgs {
  final MediaTypeAL mediaType;
  final int userId;

  MediaCollectionArgs({required this.mediaType, required this.userId});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is MediaCollectionArgs &&
            other.mediaType == mediaType &&
            other.userId == userId;
  }

  @override
  int get hashCode => Object.hash(mediaType, userId);
}

// This provideer fetches collections of media based on media type al, it is only a future provider as the data is only going to be fetched once, not paginated
final mediaCollectionProvider = FutureProvider.family((
  ref,
  MediaCollectionArgs args,
) async {
  final alClient = ref.watch(anilistProvider);
  final response = await alClient.fetchMediaListCollection(
    args.mediaType,
    args.userId,
  );

  final decodedData = jsonDecode(response.body) as Map<String, dynamic>;
  return MediaListCollectionMapper().fromJson(decodedData);
});

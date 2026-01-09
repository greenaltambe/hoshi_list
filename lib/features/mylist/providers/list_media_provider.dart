import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hoshi_list/data/dummy_tracked_media.dart';
import 'package:hoshi_list/models/media_list_query.dart';
import 'package:hoshi_list/models/tracked_media.dart';

final listMediaProvider = Provider.family<List<TrackedMedia>, MediaTypeAL>((
  ref,
  mediaType,
) {
  // Dummy data for illustration; replace with actual data fetching logic
  if (mediaType == MediaTypeAL.anime) {
    return dummyTrackedMedia
        .where((media) => media.type == MediaTypeAL.anime)
        .toList();
  } else {
    return dummyTrackedMedia
        .where((media) => media.type == MediaTypeAL.manga)
        .toList();
  }
});

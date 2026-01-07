import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hoshi_list/data/dummy_tracked_media.dart';
import 'package:hoshi_list/models/tracked_media.dart';

final listMediaProvider = Provider.family<List<TrackedMedia>, MediaType>((
  ref,
  mediaType,
) {
  // Dummy data for illustration; replace with actual data fetching logic
  if (mediaType == MediaType.anime) {
    return dummyTrackedMedia
        .where((media) => media.type == MediaType.anime)
        .toList();
  } else {
    return dummyTrackedMedia
        .where((media) => media.type == MediaType.manga)
        .toList();
  }
});

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hoshi_list/features/mylist/providers/list_media_provider.dart';
import 'package:hoshi_list/models/media_list_query.dart';
import 'package:hoshi_list/models/tracked_media.dart';

final filteredTrackedMediaProvider =
    Provider.family<
      List<TrackedMedia>,
      ({MediaTypeAL type, TrackStatus status})
    >((ref, filter) {
      final all = ref.watch(listMediaProvider(filter.type));

      return all.where((item) {
        return item.type == filter.type && item.status == filter.status;
      }).toList();
    });

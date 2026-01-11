import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hoshi_list/features/mylist/providers/filtered_list_media_provider.dart';
import 'package:hoshi_list/features/mylist/widgets/tracking_list_item.dart';
import 'package:hoshi_list/models/constants/media_type.dart';
import 'package:hoshi_list/models/tracked_media.dart';

class TrackingList extends ConsumerWidget {
  const TrackingList({
    super.key,
    required this.mediaType,
    required this.status,
  });

  final MediaTypeAL mediaType;
  final TrackStatus status;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentMedia = ref.watch(
      filteredTrackedMediaProvider((type: mediaType, status: status)),
    );
    return ListView.builder(
      itemCount: currentMedia.length,
      itemBuilder: (context, index) {
        final media = currentMedia[index];
        return TrackingListItem(trackedMedia: media);
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hoshi_list/features/mylist/widgets/tracking_list_item.dart';
import 'package:hoshi_list/models/media_list_group.dart';

class TrackingList extends ConsumerWidget {
  const TrackingList({super.key, required this.group});

  final MediaListGroup group;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      itemCount: group.entries.length,
      itemBuilder: (context, index) {
        final media = group.entries[index];
        return TrackingListItem(mediaItem: media);
      },
    );
  }
}

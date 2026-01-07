import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hoshi_list/features/home/providers/activity_provider.dart';
import 'package:hoshi_list/features/media/providers/media_details_provider.dart';

class ActivityList extends ConsumerWidget {
  const ActivityList({super.key, required this.activityFeedType});
  final ActivityFeedType activityFeedType;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activities = ref.watch(activityProvider(activityFeedType));
    return ListView.builder(
      itemCount: activities.length,
      itemBuilder: (context, index) {
        final activity = activities[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
            child: ListTile(
              title: Text(activity.username),
              subtitle: Text(
                '${activity.type.toString()} - ${activity.mediaTitle}',
              ),
              leading: activity.imageUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(activity.imageUrl!),
                    )
                  : null,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.thumb_up, size: 16),
                  SizedBox(width: 4),
                  Text(activity.likes.toString()),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

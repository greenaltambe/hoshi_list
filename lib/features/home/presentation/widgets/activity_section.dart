import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hoshi_list/features/home/domain/activity.dart';
import 'package:hoshi_list/features/home/presentation/home_providers.dart';

class ActivitySection extends StatelessWidget {
  const ActivitySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'Activity',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                const TabBar(
                  isScrollable: true,
                  indicator: BoxDecoration(),
                  dividerColor: Colors.transparent,
                  tabs: [
                    Tab(text: 'Following'),
                    Tab(text: 'Global'),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 300,
              child: TabBarView(
                children: [
                  _ActivityList(feed: ActivityFeed.following),
                  _ActivityList(feed: ActivityFeed.global),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityList extends ConsumerWidget {
  const _ActivityList({required this.feed});

  final ActivityFeed feed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activities = ref.watch(activityProvider(feed));
    return ListView.builder(
      itemCount: activities.length,
      itemBuilder: (context, index) {
        final activity = activities[index];
        return Card(
          child: ListTile(
            title: Text(activity.username),
            subtitle: Text(_describe(activity)),
            leading: activity.imageUrl == null
                ? null
                : ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(activity.imageUrl!),
                  ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.thumb_up, size: 16),
                const SizedBox(width: 4),
                Text('${activity.likes}'),
              ],
            ),
          ),
        );
      },
    );
  }

  String _describe(Activity activity) => switch (activity.type) {
    ActivityType.watched => 'Watched ${activity.mediaTitle}',
    ActivityType.read => 'Read ${activity.mediaTitle}',
    ActivityType.status => activity.statusText ?? '',
  };
}

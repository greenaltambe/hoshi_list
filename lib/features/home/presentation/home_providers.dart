import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hoshi_list/features/home/data/placeholder_activity.dart';
import 'package:hoshi_list/features/home/domain/activity.dart';

enum ActivityFeed { following, global }

final activityProvider = Provider.family<List<Activity>, ActivityFeed>((
  ref,
  feed,
) {
  return switch (feed) {
    ActivityFeed.following =>
      placeholderActivities.where((a) => !a.isDonator).toList(),
    ActivityFeed.global => placeholderActivities,
  };
});

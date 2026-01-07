import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hoshi_list/models/activity.dart';
import 'package:hoshi_list/data/dummy_activity.dart';

enum ActivityFeedType { following, global }

final activityProvider = Provider.family<List<Activity>, ActivityFeedType>((
  ref,
  feedType,
) {
  switch (feedType) {
    case ActivityFeedType.following:
      return dummyActivityList
          .where((activity) => !activity.isDonator) // example logic
          .toList();

    case ActivityFeedType.global:
      return dummyActivityList;
  }
});

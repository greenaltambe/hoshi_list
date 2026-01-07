import 'package:flutter/material.dart';
import 'package:hoshi_list/features/home/providers/activity_provider.dart';
import 'package:hoshi_list/features/home/widgets/activity_list.dart';

class ActivityTab extends StatelessWidget {
  const ActivityTab({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Material(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Activity',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Spacer(),
                  TabBar(
                    indicator: BoxDecoration(),
                    splashBorderRadius: BorderRadius.circular(16),
                    isScrollable: true,
                    dividerColor: Colors.transparent,
                    tabs: [
                      Tab(text: 'Following'),
                      Tab(text: 'Global'),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 300, // Set a fixed height for the TabBarView
              child: TabBarView(
                children: [
                  ActivityList(activityFeedType: ActivityFeedType.following),
                  ActivityList(activityFeedType: ActivityFeedType.global),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

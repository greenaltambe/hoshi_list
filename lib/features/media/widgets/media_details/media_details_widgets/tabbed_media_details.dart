import 'package:flutter/material.dart';
import 'package:hoshi_list/features/media/widgets/media_details/media_detail_tabs/characters_list_tab.dart';
import 'package:hoshi_list/features/media/widgets/media_details/media_detail_tabs/overview_tab.dart';
import 'package:hoshi_list/features/media/widgets/media_details/media_detail_tabs/staff_list_tab.dart';
import 'package:hoshi_list/models/media.dart';

class TabbedMediaDetails extends StatelessWidget {
  const TabbedMediaDetails({super.key, required this.mediaDetails});

  final MediaDetails mediaDetails;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Column(
        children: [
          Material(
            child: const TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,

              tabs: [
                Tab(icon: Icon(Icons.info), text: 'Overview'),
                Tab(icon: Icon(Icons.list), text: 'Characters'),
                Tab(icon: Icon(Icons.person), text: 'Staff'),
                Tab(icon: Icon(Icons.bar_chart), text: 'Stats'),
                Tab(icon: Icon(Icons.reviews), text: 'Reviews'),
              ],
            ),
          ),

          SizedBox(
            height: 400,
            child: TabBarView(
              children: [
                OverviewTab(mediaDetails: mediaDetails),
                CharactersListTab(mediaId: mediaDetails.id),
                StaffListTab(mediaId: mediaDetails.id),
                Center(child: Text('Stats Content')),
                Center(child: Text('Reviews Content')),
                // Add more tabs as needed
              ],
            ),
          ),
        ],
      ),
    );
  }
}

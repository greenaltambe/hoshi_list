import 'package:flutter/material.dart';
import 'package:hoshi_list/features/mylist/widgets/tracking_list.dart';
import 'package:hoshi_list/models/media_query.dart';
import 'package:hoshi_list/models/tracked_media.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ListScreenState();
  }
}

class _ListScreenState extends State<ListScreen> {
  var _selectedMediaType = MediaTypeAL.anime; // Default selection

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DefaultTabController(
        length: 4,
        child: Column(
          children: [
            SegmentedButton(
              showSelectedIcon: false,
              style: SegmentedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              segments: [
                ButtonSegment<MediaTypeAL>(
                  value: MediaTypeAL.anime,
                  label: Text('Anime'),
                ),
                ButtonSegment<MediaTypeAL>(
                  value: MediaTypeAL.manga,
                  label: Text('Manga'),
                ),
              ],
              selected: {_selectedMediaType},
              onSelectionChanged: (Set<MediaTypeAL> newSelection) {
                setState(() {
                  // Update the selected media type
                  _selectedMediaType = newSelection.first;
                });
              },
            ),
            TabBar(
              tabAlignment: TabAlignment.center,
              isScrollable: true,
              splashBorderRadius: BorderRadius.circular(16),
              tabs: [
                Tab(text: 'Planned'),
                Tab(text: 'Completed'),
                Tab(text: 'Watching'),
                Tab(text: 'On Hold'),
              ],
            ),

            Expanded(
              child: TabBarView(
                children: [
                  TrackingList(
                    mediaType: _selectedMediaType,
                    status: TrackStatus.planned,
                  ),
                  TrackingList(
                    mediaType: _selectedMediaType,
                    status: TrackStatus.completed,
                  ),
                  TrackingList(
                    mediaType: _selectedMediaType,
                    status: TrackStatus.inProgress,
                  ),
                  TrackingList(
                    mediaType: _selectedMediaType,
                    status: TrackStatus.onHold,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

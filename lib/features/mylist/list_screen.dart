import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hoshi_list/features/mylist/providers/media_list_collection_provider.dart';
import 'package:hoshi_list/features/mylist/widgets/tracking_list.dart';
import 'package:hoshi_list/features/profile/providers/user_profile_provider.dart';
import 'package:hoshi_list/models/constants/media_type.dart';

class ListScreen extends ConsumerStatefulWidget {
  const ListScreen({super.key});

  @override
  ConsumerState<ListScreen> createState() {
    return _ListScreenState();
  }
}

class _ListScreenState extends ConsumerState<ListScreen> {
  var _selectedMediaType = MediaTypeAL.anime; // Default selection

  @override
  Widget build(BuildContext context) {
    final userId = ref.watch(userProfileProvider).value?.id;
    if (userId == null) {
      return const Center(
        child: Center(
          child: Column(children: [Text('Please log in to view your list.')]),
        ),
      );
    }

    final mediaListCollection = ref.watch(
      mediaCollectionProvider(
        MediaCollectionArgs(mediaType: _selectedMediaType, userId: userId),
      ),
    );

    return Center(
      child: mediaListCollection.when(
        loading: () {
          return const Center(child: CircularProgressIndicator());
        },
        error: (error, stackTrace) {
          return Center(child: Text('Error loading list: $error'));
        },
        data: (data) {
          final groups = data;

          if (groups.isEmpty) {
            return const Center(
              child: Text(
                'Your list is empty. Start adding some media! (Baka)',
              ),
            );
          }

          return DefaultTabController(
            length: data.length,
            child: Column(
              children: [
                // The anime <-> manga toggle button
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

                // The tabs for different lists (including custom lists)
                TabBar(
                  tabAlignment: TabAlignment.center,
                  isScrollable: true,
                  splashBorderRadius: BorderRadius.circular(16),
                  tabs: groups.map((group) => Tab(text: group.name)).toList(),
                ),

                Expanded(
                  // The content of each tab
                  child: TabBarView(
                    children: groups.map((group) {
                      return TrackingList(group: group);
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

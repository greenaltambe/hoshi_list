import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hoshi_list/features/media/widgets/media_details/media_detail_tabs/characters_list_tab.dart';
import 'package:hoshi_list/features/media/widgets/media_details/media_detail_tabs/overview_tab.dart';
import 'package:hoshi_list/features/media/widgets/media_details/media_detail_tabs/relations_tab.dart';
import 'package:hoshi_list/features/media/widgets/media_details/media_detail_tabs/review_list_tab.dart';
import 'package:hoshi_list/features/media/widgets/media_details/media_detail_tabs/staff_list_tab.dart';
import 'package:hoshi_list/models/media.dart';
import 'package:hoshi_list/features/media/providers/media_details_provider.dart';
import 'package:hoshi_list/features/media/widgets/media_details/media_details_widgets/header_info.dart';

class MediaDetailsScreen extends ConsumerStatefulWidget {
  const MediaDetailsScreen({super.key, this.item, this.mediaId});

  const MediaDetailsScreen.fromId({super.key, required this.mediaId})
    : item = null;

  final Media? item;
  final int? mediaId;

  @override
  ConsumerState<MediaDetailsScreen> createState() => _MediaDetailsScreenState();
}

class _MediaDetailsScreenState extends ConsumerState<MediaDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final mediaDetails = ref.watch(
      mediaDetailsProvider(widget.item?.id ?? widget.mediaId!),
    );

    final topPadding = MediaQuery.of(context).padding.top;

    return DefaultTabController(
      length: 6,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: mediaDetails.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
          data: (mediaDetails) {
            return NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                // Back button and top bar
                // const SliverAppBar(pinned: false, floating: true, elevation: 0),

                // Main header info (image, title, score, etc)
                SliverToBoxAdapter(
                  child: Column(
                    children: [HeaderInfoSection(mediaDetails: mediaDetails)],
                  ),
                ),

                // Tab bar (sliver for sticky behavior)
                SliverPersistentHeader(
                  pinned: true, // for sticky behavior
                  delegate: SliverAppBarDelegate(
                    topPadding: topPadding,
                    tabBar: const TabBar(
                      isScrollable: true,
                      tabAlignment: TabAlignment.start,
                      tabs: [
                        Tab(icon: Icon(Icons.info), text: 'Overview'),
                        Tab(icon: Icon(Icons.link), text: 'Relations'),
                        Tab(icon: Icon(Icons.list), text: 'Characters'),
                        Tab(icon: Icon(Icons.reviews), text: 'Reviews'),
                        Tab(icon: Icon(Icons.person), text: 'Staff'),
                        Tab(icon: Icon(Icons.bar_chart), text: 'Stats'),
                      ],
                    ),
                  ),
                ),
              ],

              // The body with tab views
              body: TabBarView(
                children: [
                  OverviewTab(mediaDetails: mediaDetails),
                  RelationsTab(mediaId: mediaDetails.id),
                  CharactersListTab(mediaId: mediaDetails.id),
                  ReviewListTab(mediaId: mediaDetails.id),
                  StaffListTab(mediaId: mediaDetails.id),
                  Center(child: Text('Stats Content')),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// The SliverAppBarDelegate class to create a sticky TabBar (tab header)
class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  SliverAppBarDelegate({required this.tabBar, required this.topPadding});

  final TabBar tabBar;
  final double topPadding;

  @override
  double get minExtent => tabBar.preferredSize.height + topPadding;

  @override
  double get maxExtent => tabBar.preferredSize.height + topPadding;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      // Push the TabBar down by the status bar height
      padding: EdgeInsets.only(top: topPadding),
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
    return oldDelegate.tabBar != tabBar || oldDelegate.topPadding != topPadding;
  }
}

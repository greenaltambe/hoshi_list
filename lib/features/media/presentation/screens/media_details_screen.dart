import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hoshi_list/core/widgets/async_value_view.dart';
import 'package:hoshi_list/features/library/presentation/widgets/media_entry_sheet.dart';
import 'package:hoshi_list/features/media/presentation/providers/media_providers.dart';
import 'package:hoshi_list/features/media/presentation/widgets/details/characters_tab.dart';
import 'package:hoshi_list/features/media/presentation/widgets/details/media_header.dart';
import 'package:hoshi_list/features/media/presentation/widgets/details/overview_tab.dart';
import 'package:hoshi_list/features/media/presentation/widgets/details/relations_tab.dart';
import 'package:hoshi_list/features/media/presentation/widgets/details/reviews_tab.dart';
import 'package:hoshi_list/features/media/presentation/widgets/details/staff_tab.dart';

class MediaDetailsScreen extends ConsumerWidget {
  const MediaDetailsScreen({super.key, required this.mediaId});

  final int mediaId;

  static Future<void> open(BuildContext context, int mediaId) {
    return Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => MediaDetailsScreen(mediaId: mediaId)),
    );
  }

  static const _tabs = [
    Tab(icon: Icon(Icons.info), text: 'Overview'),
    Tab(icon: Icon(Icons.link), text: 'Relations'),
    Tab(icon: Icon(Icons.list), text: 'Characters'),
    Tab(icon: Icon(Icons.reviews), text: 'Reviews'),
    Tab(icon: Icon(Icons.person), text: 'Staff'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final details = ref.watch(mediaDetailsProvider(mediaId));
    final topPadding = MediaQuery.paddingOf(context).top;

    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        floatingActionButton: details.whenOrNull(
          data: (media) => FloatingActionButton.extended(
            onPressed: () => showMediaEntrySheet(context, media),
            label: const Text('Edit'),
            icon: const Icon(Icons.edit),
          ),
        ),
        body: AsyncValueView(
          value: details,
          onRetry: () => ref.invalidate(mediaDetailsProvider(mediaId)),
          data: (media) => NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverToBoxAdapter(child: MediaHeader(media: media)),
              SliverPersistentHeader(
                pinned: true,
                delegate: _PinnedTabBarDelegate(
                  topPadding: topPadding,
                  tabBar: const TabBar(
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    tabs: _tabs,
                  ),
                ),
              ),
            ],
            body: TabBarView(
              children: [
                OverviewTab(media: media),
                RelationsTab(mediaId: media.id),
                CharactersTab(mediaId: media.id),
                ReviewsTab(mediaId: media.id),
                StaffTab(mediaId: media.id),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Keeps the tab bar pinned below the status bar while the header scrolls.
class _PinnedTabBarDelegate extends SliverPersistentHeaderDelegate {
  const _PinnedTabBarDelegate({required this.tabBar, required this.topPadding});

  final TabBar tabBar;
  final double topPadding;

  @override
  double get minExtent => tabBar.preferredSize.height + topPadding;

  @override
  double get maxExtent => minExtent;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: EdgeInsets.only(top: topPadding),
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_PinnedTabBarDelegate oldDelegate) =>
      oldDelegate.tabBar != tabBar || oldDelegate.topPadding != topPadding;
}

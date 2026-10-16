import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hoshi_list/features/media/domain/media_browse_query.dart';
import 'package:hoshi_list/features/media/domain/media_enums.dart';
import 'package:hoshi_list/features/media/presentation/providers/media_providers.dart';
import 'package:hoshi_list/features/media/presentation/screens/media_grid_screen.dart';
import 'package:hoshi_list/features/media/presentation/widgets/media_carousel.dart';

class BrowseScreen extends StatelessWidget {
  const BrowseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: MediaType.values.length,
      child: Column(
        children: [
          TabBar(
            tabs: [for (final type in MediaType.values) Tab(text: type.label)],
          ),
          Expanded(
            child: TabBarView(
              children: [
                for (final type in MediaType.values) _BrowseTab(type: type),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BrowseTab extends StatelessWidget {
  const _BrowseTab({required this.type});

  final MediaType type;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _QueryCarousel(
            title: 'Trending ${type.label}',
            query: MediaBrowseQuery(type: type, sort: MediaSort.trendingDesc),
            style: MediaCardStyle.banner,
          ),
          const SizedBox(height: 16),
          _QueryCarousel(
            title: 'Popular ${type.label}',
            query: MediaBrowseQuery(type: type, sort: MediaSort.popularityDesc),
          ),
          const SizedBox(height: 16),
          _QueryCarousel(
            title: 'Top Rated ${type.label}',
            query: MediaBrowseQuery(type: type, sort: MediaSort.scoreDesc),
          ),
        ],
      ),
    );
  }
}

class _QueryCarousel extends ConsumerWidget {
  const _QueryCarousel({
    required this.title,
    required this.query,
    this.style = MediaCardStyle.poster,
  });

  final String title;
  final MediaBrowseQuery query;
  final MediaCardStyle style;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MediaCarousel(
      title: title,
      style: style,
      items: ref.watch(mediaListProvider(query)).whenData((p) => p.items),
      onRetry: () => ref.invalidate(mediaListProvider(query)),
      onEndReached: ref.read(mediaListProvider(query).notifier).loadMore,
      onTitleTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => MediaGridScreen(query: query, title: title),
        ),
      ),
    );
  }
}

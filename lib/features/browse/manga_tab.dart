import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hoshi_list/features/browse/providers/trending_media_provider.dart';
import 'package:hoshi_list/features/media/widgets/horizontal_media_list/error_horizontal_media_list.dart';
import 'package:hoshi_list/features/media/widgets/horizontal_media_list/horizontal_media_list.dart';
import 'package:hoshi_list/data/dummy_manga.dart';
import 'package:hoshi_list/features/media/widgets/horizontal_media_list/loading_horizontal_media_list.dart';
import 'package:hoshi_list/models/tracked_media.dart';

class MangaBrowseScreen extends ConsumerWidget {
  const MangaBrowseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trendingManga = ref.watch(trendingMediaProvider(MediaType.manga));

    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            trendingManga.when(
              loading: () => LoadingHorizontalMediaList(),
              error: (e, st) => ErrorHorizontalMediaList(),
              data: (items) =>
                  HorizontalMediaList(items: items, title: 'Trending Manga'),
            ),
            SizedBox(height: 16),
            SizedBox(height: 16),
            HorizontalMediaList(
              items: dummyMangaList,
              title: 'Top Rated Manga',
            ),
            SizedBox(height: 16),
            HorizontalMediaList(items: dummyMangaList, title: 'New Releases'),
          ],
        ),
      ),
    );
  }
}

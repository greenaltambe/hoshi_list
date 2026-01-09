import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hoshi_list/features/browse/providers/trending_media_provider.dart';
import 'package:hoshi_list/features/media/widgets/horizontal_media_list/error_horizontal_media_list.dart';
import 'package:hoshi_list/features/media/widgets/horizontal_media_list/horizontal_media_list.dart';
import 'package:hoshi_list/data/dummy_anime.dart';
import 'package:hoshi_list/features/media/widgets/horizontal_media_list/loading_horizontal_media_list.dart';
import 'package:hoshi_list/models/tracked_media.dart';

class AnimeBrowseScreen extends ConsumerWidget {
  const AnimeBrowseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trendingAnime = ref.watch(trendingMediaProvider(MediaType.anime));

    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            trendingAnime.when(
              loading: () => LoadingHorizontalMediaList(),
              error: (e, st) => ErrorHorizontalMediaList(),
              data: (items) =>
                  HorizontalMediaList(items: items, title: 'Trending anime'),
            ),
            SizedBox(height: 16),
            HorizontalMediaList(items: dummyAnimeList, title: 'New Releases'),
            SizedBox(height: 16),
            HorizontalMediaList(items: dummyAnimeList, title: 'New Releases'),
          ],
        ),
      ),
    );
  }
}

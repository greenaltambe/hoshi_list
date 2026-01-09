import 'package:flutter/material.dart';
import 'package:hoshi_list/features/media/widgets/media_list/horizontal_media_list/horizontal_media_list.dart';
import 'package:hoshi_list/models/media_list_query.dart';

class AnimeBrowseScreen extends StatelessWidget {
  const AnimeBrowseScreen({super.key});

  final _trendingQuery = const MediaQueryAL(
    type: MediaTypeAL.anime,
    sort: MediaSort.trendingDesc,
  );
  final _popularQuery = const MediaQueryAL(
    type: MediaTypeAL.anime,
    sort: MediaSort.popularityDesc,
  );
  final _topRatedQuery = const MediaQueryAL(
    type: MediaTypeAL.anime,
    sort: MediaSort.scoreDesc,
  );

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            HorizontalMediaList(query: _trendingQuery, title: 'Trending Anime'),
            SizedBox(height: 16),
            HorizontalMediaList(query: _popularQuery, title: 'Popular Anime'),
            SizedBox(height: 16),
            HorizontalMediaList(
              query: _topRatedQuery,
              title: 'Top Rated Anime',
            ),
          ],
        ),
      ),
    );
  }
}

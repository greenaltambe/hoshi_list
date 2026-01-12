import 'package:flutter/material.dart';
import 'package:hoshi_list/features/media/widgets/media_list/horizontal_media_list/expanded_horizontal_media_list.dart';
import 'package:hoshi_list/features/media/widgets/media_list/horizontal_media_list/horizontal_media_list.dart';
import 'package:hoshi_list/models/constants/media_sort.dart';
import 'package:hoshi_list/models/constants/media_type.dart';
import 'package:hoshi_list/models/media_list_query.dart';

class MangaBrowseScreen extends StatelessWidget {
  const MangaBrowseScreen({super.key});

  final _trendingQuery = const MediaQueryAL(
    type: MediaTypeAL.manga,
    sort: MediaSort.trendingDesc,
  );
  final _popularQuery = const MediaQueryAL(
    type: MediaTypeAL.manga,
    sort: MediaSort.popularityDesc,
  );
  final _topRatedQuery = const MediaQueryAL(
    type: MediaTypeAL.manga,
    sort: MediaSort.scoreDesc,
  );

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            ExpandedHorizontalMediaList(
              query: _trendingQuery,
              title: 'Trending Manga',
            ),
            SizedBox(height: 16),
            HorizontalMediaList(query: _popularQuery, title: 'Popular Manga'),
            SizedBox(height: 16),
            HorizontalMediaList(
              query: _topRatedQuery,
              title: 'Top Rated Manga',
            ),
          ],
        ),
      ),
    );
  }
}

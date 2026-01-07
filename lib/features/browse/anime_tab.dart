import 'package:flutter/material.dart';
import 'package:hoshi_list/features/browse/widgets/horizontal_list.dart';
import 'package:hoshi_list/data/dummy_anime.dart';

class AnimeBrowseScreen extends StatelessWidget {
  const AnimeBrowseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            HorizontalList(items: dummyAnimeList, title: 'Trending Anime'),
            SizedBox(height: 16),
            HorizontalList(items: dummyAnimeList, title: 'Top Rated Anime'),
            SizedBox(height: 16),
            HorizontalList(items: dummyAnimeList, title: 'New Releases'),
          ],
        ),
      ),
    );
  }
}

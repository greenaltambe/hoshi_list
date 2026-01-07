import 'package:flutter/material.dart';
import 'package:hoshi_list/features/browse/widgets/horizontal_list.dart';
import 'package:hoshi_list/data/dummy_manga.dart';

class MangaBrowseScreen extends StatelessWidget {
  const MangaBrowseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            HorizontalList(items: dummyMangaList, title: 'Trending Manga'),
            SizedBox(height: 16),
            HorizontalList(items: dummyMangaList, title: 'Top Rated Manga'),
            SizedBox(height: 16),
            HorizontalList(items: dummyMangaList, title: 'New Releases'),
          ],
        ),
      ),
    );
  }
}

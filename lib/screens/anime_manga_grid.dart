import 'package:flutter/material.dart';
import 'package:hoshi_list/widgets/anime_manga_card.dart';

class AnimeMangaGrid extends StatelessWidget {
  const AnimeMangaGrid({super.key, required this.items, required this.title});

  final List items;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 2 / 3,
          ),
          children: [
            for (var item in items)
              SizedBox(
                height: 180,
                child: AnimeMangaCard(
                  imageUrl: item.imageUrl,
                  title: item.title,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

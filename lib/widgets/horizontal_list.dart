import 'package:flutter/material.dart';
import 'package:hoshi_list/model/anime.dart';
import 'package:hoshi_list/screens/anime_manga_grid.dart';
import 'package:hoshi_list/widgets/anime_manga_card.dart';

class HorizontalList extends StatelessWidget {
  const HorizontalList({super.key, required this.items, required this.title});

  final List<Anime> items;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // The top row with title and arrow for more
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Material(
            color: Colors.transparent, // keeps background clean
            child: InkWell(
              splashFactory: InkRipple.splashFactory,
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) =>
                        AnimeMangaGrid(items: items, title: title),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
                    const Icon(Icons.arrow_forward),
                  ],
                ),
              ),
            ),
          ),
        ),

        SizedBox(
          height: 180,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: 4,
            itemBuilder: (context, index) => AnimeMangaCard(
              imageUrl: items[index].imageUrl,
              title: items[index].title,
            ),
            scrollDirection: Axis.horizontal,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hoshi_list/models/media.dart';
import 'package:hoshi_list/features/media/media_details_screen.dart';

class AnimeMangaCard extends StatelessWidget {
  const AnimeMangaCard({super.key, required this.item});

  final Media item;

  void _onTapCard(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => MediaDetailsScreen(item: item)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _onTapCard(context),
      splashFactory: InkRipple.splashFactory,
      borderRadius: BorderRadius.circular(16),
      child: Material(
        color: Colors.transparent,
        child: AspectRatio(
          aspectRatio: 2 / 3,
          child: Card(
            clipBehavior:
                Clip.hardEdge, // Ensures content doesn't overflow the card
            child: Stack(
              children: [
                Image.network(
                  item.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 4.0,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withAlpha(204),
                          Colors.transparent,
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                    child: Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

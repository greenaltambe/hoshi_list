import 'package:flutter/material.dart';
import 'package:hoshi_list/models/media.dart';
import 'package:hoshi_list/features/media/widgets/media_details/media_details_screen.dart';

class MediaListCard extends StatelessWidget {
  const MediaListCard({super.key, required this.item});

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
          aspectRatio: 2 / 3.5,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.network(item.imageUrl, fit: BoxFit.cover),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: SizedBox(
                    height:
                        (Theme.of(context).textTheme.bodySmall?.fontSize ??
                            14) *
                        2.5,
                    child: Text(
                      item.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
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

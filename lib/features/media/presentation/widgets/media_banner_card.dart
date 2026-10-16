import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hoshi_list/features/media/domain/media.dart';
import 'package:hoshi_list/features/media/presentation/screens/media_details_screen.dart';
import 'package:hoshi_list/features/media/presentation/widgets/genre_style.dart';

/// A wide card: banner, cover, score, genres and a scrollable description.
class MediaBannerCard extends StatelessWidget {
  const MediaBannerCard({super.key, required this.media});

  final MediaSummary media;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: () => MediaDetailsScreen.open(context, media.id),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                        child: Image.network(
                          media.bannerImageUrl ?? media.coverImageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.black.withAlpha(165),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      left: 10,
                      right: 10,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              media.coverImageUrl,
                              width: 60,
                              height: 90,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  media.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: textTheme.titleMedium!.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      size: 24,
                                      color: Colors.amber,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${media.averageScore}',
                                      style: textTheme.bodyMedium!.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Wrap(
                          spacing: 6,
                          runSpacing: -4,
                          children: [
                            for (final genre in media.genres)
                              Chip(
                                backgroundColor: genre.color,
                                label: Text(
                                  genre.label,
                                  style: const TextStyle(color: Colors.white),
                                ),
                                visualDensity: VisualDensity.compact,
                              ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Html(
                            data:
                                media.description ??
                                'No description available.',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

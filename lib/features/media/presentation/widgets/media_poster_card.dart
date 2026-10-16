import 'package:flutter/material.dart';
import 'package:hoshi_list/features/media/domain/media.dart';
import 'package:hoshi_list/features/media/presentation/screens/media_details_screen.dart';

/// Cover image with the average score and a title; opens the details screen.
class MediaPosterCard extends StatelessWidget {
  const MediaPosterCard({super.key, required this.media});

  final MediaSummary media;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: () => MediaDetailsScreen.open(context, media.id),
      borderRadius: BorderRadius.circular(16),
      child: AspectRatio(
        aspectRatio: 2 / 3.5,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.network(
                          media.coverImageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        right: 4,
                        top: 4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: colors.primary.withAlpha(150),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${media.averageScore}',
                            style: TextStyle(
                              color: colors.onPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: SizedBox(
                  height: (textTheme.bodySmall?.fontSize ?? 14) * 2.5,
                  child: Text(
                    media.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodySmall,
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

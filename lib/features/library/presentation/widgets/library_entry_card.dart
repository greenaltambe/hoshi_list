import 'package:flutter/material.dart';
import 'package:hoshi_list/features/library/domain/library_models.dart';
import 'package:hoshi_list/features/media/presentation/screens/media_details_screen.dart';
import 'package:percent_indicator/percent_indicator.dart';

class LibraryEntryCard extends StatelessWidget {
  const LibraryEntryCard({super.key, required this.entry});

  final MediaListEntry entry;

  /// Fraction of the media completed. When the total is unknown (ongoing
  /// series) the bar asymptotically approaches, but never reaches, 85%.
  static double progressFraction(int progress, int? total) {
    if (total != null && total > 0) return (progress / total).clamp(0, 1);
    return (progress / (progress + 20)).clamp(0, 0.85);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final media = entry.media;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => MediaDetailsScreen.open(context, media.id),
      child: Card(
        color: colors.surfaceContainer,
        clipBehavior: Clip.hardEdge,
        child: SizedBox(
          height: 180,
          child: Row(
            children: [
              SizedBox(
                width: 120,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.network(
                        media.coverImageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: _ScoreBar(
                        userScore: entry.score,
                        averageScore: media.averageScore,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        media.title,
                        style: Theme.of(context).textTheme.titleMedium,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4, right: 8),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '${entry.progress} / ${media.totalUnits ?? '??'}',
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      LinearPercentIndicator(
                        lineHeight: 20,
                        barRadius: const Radius.circular(16),
                        percent: progressFraction(
                          entry.progress,
                          media.totalUnits,
                        ),
                        backgroundColor: colors.primaryContainer,
                        progressColor: colors.onPrimaryContainer,
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

class _ScoreBar extends StatelessWidget {
  const _ScoreBar({required this.userScore, required this.averageScore});

  final int userScore;
  final int averageScore;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final style = Theme.of(
      context,
    ).textTheme.bodyMedium!.copyWith(color: colors.onPrimaryContainer);

    Widget cell(IconData icon, int value) => Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16, color: colors.onPrimaryContainer),
          const SizedBox(width: 4),
          Text('$value', style: style),
        ],
      ),
    );

    return Container(
      padding: const EdgeInsets.all(4),
      color: colors.primaryContainer,
      child: Row(
        children: [
          cell(Icons.person_4_rounded, userScore),
          Container(
            width: 1,
            height: 16,
            color: colors.onPrimaryContainer.withAlpha(100),
          ),
          cell(Icons.star, averageScore),
        ],
      ),
    );
  }
}

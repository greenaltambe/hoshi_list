import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hoshi_list/features/media/domain/media.dart';
import 'package:hoshi_list/features/media/domain/media_enums.dart';
import 'package:hoshi_list/features/media/presentation/providers/media_providers.dart';
import 'package:hoshi_list/features/media/presentation/widgets/media_carousel.dart';
import 'package:url_launcher/url_launcher.dart';

class OverviewTab extends ConsumerWidget {
  const OverviewTab({super.key, required this.media});

  final MediaDetails media;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recommendations = ref.watch(mediaRecommendationsProvider(media.id));
    final notifier = ref.read(mediaRecommendationsProvider(media.id).notifier);
    final theme = Theme.of(context);

    final stats = {
      media.type == MediaType.anime ? 'Episodes' : 'Chapters':
          media.totalUnits?.toString() ?? 'N/A',
      'Favourites': media.favourites?.toString() ?? 'N/A',
      'Score': media.averageScore?.toString() ?? 'N/A',
    };

    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (final stat in stats.entries)
                    Column(
                      children: [
                        Text(
                          stat.value,
                          style: theme.textTheme.titleSmall!.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(stat.key),
                      ],
                    ),
                ],
              ),
            ),
          ),
          if (media.externalLinks.isNotEmpty)
            SizedBox(
              width: double.infinity,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'External Links',
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          for (final link in media.externalLinks)
                            _LinkChip(link: link),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          MediaCarousel(
            title: 'Recommendations',
            style: MediaCardStyle.banner,
            items: recommendations.whenData((paged) => paged.items),
            onEndReached: notifier.loadMore,
            onRetry: () =>
                ref.invalidate(mediaRecommendationsProvider(media.id)),
          ),
        ],
      ),
    );
  }
}

class _LinkChip extends StatelessWidget {
  const _LinkChip({required this.link});

  final ExternalLink link;

  static Color _parseHex(String? hex, Color fallback) {
    if (hex == null) return fallback;
    final value = int.tryParse(hex.replaceFirst('#', '0xFF'));
    return value == null ? fallback : Color(value);
  }

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      backgroundColor: _parseHex(
        link.colorHex,
        Theme.of(context).colorScheme.primary,
      ),
      avatar: link.iconUrl == null
          ? const Icon(Icons.link, color: Colors.white)
          : Image.network(link.iconUrl!, height: 24, width: 24),
      label: Text(link.siteName, style: const TextStyle(color: Colors.white)),
      onPressed: () =>
          launchUrl(Uri.parse(link.url), mode: LaunchMode.externalApplication),
    );
  }
}

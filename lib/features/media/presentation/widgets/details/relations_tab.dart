import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hoshi_list/core/widgets/async_value_view.dart';
import 'package:hoshi_list/features/media/domain/media.dart';
import 'package:hoshi_list/features/media/domain/media_enums.dart';
import 'package:hoshi_list/features/media/presentation/providers/media_providers.dart';
import 'package:hoshi_list/features/media/presentation/widgets/media_poster_card.dart';

class RelationsTab extends ConsumerWidget {
  const RelationsTab({super.key, required this.mediaId});

  final int mediaId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AsyncValueView(
      value: ref.watch(mediaRelationsProvider(mediaId)),
      onRetry: () => ref.invalidate(mediaRelationsProvider(mediaId)),
      data: (relations) {
        if (relations.isEmpty) {
          return const Center(child: Text('No related media found.'));
        }

        final byType = <MediaRelationType, List<MediaSummary>>{};
        for (final relation in relations) {
          byType.putIfAbsent(relation.type, () => []).add(relation.media);
        }

        return ListView(
          padding: const EdgeInsets.all(8),
          children: [
            // Enum order gives a stable, meaningful section order.
            for (final type in MediaRelationType.values)
              if (byType[type] case final items?) ...[
                Text(
                  type.label,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: items.length,
                    itemBuilder: (context, index) =>
                        MediaPosterCard(media: items[index]),
                  ),
                ),
                const SizedBox(height: 20),
              ],
          ],
        );
      },
    );
  }
}

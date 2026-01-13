import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hoshi_list/features/media/providers/media_relations_provider.dart';
import 'package:flutter/material.dart';
import 'package:hoshi_list/features/media/widgets/media_list/media_list_card.dart';
import 'package:hoshi_list/models/constants/media_relations.dart';
import 'package:hoshi_list/models/related_media.dart';

class MediaRelationsList extends ConsumerWidget {
  const MediaRelationsList({super.key, required this.mediaId});

  final int mediaId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaRelations = ref.watch(relatedMediaProvider(mediaId));

    return mediaRelations.when(
      data: (relations) {
        // Group related media by their relation type
        if (relations.isEmpty) {
          return const Center(child: Text('No related media found.'));
        }

        final groupedMediaRelations = <MediaRelations, List<RelatedMedia>>{};

        for (var relation in MediaRelations.values) {
          groupedMediaRelations[relation] = [];
        }

        for (var relatedMedia in mediaRelations.value ?? []) {
          groupedMediaRelations[relatedMedia.relationType]!.add(relatedMedia);
        }

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...groupedMediaRelations.entries.map((entry) {
                final relationType = entry.key;
                final relatedMediaList = entry.value;

                if (relatedMediaList.isEmpty) {
                  return const SizedBox.shrink();
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mediaRelationsToString[relationType]!,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        itemCount: relatedMediaList.length,
                        itemBuilder: (context, index) =>
                            MediaListCard(item: relatedMediaList[index]),
                        scrollDirection: Axis.horizontal,
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                );
              }),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hoshi_list/features/media/providers/media_recommendation_list_provider.dart';
import 'package:hoshi_list/features/media/widgets/media_list/horizontal_media_list/error_horizontal_media_list.dart';
import 'package:hoshi_list/features/media/widgets/media_list/horizontal_media_list/expanded_media_list_card.dart';
import 'package:hoshi_list/features/media/widgets/media_list/horizontal_media_list/loading_horizontal_media_list.dart';

class ExpandedHorizontalRecommendationsList extends ConsumerWidget {
  const ExpandedHorizontalRecommendationsList({
    super.key,
    required this.mediaId,
    required this.title,
  });

  final int mediaId;
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(mediaRecommendationListProvider(mediaId));
    final notifier = ref.read(
      mediaRecommendationListProvider(mediaId).notifier,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // The top row with title and arrow for more
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Material(
            color: Colors.transparent, // keeps background clean
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
            ),
          ),
        ),

        items.when(
          loading: () => LoadingHorizontalMediaList(),
          error: (error, stackTrace) => ErrorHorizontalMediaList(),
          data: (items) {
            if (items.isEmpty) {
              return SizedBox(
                height: 180,
                child: Center(
                  child: Text(
                    'No items to display.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              );
            } else {
              return SizedBox(
                height: 300,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: items.length + 1,
                  itemBuilder: (context, index) {
                    if (index == items.length) {
                      return TextButton(
                        onPressed: () {
                          notifier.loadNextPage();
                        },
                        child: Icon(Icons.arrow_forward_ios),
                      ); // Extra padding at the end
                    }
                    return SizedBox(
                      width: 300,
                      child: ExpandedMediaListCard(item: items[index]),
                    );
                  },
                  scrollDirection: Axis.horizontal,
                ),
              );
            }
          },
        ),
      ],
    );
  }
}

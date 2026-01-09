import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hoshi_list/features/browse/providers/media_list_provider.dart';
import 'package:hoshi_list/features/media/widgets/media_list/media_list_card.dart';
import 'package:hoshi_list/models/media_list_query.dart';

class AnimeMangaGrid extends ConsumerWidget {
  const AnimeMangaGrid({super.key, required this.query, required this.title});

  final MediaQueryAL query;
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaState = ref.watch(mediaListProvider(query));
    final notifier = ref.read(mediaListProvider(query).notifier);
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: mediaState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text(
            'Error loading',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ),
        data: (items) {
          return NotificationListener<ScrollNotification>(
            onNotification: (scrollInfo) {
              if (scrollInfo.metrics.pixels >
                  scrollInfo.metrics.maxScrollExtent * 0.9) {
                notifier.loadNextPage();
              }
              return false;
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 2 / 3,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return SizedBox(child: MediaListCard(item: item));
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

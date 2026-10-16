import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hoshi_list/core/error/app_exception.dart';
import 'package:hoshi_list/core/widgets/async_value_view.dart';
import 'package:hoshi_list/features/media/domain/media_browse_query.dart';
import 'package:hoshi_list/features/media/presentation/providers/media_providers.dart';
import 'package:hoshi_list/features/media/presentation/widgets/media_poster_card.dart';

/// An infinitely scrolling grid of the results of [query].
class MediaGrid extends ConsumerWidget {
  const MediaGrid({super.key, required this.query});

  final MediaBrowseQuery query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final results = ref.watch(mediaListProvider(query));
    final notifier = ref.read(mediaListProvider(query).notifier);

    return AsyncValueView(
      value: results,
      onRetry: () => ref.invalidate(mediaListProvider(query)),
      data: (paged) {
        if (paged.items.isEmpty) {
          return const Center(child: Text('No results.'));
        }
        return NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            final metrics = notification.metrics;
            if (metrics.pixels > metrics.maxScrollExtent * 0.9 &&
                paged.loadMoreError == null) {
              notifier.loadMore();
            }
            return false;
          },
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(8),
                sliver: SliverGrid.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 2 / 3.5,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: paged.items.length,
                  itemBuilder: (context, index) =>
                      MediaPosterCard(media: paged.items[index]),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: paged.loadMoreError != null
                        ? TextButton(
                            onPressed: notifier.loadMore,
                            child: Text(
                              '${describeError(paged.loadMoreError!)} Retry',
                            ),
                          )
                        : paged.hasNextPage
                        ? const CircularProgressIndicator()
                        : null,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

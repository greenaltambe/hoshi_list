import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hoshi_list/features/media/providers/review_list_provider.dart';

class ReviewListTab extends ConsumerWidget {
  const ReviewListTab({super.key, required this.mediaId});

  final int mediaId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviewsList = ref.watch(mediaReviewListProvider(mediaId));
    return Column(
      children: [
        reviewsList.when(
          data: (reviews) {
            if (reviews.isEmpty) {
              return const Center(child: Text('No reviews available.'));
            }
            return Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: reviews.length + 1,
                itemBuilder: (context, index) {
                  if (index == reviews.length) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: ElevatedButton(
                        onPressed: () {
                          ref
                              .read(mediaReviewListProvider(mediaId).notifier)
                              .loadNextPage();
                        },
                        child: const Text('Load more'),
                      ),
                    );
                  }
                  final review = reviews[index];
                  return ListTile(
                    onTap: () {
                      _showReviewDialog(context, review);
                    },
                    title: Text(
                      review.summary,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    subtitle: Text(
                      'By ${review.author.name}',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(review.author.avatarUrl),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.thumb_up),
                        const SizedBox(width: 4),
                        Text('${review.score}'),
                      ],
                    ),
                  );
                },
              ),
            );
          },
          loading: () =>
              Expanded(child: const Center(child: CircularProgressIndicator())),
          error: (error, stackTrace) => Expanded(
            child: Center(child: Text('Error loading reviews: $error')),
          ),
        ),
      ],
    );
  }

  void _showReviewDialog(BuildContext context, review) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) {
        return DraggableScrollableSheet(
          expand: false,
          maxChildSize: 0.9,
          minChildSize: 0.4,
          initialChildSize: 0.6,
          builder: (context, scrollController) => SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 50,
                    height: 5,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2.5),
                    ),
                  ),
                  Text(
                    review.summary,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(review.author.avatarUrl),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'By ${review.author.name}',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          const Icon(Icons.thumb_up),
                          const SizedBox(width: 4),
                          Text('${review.score}'),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    review.body ?? 'No additional comments.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

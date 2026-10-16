import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hoshi_list/core/widgets/paged_list_view.dart';
import 'package:hoshi_list/core/widgets/sheet_drag_handle.dart';
import 'package:hoshi_list/features/media/domain/media_review.dart';
import 'package:hoshi_list/features/media/presentation/providers/media_providers.dart';

class ReviewsTab extends ConsumerWidget {
  const ReviewsTab({super.key, required this.mediaId});

  final int mediaId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PagedListView<MediaReview>(
      value: ref.watch(mediaReviewsProvider(mediaId)),
      emptyText: 'No reviews available.',
      onLoadMore: ref.read(mediaReviewsProvider(mediaId).notifier).loadMore,
      onRetry: () => ref.invalidate(mediaReviewsProvider(mediaId)),
      itemBuilder: (context, review) => ListTile(
        onTap: () => _showReview(context, review),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(review.author.avatarUrl),
        ),
        title: Text(review.summary),
        subtitle: Text('By ${review.author.name}'),
        trailing: _Score(score: review.score),
      ),
    );
  }

  void _showReview(BuildContext context, MediaReview review) {
    final theme = Theme.of(context);
    showDraggableSheet<void>(
      context,
      builder: (context, scrollController) => SingleChildScrollView(
        controller: scrollController,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SheetDragHandle(),
            Text(
              review.summary,
              style: theme.textTheme.titleMedium?.copyWith(
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
                  style: theme.textTheme.bodyMedium!.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                const Spacer(),
                _Score(score: review.score),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              review.body ?? 'No additional comments.',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _Score extends StatelessWidget {
  const _Score({required this.score});

  final int score;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.thumb_up),
        const SizedBox(width: 4),
        Text('$score'),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hoshi_list/core/widgets/async_value_view.dart';
import 'package:hoshi_list/features/media/domain/media.dart';
import 'package:hoshi_list/features/media/presentation/widgets/media_banner_card.dart';
import 'package:hoshi_list/features/media/presentation/widgets/media_poster_card.dart';

enum MediaCardStyle { poster, banner }

/// A titled horizontal list of media. All loading/error/empty states are
/// handled here so every carousel in the app looks and behaves the same.
class MediaCarousel extends StatelessWidget {
  const MediaCarousel({
    super.key,
    required this.title,
    required this.items,
    this.style = MediaCardStyle.poster,
    this.onTitleTap,
    this.onEndReached,
    this.onRetry,
  });

  final String title;
  final AsyncValue<List<MediaSummary>> items;
  final MediaCardStyle style;

  /// When set, the header becomes tappable (e.g. "see all").
  final VoidCallback? onTitleTap;

  /// Called when the user scrolls near the end, to load more items.
  final VoidCallback? onEndReached;
  final VoidCallback? onRetry;

  double get _height => style == MediaCardStyle.poster ? 200 : 300;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: onTitleTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  if (onTitleTap != null) const Icon(Icons.arrow_forward),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: _height,
          child: AsyncValueView(
            value: items,
            onRetry: onRetry,
            data: (items) {
              if (items.isEmpty) {
                return const Center(child: Text('No items to display.'));
              }
              return NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  final metrics = notification.metrics;
                  if (metrics.pixels >= metrics.maxScrollExtent - 200) {
                    onEndReached?.call();
                  }
                  return false;
                },
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: items.length,
                  itemBuilder: (context, index) => switch (style) {
                    MediaCardStyle.poster => MediaPosterCard(
                      media: items[index],
                    ),
                    MediaCardStyle.banner => SizedBox(
                      width: 300,
                      child: MediaBannerCard(media: items[index]),
                    ),
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

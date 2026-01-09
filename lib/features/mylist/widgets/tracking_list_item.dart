import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hoshi_list/features/media/widgets/media_details/media_details_screen.dart';
import 'package:hoshi_list/features/media/providers/media_details_provider.dart';
import 'package:hoshi_list/models/tracked_media.dart';

class TrackingListItem extends ConsumerWidget {
  const TrackingListItem({super.key, required this.trackedMedia});

  final TrackedMedia trackedMedia;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaDetails = ref.watch(mediaDetailsProvider(trackedMedia.mediaId));
    return mediaDetails.when(
      data: (mediaDetails) => InkWell(
        splashFactory: InkRipple.splashFactory,
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  MediaDetailsScreen.fromId(mediaId: mediaDetails.id),
            ),
          );
        },
        child: Card(
          color: Theme.of(context).colorScheme.surfaceContainer,
          clipBehavior: Clip.hardEdge,
          child: SizedBox(
            height: 150,
            child: Row(
              children: [
                Stack(
                  children: [
                    Image.network(mediaDetails.coverImageUrl),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      left: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          mediaDetails.averageScore.toString(),
                          style: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onPrimaryContainer,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 16),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mediaDetails.romajiTitle,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        'Status: ${trackedMedia.status.name}'.toUpperCase(),
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      Text('Progress: ${trackedMedia.progress}'),
                      Text('Score: ${mediaDetails.averageScore}'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text(
          'Error: $error',
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: Theme.of(context).colorScheme.error,
          ),
        ),
      ),
    );
  }
}

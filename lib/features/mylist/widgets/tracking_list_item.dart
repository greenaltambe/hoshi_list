import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hoshi_list/features/media/widgets/media_details/media_details_screen.dart';
import 'package:hoshi_list/models/media_list_group.dart';

class TrackingListItem extends ConsumerWidget {
  const TrackingListItem({super.key, required this.mediaItem});

  final MediaListEntry mediaItem;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      splashFactory: InkRipple.splashFactory,
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                MediaDetailsScreen.fromId(mediaId: mediaItem.media.id),
          ),
        );
      },
      child: Card(
        color: Theme.of(context).colorScheme.surfaceContainer,
        clipBehavior: Clip.hardEdge,
        child: SizedBox(
          height: 180,
          child: Row(
            children: [
              SizedBox(
                width: 120,
                child: Stack(
                  children: [
                    // Cover image
                    Positioned.fill(
                      child: Image.network(
                        mediaItem.media.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),

                    // User score badge
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.person_4_rounded,
                                    size: 16,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onPrimaryContainer,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    mediaItem.userScore.toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onPrimaryContainer,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 16,
                              color: Theme.of(
                                context,
                              ).colorScheme.onPrimaryContainer.withAlpha(100),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.star,
                                    size: 16,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onPrimaryContainer,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    mediaItem.media.avgScore.toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onPrimaryContainer,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Details section
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mediaItem.media.title,
                        style: Theme.of(context).textTheme.titleMedium,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        maxLines: 2,
                      ),
                      Text('Progress: ${mediaItem.userProgress}'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hoshi_list/model/media.dart';

// Top section with cover image, poster, and title widget
class HeaderInfoSection extends StatelessWidget {
  const HeaderInfoSection({super.key, required this.mediaDetails});

  final MediaDetails mediaDetails;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.network(
          mediaDetails.coverImageUrl,
          width: double.infinity,
          height: 260,
          fit: BoxFit.cover,
        ),

        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Theme.of(context).colorScheme.surface.withAlpha(150),
                  Theme.of(context).colorScheme.surface.withAlpha(200),
                  Theme.of(context).colorScheme.surface.withAlpha(255),
                  Theme.of(context).colorScheme.surface,
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 16,
          right: 16,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  mediaDetails.imageUrl,
                  height: 160,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mediaDetails.title,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      maxLines: null,
                      softWrap: true,
                    ),

                    Text(
                      mediaDetails.status.name.toUpperCase(),
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

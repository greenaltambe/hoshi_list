import 'package:flutter/material.dart';
import 'package:hoshi_list/features/media/widgets/media_details/media_details_widgets/media_description.dart';
import 'package:hoshi_list/models/constants/genre_list.dart';
import 'package:hoshi_list/models/media.dart';

// Top section with cover image, poster, and title widget
class HeaderInfoSection extends StatelessWidget {
  const HeaderInfoSection({super.key, required this.mediaDetails});

  final MediaDetails mediaDetails;

  static const double headerHeight = 250;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background banner image
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: headerHeight,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (mediaDetails.bannerImageUrl != null)
                Image.network(
                  mediaDetails.bannerImageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Container(color: Colors.grey[900]),
                ),
              if (mediaDetails.bannerImageUrl == null)
                Image.network(
                  mediaDetails.coverImageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Container(color: Colors.grey[900]),
                ),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Theme.of(context).colorScheme.surface.withAlpha(0),
                      Theme.of(context).colorScheme.surface.withAlpha(150),
                      Theme.of(context).colorScheme.surface,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(
            top: headerHeight - 100,
            left: 16,
            right: 16,
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      mediaDetails.coverImageUrl,
                      height: 160,
                      width: 110,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          mediaDetails.romajiTitle,
                          style: Theme.of(context).textTheme.titleMedium!
                              .copyWith(
                                fontSize: 20,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                          maxLines: null,
                          softWrap: true,
                        ),

                        Text(
                          mediaDetails.status.name.toUpperCase(),
                          style: Theme.of(context).textTheme.bodySmall!
                              .copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),

                        Text(
                          mediaDetails.format.name.toUpperCase(),
                          style: Theme.of(context).textTheme.bodySmall!,
                        ),

                        Text(
                          '${mediaDetails.season?.toUpperCase()} ${mediaDetails.startDate?.year ?? ''}',
                          style: Theme.of(context).textTheme.bodySmall!,
                        ),

                        Wrap(
                          spacing: 6,
                          runSpacing: -4,

                          children: mediaDetails.genres
                              .map(
                                (genre) => Chip(
                                  label: Text(genreToString[genre]!),
                                  visualDensity: VisualDensity.compact,
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              MediaDescription(description: mediaDetails.description),
            ],
          ),
        ),
      ],
    );
  }
}

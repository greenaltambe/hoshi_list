import 'package:flutter/material.dart';
import 'package:hoshi_list/models/media.dart';

class MediaBanner extends StatelessWidget {
  const MediaBanner({super.key, required this.mediaDetails});

  final MediaDetails mediaDetails;

  @override
  Widget build(BuildContext context) {
    return Stack(
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

        // Gradient overlay
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
    );
  }
}

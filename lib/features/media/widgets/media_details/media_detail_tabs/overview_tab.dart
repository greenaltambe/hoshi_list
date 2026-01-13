import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hoshi_list/features/media/widgets/media_details/media_details_widgets/expanded_horizontal_recommendations_list.dart';
import 'package:hoshi_list/models/constants/media_type.dart';
import 'package:hoshi_list/models/media.dart';
import 'package:url_launcher/url_launcher.dart';

class OverviewTab extends StatelessWidget {
  const OverviewTab({super.key, required this.mediaDetails});

  final MediaDetails mediaDetails;

  // String? _dateToYMD(DateTime? date) {
  //   if (date == null) return null;
  //   String year = date.year.toString();
  //   String month = date.month.toString().padLeft(2, '0');
  //   String day = date.day.toString().padLeft(2, '0');
  //   return '$year/$month/$day';
  // }

  Color _hexToColor(String hex) {
    hex = hex.replaceFirst('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex'; // add full opacity
    }
    return Color(int.parse(hex, radix: 16));
  }

  Color _randomColor() {
    final Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }

  @override
  Widget build(BuildContext context) {
    final overviewCardContent = {
      mediaDetails.type == MediaTypeAL.anime
          ? 'Episodes'
          : 'Chapters': mediaDetails.type == MediaTypeAL.anime
          ? mediaDetails.episodes?.toString() ?? 'N/A'
          : mediaDetails.chapters?.toString() ?? 'N/A',
      'Favorites': mediaDetails.favourites.toString(),
      'Score': mediaDetails.averageScore?.toString() ?? 'N/A',
    };

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: overviewCardContent.entries.map((entry) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          textAlign: TextAlign.center,
                          entry.value,
                          style: Theme.of(context).textTheme.titleSmall!
                              .copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(textAlign: TextAlign.center, entry.key),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),

            if (mediaDetails.externalLinks != null &&
                mediaDetails.externalLinks!.isNotEmpty)
              SizedBox(
                width: double.infinity,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'External Links',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          alignment: WrapAlignment.start,
                          children: mediaDetails.externalLinks!.map((
                            externalLink,
                          ) {
                            return InkWell(
                              onTap: () {
                                launchUrl(Uri.parse(externalLink.url));
                              },
                              child: Chip(
                                backgroundColor: externalLink.colorHex != null
                                    ? _hexToColor(externalLink.colorHex!)
                                    : _randomColor(),
                                label: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (externalLink.iconUrl != null)
                                      Image.network(
                                        externalLink.iconUrl!,
                                        height: 24,
                                        width: 24,
                                      )
                                    else
                                      Icon(
                                        Icons.link,
                                        size: 24,
                                        color: Colors.white,
                                      ),
                                    SizedBox(width: 8),
                                    Text(
                                      externalLink.siteName,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            ExpandedHorizontalRecommendationsList(
              mediaId: mediaDetails.id,
              title: 'Recommendations',
            ),
          ],
        ),
      ),
    );
  }
}

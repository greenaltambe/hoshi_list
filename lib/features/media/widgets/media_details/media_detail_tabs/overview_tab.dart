import 'package:flutter/material.dart';
import 'package:hoshi_list/models/media.dart';

class OverviewTab extends StatelessWidget {
  const OverviewTab({super.key, required this.mediaDetails});

  final MediaDetails mediaDetails;

  String? _dateToYMD(DateTime? date) {
    if (date == null) return null;
    String year = date.year.toString();
    String month = date.month.toString().padLeft(2, '0');
    String day = date.day.toString().padLeft(2, '0');
    return '$year/$month/$day';
  }

  @override
  Widget build(BuildContext context) {
    final overviewCardContent = {
      'Start Date': _dateToYMD(mediaDetails.startDate) ?? 'N/A',
      'Episodes': mediaDetails.episodes?.toString() ?? 'N/A',
      'Score': mediaDetails.averageScore?.toString() ?? 'N/A',
    };

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: overviewCardContent.entries.map((entry) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.key,
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      Text(
                        entry.value,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

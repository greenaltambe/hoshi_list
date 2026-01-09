import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hoshi_list/models/media.dart';
import 'package:hoshi_list/features/media/providers/media_details_provider.dart';
import 'package:hoshi_list/features/media/widgets/media_details/media_details_widgets/header_info.dart';
import 'package:hoshi_list/features/media/widgets/media_details/media_details_widgets/media_description.dart';
import 'package:hoshi_list/features/media/widgets/media_details/media_details_widgets/tabbed_media_details.dart';

class MediaDetailsScreen extends ConsumerWidget {
  const MediaDetailsScreen({super.key, this.item, this.mediaId});

  const MediaDetailsScreen.fromId({super.key, required this.mediaId})
    : item = null;

  final Media? item;
  final int? mediaId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaDetails = ref.watch(mediaDetailsProvider(item?.id ?? mediaId!));

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(elevation: 0, backgroundColor: Colors.transparent),
      body: SingleChildScrollView(
        child: mediaDetails.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
          data: (mediaDetails) {
            return Column(
              children: [
                HeaderInfoSection(mediaDetails: mediaDetails),
                SizedBox(height: 16),
                MediaDescription(
                  description: mediaDetails.description,
                ), // Returns as column
                SizedBox(height: 16),
                TabbedMediaDetails(mediaDetails: mediaDetails),
              ],
            );
          },
        ),
      ),
    );
  }
}

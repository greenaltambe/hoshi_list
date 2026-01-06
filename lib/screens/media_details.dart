import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hoshi_list/model/media.dart';
import 'package:hoshi_list/providers/media_details_provider.dart';
import 'package:hoshi_list/widgets/media_details/header_info.dart';
import 'package:hoshi_list/widgets/media_details/media_description.dart';
import 'package:hoshi_list/widgets/media_details/tabbed_media_details.dart';

class MediaDetailsScreen extends ConsumerWidget {
  const MediaDetailsScreen({super.key, required this.item});

  final Media item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaDetails = ref.watch(mediaDetailsProvider(item.id));
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(elevation: 0, backgroundColor: Colors.transparent),
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderInfoSection(mediaDetails: mediaDetails),
            SizedBox(height: 16),
            MediaDescription(
              description: mediaDetails.description,
            ), // Returns as column
            SizedBox(height: 16),
            TabbedMediaDetails(),
          ],
        ),
      ),
    );
  }
}
